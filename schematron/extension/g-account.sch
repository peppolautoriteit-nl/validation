<!--
     These G-account extension rules are based on the specification in
     https://stpe.nl/media/Dutch%20national%20EN%2016931%20extension%20-%20G-account%20version%201.0.pdf

     These additional rules are generally only for adding on top of the SI-UBL 2.0 / NLCIUS
-->
<schema xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" 
    xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" 
    xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    
    <pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="false" id="g-account-extension">

        <!-- BR-GA-0 (not formally defined in the specification -->
        <rule context="//cbc:CustomizationID">
            <assert id="BR-GA-0" test=". = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0#conformant#urn:fdc:nen.nl:gaccount:v1.0'" flag="fatal">
            When using the G-account extension, the CustomizationID must specify this.
            </assert>
        </rule>

        <!-- BR-GA-1 The number of Payment Terms (NL-GA-01) in each invoice MUST be two. -->
        <rule context="/ubl:Invoice">
            <assert id="BR-GA-1" test="count(cac:PaymentTerms) = 2" flag="fatal">The number of Payment Terms (NL-GA-01) in each invoice MUST be two.</assert>
        </rule>

        <!-- BR-GA-2 The number of Payment Instructions (BG-16) in each invoice MUST be two. -->
        <rule context="/ubl:Invoice">
            <assert id="BR-GA-2" test="count(cac:PaymentMeans) = 2" flag="fatal">The number of Payment Instructions (BG-16) in each invoice MUST be two.</assert>
        </rule>

        <!-- BR-GA-3 Sum of Amount due for payment (BT-115) = ∑ Payment Amount (NL-GA-03) -->
        <rule context="/ubl:Invoice">
            <assert id="BR-GA-3" test="cac:LegalMonetaryTotal/xs:decimal(cbc:PayableAmount) = sum(cac:PaymentTerms/xs:decimal(cbc:Amount))" flag="fatal">Sum of Amount due for payment (BT-115) = ∑ Payment Amount (NL-GA-03)</assert>
        </rule>

        <!-- BR-GA-4 Each Payment Terms (NL-GA-01) MUST include a Payment Means reference (NL-GA-02) -->
        <rule context="/ubl:Invoice/cac:PaymentTerms">
            <assert id="BR-GA-4" test="count(cbc:PaymentMeansID) = 1" flag="fatal">Each Payment Terms (NL-GA-01) MUST include a Payment Means reference (NL-GA-02)</assert>
        </rule>

        <!-- BR-GA-5 Each Payment Instructions (BG-16) MUST include a Payment Means identifier (NL-GA-04) -->
        <rule context="/ubl:Invoice/cac:PaymentMeans">
            <assert id="BR-GA-5" test="count(cbc:ID) = 1" flag="fatal">Each Payment Instructions (BG-16) MUST include a Payment Means identifier (NL-GA-04)</assert>
        </rule>

        <!-- BR-GA-6 The value of each Payment Means reference (NL-GA-02) MUST correspond with one and only one Payment means identifier (NL-GA-04) -->
        <!-- TODO: refactor to make it more readable by using multiple asserts -->
        <rule context="/ubl:Invoice/cac:PaymentMeans">
            <assert id="BR-GA-6" test="count(cbc:ID[text() = ../cac:PaymentTerms/cbc:PaymentMeansID[text()]]) = 1" flag="fatal">The value of each Payment Means reference (NL-GA-02) MUST correspond with one and only one Payment means identifier (NL-GA-04)</assert>
        </rule>

        <!-- BR-GA-7 There MUST be a Payment Means identifier (NL-GA-04) with a value equal to 'GACCOUNT' -->
        <rule context="/ubl:Invoice">
            <assert id="BR-GA-7" test="count(cac:PaymentMeans/cbc:ID[text()='GACCOUNT']) = 1" flag="fatal">There MUST be a Payment Means identifier (NL-GA-04) with a value equal to 'GACCOUNT'</assert>
        </rule>
    </pattern>
</schema>
