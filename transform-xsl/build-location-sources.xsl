<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="location-sources-path">sources/locations/</xsl:variable>

	<xsl:template match="locationset">
		<project name="build-location-sources" default="build-all">
			<target name="build-all">
				<xsl:apply-templates select="location"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="trip">
		&lt;trip
			name=&quot;<xsl:value-of select="@name"/>&quot;
			date=&quot;<xsl:value-of select="@date"/>&quot;
			leader=&quot;<xsl:value-of select="@leader"/>&quot;
			url=&quot;<xsl:value-of select="@url"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
		&lt;/trip&gt;
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting date=&quot;<xsl:value-of select="@date"/>&quot; <xsl:apply-templates select="@first | @exclude | @photo"/>&gt;
			<xsl:apply-templates select="notes"/>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:param name="in-sightings"/>

		&lt;species
			order-id=&quot;<xsl:value-of select="@order-id"/>&quot;
			abbreviation=&quot;<xsl:value-of select="@abbreviation"/>&quot;
			latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot;
			common-name=&quot;<xsl:value-of select="@common-name"/>&quot;
			taxonomy-id=&quot;<xsl:value-of select="@taxonomy-id"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			<xsl:apply-templates select="$in-sightings[@abbreviation=current()/@abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="location">
		<xsl:message>Building Source XML for Location '<xsl:value-of select="@name"/>'</xsl:message>

		<xsl:variable
			name="location-sightings"
			select="$sightings/sightingset/sighting[@location-name=current()/@name]"/>

		<xsl:variable
			name="location-trips"
			select="$trips/tripset/trip[@date=$location-sightings/@date]"/>

		<xsl:variable
			name="location-species"
			select="$species/taxonomyset/species[@abbreviation=$location-sightings/@abbreviation]"/>

		<echo>
			<xsl:attribute name="file">sources/locations/<xsl:value-of select="@filename-stem"/>.xml</xsl:attribute>
			&lt;!DOCTYPE generate-location-report SYSTEM "file:birdwalker.dtd"&gt;
			&lt;generate-location-report location-name="<xsl:value-of select="@name"/>"&gt;

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
