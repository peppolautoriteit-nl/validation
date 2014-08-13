set file_name=BIIRULES-UBL-T10
set convert_base=..
java -jar c:/code_resources/saxon.jar -o %convert_base%/temp/%file_name%_step_dsdl.xsl %file_name%.SCH %convert_base%/convert/iso_dsdl_include.xsl 
java -jar c:/code_resources/saxon.jar -o %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/temp/%file_name%_step_dsdl.xsl %convert_base%/convert/iso_abstract_expand.xsl
java -jar c:/code_resources/saxon.jar -o %file_name%.xsl %convert_base%/temp/%file_name%_step_abstract.xsl %convert_base%/convert/iso_svrl_for_xslt1.xsl

 