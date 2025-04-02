// Definimos una estructura de datos en formato JSON
const datos = {
    "nombre": "jennifer villatoro",
    "edad": 25,
    "email": "villatoroyuca@gmail.com",
    "direccion": {
        "calle": "Av. Siempre Viva",
        "numero": 742,
        "ciudad": "NLD"
    },
    "telefonos": ["123-456-7890", "098-765-4321"]
};

// Función para mostrar los datos en la consola
function mostrarDatos(json) {
    console.log("Nombre:", json.nombre);
    console.log("Edad:", json.edad);
    console.log("Email:", json.email);
    console.log("Dirección:", `${json.direccion.calle} #${json.direccion.numero}, ${json.direccion.ciudad}`);
    console.log("Teléfonos:", json.telefonos.join(", "));
}

// Llamamos a la función con los datos
mostrarDatos(datos);
