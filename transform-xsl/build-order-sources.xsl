<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-transform.xsl"/>

	<xsl:variable name="order-sources-path">sources/orders/</xsl:variable>

	<xsl:template match="taxonomyset">
		<project name="build-order-sources" default="build-all">
			<target name="build-all">
				<delete>
					<xsl:attribute name="dir"><xsl:value-of select="$order-sources-path"/></xsl:attribute>
				</delete>
				<mkdir>
					<xsl:attribute name="dir"><xsl:value-of select="$order-sources-path"/></xsl:attribute>
				</mkdir>
				<xsl:apply-templates select="order"/>
			</target>
		</project>
	</xsl:template>

	<xsl:template match="sighting">
		&lt;sighting&gt;
			&lt;date&gt;<xsl:value-of select="date"/>&lt;/date&gt;
			&lt;location&gt;<xsl:value-of select="location"/>&lt;/location&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			<xsl:if test="first">&lt;first&gt;true&lt;/first&gt;</xsl:if>
			<xsl:if test="exclude">&lt;exclude&gt;true&lt;/exclude&gt;</xsl:if>
		&lt;/sighting&gt;
	</xsl:template>

	<xsl:template match="genus">
		&lt;genus&gt;
			&lt;family-id&gt;<xsl:value-of select="family-id"/>&lt;/family-id&gt;
			&lt;subfamily-id&gt;<xsl:value-of select="subfamily-id"/>&lt;/subfamily-id&gt;
			&lt;genus-id&gt;<xsl:value-of select="genus-id"/>&lt;/genus-id&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/genus&gt;
	</xsl:template>

	<xsl:template match="subfamily">
		&lt;subfamily&gt;
			&lt;family-id&gt;<xsl:value-of select="family-id"/>&lt;/family-id&gt;
			&lt;subfamily-id&gt;<xsl:value-of select="subfamily-id"/>&lt;/subfamily-id&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/subfamily&gt;
	</xsl:template>

	<xsl:template match="family">
		&lt;family&gt;
			&lt;family-id&gt;<xsl:value-of select="family-id"/>&lt;/family-id&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
		&lt;/family&gt;
	</xsl:template>

	<xsl:template match="species">
		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[abbreviation=current()/abbreviation]"/>

		&lt;species&gt;
			&lt;species-id&gt;<xsl:value-of select="species-id"/>&lt;/species-id&gt;
			&lt;abbreviation&gt;<xsl:value-of select="abbreviation"/>&lt;/abbreviation&gt;
			&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
			&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
			&lt;taxonomy-id&gt;<xsl:value-of select="taxonomy-id"/>&lt;/taxonomy-id&gt;
			<xsl:apply-templates select="notes[p[string-length(text())>0]]"/>
			&lt;filename-stem&gt;<xsl:value-of select="filename-stem"/>&lt;/filename-stem&gt;

			<xsl:apply-templates select="$species-sightings"/>
		&lt;/species&gt;
	</xsl:template>

	<xsl:template match="order">
		<xsl:message>Building Source XML for Order '<xsl:value-of select="latin-name"/>'</xsl:message>

		<echo>
			<xsl:attribute name="file"><xsl:value-of select="$order-sources-path"/><xsl:value-of select="filename-stem"/>.xml</xsl:attribute>
			&lt;generate-order-report order-id="<xsl:value-of select="order-id"/>"&gt;

			&lt;order&gt;
				&lt;order-id&gt;<xsl:value-of select="order-id"/>&lt;/order-id&gt;
				&lt;latin-name&gt;<xsl:value-of select="latin-name"/>&lt;/latin-name&gt;
				&lt;common-name&gt;<xsl:value-of select="common-name"/>&lt;/common-name&gt;
			&lt;/order&gt;

			<xsl:apply-templates
				select="$species/taxonomyset/family[order-id=current()/order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/subfamily[order-id=current()/order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/genus[order-id=current()/order-id]"/>

			<xsl:apply-templates
				select="$species/taxonomyset/species[order-id=current()/order-id]"/>

			&lt;/generate-order-report&gt;
		</echo>
	</xsl:template>

</xsl:stylesheet>
