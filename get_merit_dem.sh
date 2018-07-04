#!/usr/bin/env bash
set -e
#ALGORITMO PARA DESCARGAS DE MERIT DEM [Multi-Error-Removed Improved-Terrain DEM]
#Parámetros de entrada
#north,east coordenadas  centro lower left pixel (multiplos de 5)
url="http://hydro.iis.u-tokyo.ac.jp/~yamadai/MERIT_DEM/distribute/v1.0.2/5deg/" #n70e095_dem.tif
dir_output=MDET
while getopts "n:e:O:" opt; do
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
   esac
done
#======================================================================#
#Funciones
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
	if  [ -z "$north" ] || [-z "$south" ]; then echo "debe ingresar coordenadas norte y sur"; exit 1; fi
}
function check_file_exist
{
	if [ -f $dir_output/$file ]; then echo "archivo exitente en $dir_output. Saliendo"; exit 3; fi
}
function get_merit
{
	catch="$url/$file"; outfile="$dir_output/$file";
	wget $url --user=$user -P $product/$FILE
}
#=======================================================================
#Procedimiento.
coors $north y
coors $east x
check_file_exist
get_merit
