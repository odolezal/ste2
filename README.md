# STE2
Teploměr a vlhkoměr STE2 od společnosti HW group
* Stránka výrobce: https://www.hw-group.com/cs/zarizeni/ste2
* Online demo: http://ste2.hwg.cz/
* Data sheet: https://www.hw-group.com/files/download/man/version/ste2-man_1-0-0_cs.pdf
* Portál pro monitoring (odesílání hodnot přímo ze zařízení, tzv. "HWg-Push" funkce): [SensDesk](https://sensdesk.com)
* Popis SNMP OID: [STE2_OID.txt](STE2_OID.txt)

## Bezpečnostní upozornění
Platí pro výchozí nastavení (Firmware: STE2 ver. 1.2.1 - 12.12.2018):

* **KRITICKÉ:** Spuštěný příkaz ```curl``` na kořen webového serveru (např. ```curl http://10.0.0.30/```)  vrátí XML dokument s kompletním nastavením zařízení, včetně citlivých zakódovaných proměných jako je ```<username>```, ```<password>```, ```<wifi_password>```, ```<smtp_username>```, ```<smtp_password>```, ```<sms_username>```, ```<sms_password>``` a další, které jsou za běžných okolností viditělné pouze po přihlášení. Ukázka XML výstupu na oficiálním online demu: [ste2.xml](ste2.xml)
* Přístup do konfigurace přes webové rozhraní (HTTP, tcp/80) není chráněn žádným jménem ani heslem.
* Přístup do konfigurace přes webové rozhraní neumožňuje zabezpečný (šifrovaný) přenos tzn. možnost protokolu HTTPS chybí.
* Protokol SNMP (udp/161) má přednastavený široce známý "Community string" ```public``` (pouze čtení hodnot) a ```private``` (čtení a zápis hodnot). Oba "stringy" jsou povoleny.
* Protokol SNMP (udp/161) je dostupný pouze ve verzi 2, tzn. bez možnosti pokročilejší autentizace a šifrování přenosu dat.
* Některé informace o systému a měřené proměné lze vyčítat bez autentizace. Například soubor ```values.xml``` (v kořenu webového serveru).

## Integrace se serverem TMEP.cz
* Skript: [ste2_tmep.sh](ste2_tmep.sh)
* **Ve skriptu je nutné upravit IP adresu zařízení STE2 a subdoménu a GUID podle nastavení z [tmep.cz](https://tmep.cz/)**.
