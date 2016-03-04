set file_name=SI-UBL-INV
set convert_base=.

java -jar ./lib/saxon.jar -o ./temp/SI-UBL-INV_step_dsdl.xsl SI-UBL-INV.SCH ./convert/iso_dsdl_include_xslt2.xsl 
java -jar ./lib/saxon.jar -o ./temp/SI-UBL-INV_step_abstract.xsl ./temp/SI-UBL-INV_step_dsdl.xsl ./convert/iso_abstract_expand_xslt2.xsl
java -jar ./lib/saxon.jar -o SI-UBL-INV.xsl ./temp/SI-UBL-INV_step_abstract.xsl ./convert/iso_svrl_for_xslt2.xsl
