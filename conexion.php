<?php
class Conexion {
    public static function Conectar() {
        $servidor = "localhost";
        $nombre_bd = "mechanix_bd";
        $usuario = "root";
        $password = "";
        $opciones = array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8");

        try {
            $conexion = new PDO("mysql:host=$servidor;dbname=$nombre_bd", $usuario, $password, $opciones);
            $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $conexion;
        } catch (Exception $e) {
            die("El error de conexión es: " . $e->getMessage());
        }
    }
}
?>
