<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:param name="in-trip-date"/>

	<xsl:variable
		name="trip-record"
		select="$trips/tripset/trip[date=$in-trip-date]"/>

	<xsl:variable
		name="trip-sightings"
		select="$sightings/sightingset/sighting[date=$in-trip-date]"/>

	<xsl:variable
		name="trip-species"
		select="$species/taxonomyset/species[abbreviation=$trip-sightings/abbreviation]"/>

	<xsl:variable
		name="trip-locations"
		select="$locations/locationset/location[name=$trip-sightings/location]"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Trip Report for <xsl:value-of select="$trip-record/name"/></TITLE>
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<DIV CLASS="tablehead">
				<TABLE>
					<TR>
						<TD>
							<xsl:value-of select="$trip-record/date"/>
						</TD>
						<TD>&gt;</TD>
						<TD>
							<xsl:value-of select="$trip-record/leader"/>
						</TD>
						<TD>&gt;</TD>
						<TD>
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$trip-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$trip-record/url"/>
							</A>
						</TD>
					</TR>
				</TABLE>
			</DIV>

			<H1><IMG SRC="images/trip.gif"/><xsl:value-of select="$trip-record/name"/></H1>

			<xsl:apply-templates select="$trip-record/notes[p[string-length(text())>0]]"/>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$trip-species"/>
			</xsl:call-template>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$trip-locations"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$trip-sightings"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
