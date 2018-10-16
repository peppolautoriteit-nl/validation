@set file_name=si-ubl-inv-all
@set toolsconvert_xsl_base=

java -jar ./tools/lib/saxon9he.jar -versionmsg:off -o:%toolsconvert_xsl_base%temp\%file_name%_step_dsdl.xsl schematron\%file_name%.sch %toolsconvert_xsl_base%toolsconvert_xsl\iso_dsdl_include.xsl
@if not %errorlevel%==0 goto error

java -jar ./tools/lib/saxon9he.jar -versionmsg:off -o:%toolsconvert_xsl_base%temp\%file_name%_step_abstract.xsl %toolsconvert_xsl_base%temp\%file_name%_step_dsdl.xsl %toolsconvert_xsl_base%toolsconvert_xsl\iso_abstract_expand.xsl
@if not %errorlevel%==0 goto error

java -jar ./tools/lib/saxon9he.jar -versionmsg:off -o:%file_name%.xsl %toolsconvert_xsl_base%temp\%file_name%_step_abstract.xsl %toolsconvert_xsl_base%toolsconvert_xsl\iso_svrl_for_xslt2.xsl
@if not %errorlevel%==0 goto error

@echo Artefact validation XSLT written to %file_name%.xsl
@goto end

:error
@echo Error during conversion, output not written

:end
