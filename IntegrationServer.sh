#!/bin/bash
#==========================================================================================
# Script de creacion de servidores de integracion para el bus                             #
# Autor: Aristides A. Morcillo                                                            #
# Fecha: 06/16/2018                                                                       #
#==========================================================================================
# ======================= < VALIDACION DE USUARIO > =======================
#if [ "$LOGNAME" != "mqm" ]
#  then
#       echo "ATENCION:  Para ejecutar este comando debe conectarse con su usuario y posteriormente ejecutar el comando (su - mqm)"
#       exit 1
# fi
 echo "inciando  \n"
# ------------------- < INICIALIZACION DE VARIABLES > ------------------
clear

integrationNode=$1;
nwIntegrationServ=$2; 

echo "** Integration Node:  "$integrationNode "\n";
echo "** New Integration Server:  "$nwIntegrationServ "\n";


echo "Listado de Integration Server: \n"
     mqsilist $integrationNode
echo "Fin Listado de Integration Server: \n"
echo "\n**Listado de propiedades: \n"
mqsireportproperties $integrationNode -e BG_CBL_CC_001 -o ComIbmCacheManager -r>resReportProp.txt
echo "\n**Se ha creado el archivo -resReportProp.txt-, con el resultado de las propiedades \n"

echo "\n** Se procede con la creacion de:  "$nwIntegrationServ "\n";
     mqsicreateexecutiongroup $integrationNode -e $nwIntegrationServ

echo "\n**Inicia revision de propiedades: \n"

for LINE in `cat resReportProp.txt ` #LINE guarda el resultado del fichero resReportProp.txt, que contiene la salida del
#comando mqsireportproperties
do
    PROPKEY=`echo $LINE | cut -d "=" -f1` #Extrae El propierty key
    PROPVALUE=`echo $LINE | cut -d "=" -f2` #Extrae El proierty value
    
case $PROPKEY in
     listenerPort)      
          LISTENERPORT=$PROPVALUE
		  #echo "el valor de listenerPort es : "$LISTENERPORT
          ;;
     connectionEndPoints)      
          CONNECTIONENDPOINTS=$PROPVALUE
		  #echo "el valor de connectionEndPoints es : "$CONNECTIONENDPOINTS
          ;;
     catalogClusterEndPoints)
          CATALOGCLUSTERENDPOINTS=$PROPVALUE
		  #echo "el valor de catalogClusterEndPoints es : "$CATALOGCLUSTERENDPOINTS
          ;; 
     domainName)
          DOMAINNAME=$PROPVALUE
		  #echo "el valor de domainName es : "$DOMAINNAME
          ;;
     *)
         #echo"-"
          ;;
esac


done  
     
echo "\n Asignando Gestor de memoria caché: puntos finales de conexión: \n" 
	mqsichangeproperties $integrationNode -e $nwIntegrationServ -o ComIbmCacheManager -n connectionEndPoints -v $CONNECTIONENDPOINTS
echo "\n Asignando Gestor de memoria caché: puntos finales de clúster de catálogo: \n"
	mqsichangeproperties $integrationNode -e $nwIntegrationServ -o ComIbmCacheManager -n catalogClusterEndPoints -v $CATALOGCLUSTERENDPOINTS
echo "\n Asignando Gestor de memoria caché: nombre de dominio: \n"
	mqsichangeproperties $integrationNode -e $nwIntegrationServ -o ComIbmCacheManager -n domainName -v $DOMAINNAME
	
echo "\n Inicia Listado de Integration Server: \n"
     mqsilist $integrationNode
echo "\n Fin Listado de Integration Server: \n"

echo "\n ***El Archivo resReportProp.txt, sera eliminado: \n"

rm "resReportProp.txt"

echo "\n ***Fin del Programa...... \n"
