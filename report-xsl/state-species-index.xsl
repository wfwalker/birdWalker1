<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:variable name="my-header-style">species-navigationblock</xsl:variable>

	<!-- define my report parameters -->
	<xsl:param name="in-state"/>

	<xsl:param name="state-locations" select="$locations/locationset/location[state[text()=$in-state]]"/>

	<xsl:param name="state-sightings" select="$sightings/sightingset/sighting[location=$state-locations/name]"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species seen in <xsl:value-of select="$in-state"/></H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$species/taxonomyset/species[abbreviation=$state-sightings/abbreviation]"/>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
