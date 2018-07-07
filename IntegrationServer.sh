#!/bin/bash
#==========================================================================================
# Script de creacion de servidores de integracion para el bus                                    #
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
     mqsilist $1
echo "Fin Listado de Integration Server: \n"

echo "** Se procede con la creacion de:  "$nwIntegrationServ "\n";
     mqsicreateexecutiongroup $1 -e $2
echo "\n Asignando Gestor de memoria caché: puntos finales de conexión: \n" 
	mqsichangeproperties $1 -e $2 -o ComIbmCacheManager -n connectionEndPoints -v "localhost:2850"
echo "\n Asignando Gestor de memoria caché: puntos finales de clúster de catálogo: \n"
	mqsichangeproperties $1 -e $2 -o ComIbmCacheManager -n catalogClusterEndPoints -v "BG_IBUSBEL02_localhost_2850:localhost:2853:2851"
echo "\n Asignando Gestor de memoria caché: nombre de dominio: \n"
	mqsichangeproperties $1 -e $2 -o ComIbmCacheManager -n domainName -v "WMB_BG_IBUSBEL02_localhost_2850"
	
echo "\n Listado de Integration Server: \n"
     mqsilist $1
echo "\n Fin Listado de Integration Server: \n"
