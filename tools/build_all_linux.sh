#!/bin/bash
[[ -e tools/build_all_linux.sh ]] || { echo >&2 "Please call this script from the base directory of the repository."; exit 1; }

./tools/convert_linux.sh schematron/si-ubl-1.0.sch xsl/si-ubl-1.0.xsl
./tools/convert_linux.sh schematron/si-ubl-1.1.sch xsl/si-ubl-1.1.xsl
./tools/convert_linux.sh schematron/si-ubl-1.2.sch xsl/si-ubl-1.2.xsl
./tools/convert_linux.sh schematron/si-ubl-1.2-purchaseorder.sch xsl/si-ubl-1.2-purchaseorder.xsl
./tools/convert_linux.sh schematron/si-ubl-2.0.sch xsl/si-ubl-2.0.xsl

saxon-xslt -o documentation/si-ubl-1.0/si-ubl-1.0-inv-rules-overview.html xsl/si-ubl-1.0.xsl tools/convert_xsl/rules-overview.xsl
saxon-xslt -o documentation/si-ubl-1.1/si-ubl-1.1-inv-rules-overview.html xsl/si-ubl-1.1.xsl tools/convert_xsl/rules-overview.xsl
saxon-xslt -o documentation/si-ubl-1.2/si-ubl-1.2-po-rules-overview.html xsl/si-ubl-1.2-purchaseorder.xsl tools/convert_xsl/rules-overview.xsl
saxon-xslt -o documentation/si-ubl-1.2/si-ubl-1.2-inv-rules-overview.html xsl/si-ubl-1.2.xsl tools/convert_xsl/rules-overview.xsl
saxon-xslt -o documentation/si-ubl-2.0/si-ubl-2.0-rules-overview.html xsl/si-ubl-2.0.xsl tools/convert_xsl/rules-overview.xsl
