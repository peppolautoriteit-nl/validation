rm SI*.xsl
rm *.html
./convert_linux.sh SI-UBL-PO.SCH  SI-UBL-PO-1.2.xsl
./convert_linux.sh SI-UBL-INV.SCH  SI-UBL-INV-1.2.xsl
saxon-xslt -o rules-po-overview.html  SI-UBL-PO-1.2.xsl rules-overview.xsl 
saxon-xslt -o rules-inv-overview.html  SI-UBL-INV-1.2.xsl rules-overview.xsl

