#!/bin/bash
export FILE_NAME=SI-UBL-INV
export CONVERT_BASE=.

function do_cmd {
    echo $@
    $@
}

do_cmd java -jar ./lib/saxon.jar -o ${CONVERT_BASE}/temp/${FILE_NAME}_step_dsdl.xsl ${FILE_NAME}.SCH ${CONVERT_BASE}/convert/iso_dsdl_include.xsl
do_cmd java -jar ./lib/saxon.jar -o ${CONVERT_BASE}/temp/${FILE_NAME}_step_abstract.xsl ${CONVERT_BASE}/temp/${FILE_NAME}_step_dsdl.xsl ${CONVERT_BASE}/convert/iso_abstract_expand.xsl
do_cmd java -jar ./lib/saxon.jar -o ${FILE_NAME}.xsl ${CONVERT_BASE}/temp/${FILE_NAME}_step_abstract.xsl ${CONVERT_BASE}/convert/iso_svrl_for_xslt1.xsl
