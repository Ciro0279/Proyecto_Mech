<?php
require_once "conexion.php";

$conn = Conexion::Conectar();

$sql = "SELECT id_usuario, contraseña FROM usuarios";
$stmt = $conn->prepare($sql);
$stmt->execute();

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $id = $row['id_usuario'];
    $pass_plain = $row['contraseña'];

    if (strlen($pass_plain) < 60) {  // Solo si NO está hasheada
        $pass_hashed = password_hash($pass_plain, PASSWORD_DEFAULT);

        $sql_update = "UPDATE usuarios SET contraseña = :pass WHERE id_usuario = :id";
        $stmt_update = $conn->prepare($sql_update);
        $stmt_update->bindParam(':pass', $pass_hashed);
        $stmt_update->bindParam(':id', $id);
        $stmt_update->execute();
    }
}

echo "Contraseñas actualizadas correctamente.";
?>
