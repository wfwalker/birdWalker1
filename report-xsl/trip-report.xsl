<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:variable name="my-header-style">trip-navigationblock</xsl:variable>

	<!-- define my report parameters -->
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
		<xsl:comment> $Id: trip-report.xsl,v 1.6 2001/09/18 01:53:22 walker Exp $ </xsl:comment>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0">
				<xsl:attribute name="CLASS"><xsl:value-of select="$my-header-style"/></xsl:attribute>
				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="$trip-record/date"/><BR/>
						<xsl:value-of select="$trip-record/leader"/>
					</TD>
					<xsl:if test="string-length($trip-record/url)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$trip-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$trip-record/url"/>
							</A>
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count($trip-species)"/> species<BR/>
						<xsl:value-of select="count($trip-locations)"/> locations
					</TD>
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

			<xsl:for-each select="$trip-locations">
				<xsl:variable name="this-location-name" select="name"/>
				<xsl:variable name="this-location-sightings" select="$trip-sightings[location=$this-location-name]"/>
				<xsl:variable name="this-location-species" select="$trip-species[abbreviation=$this-location-sightings/abbreviation]"/>

				<xsl:call-template name="species-table">
					<xsl:with-param name="extra-title"><xsl:value-of select="$this-location-name"/></xsl:with-param>
					<xsl:with-param name="extra-url"><xsl:value-of select="report-url"/></xsl:with-param>
					<xsl:with-param name="species-list" select="$this-location-species"/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$trip-sightings[string-length(notes/p)>0]"/>
			</xsl:call-template>

			<xsl:call-template name="trip-navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

	<!-- copy the species template from common-report and add a pointer to the footnote -->
	<!-- this is a work in progress -->

	<!-- 
	<xsl:template match="species">
		<xsl:param name="create-link"/>

		<xsl:variable name="this" select="."/>

		<xsl:choose>
			<xsl:when test="count($trip-sightings[(string-length(notes/p)>0) and (abbreviation=$this/abbreviation)])>0">
				<IMG SRC="images/blue.gif" WIDTH="10" HEIGHT="10" BORDER="0"/>
			</xsl:when>
			<xsl:otherwise>
				<IMG SRC="images/spacer.gif" WIDTH="10" HEIGHT="10" BORDER="0"/>
			</xsl:otherwise>
		</xsl:choose>

		<IMG SRC="images/spacer.gif" WIDTH="5" HEIGHT="10" BORDER="0"/>

		<A>
			<xsl:if test="string-length($create-link) > 0">
				<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="common-name"/>
		</A>
		<BR/>
	</xsl:template>
	-->

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
