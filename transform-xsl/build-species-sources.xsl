<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="species-sources-path">sources/species/</xsl:variable>

	<xsl:variable name="sightings" select="document('../sightings.xml')"/>

	<xsl:template match="*">
		<project name="build-species-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$species-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$species-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="species[abbreviation=$sightings/sightingset/sighting/abbreviation]"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="species">
		<echo>
			<xsl:attribute name="file">sources/species/<xsl:value-of select="report-url"/></xsl:attribute>
			&lt;generate-species-report abbreviation="<xsl:value-of select="abbreviation"/>"/&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
