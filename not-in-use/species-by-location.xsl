<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- <xsl:include href="sightings-common.xsl"/> -->

	<xsl:template match="sightingset">
		<HTML>
		<HEAD><TITLE>Species by Location</TITLE></HEAD>
		
		<BODY>

		<!-- compute lists of location -->

		<xsl:variable name="location-list" select="sighting/location[not(.=following::location)]" />

		<H1 STYLE="font:18pt Tahoma">Species by Location</H1>

		<P>
		<xsl:for-each select="$location-list">
			<xsl:element name="A">
				<xsl:attribute name="HREF">
					#<xsl:value-of select="."/>
				</xsl:attribute>

				<xsl:value-of select="."/>
			</xsl:element>, 
		</xsl:for-each>
		</P>

		<!-- SIGHTINGS BY LOCATION DETAILS TABLES -->

		<xsl:for-each select="$location-list">
			<xsl:variable name="this" select="." />
			<xsl:variable name="location-sightings" select="/sightingset/sighting[location=$this]"/>
			<xsl:variable name="location-species" select="$location-sightings/common-name[not(.=following::sighting[location=$this]/common-name)]"/>

			<xsl:element name="A">
				<xsl:attribute name="NAME">
					<xsl:value-of select="."/>
				</xsl:attribute>

				<H2 STYLE="font: 14pt Tahoma"><xsl:value-of select="$this"/></H2>
			</xsl:element>

			<P STYLE="font: 12pt Tahoma">
				<xsl:value-of select="count($location-species)"/> species from
				<xsl:value-of select="count($location-sightings)"/> sightings
			</P>

			<P>
				<xsl:for-each select="$location-species">
					<xsl:value-of select="."/>, 
				</xsl:for-each>
			</P>
			
		</xsl:for-each>

		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
