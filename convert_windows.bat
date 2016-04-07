set file_name=SI-UBL-INV
set convert_base=.
java -jar ./lib/saxon.jar -o %convert_base%/temp/%file_name%_step_dsdl.xsl %file_name%.SCH %convert_base%/convert/iso_dsdl_include.xsl 
java -jar ./lib/saxon.jar -o %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/temp/%file_name%_step_dsdl.xsl %convert_base%/convert/iso_abstract_expand.xsl
java -jar ./lib/saxon.jar -o %file_name%-1.1.1.xsl %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/convert/iso_svrl_for_xslt1.xsl
