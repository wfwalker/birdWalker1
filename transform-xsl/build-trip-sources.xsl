<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="trip-sources-path">sources/trips/</xsl:variable>

	<xsl:template match="*">
		<project name="build-trip-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$trip-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$trip-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="trip"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="trip">
		<echo>
			<xsl:attribute name="file">sources/trips/<xsl:value-of select="report-url"/></xsl:attribute>
			&lt;generate-trip-report trip-date="<xsl:value-of select="date"/>"/&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
