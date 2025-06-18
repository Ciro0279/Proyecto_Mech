<?php
require_once "../conexion.php";
session_start();

$error = ''; // Inicializa la variable de error

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $correo = $_POST['usuario'];
    $password_form = $_POST['password'];

    $conn = Conexion::Conectar();

    $sql = "SELECT id_usuario, contraseña, rol, nombre FROM usuarios WHERE correo = :correo";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':correo', $correo);
    $stmt->execute();

    if ($stmt->rowCount() === 1) {
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);
        $password_bd = $usuario['contraseña'];

        if (password_verify($password_form, $password_bd)) {
            $_SESSION['id_usuario'] = $usuario['id_usuario'];
            $_SESSION['nombre'] = $usuario['nombre'];
            $_SESSION['rol'] = $usuario['rol'];

            header("Location: ../dashboard/index.php");
            exit;
        } else {
            $error = "Contraseña incorrecta";
        }
    } else {
        $error = "Usuario no encontrado";
    }
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Inicio Mechanix</title>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>    

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }
        /* Flexbox for sticky footer */
        #layoutAuthentication {
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* Ensures it takes at least the full viewport height */
        }
        #layoutAuthentication_content {
            flex-grow: 1; /* Allows content to expand and push footer down */
        }
    </style>
<body>
    <div id="layoutAuthentication">
        <div id="layoutAuthentication_content">
            <main>
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-5">
                            <div class="card shadow-lg border-0 rounded-lg mt-5 card-custom">
                                <div class="card-header">
                                    <div class="text-center mb-4">
                                    <img src="../images/logo.png" alt="Logo Mechanix" style="max-width: 150px;">
                                </div>
                                    <h3 class="text-center font-weight-light my-4">Inicio</h3>
                                </div>
                    <div class="card-body">
                                    <form method="POST" action="<?php echo $_SERVER['PHP_SELF']; ?>">
                                        <div class="form-group"><label class="small mb-1" for="inputEmailAddress">Usuario</label>
                                        <input class="form-control py-4" id="inputEmailAddress" name="usuario" type="email" placeholder="Ingrese su dirección de correo" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="small mb-1" for="inputPassword">Contraseña</label>
                                            <input class="form-control py-4" id="inputPassword" name="password" type="password" placeholder="Contraseña">
                                        </div>
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" id="inputRememberPassword" type="checkbox" />
                                            <label class="form-check-label" for="inputRememberPassword">Recordar Contraseña</label>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                                            <a class="small" href="js/password.html">Recuperar contraseña?</a>
                                            <button class="btn btn-light text-primary fw-bold" type="submit">Ingresar</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="card-footer text-center py-3">
                                    <div class="small"><a href="register.html">¿Necesitas una cuenta? ¡Comunícate con el Administrador!</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div> 
        <div id="layoutAuthentication_footer">
        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">Copyright &copy; www.mechanix.co</div>
                    <div>
                        <a href="#">Política de Privacidad</a>
                        &middot;
                        <a href="#">Términos &amp; Condiciones</a>
                    </div>
                </div>
            </div>
        </footer>
        </div>
    </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <?php if (!empty($error)) : ?>
        <script>
            Swal.fire({
            icon: 'error',
            title: 'Oops...',
        text: '<?php echo $error; ?>',
        confirmButtonColor: '#3085d6'
        });
        </script>
        <?php endif; ?>
</body>
</html>
