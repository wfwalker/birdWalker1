<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="location-sources-path">sources/locations/</xsl:variable>

	<xsl:template match="locationset">
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

	<xsl:template match="trip">
		&lt;trip&gt;
			&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;leader&gt;<xsl:value-of select="leader"/>&lt;/leader&gt;
			&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;
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
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;

			<xsl:apply-templates select="$in-sightings[abbreviation=$this/abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="location">
		<xsl:message>Building Source XML for Location '<xsl:value-of select="name"/>'</xsl:message>

		<xsl:variable
			name="this"
			select="."/>

		<xsl:variable
			name="location-sightings"
			select="$sightings/sightingset/sighting[location=$this/name]"/>

		<xsl:variable
			name="location-trips"
			select="$trips/tripset/trip[date=$location-sightings/date]"/>

		<xsl:variable
			name="location-species"
			select="$species/taxonomyset/species[abbreviation=$location-sightings/abbreviation]"/>

		<echo>
			<xsl:attribute name="file">sources/locations/<xsl:value-of select="filename-stem"/>.xml</xsl:attribute>
			&lt;generate-location-report location-name="<xsl:value-of select="name"/>"&gt;

			&lt;location&gt;
				&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
				&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
				&lt;city&gt;<xsl:value-of select="city"/>&lt;/city&gt;
				&lt;state&gt;<xsl:value-of select="state"/>&lt;/state&gt;
				&lt;county&gt;<xsl:value-of select="county"/>&lt;/county&gt;
				&lt;latitude&gt;<xsl:value-of select="latitude"/>&lt;/latitude&gt;
				&lt;longitude&gt;<xsl:value-of select="longitude"/>&lt;/longitude&gt;
				&lt;system&gt;<xsl:value-of select="system"/>&lt;/system&gt;
				&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;
				<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			&lt;/location&gt;

			<xsl:apply-templates select="$location-species">
				<xsl:with-param name="in-sightings" select="$location-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="$location-trips"/>

			&lt;/generate-location-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
