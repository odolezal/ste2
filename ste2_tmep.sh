#Integrace se serverem TMEP.cz pro IP teplomer a vlhkomer STE2 od HW Group.
#Git: https://github.com/odolezal/ste2
#verze: 2.0
#=====================================

#!/bin/bash

#IP adresa zarizeni
ip_address="192.168.100.229"

#SNMP community string (vychozi je public)
snmp_community="public"

#SNMP OID teploty (prednastavena hodnota pro STE2)
snmp_oid_temp="1.3.6.1.4.1.21796.4.9.3.1.5.2"

#SNMP OID vlhkosti (prednastavena hodnota pro STE2)
snmp_oid_hum="1.3.6.1.4.1.21796.4.9.3.1.5.1"

#Subdomena na serveru TMEP.cz
tmep_subdom="subdomena"

#GUID na serveru TMEP.cz
tmep_guid="xxxyyyzzz"

#Vyctu cistou integer hodnotu teploty a pridam desetinou tecku
temp=$(snmpwalk -Oqv -v 2c -c "$snmp_community" "$ip_address" "$snmp_oid_temp" | sed 's/.$/.&/')

#Zobrazeni teploty do konzole (pro debug)
echo "Teplota:" "$temp" "C"

#Vyctu cistou integer hodnotu vlhkosti a pridam desetinou tecku
hum=$(snmpwalk -Oqv -v 2c -c "$snmp_community" "$ip_address" "$snmp_oid_hum" | sed 's/.$/.&/')

##Zobrazeni vlhkosti do konzole (pro debug)
echo "Vlhkost:" "$hum" "%"

#Poslu HTTP pozadavek na server TMEP.cz
curl "http://${tmep_subdom}.tmep.cz/?${tmep_guid}=${temp}&humV=${hum}"
