const sql = require('./db.js'); // 👈 Solo aquí debe estar
const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const fetch = require('node-fetch');
const path = require('path');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // 👉 CORS debe ir antes que las rutas
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname))); // Servir archivos estáticos

// Ruta raíz
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Rangos de humedad ideales
const rangos = {
  aromaticas: { min: 60, max: 90 },
  hortalizas: { min: 70, max: 95 },
  flores: { min: 50, max: 85 }
};

// Configurar transporte de correos
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// Enviar correo de registro
app.post('/enviarCorreo', (req, res) => {
  const { plantName, plantType, userName, customPlantName, telefono, correo } = req.body;

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: correo,
    subject: `Nuevo Registro: ${customPlantName}`,
    text: `
¡Gracias por registrar tu planta!

🌿 Planta: ${plantName}
🌱 Tipo de planta: ${plantType}
👤 Usuario: ${userName}
🪴 Nombre personalizado: ${customPlantName}
📞 Teléfono: ${telefono}
📧 Correo: ${correo}

¡Disfruta cuidándola! 🌼
    `
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error("❌ Error al enviar correo:", error);
      return res.status(500).json({ success: false, mensaje: 'Error al enviar correo: ' + error.message });
    }
    console.log('✅ Correo enviado:', info.response);
    res.json({ success: true, mensaje:`✅ ¡Tu planta "${customPlantName}" fue registrada correctamente!`});
  });
});

// Verificar humedad y enviar alerta si está fuera de rango
app.post('/verificar-humedad', async (req, res) => {
  const { plantType, correo, userName, customPlantName } = req.body;

  try {
    const response = await fetch('https://api.thingspeak.com/channels/2943187/fields/1.json?api_key=COY6HRV8L9KUVU4J&results=1');
    if (!response.ok) return res.status(502).json({ success: false, mensaje: 'Error al obtener humedad desde ThingSpeak' });

    const data = await response.json();
    const humedadStr = data.feeds[0]?.field1;

    if (!humedadStr || isNaN(humedadStr)) {
      return res.status(400).json({ success: false, mensaje: 'No se obtuvo la humedad actual.' });
    }

    const humedadActual = parseFloat(humedadStr);
    const rango = rangos[plantType];

    if (!rango) {
      return res.status(400).json({ success: false, mensaje: `Rango no definido para el tipo: ${plantType}` });
    }

    if (humedadActual < rango.min || humedadActual > rango.max) {
      const mensajeAlerta = `Hola ${userName}, tu planta "${customPlantName}"tipo (${plantType}) tiene ${humedadActual}% de humedad.\n⚠️ ¡Revisa tu sistema de riego!`;

      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: correo,
        subject: '⚠️ Alerta: Humedad fuera de rango',
        text: mensajeAlerta
      };

      try {
        await transporter.sendMail(mailOptions);
        console.log("🚨 Alerta enviada");
        return res.json({ success: true, mensaje: mensajeAlerta });
      } catch (err) {
        console.error("❌ Error enviando alerta:", err);
        return res.status(200).json({ success: true, mensaje: '⚠️ No se pudo enviar la alerta, pero la planta fue registrada y el correo fue enviado.' });
      }
    } else {
      return res.json({ success: true, mensaje: `✅ Humedad en rango ideal (${rango.min}% - ${rango.max}%)` });
    }

  } catch (error) {
    console.error("❌ Error general:", error);
    return res.status(500).json({ success: false, mensaje: 'Error al verificar humedad.' });
  }
});

// Ruta para registrar planta en Supabase
app.post('/registrarPlanta', async (req, res) => {
  const { plantName, plantType, userName, customPlantName, telefono, correo } = req.body;

  if (!plantName || !plantType || !userName || !customPlantName || !telefono || !correo) {
    return res.status(400).json({ success: false, mensaje: 'Faltan datos para registrar planta.' });
  }

  try {
    await sql`
      INSERT INTO plantas (
        plantname,
        planttype,
        username,
        customplantname,
        telefono,
        correo,
        created_at
      ) VALUES (
        ${plantName},
        ${plantType},
        ${userName},
        ${customPlantName},
        ${telefono},
        ${correo},
        NOW()
      )
    `;
    return res.json({ success: true, mensaje: '✅ Planta registrada correctamente en Supabase.' });
  } catch (error) {
    console.error('❌ Error al insertar en Supabase:', error);
    return res.status(500).json({ success: false, mensaje: 'Error al registrar planta en Supabase.' });
  }
});

// Ruta para obtener plantas desde Supabase
app.post('/misPlantas', async (req, res) => {
  const { correo } = req.body;

  if (!correo) return res.status(400).json({ success: false, mensaje: 'Se requiere correo para buscar plantas.' });

  try {
    const plantas = await sql`
      SELECT * FROM plantas WHERE correo = ${correo}
    `;
    return res.json({ success: true, plantas });
  } catch (error) {
    console.error('❌ Error al obtener plantas de Supabase:', error);
    return res.status(500).json({ success: false, mensaje: 'Error al obtener plantas.' });
  }
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
