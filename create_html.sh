#!/bin/bash
saxon-xslt  -o /opt/validation/rules-invoice-overview.html /opt/validation/SI-UBL-INV-1.2.xsl /opt/validation/rules-overview.xsl 
saxon-xslt  -o /opt/validation/rules-po-overview.html /opt/validation/SI-UBL-PO-1.2.xsl /opt/validation/rules-overview.xsl 
