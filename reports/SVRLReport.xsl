<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html"/>
	<xsl:template match="svrl:fired-rule"><events/></xsl:template>
	<xsl:template match="svrl:failed-assert">
			<li class="report failed">
				<xsl:value-of select="svrl:text"/>
			</li>
	</xsl:template>
	<xsl:template match="svrl:successful-report">
			<li class="report success">
				<xsl:value-of select="svrl:text"/>
			</li>
	</xsl:template>
	<xsl:template match="svrl:text">
			<div class="report heading">
				<xsl:value-of select="."/>
			</div>
	</xsl:template>
	<xsl:template match="svrl:active-pattern">
			<h3 class="report heading pattern">
				<xsl:value-of select="@name"/>
			</h3>
	</xsl:template>
	<xsl:template match="/">
		<html>
			<head>
				<title>Validated File <xsl:value-of select="//svrl:active-pattern[1]/@document"/></title>
				<script type="text/javascript" src="js/jquery.js"/>
			</head>
			<body>
			<div>This is the Schematron report for <em><xsl:value-of select="//svrl:active-pattern[1]/@document"/></em>, these are the findings:</div>
			<div id="errors">Errors: </div>
			<div id="success">Success: </div>
			<div id="event">Events: </div>
			<ol id="myList">
						<xsl:apply-templates/>
			</ol>
			<script>
			
			function hide_errors() {
				$("li.failed:hidden").slideToggle("slow");
				$("li.success").slideToggle("slow");
			}
			
			function hide_success() {
				$("li.success:hidden").slideToggle("slow");
				$("li.failed").slideToggle("slow");
			}
			
			$( function() {
				$("div#errors").click(hide_errors);
				$("div#success").click(hide_success);
			});
			
			$(function() {$("li.failed").css("background-color","red").width(500);});
			$(function() {$("li.success").css("background-color","green").width(500);});
			$(function() {$("div.heading").css("font-weight","bolder").width(500);});
			$(function() {$("h3.pattern").css("font-weight","bolder").width(500);});
			$(function() {$("<b/>").html($("li.failed").size() +" Errors").appendTo("#errors");});
			$(function() {$("<b/>").html($("li.success").size() +" Reports").appendTo("#success");});
			$(function() {$("<b/>").html($("events").size() +" Successful").appendTo("#event");});
			</script>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
