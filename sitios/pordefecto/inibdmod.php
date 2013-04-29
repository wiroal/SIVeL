<?php
// vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker fileencoding=utf-8:
/**
 * Inicialización de base de datos y rutas
 *
 * PHP version 5
 *
 * @category  SIVeL
 * @package   SIVeL
 * @author    Vladimir Támara <vtamara@pasosdeJesus.org>
 * @copyright 2012 Dominio público. Sin garantías.
 * @license   https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público. Sin garantías.
 * @link      http://sivel.sf.net
 * Acceso: SÓLO DEFINICIONES
 */


// Mejor no empleamos sobrecarga porque no funciona en
// diversas versiones de PHP
if (!defined('DB_DATAOBJECT_NO_OVERLOAD')) {
    define('DB_DATAOBJECT_NO_OVERLOAD',1);
}

if (!isset($dbusuario)) {
    die("inibdmod.php debe incluirse después de incluir conf.php de un sitio");
}

/** DSN de la base de datos.  */
$dsn = "pgsql://$dbusuario:$dbclave@$dbservidor/$dbnombre";

require_once "PEAR.php";

require_once 'DB/DataObject.php';
require_once 'DB/DataObject/FormBuilder.php';

global $pear;
$pear = new PEAR();
$options =& $pear->getStaticProperty('DB_DataObject', 'options');
$options = array(
    'database' => $dsn,
    'schema_location' => $dirsitio . '/DataObjects',
    'class_location' => 'DataObjects/',
    'require_prefix' => 'DataObjects/',
    'class_prefix' => 'DataObjects_',
    'extends_location' => 'DataObjects_',
    'debug' => isset($GLOBALS['DB_Debug']) ? $GLOBALS['DB_Debug'] : '0',
);

$_DB_DATAOBJECT_FORMBUILDER['CONFIG'] = array (
    'select_display_field' => 'nombre',
    'hidePrimaryKey' => false,
    'submitText' => 'Enviar',
    'linkDisplayLevel' => 2,
    'dbDateFormat' => 1,
    'dateElementFormat' => "d-m-Y",
    'useCallTimePassByReference' => 0
);


/* Rutas en particular donde haya subdirectorios DataObjects */
$rutas_include = ini_get('include_path').
    ":.:$dirserv:$dirserv/$dirsitio:$dirsitio:";
$lm = explode(" ", $modulos);
foreach ($lm as $m) {
    $rutas_include .= "$m:$m/DataObjects/:";
}

/* La siguiente requiere AllowOverride All en configuración de Apache */
ini_set('include_path', $rutas_include);

foreach ($lm as $m) {
    if (file_exists("$m/conf.php")) {
        require_once "$m/conf.php";
    }
}
//print_r($GLOBALS['ficha_tabuladores']);

foreach ($GLOBALS['remplaza_ficha_tabuladores'] as $a) {
    $nom = $a[0];
    $arc = $a[1];
    $nft = array();
    for ($nf = 0;
        $nf < count($GLOBALS['ficha_tabuladores']);
        $nf++
    ) {
        $f = $GLOBALS['ficha_tabuladores'][$nf];
        if ($f[0] == $nom) {
            $f[1] = $arc;
        }
        $nft[$nf] = $f;
    }
    $GLOBALS['ficha_tabuladores'] = $nft;
}

foreach ($GLOBALS['elimina_ficha_tabuladores'] as $idf) {
    for ($nf = 0;
        $nf < count($GLOBALS['ficha_tabuladores']);
        $nf++
    ) {
        $f = $GLOBALS['ficha_tabuladores'][$nf];
        if ($f[0] == $idf) {
            $puestoelim = $f[2];
            $puesto = $nf;
            break;
        }
    }
    $nft = array();
    for ($nf = 0;
        $nf < count($GLOBALS['ficha_tabuladores']) - 1;
        $nf++
    ) {
        $f = $GLOBALS['ficha_tabuladores'][$nf];
        $fpe = $f[2];
        if ($fpe > $puestoelim) {
            $f[2] = $fpe - 1;
        }
        if ($nf < $puesto) {
            $nft[$nf] = $f;
        } else if ($nf >= $puesto) {
            $nft[$nf] = $GLOBALS['ficha_tabuladores'][$nf + 1];
        }
    }
    $GLOBALS['ficha_tabuladores'] = $nft;
}
//echo "<hr>";print_r($GLOBALS['ficha_tabuladores']); 



foreach ($GLOBALS['nueva_ficha_tabuladores'] as $a) {
    $puesto = $a[0];
    $nom = $a[1];
    $arc = $a[2];
    $puestoelim = $a[3];
    $nft = array();
    for ($nf = 0;
        $nf < count($GLOBALS['ficha_tabuladores']);
        $nf++
    ) {
        $f = $GLOBALS['ficha_tabuladores'][$nf];
        $fpe = $f[2];
        if ($fpe >= $puestoelim) {
            $f[2] = $fpe + 1;
        }
        if ($nf < $puesto) {
            $nft[$nf] = $f;
        } else if ($nf == $puesto) {
            $nft[$nf] = array($nom, $arc, $puestoelim);
            $nft[$nf + 1] = $f;
        } else  {
            $nft[$nf + 1] = $f;
        }
        //echo "OJO nft="; print_r($nft); echo "<br>";
    }
    $GLOBALS['ficha_tabuladores'] = $nft;
}

//var_dump($GLOBALS['ficha_tabuladores']);
//die("x");
