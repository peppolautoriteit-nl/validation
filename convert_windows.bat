set file_name=SI-UBL-INV
set convert_base=.
java -jar ./lib/saxon9he.jar -o %convert_base%/temp/%file_name%_step_dsdl.xsl %file_name%.SCH %convert_base%/convert/iso_dsdl_include_xslt2.xsl
java -jar ./lib/saxon9he.jar -o %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/temp/%file_name%_step_dsdl.xsl %convert_base%/convert/iso_abstract_expand_xslt2.xsl
java -jar ./lib/saxon9he.jar -o %file_name%.xsl %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/convert/iso_svrl_for_xslt2.xsl
