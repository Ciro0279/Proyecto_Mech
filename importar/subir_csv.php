<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Importar Clientes</title>
</head>
<body>

<?php
header('Content-Type: text/html; charset=UTF-8');  
require('config.php'); // Conexión con mechanix_db

$tipo       = $_FILES['dataCliente']['type'];
$tamanio    = $_FILES['dataCliente']['size'];
$archivotmp = $_FILES['dataCliente']['tmp_name'];
$lineas     = file($archivotmp);

$i = 0;
$agregados = 0;

foreach ($lineas as $linea) {
    if ($i != 0) {
        $datos = explode(";", $linea);

        $nombre     = isset($datos[0]) ? utf8_encode(trim($datos[0])) : '';
        $apellido   = isset($datos[1]) ? utf8_encode(trim($datos[1])) : '';
        $documento  = isset($datos[2]) ? utf8_encode(trim($datos[2])) : '';
        $id_tipo_doc= isset($datos[3]) ? intval(trim($datos[3])) : 0;
        $telefono   = isset($datos[4]) ? utf8_encode(trim($datos[4])) : '';
        $correo     = isset($datos[5]) ? utf8_encode(trim($datos[5])) : '';
        $direccion  = isset($datos[6]) ? utf8_encode(trim($datos[6])) : '';

        if ($documento != '') {
            $sqlInsert = "INSERT INTO clientes 
                (nombre_cliente, apellido_cliente, documento_cliente, id_tipo_doc, telefono, correo, direccion) 
                VALUES 
                ('$nombre', '$apellido', '$documento', '$id_tipo_doc', '$telefono', '$correo', '$direccion')";

            $query = mysqli_query($con, $sqlInsert);
            if ($query) {
                $agregados++;
            } else {
                echo "<p style='color:red;'>Error al insertar documento: $documento</p>";
            }
        }
    }

    $i++;
}

echo "<center><p>Total de clientes agregados: <strong>$agregados</strong></p></center>";
echo "<center><a href='index.php'>Volver</a></center>";
?>

</body>
</html>



