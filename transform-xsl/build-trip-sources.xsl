<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

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

	<xsl:template match="sighting">
		&lt;sighting&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;location&gt;<xsl:value-of select="location"/>&lt;/location&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
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
			&lt;report-url&gt;<xsl:value-of select="report-url"/>&lt;/report-url&gt;

			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>

			<xsl:apply-templates select="$in-sightings[abbreviation=$this/abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="location">
		&lt;location&gt;
			&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
			&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
			&lt;city&gt;<xsl:value-of select="city"/>&lt;/city&gt;
			&lt;state&gt;<xsl:value-of select="state"/>&lt;/state&gt;
			&lt;county&gt;<xsl:value-of select="county"/>&lt;/county&gt;
			&lt;latitude&gt;<xsl:value-of select="latitude"/>&lt;/latitude&gt;
			&lt;longitude&gt;<xsl:value-of select="longitude"/>&lt;/longitude&gt;
			&lt;system&gt;<xsl:value-of select="system"/>&lt;/system&gt;
			&lt;report-url&gt;<xsl:value-of select="report-url"/>&lt;/report-url&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
		&lt;/location&gt;
	</xsl:template>

	<xsl:template match="trip">
		<xsl:variable
			name="in-trip-date"
			select="date"/>

		<xsl:variable
			name="trip-sightings"
			select="$sightings/sightingset/sighting[date=$in-trip-date]"/>

		<xsl:variable
			name="trip-species"
			select="$species/taxonomyset/species[abbreviation=$trip-sightings/abbreviation]"/>

		<xsl:variable
			name="trip-locations"
			select="$locations/locationset/location[name=$trip-sightings/location]"/>

		<xsl:message>Building Source XML for Trip '<xsl:value-of select="name"/>'</xsl:message>

		<echo>
			<xsl:attribute name="file">sources/trips/<xsl:value-of select="report-url"/></xsl:attribute>
			&lt;generate-trip-report trip-date="<xsl:value-of select="date"/>"&gt;

			&lt;trip&gt;
				&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
				&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
				&lt;leader&gt;<xsl:value-of select="leader"/>&lt;/leader&gt;
				&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
				&lt;report-url&gt;<xsl:value-of select="report-url"/>&lt;/report-url&gt;
				<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			&lt;/trip&gt;

			<xsl:apply-templates select="$trip-species">
				<xsl:with-param name="in-sightings" select="$trip-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="$trip-locations"/>

			&lt;/generate-trip-report&gt;
		</echo>
	</xsl:template>
</xsl:stylesheet>
