<?php
// vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker fileencoding=utf-8:
/**
 * Objeto asociado a una tabla de la base de datos.
 * Parcialmente generado por DB_DataObject.
 *
 * PHP version 5
 *
 * @category  SIVeL
 * @package   SIVeL
 * @author    Vladimir Támara <vtamara@pasosdeJesus.org>
 * @copyright 2004 Dominio público. Sin garantías.
 * @license   https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público. Sin garantías.
 * @link      http://sivel.sf.net
 * Acceso: SÓLO DEFINICIONES
 */

/**
 * Definicion para la tabla pconsolidado.
 */
require_once 'DataObjects/Basica.php';

/**
 * Definicion para la tabla pconsolidado.
 * Ver documentación de DataObjects_Basica.
 *
 * @category SIVeL
 * @package  SIVeL
 * @author   Vladimir Támara <vtamara@pasosdeJesus.org>
 * @license  https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público.
 * @link     http://sivel.sf.net/tec
 * @see      DataObjects_Basica
 */
class DataObjects_Pconsolidado extends DataObjects_Basica
{

    var $__table = 'pconsolidado';    // table name
    var $no_columna;                     // int4(4)  not_null primary_key
    var $rotulo;                          // varchar(-1)  not_null
    var $tipo_violencia;                  // varchar(-1)  not_null
    var $clasificacion;                   // varchar(-1)  not_null
    var $peso;                            // int

    /**
     * Constructora
     * return @void
     */
    public function __construct()
    {
        parent::__construct();

        $this->nom_tabla = _('Columnas de Reporte Consolidado');
        $this->fb_fieldLabels['rotulo'] = _('Rotulo');
        $this->fb_fieldLabels['tipo_violencia'] = _('Tipo de Violencia');
        $this->fb_fieldLabels['clasifcacion'] = _('Clasificación');
        $this->fb_fieldLabels['peso'] = _('Peso');
    }


    var $fb_linkDisplayFields = array('no_columna', 'rotulo', 'peso');
    var $fb_hidePrimaryKey = true;

    var $fb_preDefOrder = array(
        'no_columna',
        'rotulo',
        'tipo_violencia',
        'clasificacion',
        'peso',
        'fechacreacion',
        'fechadeshabilitacion',
    );
    var $fb_fieldsToRender = array(
        'no_columna',
        'rotulo',
        'tipo_violencia',
        'clasificacion',
        'peso',
        'fechacreacion',
        'fechadeshabilitacion',
    );
    var $fb_fieldsRequired = array(
        'no_columna',
        'rotulo',
        'tipo_violencia',
        'clasificacion',
        'tipo_fuente',
        'fechacreacion',
    );


    /**
     * Ajusta formulario generado.
     *
     * @param object &$form      Formulario HTML_QuickForm
     * @param object &$formbuilder Generador DataObject_FormBuilder
     *
     * @return void
     */
    function postGenerateForm(&$form, &$formbuilder)
    {
        parent::postGenerateForm($form, $formbuilder);

        if (isset($this->no_columna)) {
            $dcategoria = objeto_tabla('categoria');
            $dcategoria->col_rep_consolidado = $this->no_columna;
            $dcategoria->orderby('id');
            $sep = $lv = "";
            $dcategoria->find();
            while ($dcategoria->fetch()) {
                $idc = $dcategoria->id;
                $lv .= $sep . "<a href='detalle.php?"
                    . "id=id=$idc&tabla=categoria'>"
                    . $dcategoria->id_tipo_violencia . $idc
                    . "</a>";
                $sep = ", ";
            }
            if ($lv != '') {
                $form->addElement(
                    'static', 'empleada', _('Empleada en categorias'), $lv
                );
            }
        }

    }


}
?>