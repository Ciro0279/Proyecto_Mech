<?php
// Parámetros de conexión
$usuario     = "root";
$password    = "";
$servidor    = "localhost";
$basededatos = "mechanix_db";

// Crear la conexión
$con = mysqli_connect($servidor, $usuario, $password);

// Verificar la conexión
if (!$con) {
    die("❌ No se ha podido conectar al servidor: " . mysqli_connect_error());
}

// Establecer codificación UTF-8
mysqli_set_charset($con, "utf8");

// Seleccionar la base de datos
$db = mysqli_select_db($con, $basededatos);
if (!$db) {
    die("❌ Error al conectar con la base de datos: " . mysqli_error($con));
}

// Confirmación opcional
// echo "✅ Conexión exitosa a mechanix_db.";
?>

