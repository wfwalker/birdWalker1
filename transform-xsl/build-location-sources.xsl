<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="location-sources-path">sources/locations/</xsl:variable>

	<xsl:template match="*">
		<project name="build-location-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$location-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$location-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="location"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="location">
		<echo>
			<xsl:attribute name="file">sources/locations/<xsl:value-of select="report-url"/></xsl:attribute>
			&lt;generate-location-report location-name="<xsl:value-of select="name"/>"/&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
