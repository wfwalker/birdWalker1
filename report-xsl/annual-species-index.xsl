<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:param name="in-year"/>

	<xsl:variable name="year-abbreviations" select="$sightings/sightingset/sighting[not(exclude) and contains(date, $in-year)]/abbreviation"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-year"/></TITLE>
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species seen in <xsl:value-of select="$in-year"/></H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$species/taxonomyset/species[abbreviation=$year-abbreviations]"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
