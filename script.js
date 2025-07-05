function enviarFormulario(event) {
  event.preventDefault();

  const plantName = document.getElementById("plantName").value;
  const plantType = document.getElementById("plantType").value;
  const userName = document.getElementById("userName").value.trim();
  const customPlantName = document.getElementById("customPlantName").value.trim();
  const telefono = document.getElementById("telefono").value.trim();
  const correo = document.getElementById("correo").value.trim();

  if (!userName || !customPlantName || !telefono || !correo) {
    alert("⚠️ Por favor, llena todos los campos antes de enviar.");
    return;
  }

  let mensajes = [];

  // Paso 1: Registrar planta
  fetch('https://parcial1-jennifer.onrender.com/registrarPlanta', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ plantName, plantType, userName, customPlantName, telefono, correo })
  })
  .then(res => res.json())
  .then(data => {
    if (!data.success) throw new Error("Registro: " + data.mensaje);
    mensajes.push("✅ Planta registrada correctamente.");
    
    // Paso 2: Enviar correo
    return fetch('https://parcial1-jennifer.onrender.com/enviarCorreo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ plantName, plantType, userName, customPlantName, telefono, correo })
    });
  })
  .then(res => res.json())
  .then(data => {
    if (!data.success) throw new Error("Correo: " + data.mensaje);
    mensajes.push("✅ Correo de confirmación enviado.");

    // Paso 3: Verificar humedad
    return fetch('https://parcial1-jennifer.onrender.com/verificar-humedad', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ plantType, correo, userName, customPlantName })
    });
  })
  .then(res => res.json())
  .then(data => {
    mensajes.push("🌱 Humedad: " + data.mensaje);
    alert(mensajes.join('\n'));
    cerrarModal();
  })
  .catch(error => {
    mensajes.push("⚠️ " + error.message);
    alert(mensajes.join('\n'));
    cerrarModal();
  });
}

// Cierra el modal y limpia el formulario
function cerrarModal() {
  const modal = document.getElementById("plantModal"); // Corregido a tu modal real
  if (modal) {
    modal.style.display = "none";
    document.getElementById("plantForm").reset();
  }
}

// 🔹 FUNCIONES PARA "MIS PLANTAS"

function mostrarMisPlantas() {
  const correo = document.getElementById("correoConsulta").value.trim();
  if (!correo) {
    alert("Por favor, ingresa tu correo.");
    return;
  }

  fetch("https://parcial1-jennifer.onrender.com/misPlantas", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ correo })
  })
  .then(res => res.json())
  .then(async data => {
    const contenedor = document.getElementById("resultadoPlantas");
    contenedor.innerHTML = "";

    if (!data.success || data.plantas.length === 0) {
      contenedor.innerHTML = "<p>No se encontraron plantas registradas con ese correo.</p>";
      return;
    }

    const humedad = await obtenerHumedadActual();

    data.plantas.forEach(planta => {
      const rango = obtenerRango(planta.planttype);
      const estado = humedad < rango.min || humedad > rango.max ? "⚠️ Fuera de rango" : "✅ En rango";

      const tarjeta = document.createElement("div");
      tarjeta.classList.add("plant");
      tarjeta.innerHTML = `
        <h3>${planta.customPlantName}</h3>
        <p><strong>Planta:</strong> ${planta.plantName}</p>
        <p><strong>Tipo:</strong> ${planta.plantType}</p>
        <p><strong>Humedad actual:</strong> ${humedad}%</p>
        <p><strong>Estado:</strong> ${estado}</p>
      `;
      contenedor.appendChild(tarjeta);
    });
  })
  .catch(err => {
    console.error("Error:", err);
    alert("❌ Error al consultar tus plantas.");
  });
}

async function obtenerHumedadActual() {
  try {
    const res = await fetch("https://api.thingspeak.com/channels/2943187/fields/1.json?api_key=COY6HRV8L9KUVU4J&results=1");
    const data = await res.json();
    return parseFloat(data.feeds[0].field1 || 0);
  } catch (err) {
    console.error("Error humedad:", err);
    return 0;
  }
}

function obtenerRango(tipo) {
  const rangos = {
    aromaticas: { min: 60, max: 90 },
    hortalizas: { min: 70, max: 95 },
    flores: { min: 50, max: 85 }
  };
  return rangos[tipo] || { min: 0, max: 100 };
}
