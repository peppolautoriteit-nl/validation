<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt" xmlns="http://purl.oclc.org/dsdl/schematron">
	<!-- 
		Release 1.1
		Author: M.P. Diepstra (Innopay) 
		Email: support@simplerinvoicing.org
	-->
	<!-- 
		Usable XPath statements for getting insight into Schematron file:
		//rule[@context=preceding-sibling::rule/@context]      - - - > Gets all rules that might not get fired because they have the same context as previous rules
		max(//assert/substring-before(text(), ']'))   - - - > Gets the maximum number of the current error numbering in the rule set
		//assert[@flag='fatal' or (not(@flag) and parent::rule/@flag='fatal')]    - - - > Gets all asserts that are flagged 'fatal'
		//assert[not(@flag) or @flag != parent::rule/@flag] - - - > Gets all asserts where the flag differs from the rule flag 
	-->
	<!-- 
		Development comments:
		To facilitate developers of invoicing software, the rules should point to the actual elements that are giving the problem. Sometimes this
		is not possible, like when the element is required but it's not there, but most times this should be possible.
		So instead of writing an assert with cbc:ID = 'something' you should ensure that the cbc:ID is matched in the context of the rule and the
		assert then only needs to check .='something' 
		If the context would be a to broad match than limit it using predicates with a parent match like cbc:ID[parent::cac:TaxScheme]
		
		TODO: 
			- Add calculation rules for going from taxamount to transactioncurrencyamount
			- Fix PEPPOL and BII rules to ensure that they target the proper context to facilitate easier pinpointing of problems
			- Fix BII rules for payable amounts calculation 
						- doesn't work when prepaid is filled, but payable amounts is still the same
						- doesn't check payable rounding amounts correctly
			- Add warnings for elements not in the core
			- Decide whether or not multiple occurences of items that have macoccur of 1 should be fatal or warning
	-->
	<title>Simplerinvoicing invoice v1.1 bound to UBL 2.1 and OPENPEPPOL v2</title>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<phase id="invoice_phase">
		<active pattern="BII-UBL-T10"/>
		<active pattern="PEPPOL-UBL-T10"/>
		<active pattern="SI-V11-INV"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="BII-CodesT10"/>
		<active pattern="PEPPOL-CodesT10"/>
		<active pattern="SI-V11-CODES"/>
	</phase>
	<phase id="warning_phase">
		<active pattern="SI-V11-INV-WARNING"/>
	</phase>
	<phase id="simplerinvoicing_compatibility_phase">
		<active pattern="SI-V10-INV-FATAL"/>
		<active pattern="SI-V10-INV-WARNING"/>
	</phase>
  
	<!-- BII patterns -->
	<include href="BII/abstract/BIIRULES-T10.sch"/>
	<include href="BII/UBL/BIIRULES-UBL-T10.sch"/>
	<include href="BII/codelist/BIIRULESCodesT10-UBL.sch"/>	
	
	<!-- PEPPOL patterns -->
	<include href="PEPPOL/abstract/OPENPEPPOL-T10.sch"/>
	<include href="PEPPOL/UBL/OPENPEPPOL-UBL-T10.sch"/>
	<include href="PEPPOL/codelist/OPENPEPPOLCodesT10-UBL.sch"/>
	
	<!-- Simplerinvoicing patterns -->
	<include href="SI-UBL-INV-WARNING.SCH"/>
	<include href="SI-UBL-INV-COMPAT-FATAL.SCH"/>
	<include href="SI-UBL-INV-COMPAT-WARNING.SCH"/>

	
	<!-- Simplerinvoicing rules -->
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-V11-INV">
		<!-- Backwards compatibility statement for Simplerinvoicing v1.0, it should include the version for which the asserts in this pattern MUST not be executed -->
		<!--<rule context="node()[/ubl:Invoice/cbc:UBLVersionID != '2.1'] | @*[/ubl:Invoice/cbc:UBLVersionID != '2.1']" />-->
		<rule context="node()[/ubl:Invoice/cbc:UBLVersionID != '2.1'] | @*[/ubl:Invoice/cbc:UBLVersionID != '2.1']">
			<assert test="true()" />
		</rule>
		<!-- End backwards compatibiltiy statement -->
		
		<rule context="/" flag="fatal">
			<assert test="ubl:Invoice" flag="fatal">[SI-V11-INV-R000]-This is NOT a UBL 2.x document, validation cannot continue</assert>
		</rule>
		<rule context="ubl:Invoice" flag="fatal">
			<assert test="cbc:UBLVersionID='2.1'" flag="fatal">[SI-V11-INV-R001]-Each invoice MUST be specified as a UBL 2.1 document</assert>
			<assert test="cbc:InvoiceTypeCode" flag="fatal">[SI-V11-INV-R002]-Each invoice MUST have an InvoiceTypeCode declaration</assert>
		</rule>
		<rule context="cbc:CompanyID" flag="fatal">
			<assert test="@schemeID" flag="fatal">[SI-V11-INV-R003]-A CompanyID MUST be specified using a PEPPOL Party identifier</assert>
		</rule>
		<rule context="cac:ExternalReference" flag="fatal">
			<assert test="normalize-space(cbc:URI) != ''" flag="fatal">[SI-V11-INV-R004]-An external reference MUST have its uri specified</assert>
		</rule>
		<rule context="cac:Country | cac:OriginCountry" flag="fatal">
			<assert test="cbc:IdentificationCode" flag="fatal">[SI-V11-INV-R005]-A country MUST be identified by a two-letter identification code as specified in ISO3166-1:Alpha2</assert>
		</rule>
		<rule context="cac:TaxScheme" flag="fatal">
			<assert test="cbc:ID/@schemeID='UN/ECE 5153'" flag="fatal">[SI-V11-INV-R006]-A tax scheme MUST have an identifier specifying it uses the UN/ECE 5153 list</assert>
		</rule>
		<rule context="cac:PartyLegalEntity" flag="fatal">
			<assert test="cbc:CompanyID" flag="fatal">[SI-V11-INV-R007]-A legal entity MUST have a company identifier</assert>
		</rule>
		<rule context="cac:DeliveryTerms" flag="fatal">
			<assert test="normalize-space(cbc:SpecialTerms/text()) != ''" flag="fatal">[SI-V11-INV-R008]-If delivery terms are specified they MUST be expressed as special conditions</assert>
		</rule>
		<rule context="cbc:PrimaryAccountNumberID" flag="fatal">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R009]-A primary account number MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cbc:NetworkID" flag="fatal">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R010]-A network id MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cac:PayeeFinancialAccount" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R011]-A financial account MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:PayeeFinancialAccount]" flag="fatal">
			<assert test="string-length(normalize-space(text())) &gt; 0" flag="fatal">[SI-V11-INV-R012]-A financial account id MUST have a value</assert>
		</rule>
		<rule context="cac:FinancialInstitution" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R013]-A financial institution MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:FinancialInstitution]" flag="fatal">
			<assert test="string-length(normalize-space(text())) &gt; 0" flag="fatal">[SI-V11-INV-R014]-A financial institution id MUST have a value</assert>
		</rule>
		<rule context="cac:TaxCategory" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R015]-A tax category MUST have an id</assert>
			<assert test="string(cbc:ID) != 'S' or cbc:Percent" flag="fatal">[SI-V11-INV-R016]-The VAT category percentage MUST be provided if the VAT category code is standard.</assert>
		</rule>
		<rule context="cbc:MathematicOperatorCode" flag="fatal">
			<assert test="translate(text(), 'MULTIPLY', 'multiply') = 'multiply' or translate(text(), 'DIVE', 'dive') = 'divide'" flag="fatal">[SI-V11-INV-R017]-A mathematic operator MUST be specified as a code specifying whether the calculation rate is a multiplier or divisor</assert>
		</rule>
		<rule context="cac:LegalMonetaryTotal" flag="fatal">
			<assert test="not(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator='false']) or cbc:AllowanceTotalAmount" flag="fatal">[SI-V11-INV-R018]-An allowance total MUST be specified when allowances are applicable</assert>
			<assert test="not(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator='true']) or cbc:ChargeTotalAmount" flag="fatal">[SI-V11-INV-R019]-A charge total MUST be specified when charges are applicable</assert>
		</rule>
		<rule context="cac:Item" flag="fatal">
			<assert test="cbc:Name" flag="fatal">[SI-V11-INV-R020]-An item on an invoiceline MUST have a name</assert>
		</rule>
		<rule context="cac:OriginCountry/cbc:IdentificationCode" flag="fatal">
			<assert test="@listID='3166-1:Alpha2'" flag="fatal">[SI-V11-INV-R021]-A country identification code MUST have a list identifier attribute 'ISO3166-1:Alpha2'</assert>
		</rule>
		<rule context="cac:AdditionalItemProperty" flag="fatal">
			<assert test="cbc:Value and cbc:Name" flag="fatal">[SI-V11-INV-R022]-An additional item property MUST have a name and a value</assert>
		</rule>
		<rule context="cac:InvoiceLine" flag="fatal">
			<assert test="cac:Price" flag="fatal">[SI-V11-INV-R023]-An invoiceline MUST have a price section</assert>
		</rule>
		<rule context="ubl:Invoice/cac:PayeeParty" flag="fatal">
			<assert test="cac:PartyName/cbc:Name" flag="fatal">[SI-V11-INV-R024]-If payee information is provided then the payee name MUST be specified.</assert>
		</rule>
		<rule context="cbc:TransactionCurrencyTaxAmount/@currencyID[/ubl:Invoice/cbc:TaxCurrencyCode]" flag="fatal">
			<assert test="/ubl:Invoice/cbc:TaxCurrencyCode and string(.) = string(/ubl:Invoice/cbc:TaxCurrencyCode)" flag="fatal">[SI-V11-INV-R025]-Transaction currency tax amounts MUST be in the local currency and equal to the tax currency defined on the header level</assert>
		</rule>
		<rule context="@currencyID" flag="fatal">
			<assert test="string(.) = string(/ubl:Invoice/cbc:DocumentCurrencyCode)" flag="fatal">[SI-V11-INV-R026]-Currency Identifier MUST be stated in the currency as defined on header level</assert>
		</rule>
		<rule context="ubl:Invoice/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount" flag="fatal">
			<assert test="not(/ubl:Invoice/cac:InvoiceLine/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT'])" flag="fatal">[SI-V11-INV-R027]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</assert>
		</rule>
		<rule context="cac:AllowanceCharge" flag="fatal">
			<assert test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0" flag="fatal">[SI-V11-INV-R028]-An allowance percentage MUST NOT be negative.</assert>
			<assert test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) " flag="fatal">[SI-V11-INV-R029]-In allowances, both or none of numeric factor and base amount SHOULD be provided</assert>
		</rule>
	</pattern>

	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-V11-CODES">
		<!-- Backwards compatibility statement for Simplerinvoicing v1.0, it should include the version for which the asserts in this pattern MUST not be executed -->
		<rule context="node()[/ubl:Invoice/cbc:UBLVersionID != '2.1'] | @*[/ubl:Invoice/cbc:UBLVersionID != '2.1']">
			<assert test="true()" />
		</rule>
		<!-- End backwards compatibiltiy statement -->
	
		<rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-V11-CODE-R001]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:TaxScheme]" flag="fatal">
			<assert test="((not(contains(normalize-space(.),' ')) and contains( ' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK ADD BOL CAP CAR COC CST CUD CVD ENV EXC EXP FET FRE GCN GST ILL IMP IND LAC LCN LDP LOC LST MCA MCD OTH PDB PDC PRF SCN SSS STT SUP SUR SWT TAC TOT TOX TTA VAD VAT ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal">[SI-V11-CODE-R002]-A tax scheme identifier MUST be from the UN/ECE 5153 list</assert>
		</rule>
		<rule context="cac:OriginCountry/cbc:IdentificationCode" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal">[SI-V11-CODE-R003]-Country codes in an invoice MUST be coded using ISO code list 3166-1</assert>
		</rule>
		<rule context="cac:StandardItemIdentification/cbc:ID/@schemeID" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal">[SI-V11-CODE-R004]-Standard item identifiers SHOULD be GTIN.</assert>
		</rule>
	</pattern>
	
</schema>
