<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="order-sources-path">sources/orders/</xsl:variable>

	<xsl:template match="taxonomyset">
		<project name="build-order-sources" default="build-all">
			<target name="build-all">
				<xsl:apply-templates select="order"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting date=&quot;<xsl:value-of select="@date"/>&quot; location-name=&quot;<xsl:value-of select="@location-name"/>&quot; <xsl:apply-templates select="first | exclude | photo"/>&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
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

	<xsl:template match="species">
		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[@abbreviation=current()/@abbreviation]"/>

		&lt;species
			species-id=&quot;<xsl:value-of select="@species-id"/>&quot;
			abbreviation=&quot;<xsl:value-of select="@abbreviation"/>&quot;
			latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot;
			common-name=&quot;<xsl:value-of select="@common-name"/>&quot;
			taxonomy-id=&quot;<xsl:value-of select="@taxonomy-id"/>&quot;
			filename-stem=&quot;<xsl:value-of select="@filename-stem"/>&quot;&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			<xsl:apply-templates select="$species-sightings"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="order">
		<xsl:message>Building Source XML for Order '<xsl:value-of select="@latin-name"/>'</xsl:message>

		<echo>
			<xsl:attribute name="file"><xsl:value-of select="$order-sources-path"/><xsl:value-of select="@filename-stem"/>.xml</xsl:attribute>
			&lt;!DOCTYPE generate-order-report SYSTEM "file:dtds/generate-report.dtd"&gt;
			&lt;generate-order-report order-id="<xsl:value-of select="@order-id"/>"&gt;

			&lt;order
				order-id=&quot;<xsl:value-of select="@order-id"/>&quot;
				latin-name=&quot;<xsl:value-of select="@latin-name"/>&quot;
				common-name=&quot;<xsl:value-of select="@common-name"/>&quot;/&gt;

			<xsl:apply-templates
				select="$species/taxonomyset/family[@order-id=current()/@order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/subfamily[@order-id=current()/@order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/genus[@order-id=current()/@order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/species[@order-id=current()/@order-id]"/>

			&lt;/generate-order-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
