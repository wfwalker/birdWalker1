<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:param name="in-order-id"/>

	<xsl:variable
		name="order-record"
		select="$species/taxonomyset/order[order-id=$in-order-id]"/>

	<xsl:variable
		name="order-all-families"
		select="$species/taxonomyset/family[order-id=$in-order-id]"/>

	<xsl:variable
		name="order-all-subfamilies"
		select="$species/taxonomyset/subfamily[order-id=$in-order-id]"/>

	<xsl:variable
		name="order-all-genera"
		select="$species/taxonomyset/genus[order-id=$in-order-id]"/>

	<xsl:variable
		name="order-all-species"
		select="$species/taxonomyset/species[order-id=$in-order-id]"/>

	<xsl:variable
		name="order-sightings"
		select="$sightings/sightingset/sighting[abbreviation=$order-all-species/abbreviation]"/>

	<xsl:variable
		name="order-life-species"
		select="$order-all-species[abbreviation=$order-sightings/abbreviation]"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for Order <xsl:value-of select="$order-record/latin-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0" BGCOLOR="#EEEEEE">
				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count($order-all-families)"/> families<BR/>
						<xsl:value-of select="count($order-all-subfamilies)"/> subfamilies
					</TD>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count($order-all-genera)"/> genera<BR/>
						<xsl:value-of select="count($order-all-species)"/> species
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/species.gif"/>
				Species Report for Order <xsl:value-of select="$order-record/latin-name"/>
				"<xsl:value-of select="$order-record/common-name"/>"
			</H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$order-life-species"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$order-sightings[string-length(notes/p)>0]"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

	<xsl:template match="sighting">
		<xsl:variable name="this" select="."/>

		<xsl:call-template name="sighting-entry">
			<xsl:with-param name="sighting-record" select="$this"/>

			<xsl:with-param name="aux-record-1" select="$species/taxonomyset/species[abbreviation=$this/abbreviation]"/>
			<!-- <xsl:with-param name="aux-record-3" select="$trips/tripset/trip[date=$this/date]"/> -->
			<xsl:with-param name="aux-record-2" select="$locations/locationset/location[name=$this/location]"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
