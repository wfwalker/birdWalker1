<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="year-sources-path">sources/years/</xsl:variable>

	<xsl:template match="yearset">
		<project name="build-year-sources" default="build-all">
			<target name="build-all">
				<xsl:apply-templates select="year"/>
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

	<xsl:template match="orderset">
		<xsl:message>THIS SHOULD NOT BE HAPPENING</xsl:message>	
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
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			<xsl:apply-templates select="$in-sightings[@abbreviation=current()/@abbreviation]"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="year">
		<xsl:message>Building Source XML for Year '<xsl:value-of select="@name"/>'</xsl:message>

		<xsl:variable
			name="year-sightings"
			select="$sightings/sightingset/sighting[starts-with(@date, current()/@name)]"/>

		<xsl:variable
			name="year-trips"
			select="$trips/tripset/trip[starts-with(@date, current()/@name)]"/>

		<xsl:variable
			name="year-species"
			select="$species/taxonomyset/species[@abbreviation=$year-sightings/@abbreviation]"/>

		<echo>
			<xsl:attribute name="file">sources/years/<xsl:value-of select="@name"/>.xml</xsl:attribute>
			&lt;!DOCTYPE generate-year-report SYSTEM "file:birdwalker.dtd"&gt;
			&lt;generate-year-report year-name="<xsl:value-of select="@name"/>"&gt;

			&lt;year name=&quot;<xsl:value-of select="@name"/>&quot;/&gt;

			<xsl:apply-templates select="$year-species">
				<xsl:with-param name="in-sightings" select="$year-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="$year-trips"/>

			&lt;/generate-year-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
