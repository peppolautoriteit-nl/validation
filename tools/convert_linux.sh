#!/bin/bash
CONVERT_XSL_PATH="tools/convert_xsl"
INPUT_FILE=$1
OUTPUT_FILE=$2
TMPDIR="/tmp/validation_tmp"

[[ -e tools/convert_linux.sh ]] || { echo >&2 "Please call this script from the base directory of the repository."; exit 1; }
[[ -e ${TMPDIR} ]] || { mkdir -p ${TMPDIR}; }

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

do_cmd java -jar ./tools/lib/saxon9he.jar -o:${TMPDIR}/step1_dsdl.xsl $INPUT_FILE ${CONVERT_XSL_PATH}/iso_dsdl_include.xsl &&\
do_cmd java -jar ./tools/lib/saxon9he.jar -o:${TMPDIR}/step2_abstract.xsl ${TMPDIR}/step1_dsdl.xsl ${CONVERT_XSL_PATH}/iso_abstract_expand.xsl &&\
do_cmd java -jar ./tools/lib/saxon9he.jar -o:${OUTPUT_FILE} ${TMPDIR}/step2_abstract.xsl ${CONVERT_XSL_PATH}/iso_svrl_for_xslt2.xsl
