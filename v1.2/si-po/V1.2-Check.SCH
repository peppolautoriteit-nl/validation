    <rule context="node()[not(contains(//cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns010:ver2.0:extended:urn:www.peppol.eu:bis:peppol3a:ver2.0:extended:urn:www.simplerinvoicing.org:si:si-ubl:ver1.1.x'))] | @*[not(contains(//cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns010:ver2.0:extended:urn:www.peppol.eu:bis:peppol3a:ver2.0:extended:urn:www.simplerinvoicing.org:si:si-ubl:ver1.2'))]">
        <assert test="true()" />
    </rule>
