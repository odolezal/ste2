# STE2
Teploměr a vlhkoměr STE2 od společnosti HW group
* Stránka výrobce: https://www.hw-group.com/cs/zarizeni/ste2
* Online demo: http://ste2.hwg.cz/
* Data sheet: https://www.hw-group.com/files/download/man/version/ste2-man_1-0-0_cs.pdf
* Portál pro monitoring (odesílání hodnot přímo ze zařízení, tzv. "HWg-Push" funkce): [SensDesk](https://sensdesk.com)
* Popis SNMP OID: [STE2_OID.txt](STE2_OID.txt)

## Integrace se serverem TMEP.cz
* Skript: [ste2_tmep.sh](ste2_tmep.sh)
* **Ve skriptu je nutné upravit IP adresu zařízení STE2 a subdoménu a GUID podle nastavení z [tmep.cz](https://tmep.cz/)**.
