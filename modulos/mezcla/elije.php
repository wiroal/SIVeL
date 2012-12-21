<?php
//  vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker:
/**
 * Detecta víctimas repetidas
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
require_once 'HTML/QuickForm/Controller.php';
require_once 'HTML/QuickForm/Action/Display.php';
require_once 'HTML/QuickForm/Action/Next.php';
require_once 'HTML/QuickForm/Action/Back.php';
require_once 'HTML/QuickForm/Action/Jump.php';
require_once 'HTML/QuickForm/header.php';
require_once 'HTML/QuickForm/date.php';
require_once 'HTML/QuickForm/text.php';
require_once 'PagTipoViolencia.php';
require_once 'PagUbicacion.php';
require_once 'ResConsulta.php';
require_once 'misc.php';


/**
 * Acción que responde al boton Comparar dos caso por numero
 *
 * @category SIVeL
 * @package  SIVeL
 * @author   Vladimir Támara <vtamara@pasosdeJesus.org>
 * @license  http://creativecommons.org/licenses/publicdomain/ Dominio Público.
 * @link     http://sivel.sf.net/tec
 */
class AccionComparaDos extends HTML_QuickForm_Action
{
    /**
     * Ejecuta acción
     *
     * @param object &$page      Página
     * @param string $actionName Acción
     *
     * @return void
     */
    function perform(&$page, $actionName)
    {
        $pId1   = var_post_escapa('id1', $db);
        $pId2   = var_post_escapa('id2', $db);

        header("Location: opcion.php?num=1004&id1=$pId1&id2=$pId2");

        die("compara");
    }
}

/**
 * Responde a botón Consulta
 *
 * @category SIVeL
 * @package  SIVeL
 * @author   Vladimir Támara <vtamara@pasosdeJesus.org>
 * @license  https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público.
 * @link     http://sivel.sf.net/tec
 */
class AccionVictimasrep extends HTML_QuickForm_Action
{

    /**
     * Presenta categorias que conformaran cada columna de la tabla.
     * Depuración
     *
     * @param handle  &$db    Conexión a BD
     * @param array   $cataux Cat
     * @param unknown $pResto pResto
     * @param unknown $ncol   Número de columnas
     *
     * @return void
     */
    function depTabla(&$db, $cataux, $pResto, $ncol)
    {
        $n = 1;
        $sep = "";
        foreach ($cataux as $l => $lc) {
            $p = objeto_tabla('parametros_reporte_consolidado');
            if (PEAR::isError($p)) {
                die($p->getMessage());
            }
            if ($n==($ncol+1)) {
                $rot = '(Resto)';
            } else if ($p->get($n)==1) {
                $rot = "(" . $p->rotulo.")";
            } else {
                $rot = '';
            }
            if ($n<($ncol+1) || ($pResto && $n==($ncol+1))) {
                $html_l = $sep . "<b>" . htmlentities($l) 
                    . " " . htmlentities($rot) . ":</b>";
                echo $html_l;
                foreach ($lc as $cc) {
                    echo htmlentities($cc) . " ";
                }
                $sep = "; ";
            }
            $n++;
        }
    }




