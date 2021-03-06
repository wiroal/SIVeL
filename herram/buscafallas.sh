#!/bin/sh
# Busca posibles fallas de seguridad en fuentes de SIVeL
# Dominio público. 2011. Sin Garantías. vtamara@pasosdeJesus.org

#function x {
echo "* Emplear htmlentities_array con $db->getAssoc"
#find . -name "*php" -exec grep -H -e "[\(] *\$db->getAssoc" {} ';'
find . -name "*php" -exec grep -B 1 "getAssoc" {} ';' | sed -e "s/^[^ ]*: *//g" | sed -e "s/^\./|/g;s/  */ /g" | tr -d "\n"  | tr "|" "\n" | grep -v "htmlentities_array"
echo "* Escapar antes de incluir en base de datos para evitar inyecciones SQL"
find . -name "*php" -exec grep -H -e "[^=]= *\$valores\[" {} ';'
find . -name "*php" -exec grep -H -e "[^=]= *\$_REQUEST\[[^=]*$" {} ';'
find . -name "*php" -exec grep -H -e "[^=]= *\$_GET\[[^=]*$" {} ';'
find . -name "*php" -exec grep -H -e "[^=]= *\$_POST\[[^=]*$" {} ';'
echo "* Emplear loadArray(htmlentities_array en lugar de loadDbResult"
find . -name "*php" -exec grep -H -e "loadDbResult" {} ';'
echo "* No usar loadQuery sino htmlentities_array(getAssoc"
find . -name "*php" -exec grep "loadQuery" {} ';'

#echo "* Fuentes corresponden a las del CVS: ";
#cvs -z3 update -Pd

echo -n "* Extensiones identificadas en documentación: ";
tot=0;
ident=0;
#for i in `find ./ -type f | sed -e "s/.*[^\/.]\.//g;s/.*htaccess//g;s/.*Makefile//g;s/.*\/CVS\/.*//g;s/.*db2rep//g;s/\.git.*//g;s/.*~//g;s/.*tmp//g;s/.*[0-9]$//g;s/.*README.*//g;s/.*bak//g;s/.*htm.*//g;s/.*xcf//g;s/.*tex//g;s/.*swp//g;s/.*aux//g;s/.*dat//g;s/.*doc//g;s/.*dvi//g;s/.*inc//g;s/.*ini//g;s/.*log//g;s/.*idx//g;s/.*inc//g;s/.*log//g;s/.*out//g;s/.*sample//g;s/.*ps//g;s/.*pot//g;s/.*po//g" | sort -u`; do
for i in `find ./ -type f | sed -e "s/.*[^\/.]\.//g;s/.*htaccess//g;s/.*Makefile//g;s/.*\/CVS\/.*//g;s/.*db2rep//g;s/\.\/\.git.*//g;s/.*~//g;s/.*tmp//g;s/.*README//g;s/.*[0-9][0-9]//g" | sort -u`; do
    grep ".$i" ./doc/per-fuentes.xdbk > /dev/null 2> /dev/null
    if (test "$?" != "0") then {
        echo -n " *Falta $i* ";
    } else {
        ident=`expr $ident + 1`
    } fi;
    tot=`expr $tot + 1`
done
echo "  $ident / $tot";

echo -n "* Herramientas identificadas en documentación: "
tot=0;
ident=0;
for i in `find ./ -name "*\.sh"`; do
    n=`basename $i`;
    grep -l -e "$n" ./doc/*xdbk > /dev/null 2>&1
    if (test "$?" != "0") then {
        echo " *Falta $n* ";
    } else {
        ident=`expr $ident + 1`
    } fi;
    tot=`expr $tot + 1`
done;
echo "  $ident / $tot"

echo "* V4.1 Autenticación en páginas que lo requieren, las que no deben decir forma de acceso especial"
find . -name "*php" | sort > /tmp/todos
find . -name "*php" -exec grep -l -e "autentica_usuario" -e "Acceso: S.*LO DEFINICIONES" -e "Acceso: CONSULTA P.*BLICA" -e "Acceso: INTERPRETE DE COMANDOS" {} ';' | sort > /tmp/conAutentica 
diff /tmp/todos /tmp/conAutentica


echo "* V5.1, V5.2 Funcion procesa llama valores a su primer argumento"
p=`find . -name "*php" -exec grep -l -e "function *procesa *(" {} ';'`
grep -A 1 "function *procesa" $p | grep "^[^ ]*:" | grep -v -e "procesa *( *\&\$valores"

echo "V5.1, V5.2 Variables de entrada sin asignacion, comparación, isset, var_escapa_aut o var_escapa:"
for b in _REQUEST _POST _GET valores ; do
	p=`find . -name "*php" -exec grep -l -e "$b *\[" {} ';'`
	grep -A 1 "$b *\[" $p | grep "^[^ ]*:" | grep -v -e "isset *( *\$$b" -e "unset *( *\$$b" -e "\$$b[^ ]* *=" -e "\$$b[^ ]* *!=" -e "(int) *\$$b" -e "var_escapa( *\$$b"  -e "empty *( *\$$b" -e "^[^\$]*//" -e "var_escapa_aut( *\$$b"
done;
p=`find . -name "*php" -exec grep -l -e "_submitValues *\[" {} ';'`
grep -A 1 "_submitValues *\[" $p | grep "^[^ ]*:" | grep -v -e "isset *(.*->_submitValues" -e "unset *(.*->_submitValues" -e "_submitValues[^ ]* *=" -e "_submitValues[^ ]* *!=" -e "(int).*->_submitValues" -e "var_escapa(.*->_submitValues"  -e "== .*->_submitValues"

#| grep -v -e "\$_REQUEST[^ ]* *!=" 
#for i in `find . -name "*php" -exec grep -l -e "_REQUEST" {} ';'`; do
#	grep -C 1 -e "isset *( *\$_REQUEST"  -e "(int) *\$_REQUEST" -e "var_escapa *( *\$_REQUEST" $i
#done

#}
echo "OWASP V6.1 Validando salida";
p=`find . -name "*php" -exec grep -l -e "[ \t]echo[ \t]" -e print_r {} ';'`
for i in $p; do
	awk "/ echo / { ini = 1; }
	/.*/ { if (ini == 1) { print \"$i: \" \$0; } }
	/ ?>/ { ini = 0; }
	/; *\$/ { ini = 0; }" $i
done | grep '\$' | grep -v -e '(int)\$' -e "OJO" -e "htmljs" -e "htmlspecialchars" -e "pruebas" -e GLOBALS -e "htmlentities" -e "//" -e "urlencode" -e "html_" -e "Html" -e "adjunto_" -e "Adjunto" -e "count" -e "_ne" -e "json_encode" -e "format";

