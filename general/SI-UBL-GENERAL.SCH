<?xml version="1.0" encoding="UTF-8"?>

<!-- These are some general checks that make sure we can determine the
     version; without with the version-specific tests could not be run.
-->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-VERSIONS">
    <rule context="ubl:Invoice" flag="fatal">
        <assert test="cbc:CustomizationID" flag="fatal">[BII2-T10-R001] An invoice MUST have a customization identifier</assert>
    </rule>
    <!-- must be si 1.0 to 1.2 -->
	<rule context="cbc:CustomizationID">
		<assert test="contains(., 'urn:www.simplerinvoicing.org:si:si-ubl:ver1.1') or
                      contains(., 'urn:www.simplerinvoicing.org:si:si-ubl:ver1.2') or
                      contains(., 'urn:www.simplerinvoicing.org:si-ubl:invoice:ver1.0.x')
                     " flag="fatal">[SI-V11-INV-R200]-This XML instance is NOT tagged as an SI-UBL invoice</assert>
	</rule>
</pattern>
