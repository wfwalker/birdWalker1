<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- <xsl:include href="sightings-common.xsl"/> -->

	<xsl:template match="sightingset">
		<HTML>
		<HEAD><TITLE>Sightings by Species</TITLE></HEAD>
		
		<BODY>

		<!-- compute lists of species -->

		<xsl:variable name="species-list" select="sighting/common-name[not(.=following::common-name)]" />

		<H1 STYLE="font:18pt Tahoma">Sightings by Species</H1>

		<!-- SIGHTINGS BY SPECIES -->

		<xsl:for-each select="$species-list">
			<xsl:variable name="this" select="." />
			<xsl:variable name="species-sightings" select="/sightingset/sighting[common-name=$this]"/>
			<xsl:variable name="species-unique-locations" select="$species-sightings/location[not(.=following::sighting[common-name=$this]/location)]"/>

			<H2 STYLE="font: 14pt Tahoma"><xsl:value-of select="$this"/></H2>
			<P STYLE="font: 12pt Tahoma">
				<xsl:value-of select="count($species-sightings)"/> sightings in
				<xsl:value-of select="count($species-unique-locations)"/> locations
			</P>

			<P STYLE="font: 10pt Tahoma">
				<xsl:for-each select="$species-unique-locations">
					<xsl:value-of select="."/>, 
				</xsl:for-each>
			</P>

		</xsl:for-each>

		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
