<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Importar Clientes</title>
</head>
<body>

<?php
header('Content-Type: text/html; charset=UTF-8');
require('config.php'); // Debe definir $con = mysqli_connect(...);

if (isset($_FILES['dataCliente']) && $_FILES['dataCliente']['error'] === UPLOAD_ERR_OK) {
    $archivo = $_FILES['dataCliente']['tmp_name'];
    $lineas = file($archivo);
    $i = 0;
    $agregados = 0;

    foreach ($lineas as $linea) {
        $i++;
        $linea = trim($linea);
        if (empty($linea)) continue;

        $datos = explode(";", $linea);
        if (count($datos) < 7) {
            echo "<p style='color:red;'>Línea $i inválida: menos de 7 columnas.</p>";
            continue;
        }

        // Escapar y limpiar datos
        list($nombre, $apellido, $documento, $id_tipo_doc,
             $telefono, $correo, $direccion) =
            array_map(function($v) use ($con) {
                return mysqli_real_escape_string($con, trim($v));
            }, $datos);

        $id_tipo_doc = intval($id_tipo_doc);
        if ($id_tipo_doc <= 0) {
            echo "<p style='color:orange;'>Línea $i: id_tipo_doc no válido ($id_tipo_doc).</p>";
            continue;
        }

        // Verificar que exista el tipo de documento
        $rt = mysqli_query($con,
            "SELECT 1 FROM tipo_documento WHERE id_tipo_doc = $id_tipo_doc");
        if (!$rt || mysqli_num_rows($rt) === 0) {
            echo "<p style='color:orange;'>Línea $i: id_tipo_doc ($id_tipo_doc) no existe.</p>";
            continue;
        }

        // Evitar duplicados por documento
        $rc = mysqli_query($con,
            "SELECT id_cliente FROM clientes WHERE documento_cliente = '$documento'");
        if (mysqli_num_rows($rc) > 0) {
            echo "<p style='color:gray;'>Línea $i: documento '$documento' ya existe. Omitido.</p>";
            continue;
        }

        // Insertar en clientes
        $sql = "INSERT INTO clientes
            (nombre_cliente, apellido_cliente, documento_cliente,
             id_tipo_doc, telefono, correo, direccion)
         VALUES
            ('$nombre', '$apellido', '$documento',
             $id_tipo_doc, '$telefono', '$correo', '$direccion')";
        if (mysqli_query($con, $sql)) {
            $agregados++;
        } else {
            echo "<p style='color:red;'>Línea $i: error MySQL: "
                . mysqli_error($con) . "</p>";
        }
    }

    echo "<hr><p>Total de clientes agregados: <strong>$agregados</strong></p>";
    echo "<p><a href='index.php'>Volver</a></p>";

} else {
    echo "<p style='color:red;'>No se subió un archivo válido.</p>";
}
?>

</body>
</html>
