const imagenesMenu = {
  Hierbabuena: "images/Hierbanuena.jpg",
  Menta: "images/menta.jpg",
  Romero: "images/romero.jpg",
  Ruda: "images/ruda.jpg",
  Tomate: "images/tomate.jpg",
  lechuga: "images/lechuga.jpg",
  Cebolla: "images/cebolla.jpg",
  Cilantro: "images/cilantro.jpg",
  "Corona de Cristo": "images/coronadecristo.jpg",
  Periskia: "images/Periskia.jpg",
  "Cactus Estrella": "images/CactusEstrella",
  suculenta: "images/suculenta.jpg",
  "Chile Verde": "images/chileverde.jpg"
};
// Enviar formulario de registro de planta
function enviarFormulario(event) {
  event.preventDefault();


  const plantName = document.getElementById("plantName").value;
  const imageFile = imagenesMenu[plantName]; // <- aquí seleccionamos la imagen correcta

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
    body: JSON.stringify({ plantName, plantType, userName, customPlantName, telefono, correo,  imageFile: imageFile   })
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
  const modal = document.getElementById("plantModal");
  if (modal) {
    modal.style.display = "none";
    document.getElementById("plantForm").reset();
  }
}

// --- GESTIÓN DE USUARIO (correo) ---
// Guardar correo y mostrar plantas
function guardarCorreo() {
  const correo = document.getElementById("correoConsulta").value.trim();
  if (!correo) return alert("⚠️ Ingresa un correo válido.");
  localStorage.setItem("correoUsuario", correo);
  document.getElementById("correoConsulta").value = "";
  cargarPanelUsuario();
  mostrarMisPlantas();
}

// Mostrar correo actual y ocultar login
function cargarPanelUsuario() {
  const correo = localStorage.getItem("correoUsuario");
  if (!correo) return;

  document.getElementById("loginCorreo").style.display = "none";
  document.getElementById("panelUsuario").style.display = "block";
  document.getElementById("correoActual").textContent = correo;
}

// Cerrar sesión
function cerrarSesion() {
  localStorage.removeItem("correoUsuario");
  document.getElementById("loginCorreo").style.display = "block";
  document.getElementById("panelUsuario").style.display = "none";
  document.getElementById("resultadoPlantas").innerHTML = "";
}

// Mostrar las plantas registradas del correo guardado
function mostrarMisPlantas() {
  const correo = localStorage.getItem("correoUsuario");
  if (!correo) return;

  fetch("https://parcial1-jennifer.onrender.com/misPlantas", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ correo })
  })
  .then(res => res.json())
  .then(async data => {
    const contenedor = document.getElementById("resultadoPlantas");
    contenedor.innerHTML = "";

    if (!data.success || !Array.isArray(data.plantas) || data.plantas.length === 0) {
      contenedor.innerHTML = "<p>No se encontraron plantas registradas.</p>";
      return;
    }

    const humedad = await obtenerHumedadActual();

    data.plantas.forEach(planta => {
      // Validar propiedades para evitar undefined
      const nombrePlantaRaw = planta.plantname || planta.plantName || "";
      // Convertir a string para evitar error si es undefined/null
      const nombrePlantaStr = nombrePlantaRaw ? nombrePlantaRaw.toString() : "";
      const nombrePlanta = nombrePlantaStr.toLowerCase().replace(/\s/g, "");
      const customPlantName = planta.customplantname || planta.customPlantName || "Sin nombre";
      const tipoPlanta = planta.planttype || planta.plantType || "desconocido";
      const idPlanta = planta.id || planta.ID || null;

      // Si no hay id no crear la tarjeta (evitar errores)
      if (!idPlanta) return;

      const rango = obtenerRango(tipoPlanta);
      const estado = humedad < rango.min || humedad > rango.max ? "⚠️ Fuera de rango" : "✅ En rango";

      // Buscar imagen, si no tiene asignada usa default
      const nombreImagen = planta.imageFile ? planta.imageFile : "images/default.jpg";

      const tarjeta = document.createElement("div");
      tarjeta.classList.add("plant");
      tarjeta.innerHTML = `
        <h3>${customPlantName}</h3>
        <img src="${nombreImagen}" alt="${nombrePlantaRaw}" width="200" style="margin-bottom:10px;">
        <p><strong>Planta:</strong> ${nombrePlantaRaw}</p>
        <p><strong>Tipo:</strong> ${tipoPlanta}</p>
        <p><strong>Humedad actual:</strong> ${humedad}%</p>
        <p><strong>Estado:</strong> ${estado}</p>
        <button onclick="eliminarPlanta(${idPlanta})" style="background:#e74c3c; color:white; border:none; padding:5px 10px; cursor:pointer;">🗑️ Eliminar</button>
      `;
      contenedor.appendChild(tarjeta);
    });
  })
  .catch(err => {
    console.error("Error:", err);
    alert("❌ Error al consultar tus plantas.");
  });
}

// Función para eliminar planta por id
function eliminarPlanta(id) {
  if (!confirm("¿Seguro que quieres eliminar esta planta?")) return;

  fetch("https://parcial1-jennifer.onrender.com/eliminarPlanta", {
    method: "DELETE",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id })
  })
  .then(res => res.json())
  .then(data => {
    alert(data.mensaje);
    mostrarMisPlantas(); // Recargar la lista
  })
  .catch(err => {
    console.error("Error al eliminar:", err);
    alert("❌ No se pudo eliminar la planta.");
  });
}

// Obtener humedad actual desde ThingSpeak
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

// Obtener rango ideal por tipo de planta
function obtenerRango(tipo) {
  const rangos = {
    aromaticas: { min: 70, max: 80 },
    hortalizas: { min: 50, max: 80 },
    flores: { min: 30, max: 70 }
  };
  return rangos[tipo] || { min: 0, max: 100 };
}

// Al cargar la página, verificar si hay correo guardado y mostrar plantas
window.onload = () => {
  cargarPanelUsuario();
  mostrarMisPlantas();
};
