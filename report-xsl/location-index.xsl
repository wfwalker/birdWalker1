<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Location Reports</TITLE>
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<H1><IMG SRC="images/location.gif"/>Index of Location Reports</H1>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$locations/locationset/location"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
