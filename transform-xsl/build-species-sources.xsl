<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="species-sources-path">sources/species/</xsl:variable>

	<xsl:template match="taxonomyset">
		<project name="build-species-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$species-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$species-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="species[abbreviation=$sightings/sightingset/sighting/abbreviation]"/>
				<!-- xsl:apply-templates select="species"/ -->
			</target>
		</project>
	</xsl:template>

	<xsl:template match="trip">
		<xsl:param
			name="in-sightings"/>

		&lt;trip&gt;
			&lt;name&gt;<xsl:value-of select="name"/>&lt;/name&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;leader&gt;<xsl:value-of select="leader"/>&lt;/leader&gt;
			&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;
			<xsl:apply-templates select="$in-sightings[date=current()/date]"/>
		&lt;/trip&gt;
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
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;
		&lt;/location&gt;
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;location&gt;<xsl:value-of select="location"/>&lt;/location&gt;

			<xsl:apply-templates select="exclude | first | photo | notes"/>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="genus">
		&lt;genus&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/genus&gt;
	</xsl:template>

	<xsl:template match="subfamily">
		&lt;subfamily&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/subfamily&gt;
	</xsl:template>

	<xsl:template match="family">
		&lt;family&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/family&gt;
	</xsl:template>

	<xsl:template match="order">
		&lt;order&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;
		&lt;/order&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[abbreviation=current()/abbreviation]"/>

		<xsl:variable
			name="species-locations"
			select="$locations/locationset/location[name=$species-sightings/location]"/>

		<xsl:message>Building Source XML for Species '<xsl:value-of select="common-name"/>' <xsl:value-of select="position()"/></xsl:message>

		<echo>
			<xsl:attribute name="file">sources/species/<xsl:value-of select="filename-stem"/>.xml</xsl:attribute>
			&lt;!DOCTYPE sightingset SYSTEM "file:dtds/species-report-source.dtd"&gt;
			&lt;generate-species-report abbreviation="<xsl:value-of select="abbreviation"/>"&gt;

			&lt;species&gt;
				&lt;order-id&gt;<xsl:value-of select="order-id"/>&lt;/order-id&gt;
				&lt;family-id&gt;<xsl:value-of select="family-id"/>&lt;/family-id&gt;
				&lt;subfamily-id&gt;<xsl:value-of select="subfamily-id"/>&lt;/subfamily-id&gt;
				&lt;genus-id&gt;<xsl:value-of select="genus-id"/>&lt;/genus-id&gt;
				&lt;species-id&gt;<xsl:value-of select="species-id"/>&lt;/species-id&gt;
				&lt;abbreviation&gt;<xsl:value-of select="abbreviation"/>&lt;/abbreviation&gt;
				&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
				&lt;url&gt;<xsl:value-of select="url"/>&lt;/url&gt;
				&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
				&lt;taxonomy-id&gt;<xsl:value-of select="taxonomy-id"/>&lt;/taxonomy-id&gt;
				<xsl:apply-templates select="notes"/>
				&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;

			&lt;/species&gt;

			<xsl:apply-templates select="$species-locations"/>

			<xsl:apply-templates select="document('../flat-trips.xml')/tripset/trip[date=$species-sightings/date]">
				<xsl:with-param name="in-sightings" select="$species-sightings"/>
			</xsl:apply-templates>

			<xsl:apply-templates
				select="$species/taxonomyset/order[order-id=current()/order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/family[order-id=current()/order-id and
														family-id=current()/family-id]"/>
			<xsl:apply-templates
				select="$species/taxonomyset/subfamily[order-id=current()/order-id and
														family-id=current()/family-id and
														subfamily-id=current()/subfamily-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/genus[order-id=current()/order-id and
														family-id=current()/family-id and
														subfamily-id=current()/subfamily-id and
														genus-id=current()/genus-id]"/>

	
			&lt;/generate-species-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
