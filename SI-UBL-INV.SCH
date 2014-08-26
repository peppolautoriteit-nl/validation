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
			- Fix rule numbering
		
	-->
	<title>Simplerinvoicing invoice v1.1 bound to UBL 2.1 and OPENPEPPOL v2</title>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<phase id="T10_phase">
		<active pattern="BII-UBL-T10"/>
		<active pattern="PEPPOL-UBL-T10"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="BII-CodesT10"/>
		<active pattern="PEPPOL-CodesT10"/>
		<active pattern="SI-UBL-CODES"/>
	</phase>
	<phase id="si_phase">
		<active pattern="SI-UBL-INV-WARNING-NEW"/>
		<active pattern="SI-UBL-INV-WARNING"/>
		<active pattern="SI-UBL-INV-FATAL"/>
		<active pattern="SI-UBL-INV-REQUIRED"/>
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
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-INV-REQUIRED">
		<!-- Rules are numbered in the region 0xx -->
		<rule context="ubl:Invoice">
			<assert test="cbc:UBLVersionID='2.1'" flag="fatal">[SI-V11-INV-R001]-Each invoice MUST be specified as a UBL 2.1 document</assert>
			<assert test="cbc:InvoiceTypeCode" flag="fatal">[SI-V11-INV-R002]-Each invoice MUST have a type declaration</assert>
		</rule>
		<rule context="cac:InvoiceLine">
			<assert test="normalize-space(cbc:InvoicedQuantity/text()) != ''" flag="fatal">[SI-V11-INV-R003]-Each invoice line MUST have an invoiced quantity</assert>
		</rule>
		<rule context="cbc:CompanyID">
			<assert test="@schemeID" flag="fatal">[SI-V11-INV-R004]-A CompanyID MUST be specified using a PEPPOL Party identifier</assert>
		</rule>
		<rule context="cac:ExternalReference">
			<assert test="normalize-space(cbc:URI) != ''">[SI-V11-INV-R005]-An external reference MUST have its uri specified</assert>
		</rule>
		<rule context="cac:Country">
			<assert test="cbc:IdentificationCode">[SI-V11-INV-R006]-A country MUST be identified by a two-letter identification code as specified in ISO3166-1:Alpha2</assert>
		</rule>
		<rule context="cac:TaxScheme">
			<assert test="cbc:ID/@schemeID='UN/ECE 5153'">[SI-V11-INV-R007]-A tax scheme MUST have an identifier specifying it uses the UN/ECE 5153 list</assert>
		</rule>
		<rule context="cac:PartyLegalEntity">
			<assert test="cbc:CompanyID" flag="fatal">[SI-V11-INV-R008]-A legal entity MUST have a company identifier</assert>
		</rule>
		<rule context="cac:DeliveryTerms">
			<assert test="normalize-space(cbc:SpecialTerms/text()) != ''" flag="fatal">[SI-V11-INV-R009]-If delivery terms are specified they MUST be expressed as special conditions</assert>
		</rule>
		<rule context="cbc:PrimaryAccountNumberID">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R010]-A primary account number MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cbc:NetworkID">
			<assert test="normalize-space(text()) != ''" flag="fatal">[SI-V11-INV-R011]-A network id MUST be specified if a card account is used</assert>
		</rule>
		<rule context="cac:PayeeFinancialAccount" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R012]-A financial account MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:PayeeFinancialAccount]" flag="fatal">
			<report test="normalize-space(text()) = ''">[SI-V11-INV-R013]-A financial account id MUST have a value</report>
		</rule>
		<rule context="cac:FinancialInstitution" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R014]-A financial institution MUST have an id</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:FinancialInstitution]" flag="fatal">
			<report test="normalize-space(text()) = ''">[SI-V11-INV-R015]-A financial institution id MUST have a value</report>
		</rule>
		<rule context="cac:TaxCategory" flag="fatal">
			<assert test="cbc:ID" flag="fatal">[SI-V11-INV-R016]-A tax category MUST have an id</assert>
			<assert test="string(cbc:ID) != 'S' or cbc:Percent">[SI-V11-INV-R017]-The VAT category percentage MUST be provided if the VAT category code is standard.</assert>
		</rule>

		

	</pattern>
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-INV-FATAL">
		<!-- Rules are numbered in the region 1xx -->
		<rule context="@currencyID">
			<assert test="string(.) = string(/ubl:Invoice/cbc:DocumentCurrencyCode)">[SI-UBL-INV-R100]-Currency Identifier MUST be in stated in the currency stated on header level</assert>
		</rule>
		
		<rule context="cac:TaxCategory" flag="fatal">
			<assert test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')" flag="fatal">[SI-UBL-INV-R430]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</assert>
		</rule>
		
		<rule context="ubl:Invoice" flag="fatal">
			<assert test="//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')" flag="fatal">[SI-UBL-INV-R436]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</assert>
			<assert test="(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)" flag="fatal">[SI-UBL-INV-R437]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</assert>
			<assert test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')" flag="fatal">[SI-UBL-INV-R438]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</assert>
			<assert test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')" flag="fatal">[SI-UBL-INV-R439]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</assert>

		</rule>
		<rule context="cac:AllowanceCharge" flag="fatal">
			<assert test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0" flag="fatal">[SI-UBL-INV-R434]-An allowance percentage MUST NOT be negative.</assert>
			<assert test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) " flag="warning">[SI-UBL-INV-R435]-In allowances, both or none of percentage and base amount SHOULD be provided</assert>
		</rule>
		<rule context="ubl:Invoice/cac:PayeeParty" flag="fatal">
			<assert test="cac:PartyName/cbc:Name" flag="fatal">[SI-UBL-INV-R432]-If payee information is provided then the payee name MUST be specified.</assert>
		</rule>
		<rule context="cac:Item/cac:ClassifiedTaxCategory" flag="fatal">
			<assert test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))" flag="fatal">[SI-UBL-INV-R433]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</assert>
		</rule>
		<rule context="cac:LegalMonetaryTotal" flag="fatal">
			<assert test="number(cbc:PayableAmount) &gt;= 0" flag="fatal">[SI-UBL-INV-R440]-Total payable amount in an invoice MUST NOT be negative</assert>
		</rule>
		
	</pattern>
	
	
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-CODES">
		<!-- Rules are numbered in the region 0xx -->
		<rule context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-V11-CODE-R001]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</assert>
		</rule>
		<rule context="cbc:ID[parent::cac:TaxScheme]">
			<assert test="((not(contains(normalize-space(.),' ')) and contains( ' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK ADD BOL CAP CAR COC CST CUD CVD ENV EXC EXP FET FRE GCN GST ILL IMP IND LAC LCN LDP LOC LST MCA MCD OTH PDB PDC PRF SCN SSS STT SUP SUR SWT TAC TOT TOX TTA VAD VAT ',concat(' ',normalize-space(.),' ') ) ) )">[SI-V11-CODE-R002]-A tax scheme identifier MUST be from the UN/ECE 5153 list</assert>
		</rule>
	</pattern>
	
	
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-INV-WARNING-NEW">
		<!-- Rules are numbered in the region 2xx -->
		<rule context="cbc:CustomizationID">
			<assert test="contains(., 'urn:www.simplerinvoicing.org:si-ubl:invoice:ver1.1.x')" flag="warning">[SI-V11-INV-R000]-This XML instance is NOT tagged as a SI-UBL v1.1 invoice</assert>
		</rule>
		<rule context="cac:ContractDocumentReference[2]">
			<report test=".">[SI-V11-INV-R200]-An SI invoice SHOULD not contain more than one contract document reference</report>
		</rule>
		<rule context="cac:InvoicePeriod[2]">
			<report test=".">[SI-V11-INV-R201]-An SI invoice SHOULD not contain more than one invoice period</report>
		</rule>
		<rule context="cbc:Note[2]">
			<report test=".">[SI-V11-INV-R202]-Multple notes in a section SHOULD not occur</report>
		</rule>
		<rule context="cbc:PartyIdentification[2]">
			<report test="." flag="warning">[SI-UBL-INV-R203]-A party SHOULD not contain more than one identification</report>
		</rule>
		<rule context="cac:PartyName[2]">
			<report test="." flag="warning">[SI-UBL-INV-R204]-A party SHOULD not contain more than one name</report>
		</rule>
		<rule context="cac:PartyTaxScheme[2]">
			<report test="." flag="warning">[SI-UBL-INV-R206]-A party SHOULD not contain more than one tax scheme</report>
		</rule>
		<rule context="cac:PartyLegalEntity[2]">
			<report test="." flag="warning">[SI-UBL-INV-R208]-A party SHOULD not contain more than one legal entity</report>
		</rule>
		<rule context="cac:PostalAddress | cac:Address">
			<assert test="(cbc:StreetName and cbc:BuildingNumber and cbc:CityName and cbc:PostalZone and cac:Country)" flag="warning">[SI-UBL-INV-R207]-An address in an invoice SHOULD contain at least, street name and number, city name, zip code and the country</assert>
		</rule>
		<rule context="cac:PaymentMeans[2]">
			<report test="." flag="warning">[SI-UBL-INV-R209]-An invoice SHOULD not contain more than one means of payment</report>
		</rule>
		<rule context="cbc:PaymentID[2]">
			<report test="." flag="warning">[SI-UBL-INV-R210]-A payment means SHOULD not have multiple payment ids</report>
		</rule>
		<rule context="cbc:PrimaryAccountNumberID">
			<assert test="string-length(normalize-space(text())) = 4 or string-length(normalize-space(text())) = 6">[SI-UBL-INV-R211]-In accordance to general rules for
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
			<assert test="preceding-sibling::cbc:ID[text() = 'E' or text() = 'AB']">[SI-UBL-INV-R214]-A tax exemption reason or reason code SHOULD only be given when the tax category is tax exempt</assert>
		</rule>
		
		<rule context="cac:TaxCategory[2]">
			<report test=".">[SI-V11-INV-R215]-Tax category SHOULD not occur more than once in a section</report>
		</rule>
		
		<rule context="*">
			<assert test="* or normalize-space(text()) != ''" flag="warning">[SI-V11-INV-R001]-An invoice SHOULD not contain empty elements.</assert>
		</rule>
	</pattern>
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-INV-WARNING">
		<rule context="ubl:Invoice/cac:InvoiceLine" flag="warning">
			<assert test="count(cac:TaxTotal)&lt;=1" flag="warning">[SI-UBL-INV-R412]-Element 'TaxTotal' may occur at maximum 1 times.</assert>
			<assert test="count(cac:Price)=1" flag="warning">[SI-UBL-INV-R413]-Element 'Price' must occur exactly 1 times.</assert>
		</rule>
		<rule context="ubl:Invoice/cac:InvoiceLine/cac:Item" flag="warning">
			<assert test="count(cbc:Description)&lt;=1" flag="warning">[SI-UBL-INV-R414]-Element 'Description' may occur at maximum 1 times.</assert>
			<assert test="count(cbc:Name)=1" flag="warning">[SI-UBL-INV-R415]-Element 'Name' must occur exactly 1 times.</assert>
			<assert test="count(cac:ClassifiedTaxCategory)&lt;=1" flag="warning">[SI-UBL-INV-R416]-Element 'ClassifiedTaxCategory' may occur at maximum 1 times.</assert>
		</rule>
		<rule context="ubl:Invoice/cac:InvoiceLine/cac:Price" flag="warning">
			<assert test="count(cac:AllowanceCharge)&lt;=1" flag="warning">[SI-UBL-INV-R417]-Element 'AllowanceCharge' may occur at maximum 1 times.</assert>
		</rule>
		<rule context="ubl:Invoice/cac:LegalMonetaryTotal" flag="warning">
			<assert test="count(cbc:TaxExclusiveAmount)=1" flag="warning">[SI-UBL-INV-R418]-Element 'TaxExclusiveAmount' must occur exactly 1 times.</assert>
			<assert test="count(cbc:TaxInclusiveAmount)=1" flag="warning">[SI-UBL-INV-R419]-Element 'TaxInclusiveAmount' must occur exactly 1 times.</assert>
			<assert test="count(cbc:LineExtensionAmount)=1" flag="warning">[SI-UBL-INV-R453]-Element 'LineExtensionAmount' must occur exactly 1 times.</assert>
		</rule>

		<rule context="cac:Delivery/cac:DeliveryLocation/cac:Address" flag="warning">
			<assert test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)" flag="warning">[SI-UBL-INV-R427]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code.</assert>
		</rule>
		<rule context="cac:TaxSubtotal" flag="warning">
			<assert test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or (cac:TaxCategory/cbc:ID != 'E')" flag="warning">[SI-UBL-INV-R431]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</assert>
		</rule>
		<rule context="cac:PostalAddress/cbc:ID//@schemeID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-UBL-INV-R447]-Postal address identifiers SHOULD be GLN.</assert>
		</rule>
		<rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-UBL-INV-R448]-Location identifiers SHOULD be GLN</assert>
		</rule>
		<rule context="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" flag="warning">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )" flag="warning">[SI-UBL-INV-R449]-Standard item identifiers SHOULD be GTIN.</assert>
		</rule>
	</pattern>
</schema>
