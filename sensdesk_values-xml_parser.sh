### SensDesk.com values.xml Parser
#Zdroj: https://github.com/odolezal
#Kontakt: www.odolezal.cz
###################################

#READ ME:
#Vas klic "values.xml key" je uveden na "https://sensdesk.com/sensdesk/team/". Nahradte jim "KEY" v radcich nize.
#Zkontrolujte hodnotu "sens_id" u cidla, resp. cidel! Kazde cidlo ma svoje unikatni ID. Hodnotu lze precist z cisteho XML vystupu, napr. v prohlizeci. Nahradte jimi "XYZ" v radcich nize.

#Zavislosti: nastroj "xmllint" z balicku "libxml2-utils"

###################################

#!/bin/bash

echo "SensDesk.com values.xml Parser"

#Casove razitko (pro debug)
timestamp=$(date +"%H:%M:%S, %d.%m.%Y")
echo "Casove razitko:" "$timestamp"

#Server status (pro debug)
server_status=$(curl -s -I http://sensdesk.com | grep "HTTP")
echo "Odpoved serveru:" "$server_status"

#Parsovani teploty
temp_final=$(curl -s http://sensdesk.com/sensdesk/values.xml?values_xml_key=KEY -o values.xml | xmllint --xpath "string(//Root/Devices/Device/Groups/Group/Sensors/Sensor[@sens_id="XYZ"]/Value)" /mnt/usb/backup/values.xml | sed 's/.$/.&/')
echo "Teplota:" "$temp_final" "°C"

#Parsovani vlhkosti
hum_final=$(curl -s http://sensdesk.com/sensdesk/values.xml?values_xml_key=KEY -o values.xml | xmllint --xpath "string(//Root/Devices/Device/Groups/Group/Sensors/Sensor[@sens_id="XYZ"]/Value)" values.xml | sed 's/.$/.&/')
echo "Vlhkost:" "$hum_final" "%"