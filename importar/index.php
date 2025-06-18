<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Importar Clientes desde CSV</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        body { padding-top: 60px; }
        .file-input__label { cursor: pointer; display: inline-block; padding: 10px 20px; background-color: #563d7c; color: #fff; border-radius: 5px; }
        .btn-enviar { background-color: #28a745; color: white; padding: 10px 25px; border: none; border-radius: 4px; }
        table th, table td { vertical-align: middle; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <a class="navbar-brand" href="#">Importar Clientes</a>
</nav>

<div class="container mb-5">
    <h3 class="text-center mb-4">Importar <span class="text-primary">Clientes</span> desde archivo CSV</h3>
    
    <div class="row">
        <div class="col-md-5">
            <form action="subir_csv.php" method="POST" enctype="multipart/form-data">
                <div class="mb-3">
                    <input type="file" name="dataCliente" id="file-input" class="form-control" accept=".csv" required>
                </div>
                <div class="text-center">
                    <input type="submit" name="subir" class="btn-enviar" value="Subir Archivo CSV">
                </div>
            </form>
        </div>

        <div class="col-md-7">
            <?php
            include('config.php');
            $sql = "SELECT * FROM clientes ORDER BY id_cliente ASC";
            $resultado = mysqli_query($con, $sql);
            $total = mysqli_num_rows($resultado);
            ?>
            <h6 class="text-center">Clientes registrados <strong>(<?php echo $total; ?>)</strong></h6>

            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Nombre</th>
                        <th>Apellido</th>
                        <th>Documento</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Dirección</th>
                    </tr>
                </thead>
                <tbody>
                <?php 
                $i = 1;
                while ($cliente = mysqli_fetch_assoc($resultado)) { ?>
                    <tr>
                        <td><?= $i++ ?></td>
                        <td><?= $cliente['nombre_cliente'] ?></td>
                        <td><?= $cliente['apellido_cliente'] ?></td>
                        <td><?= $cliente['documento_cliente'] ?></td>
                        <td><?= $cliente['telefono'] ?></td>
                        <td><?= $cliente['correo'] ?></td>
                        <td><?= $cliente['direccion'] ?></td>
                    </tr>
                <?php } ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>

