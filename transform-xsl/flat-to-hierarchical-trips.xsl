<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="sightings" select="document('./sightings.xml')"/>

	<xsl:template match="tripset">
		<tripset>
			<xsl:apply-templates select="trip"/>
		</tripset>
	</xsl:template>

	<xsl:template match="trip">
		<xsl:variable name="tripdate" select="date"/>

		<trip>
			<xsl:copy-of select="name"/>
			<xsl:copy-of select="date"/>
			<xsl:copy-of select="leader"/>
			<xsl:copy-of select="url"/>
			<xsl:copy-of select="notes"/>
			
			<sightings>
				<xsl:for-each select="$sightings/sightingset/sighting[date=$tripdate]">
					<sighting>
						<xsl:copy-of select="abbreviation"/>
						<xsl:copy-of select="location"/>
						<xsl:copy-of select="notes"/>
					</sighting>
				</xsl:for-each>
			</sightings>
		</trip>
	</xsl:template>

</xsl:stylesheet>
