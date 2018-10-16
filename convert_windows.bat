@set file_name=SI-UBL-INV
@set convert_base=

java -jar ./lib/saxon9he.jar -versionmsg:off -o:%convert_base%temp\%file_name%_step_dsdl.xsl %file_name%.SCH %convert_base%convert\iso_dsdl_include.xsl
@if not %errorlevel%==0 goto error

java -jar ./lib/saxon9he.jar -versionmsg:off -o:%convert_base%temp\%file_name%_step_abstract.xsl %convert_base%temp\%file_name%_step_dsdl.xsl %convert_base%convert\iso_abstract_expand.xsl
@if not %errorlevel%==0 goto error

java -jar ./lib/saxon9he.jar -versionmsg:off -o:%file_name%.xsl %convert_base%temp\%file_name%_step_abstract.xsl %convert_base%convert\iso_svrl_for_xslt2.xsl
@if not %errorlevel%==0 goto error

@echo Artefact validation XSLT written to %file_name%.xsl
@goto end

:error
@echo Error during conversion, output not written

:end
