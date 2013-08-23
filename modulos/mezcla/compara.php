<?php
//  vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker fileencoding=utf-8:
/**
 * Mezcla dos casos
 *
 * PHP version 5
 *
 * @category  SIVeL
 * @package   SIVeL
 * @author    Vladimir Támara <vtamara@pasosdeJesus.org>
 * @copyright 2011 Dominio público. Sin garantías.
 * @license   https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público. Sin garantías.
 * @version   CVS: $Id: victimasrep.php,v 1.1 2012/01/11 17:41:30 vtamara Exp $
 * @link      http://sivel.sf.net
*/

/**
 * Detecta víctimas repetidas
 */

require_once "aut.php";
require_once $_SESSION['dirsitio'] . "/conf.php";
require_once 'misc.php';


foreach ($GLOBALS['ficha_tabuladores'] as $tab) {
    list($n, $c, $o) = $tab;
    if (($d = strrpos($c, "/"))>0) {
        $c = substr($c, $d+1);
    }
    // @codingStandardsIgnoreStart
    require_once "$c.php";
    // @codingStandardsIgnoreEnd
}

/**
 * Retorna subcadena izquierda de $s hasta el punto
 *
 * @param string $s Cadena
 *
 * @return Prfijo izquierdo de z hasta .
 */
function hastapunto($s) 
{
    $p = strpos($s, '.');
    $r = $s;
    if ($p !== false) {
        $r = substr($s, 0, $p); 
    }
    return $p;
}

/**
 * Punto de entrada
 *
 * @param string $dsn URl de la base
 *
 * @return void
 */
function muestra($dsn)
{
    $aut_usuario = "";
    $db = autentica_usuario($dsn, $accno, $aut_usuario, 31);
    encabezado_envia("Comparación y mezcla de 2 casos");

    $nid = 0;
    $id1 = 0;
    $id2 = 0;
    $err = "";
    foreach ($_POST as $l => $v) {
        if (substr($l, 0, 2) == 'id') {
            if ($nid == 0) {
                $id1 = (int)substr($l, 2);
            } elseif ($nid == 1) {
                $id2 = (int)substr($l, 2);
            } 
            $nid++;
        }
    }
    if (isset($_GET['id1']) && isset($_GET['id2'])) {
        $id1 = (int)$_GET['id1'];
        $id2 = (int)$_GET['id2'];
        $nid = 2;
    }
    if ($nid != 2 || $id1 <=0 || $id2 <= 0 || $id1 == $id2) {
        die("Debe se&ntilde;alar dos casos en lugar de $nid");
    }
    if ($id2 < $id1) {
        $t = $id1;
        $id1 = $id2;
        $id2 = $t;
    }
    echo "Se unir&aacute;n fuentes y anexos de los dos casos";
    $r = array('caso_id' => array('Código', $id1, $id2, 3)); 
    // 'Id' => array('Etiqueta', 'Valor 1', 'Valor 2', 'preferido 1 or 2')
    foreach ($GLOBALS['ficha_tabuladores'] as $tab) {
        list($n, $c, $o) = $tab;
        if (($d = strrpos($c, "/"))>0) {
            $c = substr($c, $d+1);
        }
        //echo "OJO $n $c $o<br>";
        if (is_callable(array($c, 'compara'))) {
            //echo "OJO compara<br>";
            call_user_func_array(
                array($c, 'compara'),
                array(&$db, &$r, $id1, $id2, null)
            );
        } else {
            echo_esc("Falta compara en $n, $c");
        }
    }

    echo "<form action='opcion.php?num=1005' method='POST' target='_blank'>";
    echo "<input type='hidden' name='id1' value='$id1'/>";
    echo "<input type='hidden' name='id2' value='$id2'/>";
    echo "<table border='1'>";
    echo "<tr><th>Dato</th><th colspan='2'>Caso 1<"
        . "/th><th colspan='2'>Caso 2</th><th>Nuevo</th></tr>";
    foreach ($r as $i => $v) {
        $check1 = "checked='checked'";
        $check2 = "";
        $check3 = "";
        if ($v[3] == 3) {
            $check3 = "checked='checked'";
            $check1 ="";
        } else if ($v[3] == 2) {
            $check2 = "checked='checked'";
            $check1 ="";
        }
        $nc_html = htmlentities($v[0], ENT_COMPAT, 'UTF-8');
        $v1_html = htmlentities($v[1], ENT_COMPAT, 'UTF-8');
        $v2_html = htmlentities($v[2], ENT_COMPAT, 'UTF-8');
        if ($nc_html == "C&oacute;digo") {
            $v1_html = enlace_edita($v[1]);
            $v2_html = enlace_edita($v[2]);
        }
        echo "<tr><td>" . $nc_html . "</td><td>" 
            . $v1_html . "</td><td>"
            . "<input type='radio' name='$i' value='1' $check1></td><td>"
            . $v2_html . "</td><td>"
            . "<input type='radio' name='$i' value='2' $check2></td>";
        if ($check3 != "") {
            echo "<td>"
                . "<input type='radio' name='$i' value='3' $check3></td>";
        } else {
            echo "<td></td>";
        }
        echo "</tr>\n";
    }
    echo "</table>";
    echo "<center><input type='submit' value='Mezclar'/></center>";


}


?>
