<?php
session_start();

include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

//recepcion de datos enviados mediante POST desde ajax
$usuario = (isset($_POST['usuario'])) ? $_POST['usuario'] : '';
$password = (isset($_POST['password'])) ? $_POST['password'] : '';

$pass = md5($password); // encripto la clave enviada por el usuario para compararla con la clave encriptada

$consulta = "SELECT * FROM usuarios WHERE usuario='$usuario AND password='$pass' AND Rol='Administrador' "
$resultado = $conexion->prepare($consulta);
$resultado->execute();

if($resultado->rowCount() >= 1){
    $data = $resultado->fetchAll(PDO::FETCH_ASSOC);
    $_SESSION["s_"] = $usuario;

}else{
    $_SESSION["s_usuario"] = null;
    $data=null;
}

print json_encode($data);
$conexion=null;

//usuarios de prueba en la base de datos
//usuario: admin pass:12345
//usuario: demo pass:demo