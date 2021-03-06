<?php
// vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker fileencoding=utf-8:
/**
 * Variables de configuración del módulo
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

// Opciones del menú

$GLOBALS['modulo'][400] = '';

if (!esta_nueva_ficha('segjudicial')) {
    $GLOBALS['nueva_ficha_tabuladores'][] =  array(
        9, 'segjudicial', 'modulos/segjudicial/PagSegJudicial', 9
    );
}
