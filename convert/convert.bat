@set INPUT_FILE=%1
@set OUTPUT_FILE=%2
@set MYDIR=%~dp0
@set TMPDIR="%MYDIR%/temp/"
@set SAX="%MYDIR%/lib/saxon9he.jar"
@set CONVERT_XSL_PATH="%MYDIR%/convert_xsl"

if not exist "%TMPDIR%" mkdir "%TMPDIR%"

java -jar %SAX% -o:%TMPDIR%/step1_dsdl.xsl $INPUT_FILE %CONVERT_XSL_PATH%/iso_dsdl_include.xsl &&\
@if not %errorlevel%==0 goto error
java -jar %SAX% -o:%TMPDIR%/step2_abstract.xsl %TMPDIR%/step1_dsdl.xsl %CONVERT_XSL_PATH%/iso_abstract_expand.xsl &&\
@if not %errorlevel%==0 goto error
java -jar %SAX% -o:%OUTPUT_FILE% %TMPDIR%/step2_abstract.xsl %CONVERT_XSL_PATH%/iso_svrl_for_xslt2.xsl &&\
@if not %errorlevel%==0 goto error

@echo Artefact validation XSLT written to %file_name%.xsl
@goto end

:error
@echo Error during conversion, output not written

:end
