validation
==========

Contains all files related to validation of the simplerinvoicing xml files.

The validation is based on Schematron; specified in the file SI-UBL-INV.SCH and SI-UBL-PO.SCH.

An XSLT-file based on the schematron definition is also provided; for
SI-UBL-1.2 this is currently SI-UBL-INV-1.2.xsl for invoice and SI-UBL-PO-1.2.xsl for purchase order.

You can recreate this XSLT file by running one of the conversion scripts.
By default the generated XSLT files will be based on XSLT2 but you can create XSLT1 compatible XSLT files by changing the `XSLT_VERSION` in the scripts, e.g. with `XSLT_VERSION=1 ./convert_linux.sh SI-UBL-INV.SCH SI-UBL-INV-1.2.xsl`.

An overview of the applicable rules can be found in rules-overview-invoice.html and rules-overview-po.html
(generated from the generated XSLT file).
