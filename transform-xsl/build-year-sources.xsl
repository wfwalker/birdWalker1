<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="year-sources-path">sources/years/</xsl:variable>

	<xsl:template match="yearset">
		<project name="build-year-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$year-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$year-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="year"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="trip">
		&lt;trip&gt;
			&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;leader&gt;<xsl:value-of select="leader"/>&lt;/leader&gt;
			&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
			&lt;report-url&gt;<xsl:value-of select="report-url"/>&lt;/report-url&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
		&lt;/trip&gt;
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			<xsl:if test="first">&lt;first&gt;true&lt;/first&gt;</xsl:if>
			<xsl:if test="exclude">&lt;exclude&gt;true&lt;/exclude&gt;</xsl:if>
			<xsl:apply-templates select="notes"/>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:param name="in-sightings"/>

		<xsl:variable
			name="this"
			select="."/>

		&lt;species&gt;
			&lt;order-id&gt;<xsl:value-of select="order-id"/>&lt;/order-id&gt;
			&lt;family-id&gt;<xsl:value-of select="family-id"/>&lt;/family-id&gt;
			&lt;subfamily-id&gt;<xsl:value-of select="subfamily-id"/>&lt;/subfamily-id&gt;
			&lt;genus-id&gt;<xsl:value-of select="genus-id"/>&lt;/genus-id&gt;
			&lt;species-id&gt;<xsl:value-of select="species-id"/>&lt;/species-id&gt;
			&lt;abbreviation&gt;<xsl:value-of select="abbreviation"/>&lt;/abbreviation&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
			&lt;taxonomy-id&gt;<xsl:value-of select="taxonomy-id"/>&lt;/taxonomy-id&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			&lt;report-url&gt;<xsl:value-of select="report-url"/>&lt;/report-url&gt;

			<xsl:apply-templates select="$in-sightings[abbreviation=$this/abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="year">
		<xsl:message>Building Source XML for Year '<xsl:value-of select="@name"/>'</xsl:message>

		<xsl:variable
			name="this"
			select="."/>

		<xsl:variable
			name="year-sightings"
			select="$sightings/sightingset/sighting[starts-with(date, $this/@name)]"/>

		<xsl:variable
			name="year-trips"
			select="$trips/tripset/trip[starts-with(date, $this/@name)]"/>

		<xsl:variable
			name="year-species"
			select="$species/taxonomyset/species[abbreviation=$year-sightings/abbreviation]"/>

		<echo>
			<xsl:attribute name="file">sources/years/<xsl:value-of select="@name"/>.html</xsl:attribute>
			&lt;generate-year-report year-name="<xsl:value-of select="@name"/>"&gt;

			&lt;year&gt;
				&lt;name&gt;<xsl:value-of select="@name"/>&lt;/name&gt;
			&lt;/year&gt;

			<xsl:apply-templates select="$year-species">
				<xsl:with-param name="in-sightings" select="$year-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="$year-trips"/>

			&lt;/generate-year-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>