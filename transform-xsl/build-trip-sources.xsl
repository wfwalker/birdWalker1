<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="trip-sources-path">sources/trips/</xsl:variable>

	<xsl:template match="tripset">
		<project name="build-trip-sources" default="build-all">
			<target name="build-all">
				<xsl:apply-templates select="trip"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting location-name=&quot;<xsl:value-of select="@location-name"/>&quot;<xsl:apply-templates select="@first | @exclude | @photo"/> &gt;
			<xsl:apply-templates select="notes"/>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:param name="in-sightings"/>

		&lt;species
			order-id=&quot;<xsl:value-of select="@order-id"/>&quot;
			family-id=&quot;<xsl:value-of select="@family-id"/>&quot;
			subfamily-id=&quot;<xsl:value-of select="@subfamily-id"/>&quot;
			genus-id=&quot;<xsl:value-of select="@genus-id"/>&quot;
			species-id=&quot;<xsl:value-of select="@species-id"/>&quot;
			abbreviation=&quot;<xsl:value-of select="@abbreviation"/>&quot;
			latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot;
			common-name=&quot;<xsl:value-of select="@common-name"/>&quot;
			taxonomy-id=&quot;<xsl:value-of select="@taxonomy-id"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;

			<xsl:apply-templates select="notes"/>

			<xsl:apply-templates select="$in-sightings[@abbreviation=current()/@abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="location">
		&lt;location
			name=&quot;<xsl:value-of select="@name"/>&quot;
			url=&quot;<xsl:value-of select="@url"/>&quot;
			city=&quot;<xsl:value-of select="@city"/>&quot;
			state=&quot;<xsl:value-of select="@state"/>&quot;
			county=&quot;<xsl:value-of select="@county"/>&quot;
			latitude=&quot;<xsl:value-of select="@latitude"/>&quot;
			longitude=&quot;<xsl:value-of select="@longitude"/>&quot;
			system=&quot;<xsl:value-of select="@system"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
			<xsl:apply-templates select="@notes"/>
		&lt;/location&gt;
	</xsl:template>

	<xsl:template match="trip">
		<xsl:variable
			name="in-trip-date"
			select="@date"/>

		<xsl:variable
			name="trip-sightings"
			select="$sightings/sightingset/sighting[@date=$in-trip-date]"/>

		<xsl:variable
			name="trip-species"
			select="$species/taxonomyset/species[@abbreviation=$trip-sightings/@abbreviation]"/>

		<xsl:variable
			name="trip-locations"
			select="$locations/locationset/location[@name=$trip-sightings/@location-name]"/>

		<xsl:message>Building Source XML for Trip '<xsl:value-of select="@name"/>'</xsl:message>

		<echo>
			<xsl:attribute name="file">sources/trips/<xsl:value-of select="@filename-stem"/>.xml</xsl:attribute>
			&lt;!DOCTYPE generate-trip-report SYSTEM "file:dtds/generate-report.dtd"&gt;
			&lt;generate-trip-report trip-date="<xsl:value-of select="date"/>"&gt;

			&lt;trip
				name=&quot;<xsl:value-of select="@name"/>&quot;
				date=&quot;<xsl:value-of select="@date"/>&quot;
				leader=&quot;<xsl:value-of select="@leader"/>&quot;
				url=&quot;<xsl:value-of select="@url"/>&quot;
				filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
				<xsl:apply-templates select="notes"/>
			&lt;/trip&gt;

			<xsl:apply-templates select="$trip-species">
				<xsl:with-param name="in-sightings" select="$trip-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="$trip-locations"/>

			&lt;/generate-trip-report&gt;
		</echo>
	</xsl:template>
</xsl:stylesheet>
