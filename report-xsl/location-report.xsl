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
		<xsl:comment> $Id$ </xsl:comment>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="navigation-block"/>

			<TABLE WIDTH="100%" BGCOLOR="#EEEEEE" BORDER="0" CELLPADDING="5" CELLSPACING="0">
				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="$location-record/city"/>,<BR/>
						<xsl:value-of select="$location-record/state"/>
					</TD>
					<xsl:if test="string-length($location-record/county) > 0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<xsl:value-of select="$location-record/county"/> county
						</TD>
					</xsl:if>
					<xsl:if test="string-length($location-record/url)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$location-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$location-record/url"/>
							</A>
						</TD>
					</xsl:if>
					<xsl:if test="string-length($location-record/latitude)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							lat <xsl:value-of select="$location-record/latitude"/><BR/>
							long <xsl:value-of select="$location-record/longitude"/>
							(<xsl:value-of select="$location-record/system"/>)
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/location.gif"/>
				Location Report for <xsl:value-of select="$location-record/name"/>
			</H1>

			<xsl:apply-templates select="$location-record/notes[p[string-length(text())>0]]"/>

			<xsl:call-template name="species-table">
				<xsl:with-param name="species-list" select="$location-species"/>
			</xsl:call-template>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$location-trips"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$location-sightings[string-length(notes/p)>0]"/>
			</xsl:call-template>
	
			<xsl:if test="count($location-trips) > 15">
				<xsl:call-template name="monthly-distribution">
					<xsl:with-param name="dated-items" select="$location-trips"/>
					<xsl:with-param name="item-kind">trips</xsl:with-param>
				</xsl:call-template>
	
				<xsl:call-template name="yearly-distribution">
					<xsl:with-param name="dated-items" select="$location-trips"/>
					<xsl:with-param name="item-kind">trips</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
	
			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

	<xsl:template match="sighting">
		<xsl:variable name="this" select="."/>

		<xsl:call-template name="sighting-entry">
			<xsl:with-param name="sighting-record" select="$this"/>

			<xsl:with-param name="aux-record-1" select="$species/taxonomyset/species[abbreviation=$this/abbreviation]"/>
			<xsl:with-param name="aux-record-2" select="$trips/tripset/trip[date=$this/date]"/>
			<!-- <xsl:with-param name="aux-record-3" select="$locations/locationset/location[name=$this/location]"/> -->
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
