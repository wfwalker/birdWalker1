<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:variable
		name="non-excluded-abbreviations"
		select="$sightings/sightingset/sighting[not(exclude)]/abbreviation"/>
	
	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Life Species</TITLE>
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Life Species</H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$species/taxonomyset/species[abbreviation=$non-excluded-abbreviations]"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
