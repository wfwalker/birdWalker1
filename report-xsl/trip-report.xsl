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
		<xsl:comment> $Id$ </xsl:comment>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0" BGCOLOR="#EEEEEE">
				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="$trip-record/date"/><BR/>
						<xsl:value-of select="$trip-record/leader"/>
					</TD>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<xsl:if test="string-length($trip-record/url)>0">
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$trip-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$trip-record/url"/>
							</A>
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/trip.gif"/>
				Trip Report for <xsl:value-of select="$trip-record/date"/>
				"<xsl:value-of select="$trip-record/name"/>"
			</H1>

			<xsl:apply-templates select="$trip-record/notes[p[string-length(text())>0]]"/>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$trip-species"/>
			</xsl:call-template>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$trip-locations"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$trip-sightings[string-length(notes/p)>0]"/>
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
