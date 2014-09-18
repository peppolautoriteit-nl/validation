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
			- Backwards compatibility with v1.0
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
  <!-- Abstract CEN BII patterns -->
  <!-- ========================= -->
  <include href="BII/abstract/BIIRULES-T10.sch"/>
  <!-- Data Binding parameters -->
  <!-- ======================= -->
  <include href="BII/UBL/BIIRULES-UBL-T10.sch"/>
  <!-- Code Lists Binding rules -->
  <!-- ======================== -->
  <include href="BII/codelist/BIIRULESCodesT10-UBL.sch"/>	
	
	
	<!-- Abstract PEPPOL patterns -->
	<!-- ========================= -->
	<include href="PEPPOL/abstract/OPENPEPPOL-T10.sch"/>
	<!-- Data Binding parameters -->
	<!-- ======================= -->
	<include href="PEPPOL/UBL/OPENPEPPOL-UBL-T10.sch"/>
	<!-- Code Lists Binding rules -->
	<!-- ======================== -->
	<include href="PEPPOL/codelist/OPENPEPPOLCodesT10-UBL.sch"/>
	
	
	

	
	<!-- Simplerinvoicing rules -->
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-V11-INV">
		<!-- Rules are numbered in the region 0xx -->
		<rule context="/">
			<assert test="ubl:Invoice" flag="fatal">[SI-V11-INV-R000]-This is NOT a UBL 2.x document, validation cannot continue</assert>
		</rule>
		<rule context="ubl:Invoice">
			<assert test="cbc:UBLVersionID='2.1'" flag="fatal">[SI-V11-INV-R001]-Each invoice MUST be specified as a UBL 2.1 document</assert>
			<assert test="cbc:InvoiceTypeCode" flag="fatal">[SI-V11-INV-R002]-Each invoice MUST have a type declaration</assert>
		</rule>
		<rule context="cbc:CompanyID">
			<assert test="@schemeID" flag="fatal">[SI-V11-INV-R003]-A CompanyID MUST be specified using a PEPPOL Party identifier</assert>
		</rule>
		<rule context="cac:ExternalReference">
			<assert test="normalize-space(cbc:URI) != ''">[SI-V11-INV-R004]-An external reference MUST have its uri specified</assert>
		</rule>
		<rule context="cac:Country | cac:OriginCountry">
			<assert test="cbc:IdentificationCode">[SI-V11-INV-R005]-A country MUST be identified by a two-letter identification code as specified in ISO3166-1:Alpha2</assert>
		</rule>
		<rule context="cac:TaxScheme">
			<assert test="cbc:ID/@schemeID='UN/ECE 5153'">[SI-V11-INV-R006]-A tax scheme MUST have an identifier specifying it uses the UN/ECE 5153 list</assert>
		</rule>
		<rule context="cac:PartyLegalEntity">
			<assert test="cbc:CompanyID" flag="fatal">[SI-V11-INV-R007]-A legal entity MUST have a company identifier</assert>
		</rule>
		<rule context="cac:DeliveryTerms">
			<assert test="normalize-space(cbc:SpecialTerms/text()) != ''" flag="fatal">[SI-V11-INV-R008]-If delivery terms are specified they MUST be expressed as special conditions</assert>
		</rule>
		<rule context="cbc:PrimaryAccountNumberID">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R009]-A primary account number MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cbc:NetworkID">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R010]-A network id MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cac:PayeeFinancialAccount" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R011]-A financial account MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:PayeeFinancialAccount]" flag="fatal">
			<report test="normalize-space(text()) = ''">[SI-V11-INV-R012]-A financial account id MUST have a value</report>
		</rule>
		<rule context="cac:FinancialInstitution" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R013]-A financial institution MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:FinancialInstitution]" flag="fatal">
			<report test="normalize-space(text()) = ''">[SI-V11-INV-R014]-A financial institution id MUST have a value</report>
		</rule>
		<rule context="cac:TaxCategory" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R015]-A tax category MUST have an id</assert>
			<assert test="string(cbc:ID) != 'S' or cbc:Percent">[SI-V11-INV-R016]-The VAT category percentage MUST be provided if the VAT category code is standard.</assert>
		</rule>
		<rule context="cbc:MathematicOperatorCode" flag="fatal">
			<assert test="translate(text(), 'MULTIPLY', 'multiply') = 'multiply' or translate(text(), 'DIVE', 'dive') = 'divide'" flag="fatal">[SI-V11-INV-R017]-A mathematic operator MUST be specified as a code specifying whether the calculation rate is a multiplier or divisor</assert>
		</rule>
		<rule context="cac:LegalMonetaryTotal">
			<assert test="not(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator='false']) or cbc:AllowanceTotalAmount">[SI-V11-INV-R018]-An allowance total MUST be specified when allowances are applicable</assert>
			<assert test="not(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator='true']) or cbc:ChargeTotalAmount">[SI-V11-INV-R019]-A charge total MUST be specified when charges are applicable</assert>
		</rule>
		<rule context="cac:Item">
			<assert test="cbc:Name">[SI-V11-INV-R020]-An item on an invoiceline MUST have a name</assert>
		</rule>
		<rule context="cac:OriginCountry/cbc:IdentificationCode">
			<assert test="@listID='3166-1:Alpha2'">[SI-V11-INV-R021]-A country identification code MUST have a list identifier attribute 'ISO3166-1:Alpha2'</assert>
		</rule>
		<rule context="cac:AdditionalItemProperty">
			<assert test="cbc:Value and cbc:Name">[SI-V11-INV-R022]-An additional item property MUST have a name and a value</assert>
		</rule>
		<rule context="cac:InvoiceLine">
			<assert test="cac:Price">[SI-V11-INV-R023]-An invoiceline MUST have a price section</assert>
		</rule>
		<rule context="ubl:Invoice/cac:PayeeParty" flag="fatal">
			<assert test="cac:PartyName/cbc:Name" flag="fatal">[SI-V11-INV-R024]-If payee information is provided then the payee name MUST be specified.</assert>
		</rule>
		<rule context="cbc:TransactionCurrencyTaxAmount/@currencyID[/ubl:Invoice/cbc:TaxCurrencyCode]">
			<assert test="/ubl:Invoice/cbc:TaxCurrencyCode and string(.) = string(/ubl:Invoice/cbc:TaxCurrencyCode)">[SI-V11-INV-R025]-Transaction currency tax amounts MUST be in the local currency and equal to the tax currency defined on the header level</assert>
		</rule>
		<rule context="@currencyID">
			<assert test="string(.) = string(/ubl:Invoice/cbc:DocumentCurrencyCode)">[SI-V11-INV-R026]-Currency Identifier MUST be stated in the currency as defined on header level</assert>
		</rule>
		<rule context="/ubl:Invoice/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount" flag="fatal">
			<report test="not(/ubl:Invoice/cac:InvoiceLine/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])" flag="fatal">[SI-V11-INV-R027]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</report>
		</rule>
		<rule context="cac:AllowanceCharge" flag="fatal">
			<assert test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0" flag="fatal">[SI-V11-INV-R028]-An allowance percentage MUST NOT be negative.</assert>
			<assert test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) " flag="fatal">[SI-V11-INV-R029]-In allowances, both or none of numeric factor and base amount SHOULD be provided</assert>
		</rule>
	</pattern>

	
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-V11-CODES">
		<rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-V11-CODE-R001]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:TaxScheme]">
			<assert test="((not(contains(normalize-space(.),' ')) and contains( ' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK ADD BOL CAP CAR COC CST CUD CVD ENV EXC EXP FET FRE GCN GST ILL IMP IND LAC LCN LDP LOC LST MCA MCD OTH PDB PDC PRF SCN SSS STT SUP SUR SWT TAC TOT TOX TTA VAD VAT ',concat(' ',normalize-space(.),' ') ) ) )">[SI-V11-CODE-R002]-A tax scheme identifier MUST be from the UN/ECE 5153 list</assert>
		</rule>
		<rule context="cac:OriginCountry/cbc:IdentificationCode" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal">[SI-V11-CODE-R003]-Country codes in an invoice MUST be coded using ISO code list 3166-1</assert>
		</rule>
		<rule context="cac:StandardItemIdentification/cbc:ID/@schemeID" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal">[SI-V11-CODE-R004]-Standard item identifiers SHOULD be GTIN.</assert>
		</rule>
	</pattern>
	
	
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-V11-INV-WARNING">
		<!-- Rules are numbered in the region 2xx -->
		<rule context="cbc:CustomizationID">
			<assert test="contains(., 'urn:www.simplerinvoicing.org:si-ubl:invoice:ver1.1.x')" flag="warning">[SI-V11-INV-R200]-This XML instance is NOT tagged as a SI-UBL v1.1 invoice</assert>
		</rule>
		<rule context="cac:ContractDocumentReference[2]">
			<report test=".">[SI-V11-INV-R201]-An SI invoice SHOULD not contain more than one contract document reference</report>
		</rule>
		<rule context="cac:InvoicePeriod[2]">
			<report test=".">[SI-V11-INV-R202]-An SI invoice SHOULD not contain more than one invoice period</report>
		</rule>
		<rule context="cbc:Note[2]">
			<report test=".">[SI-V11-INV-R203]-Multple notes in a section SHOULD not occur</report>
		</rule>
		<rule context="cbc:PartyIdentification[2]">
			<report test="." flag="warning">[SI-V11-INV-R204]-A party SHOULD not contain more than one identification</report>
		</rule>
		<rule context="cac:PartyName[2]">
			<report test="." flag="warning">[SI-V11-INV-R205]-A party SHOULD not contain more than one name</report>
		</rule>
		<rule context="cac:PartyTaxScheme[2]">
			<report test="." flag="warning">[SI-V11-INV-R206]-A party SHOULD not contain more than one tax scheme</report>
		</rule>
		<rule context="cac:PartyLegalEntity[2]">
			<report test="." flag="warning">[SI-V11-INV-R207]-A party SHOULD not contain more than one legal entity</report>
		</rule>
		<rule context="cac:PostalAddress | cac:Address">
			<assert test="(cbc:StreetName and cbc:BuildingNumber and cbc:CityName and cbc:PostalZone and cac:Country)" flag="warning">[SI-V11-INV-R208]-An address in an invoice SHOULD contain at least, street name and number, city name, zip code and the country</assert>
		</rule>
		<rule context="cac:PaymentMeans[2]">
			<report test="." flag="warning">[SI-V11-INV-R209]-An invoice SHOULD not contain more than one means of payment</report>
		</rule>
		<rule context="cbc:PaymentID[2]">
			<report test="." flag="warning">[SI-V11-INV-R210]-A payment means SHOULD not have multiple payment ids</report>
		</rule>
		<rule context="cbc:PrimaryAccountNumberID">
			<assert test="string-length(normalize-space(text())) = 4 or string-length(normalize-space(text())) = 6">[SI-V11-INV-R211]-In accordance to general rules for
				referencing payments cards only the last 4 or 6 digits of the card number SHOULD be used.</assert>
		</rule>
		<rule context="cac:PaymentTerms[2]">
			<report test=".">[SI-V11-INV-R212]-An invoice SHOULD not have multiple payment terms</report>
		</rule>
		<!-- Next rule is commented because it conflicts with rule BII2-T10-R025, for the moment we assume the BII2 
		rule should be followed -->
		<!--<rule context="cbc:AllowanceChargeReason" flag="fatal">
			<report test="preceding-sibling::cbc:AllowanceChargeReasonCode">[SI-V11-INV-R213]-When an allowance charge reason code is specified the allowance charge reason SHOULD not be included</report>
		</rule>-->
		<rule context="cbc:TaxExemptionReasonCode | cbc:TaxExemptionReason">
			<assert test="preceding-sibling::cbc:ID[text() = 'E' or text() = 'AB']">[SI-V11-INV-R214]-A tax exemption reason or reason code SHOULD only be given when the tax category is tax exempt</assert>
		</rule>
		<rule context="cac:TaxCategory[2]">
			<report test=".">[SI-V11-INV-R215]-Tax category SHOULD not occur more than once in a section</report>
		</rule>
		<rule context="cac:TaxTotal[2]">
			<report test=".">[SI-V11-INV-R216]-An invoice SHOULD not have multiple tax totals on invoice level</report>
		</rule>
		<rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-V11-INV-R217]-Location identifiers SHOULD be GLN</assert>
		</rule>
		<rule context="cac:Delivery[2]">
			<report test=".">[SI-V11-INV-R218]-Each invoiceline SHOULD have no more than one delivery specified</report>
		</rule>
		<rule context="cac:ClassifiedTaxCategory[2]">
			<report test=".">[SI-V11-INV-R219]-An invoiceline SHOULD not have more than one classified tax category</report>
		</rule>
		<rule context="cac:Price/cac:AllowanceCharge[2]">
			<report test=".">[SI-V11-INV-R220]-The price in an invoiceline SHOULD not have more than one allowance charge</report>
		</rule>
		
		<rule context="*">
			<assert test="* or normalize-space(text()) != ''" flag="warning">[SI-V11-INV-R001]-An invoice SHOULD not contain empty elements.</assert>
		</rule>
	</pattern>
</schema>