    /**
     * Realiza consulta
     *
     * @param unknown &$page      Página
     * @param unknown $actionName nombre de la acción
     *
     * @return void
     * @access public
     */
    function perform(&$page, $actionName)
    {
        $d = objeto_tabla('categoria');
        if (PEAR::isError($d)) {
            die($d->getMessage());
        }
        //verifica_sin_CSRF($page->_submitValues);

        $fb =& DB_DataObject_FormBuilder::create($d);
        $db =& $d->getDatabaseConnection();

        $pFini      = var_post_escapa('fini', $db);
        $pFfin      = var_post_escapa('ffin', $db);
        assert($pFini['Y'] == '' || ($pFini['Y'] >= 1900));
        assert($pFfin['Y'] == '' || ($pFfin['Y'] >= 1900));
        $pIdClase   = (int)var_post_escapa('id_clase');
        $pIdMunicipio = (int)var_post_escapa('id_municipio', $db);
        $pIdDepartamento = (int)var_post_escapa('id_departamento', $db);

        $campos = array('caso_id' => 'Cód.');
        $tablas = "victima, caso";
        $where = "";

        consulta_and_sinap($where, "victima.id_caso", "caso.id");
        consulta_and(
            $db, $where, "caso.fecha",
            $GLOBALS['consulta_web_fecha_min'], ">="
        );
        consulta_and(
            $db, $where, "caso.fecha",
            $GLOBALS['consulta_web_fecha_max'], "<="
        );

        $tgeo = "";
        if ($pIdClase != '') {
            $tgeo = "ubicacion, ";
            consulta_and_sinap($where, "ubicacion.id_caso", "caso.id");
            consulta_and_sinap(
                $where, "ubicacion.id_departamento", $pIdDepartamento
            );
            consulta_and_sinap($where, "ubicacion.id_municipio", $pIdMunicipio);
            consulta_and_sinap($where, "ubicacion.id_clase", $pIdClase);
        } else if ($pIdMunicipio != '') {
            $tgeo = "ubicacion, ";
            consulta_and_sinap($where, "ubicacion.id_caso", "caso.id");
            consulta_and_sinap(
                $where, "ubicacion.id_departamento", $pIdDepartamento
            );
            consulta_and_sinap($where, "ubicacion.id_municipio", $pIdMunicipio);
        } else if ($pIdDepartamento != '') {
            $tgeo = "ubicacion, ";
            consulta_and_sinap($where, "ubicacion.id_caso", "caso.id");
            $where .= " AND ubicacion.id_departamento IN " 
                . "('$pIdDepartamento', '1000') ";
        }
        
        if ($pFini['Y'] != '') {
            consulta_and(
                $db, $where, "caso.fecha",
                arr_a_fecha($pFini, true), ">="
            );
        }
        if ($pFfin['Y'] != '') {
            consulta_and(
                $db, $where, "caso.fecha",
                arr_a_fecha($pFfin, false), "<="
            );
        }

        $q = " SELECT caso.id, persona.id, " .
            " persona.nombres || ' ' || persona.apellidos, caso.fecha " .
            " FROM $tgeo persona, victima, caso " .
            " WHERE persona.id=victima.id_persona " .
            " AND $where " ;
        $q = "(" . $q . ") ORDER BY 3";
        //echo "q es $q<br>";
        $result = hace_consulta($db, $q);

        $datv = array();
        $dn = array();
        $tv = 0;
        while ($result->fetchInto($row)) {
            $datv[$tv] = array($row[0], $row[1], $row[2], $row[3]);
            $tv++;
        }

        echo "<p>Total de casos con v&iacute;ctima: $tv</p>";
        $suma = array();
        echo "<form  action='opcion.php?num=1004' method='post' target='_blank'>";
        echo "<input name='Comparar' type='submit' class='form' id='Comparar' value='Comparar'>";
        echo "<table border='1'>\n";
        echo "<tr>";
        echo "<td>IdCaso</td><td>IdVic</td>";
        echo "<th>Fecha</th><th>Ubicaci&oacute;n</th><th>V&iacute;ctimas</th>";

        for ($v = 0;$v < $tv; $v++) {
            $idcaso = $datv[$v][0];
            $idvic = $datv[$v][1];
            $nom = $datv[$v][2];
            $fecha = $datv[$v][3];
            $ubi = "";
            $u =&  objeto_tabla('ubicacion');
            $u->id_caso = $idcaso;
            if ($u->find() == 0) {
                $ubi = "";
                //echo "<br/><font color='red'>Caso sin ubicacion: " .  "$idcaso</font>";
            } else {
                $u->fetch();
                $d = $u->getLink('id_departamento');
                $ubi = trim($d->nombre);
                if (isset($u->id_municipio)) {
                    $m =&  objeto_tabla('municipio');
                    $m->id = $u->id_municipio;
                    $m->id_departamento = $u->id_departamento;
                    if ($m->find()==0) {
                        die("Caso " . $idcaso .
                            " referencia municipio inexistente " .
                            $m->id.", " . $m->id_departamento
                        );
                    }
                    $m->fetch();
                    $ubi .= " - ".trim($m->nombre);
                }
            }

            echo "<tr>";
            echo "<td><a href='captura_caso.php?modo=edita&id=" .
                (int)$idcaso . "'>" . (int)$idcaso . "</a></td>";
            echo "<td>" . (int)$idvic . "</td>";
            echo "<td>" . htmlentities($fecha) . "</td><td>" . 
                    htmlentities($ubi) . "</td><td>" .
                    trim(htmlentities($nom)) . "</td>";
            echo "<td><input name='id" . (int)$idcaso .  "' "
                . " type=\"checkbox\"/></td>";
            echo "</tr>";
        }
        echo "</table>";
        echo "</form>";
    }
}


