#!/bin/bash
export FILE_NAME=SI-UBL-INV
export CONVERT_BASE=.
export INPUT_FILE=$1
export OUTPUT_FILE=$2

if [ -z $OUTPUT_FILE ] || [ -z $INPUT_FILE ]; then
    echo "usage: convert_linux.sh <input file> <xslt output file>";
    exit 1;
else
    echo "Generating XSLT file $OUTPUT_FILE";
fi

function do_cmd {
    echo $@
    $@
}

do_cmd java -jar ./lib/saxon9he.jar -o:${CONVERT_BASE}/temp/step1_dsdl.xsl ${FILE_NAME}.SCH ${CONVERT_BASE}/convert/iso_dsdl_include_xslt2.xsl
do_cmd java -jar ./lib/saxon9he.jar -o:${CONVERT_BASE}/temp/step2_abstract.xsl ${CONVERT_BASE}/temp/step1_dsdl.xsl ${CONVERT_BASE}/convert/iso_abstract_expand_xslt2.xsl
do_cmd java -jar ./lib/saxon9he.jar -o:${OUTPUT_FILE} ${CONVERT_BASE}/temp/step2_abstract.xsl ${CONVERT_BASE}/convert/iso_svrl_for_xslt2.xsl
