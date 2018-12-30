#!/bin/bash
#Vyctu cistou integer hodnotu teploty a vlhkosti ze STE2 pomoci SNMP
temp_raw=$(snmpwalk -Oqv -v 2c -c public 10.0.0.30 1.3.6.1.4.1.21796.4.9.3.1.5.2)
#echo "$temp_raw"
hum_raw=$(snmpwalk -Oqv -v 2c -c public 10.0.0.30 1.3.6.1.4.1.21796.4.9.3.1.5.1)
#echo "$hum_raw"

#Pridam desetinou tecku, ktera chybi
temp_final=$(echo "$temp_raw" | sed 's/.$/.&/')
echo "Teplota:" "$temp_final"
hum_final=$(echo "$hum_raw" | sed 's/.$/.&/')
echo "Vlhkost:" "$hum_final"

#Poslu na tmep.cz server (-I pro zobrazeni statusu HTTP odpovedi)
curl -I "http://subdomena.tmep.cz/?GUID=${temp_final}&humV=${hum_final}"
