<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:variable name="my-header-style">location-navigationblock</xsl:variable>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Location Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<H1><IMG SRC="images/location.gif"/>Index of Location Reports</H1>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$locations/locationset/location"/>
			</xsl:call-template>

			<xsl:call-template name="location-navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
