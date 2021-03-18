
=====================================================================
                  XML schéma pro výměnu faktur ISDOC
=====================================================================

                        Verze 5.2 z 7.7.2009

       (c) 2009 Sdružení pro informační společnost, www.spis.cz

=====================================================================

Přiložená schémata formálně definují výměnný formát faktur definovaný 
Pracovní skupinou elektronické standardy výměny dat sdružení SPIS.

Obsah distribuce:
-----------------

xsd/*   - schémata v jazyce W3C XML Schema

          isdoc-invoice-5.2.xsd       - základní schéma

          isdoc-invoice-dsig-5.2.xsd  - schéma validující i stukturu 
                                        vloženého digitálního podpisu

          xmldsig-core-schema.xsd     - schéma XML Signature                                    

doc/*   - hypertextová dokumentace W3C XML Schematu


Poznámka:
---------

Použijte schéma isdoc-invoice-5.2.xsd, pokud budete potřebovat validovat pouze 
samotnou fakturu bez elektronického podpisu. V případě validace vč. podpisu
použijte schéma isdoc-invoice-dsig-5.2.xsd, které pomocí příkazů import a 
redefine automaticky použije i obě další schémata.

Omezení schémat:
----------------

Ve verzi 5.2 nedefinuje schéma přiliš striktní kontroly, popisuje
pouze základní strukturu faktury a datové typy. Je pravděpodobné, že
v budoucnu bude schéma vylepšeno tak, aby provádělo důslednější
kontroly dat.

Změny oproti předchozí verzi 5.1:
---------------------------------

* elementy UserID a CatalogFirmIdentification změněny na nepovinné

* datový typ pro PSČ (PostalZoneType) změněn z xs:integer na xs:string

* zpřísněna kontrola datového typu pro UUID (UUIDType). Nyní se
  kontroluje, zda má hodnota tvar
  [0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}

* přidán nepovinný element IssuingSystem, do kterého lze uložit
  identifikaci systému, který odesílá/generuje fakturu

* délka identifikátoru řádky faktury (element ID uvnitř elementu
  InvoiceLine) byla omezena na 36 znaků

* element ExternalOrderID je nyní uvnitř elementu OrderLineReference
  nepovinný



Kontakt: info@isdoc.cz, www.isdoc.cz
