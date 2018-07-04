#!/usr/bin/env bash
set -e
#ALGORITMO PARA DESCARGAS DE MERIT DEM [Multi-Error-Removed Improved-Terrain DEM] [SCRAPER]
#Primera versión: 2018-07-04
#=================================================================================#
#Parámetros de entrada
#north,east coordenadas - centro lower left pixel (deben ser multiplos de 5) -
url="http://hydro.iis.u-tokyo.ac.jp/~yamadai/MERIT_DEM/distribute/v1.0.2/5deg/" 
dir_output=MDET #directorio donde se descargará archivo .tif 
user=usuario #usuario dado por administradores de sitio
password=pass #pass dado por administradores de sitio
while getopts "n:e:O:u:p:" opt; do
  case $opt in
    n)
	  north=$OPTARG 
      ;;
    e)
	  east=$OPTARG
      ;;
    O)
	  dir_output=$OPTARG
      ;;
      
    u)
	  user=$OPTARG
      ;;
      
    p)
	  password=$OPTARG
      ;;
   esac
done
#======================================================================#
#Funciones de procedimiento
function unsign
{
	echo "$1" | cut -d- -f2
}
function ad_zero
{
	if [ "$1" -lt 100 ]; then echo 0"$1"; fi
}
function coors
{
	if [ "$(echo $1 | cut -c1-1)" == "-" ]
	then
		if [ "$2" == "x" ]
		then
			east=$(unsign $1)
			east=$(ad_zero $east)
			east="w""$east";
		else
			north=$(unsign $1)
			north="s""$north";
		fi
	else
		if [ "$2" == "x" ]
		then
			east=$(ad_zero $east)
			east="e""$east";
		else
			north="n""$north"
		fi
	fi
	file="$north""$east"_dem.tif
}
function check_pars
{
	if  [ -z "$north" ] || [-z "$south" ]; then echo "debe ingresar coordenadas norte y sur. Sintaxis: get_merit_dem.sh -n (latitud norte) -e (latitud este) -d [dir_output]"; exit 1; fi
}
function check_file_exist
{
	if [ -f $dir_output/$file ]; then echo "archivo exitente en $dir_output. Saliendo"; exit 2; fi
}
function get_merit
{
	catch="$url/$file"; outfile="$dir_output/$file";
	wget $url --user=$user --password=$pass -P $product/$FILE
}
#=======================================================================
#Estructura de Procedimiento
#a. Toma coordenadas de entrada y transforma a formato de patrón de archivo (para búsqueda y captura)
coors $north y
coors $east x
#b. Evalúa si el archivo ya existe en el sistema, en la carpeta de salida especificada en dir_output
check_file_exist
#c. En caso de no existir descarga
get_merit
