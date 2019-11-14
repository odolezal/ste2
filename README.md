# STE2
Teploměr a vlhkoměr STE2 od společnosti HW group
* Stránka výrobce: https://www.hw-group.com/cs/zarizeni/ste2
* Online demo: http://ste2.hwg.cz/
* Data sheet: https://www.hw-group.com/files/download/man/version/ste2-man_1-0-0_cs.pdf
* Portál pro monitoring (odesílání hodnot přímo ze zařízení, tzv. "HWg-Push" funkce): [SensDesk](https://sensdesk.com)
* Popis SNMP OID: [STE2_OID.txt](STE2_OID.txt)

## Bezpečnostní upozornění

Firmware: STE2 ver. **1.2.2** - 02.08.2019 (a pravděpodobně všechny starší verze, viz release history: https://www.hw-group.com/cs/product-version/ste2). Platí pro výchozí nastavení.

* **KRITICKÉ:** Spuštěný příkaz ```curl``` na kořen webového serveru (např. ```curl http://10.0.0.30/```)  vrátí XML dokument s kompletním nastavením zařízení, včetně citlivých zakódovaných proměných jako je ```<username>```, ```<password>```, ```<wifi_password>```, ```<smtp_username>```, ```<smtp_password>```, ```<sms_username>```, ```<sms_password>``` a další, které jsou za běžných okolností viditělné pouze po přihlášení. Ukázka XML výstupu na oficiálním online demu: [ste2.xml](ste2.xml)
* Přístup do konfigurace přes webové rozhraní (HTTP, tcp/80) není chráněn žádným jménem ani heslem.
* Přístup do konfigurace přes webové rozhraní neumožňuje zabezpečný (šifrovaný) přenos tzn. možnost protokolu HTTPS chybí.
* Protokol SNMP (udp/161) má přednastavený široce známý "Community string" ```public``` (pouze čtení hodnot) a ```private``` (čtení a zápis hodnot). Oba "stringy" jsou povoleny.
* Protokol SNMP (udp/161) je dostupný pouze ve verzi 2, tzn. bez možnosti pokročilejší autentizace a šifrování přenosu dat.
* Některé informace o systému a měřené proměné lze vyčítat bez autentizace. Například soubor ```values.xml``` (v kořenu webového serveru).

## Integrace se serverem TMEP.cz
* Skript: [ste2_tmep.sh](ste2_tmep.sh)

_(poslední úpravy k 14.11.2019)_

 **Ve skriptu je nutné upravit IP adresu zařízení STE2 (```ip_address```), subdoménu (```tmep_subdom```) a GUID (```tmep_guid```) podle nastavení z [tmep.cz](https://tmep.cz/)**. Zbytek parametrů předpokládá výchozí nastavení zařízení.

Skript neobsahuje smyčku. Pro opakovaná měření je potřeba do ```crontab```u přidat:
```
*/5 * * * * sudo bash /home/pi/ste2_tmep_ng.sh &>/dev/null
```

## SensDesk.com values.xml Parser
* Skript: [sensdesk_values-xml_parser.sh](sensdesk_values-xml_parser.sh)

**Závislosti:** nástroj ```xmllint``` z balíčku ```libxml2-utils```.

### Proč tento skript?
Samotné zařízení STE2 neumožňuje definovat vlastní posílaní hodnot z čidel pomocí standardního HTTP GET požadavku. Jediný způsob, jak stahovat hodnoty bez přímého přístupu (např. přes SNMP nebo HTTP v lokální síti) je nastavit zařízení, aby odesílalo hodnoty na portál a SensDesk.com ty následně dále zpracovávat, což dělá právě skript ```sensdesk_values-xml_parser.sh```

[SensDesk.com](https://www.sensdesk.com) je portál pro IoT zařízení od společnosti [HW Group](https://www.hw-group.com/), který umožňuje sledovat měřené veličiny, monitorovat připojené zařízení a zasílat upozornění.

Součástí portálu je i jednoduché API, které umožňuje na specifické URL pracovat s XML výstupem. V zásadadě, každé zařízení má na portálu dostupné rozhraní přes soubor ```values.xml``` ze kterého lze vyčíst mnoho informací, předně pak např. hodnotu teploty nebo vlhkosti.

### Jak na to?
* Nakonfigurujte zařízení aby odesílalo hodnoty na portál Sendesk. Obecný rozcestník s postupem zde: https://sensdesk.com/connect-to-the-sensdeskcom, popř. hledejte přímo v uživatelské příručce.
* Na portálu SensDesk.com, v záložce [Teams](https://sensdesk.com/sensdesk/team), najdete hodnotu přístupového klíče, tzv. ```values.xml key```, viz nápověda: https://www.hw-group.com/cs/podpora/zmeny-prace-se-setupxml-v-portale-sensdesk
* Hodnotou ```values.xml key``` nahraďte proměnou ```KEY``` [ve skriptu](https://github.com/odolezal/ste2/blob/master/sensdesk_values-xml_parser.sh#L27).
* Otevřete URL s XML výstupem. Tvar je ```http://sensdesk.com/sensdesk/values.xml?values_xml_key=KEY```
* V surovém XML najděte požadovaná čidla a jejich identifikátor, např ```<Sensor sens_id="230008">```. Číselnou hodnotou (zde např. ```230008``` nahraďte proměné ```XYZ``` [u řádků](https://github.com/odolezal/ste2/blob/master/sensdesk_values-xml_parser.sh#L27) pro parsování teploty a vlhkosti.

### Doplňující poznámky
* Ve skriptu jsou i dva debug příkazy, které zakomentujte, pokud je nepotřebujete.
* Četnost zasílání hodnot na portál lze nastavit v zařízení, na kartě ```Portal```, hodnota ```AutoPush```. Nicméně, na stejné kartě je (zřejmě) globální konstanta ```Push Period``` "časovače" nastavená na 900 sekund, tzn. 15 minut. Nelze tedy s jistotou říci, že hodnoty stahované z portálu SensDesk.com jsou právě tak aktuální, jak jsou v určitém čase odeslány ze zařízení. Nicméně, lze odvodit, že data nejsou starší, než 15 minut (kdy by mělo dojít k pushnutí hodnot na portál v každém případě).
* Jakékoli komentáře a vylepšení vítány :)
