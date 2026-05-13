<?php

$valor1 = $_GET["valor1"];
$valor2 = $_GET["valor2"];

$resultado = $valor1 + $valor2;

if ($resultado >= 50) {
    echo "O valor inserido é maior ou igual a 50!";
} else {
    echo "O valor inserido é menor que 50!";
}
?>