/**
 * Formulario de reporte consolidado
 *
 * @category SIVeL
 * @package  SIVeL
 * @author   Vladimir Támara <vtamara@pasosdeJesus.org>
 * @license  https://www.pasosdejesus.org/dominio_publico_colombia.html Dominio Público.
 * @link     http://sivel.sf.net/tec
 */
class PagVictimasrep extends HTML_QuickForm_Page
{

    /**
     * Constructora.
     *
     * @return void
     */
    function PagVictimasrep()
    {
        $this->HTML_QuickForm_Page('victimiasrep', 'post', '_self', null);

        $this->addAction('id_departamento', new CamDepartamento());
        $this->addAction('id_municipio', new CamMunicipio());


        $this->addAction('compara', new AccionComparaDos());
        $this->addAction('consulta', new AccionVictimasrep());
    }


    /**
     * Construye formulario
     *
     * @return void
     * @access public
     */
    function buildForm()
    {
        encabezado_envia();
        $this->_formBuilt = true;
        $x =&  objeto_tabla('departamento');
        $db = $x->getDatabaseConnection();

        $e =& $this->addElement('header', null, 'Compara dos casos por número');
        $e =& $this->addElement('text', 'id1' );
        $e->setSize(7);
        $e =& $this->addElement('text', 'id2' );
        $e->setSize(7);

        $e =& $this->addElement(
            'submit',
            $this->getButtonName('compara'), 'Comparar'
        );

        $e =& $this->addElement(
            'header', null, 
            'Reporte para identificar v&iacute;ctimas repetidas'
        );

        list($dep, $mun, $cla) = PagUbicacion::creaCamposUbicacion(
            $db, $this, 'victimaIndividual', 
            0, 0
        );

        $this->addElement($dep);
        $this->addElement($mun);
        $this->addElement($cla);

        $cy = date('Y');
        if ($cy < 2005) {
            $cy = 2005;
        }
        $e =& $this->addElement(
            'date', 'fini', 'Desde: ',
            array('language' => 'es', 'addEmptyOption' => true,
            'minYear' => $GLOBALS['anio_min'], 'maxYear' => $cy
            )
        );
        $e =& $this->addElement(
            'date', 'ffin', 'Hasta',
            array('language' => 'es', 'addEmptyOption' => true,
            'minYear' => $GLOBALS['anio_min'], 'maxYear' => $cy
            )
        );
        $e =& $this->addElement('hidden', 'num', (int)$_REQUEST['num']);

        $prevnext = array();
        $sel =& $this->createElement(
            'submit',
            $this->getButtonName('consulta'), 'Consulta'
        );
        $prevnext[] =& $sel;
        $this->addGroup($prevnext, null, '', '&nbsp;', false);

        $tpie = "<div align=right><a href=\"index.php\">" .
            "Men&uacute; Principal</a></div>";
        $e =& $this->addElement('header', null, $tpie);

        if (!isset($_POST['evita_csrf'])) {
            $_SESSION['sin_csrf'] = mt_rand(0, 1000);
        }
        $this->addElement('hidden', 'evita_csrf', $_SESSION['sin_csrf']);

        $this->setDefaultAction('consulta');

    }

}

function muestra($dsn)
{
    $aut_usuario = "";
    autentica_usuario($dsn, $accno, $aut_usuario, 31);

    $wizard =& new HTML_QuickForm_Controller('Victimasrep', false);
    $consweb = new PagVictimasrep();

    $wizard->addPage($consweb);


    $wizard->addAction('display', new HTML_QuickForm_Action_Display());
    $wizard->addAction('jump', new HTML_QuickForm_Action_Jump());

    $wizard->addAction('process', new AccionVictimasrep());

    $wizard->run();
}

?>