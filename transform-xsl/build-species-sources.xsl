<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="species-sources-path">sources/species/</xsl:variable>

	<xsl:template match="taxonomyset">
		<project name="build-species-sources" default="build-all">
			<target name="build-all">
				<xsl:apply-templates select="species[@abbreviation=$sightings/sightingset/sighting/@abbreviation]"/>
				<!-- xsl:apply-templates select="species"/ -->
			</target>
		</project>
	</xsl:template>

	<xsl:template match="trip">
		<xsl:param
			name="in-sightings"/>

		&lt;trip
			name=&quot;<xsl:value-of select="@name"/>&quot;
			date=&quot;<xsl:value-of select="@date"/>&quot;
			leader=&quot;<xsl:value-of select="@leader"/>&quot;
			url=&quot;<xsl:value-of select="@url"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
			<xsl:apply-templates select="$in-sightings[@date=current()/@date]"/>
		&lt;/trip&gt;
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
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;/&gt;
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting date=&quot;<xsl:value-of select="@date"/>&quot; location-name=&quot;<xsl:value-of select="@location-name"/>&quot; <xsl:apply-templates select="@exclude | @first | @photo"/>&gt;
			<xsl:apply-templates select="notes"/>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="genus">
		&lt;genus latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot; common-name=&quot;<xsl:value-of select="@common-name"/>&quot;/&gt;
	</xsl:template>

	<xsl:template match="subfamily">
		&lt;subfamily latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot; common-name=&quot;<xsl:value-of select="@common-name"/>&quot;/&gt;
	</xsl:template>

	<xsl:template match="family">
		&lt;family latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot; common-name=&quot;<xsl:value-of select="@common-name"/>&quot;/&gt;
	</xsl:template>

	<xsl:template match="order">
		&lt;order latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot; common-name=&quot;<xsl:value-of select="@common-name"/>&quot; filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;/&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[@abbreviation=current()/@abbreviation]"/>

		<xsl:variable
			name="species-locations"
			select="$locations/locationset/location[@name=$species-sightings/@location-name]"/>

		<xsl:message>Building Source XML for Species '<xsl:value-of select="@common-name"/>' <xsl:value-of select="position()"/></xsl:message>

		<echo>
			<xsl:attribute name="file">sources/species/<xsl:value-of select="@filename-stem"/>.xml</xsl:attribute>
			&lt;!DOCTYPE generate-species-report SYSTEM "file:dtds/generate-report.dtd"&gt;
			&lt;generate-species-report abbreviation="<xsl:value-of select="@abbreviation"/>"&gt;

			&lt;species
				order-id=&quot;<xsl:value-of select="@order-id"/>&quot;
				species-id=&quot;<xsl:value-of select="@species-id"/>&quot;
				abbreviation=&quot;<xsl:value-of select="@abbreviation"/>&quot;
				latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot;
				url=&quot;<xsl:value-of select="@url"/>&quot;
				common-name=&quot;<xsl:value-of select="@common-name"/>&quot;
				taxonomy-id=&quot;<xsl:value-of select="@taxonomy-id"/>&quot;
				filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
				<xsl:apply-templates select="notes"/>

			&lt;/species&gt;

			<xsl:apply-templates select="$species-locations"/>

			<xsl:apply-templates select="document('../flat-trips.xml')/tripset/trip[@date=$species-sightings/@date]">
				<xsl:with-param name="in-sightings" select="$species-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates
				select="document('../flat-species.xml')/taxonomyset/order[@order-id=current()/@order-id]"/>

			<xsl:apply-templates
				select="document('../flat-species.xml')/taxonomyset/family[@order-id=current()/@order-id and
														@family-id=current()/@family-id]"/>
			<xsl:apply-templates
				select="document('../flat-species.xml')/taxonomyset/subfamily[@order-id=current()/@order-id and
														@family-id=current()/@family-id and
														@subfamily-id=current()/@subfamily-id]"/>

			<xsl:apply-templates
				select="document('../flat-species.xml')/taxonomyset/genus[@order-id=current()/@order-id and
														@family-id=current()/@family-id and
														@subfamily-id=current()/@subfamily-id and
														@genus-id=current()/@genus-id]"/>

	
			&lt;/generate-species-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
