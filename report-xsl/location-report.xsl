<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:param name="in-location"/>

	<xsl:variable
		name="location-record"
		select="$locations/locationset/location[name=$in-location]"/>

	<xsl:variable
		name="location-sightings"
		select="$sightings/sightingset/sighting[location=$in-location]"/>

	<xsl:variable
		name="location-trips"
		select="$trips/tripset/trip[date=$location-sightings/date]"/>

	<xsl:variable
		name="location-species"
		select="$species/taxonomyset/species[abbreviation=$location-sightings/abbreviation]"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Location Report for <xsl:value-of select="$in-location"/></TITLE>
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<DIV CLASS="tablehead">
			<TABLE>
				<TR>
					<TD>
						<xsl:value-of select="$location-record/state"/>
					</TD>
					<TD>&gt;</TD>
					<xsl:if test="string-length($location-record/count) > 0">
						<TD>
							<xsl:value-of select="$location-record/county"/> county
						</TD>
						<TD>&gt;</TD>
					</xsl:if>
					<TD>
						<xsl:value-of select="$location-record/city"/>
					</TD>
					<TD>&gt;</TD>
					<TD>
						<CODE>
							lat <xsl:value-of select="$location-record/latitude"/>
							long <xsl:value-of select="$location-record/longitude"/><xsl:text> </xsl:text>
							(<xsl:value-of select="$location-record/system"/>)
						</CODE>
					</TD>
				</TR>
			</TABLE>
			</DIV>

			<H1><IMG SRC="images/location.gif"/><xsl:value-of select="$location-record/name"/></H1>

			<xsl:apply-templates select="$location-record/notes[p[string-length(text())>0]]"/>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$location-species"/>
			</xsl:call-template>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$location-trips"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$location-sightings"/>
			</xsl:call-template>
	
			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
