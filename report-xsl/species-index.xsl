<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:param name="my-background-color" select="$species-background-color"/>

	<xsl:variable
		name="non-excluded-abbreviations"
		select="$sightings/sightingset/sighting[not(exclude)]/abbreviation"/>
	
	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species Reports</H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$species/taxonomyset/species[abbreviation=$non-excluded-abbreviations]"/>
			</xsl:call-template>

			<xsl:call-template name="order-table"/>

			<xsl:call-template name="monthly-distribution">
				<xsl:with-param name="dated-items" select="$sightings/sightingset/sighting"/>
				<xsl:with-param name="item-kind">total sightings</xsl:with-param>
			</xsl:call-template>
	
			<xsl:call-template name="yearly-distribution">
				<xsl:with-param name="dated-items" select="$sightings/sightingset/sighting"/>
				<xsl:with-param name="item-kind">total sightings</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
