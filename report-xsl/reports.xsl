<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="*">
		<HTML>
		<xsl:comment> $Id: reports.xsl,v 1.4 2001/11/06 17:18:24 walker Exp $ </xsl:comment>
		<xsl:apply-templates select="*"/>
		</HTML>
	</xsl:template>

	<!-- *** LOCATION REPORT *** -->

	<xsl:template match="generate-location-report">
		<xsl:message>
			Generating Location Report for '<xsl:value-of select="@location-name"/>'
			sightings <xsl:value-of select="count(species/sighting)"/>
			trips <xsl:value-of select="count(trip)"/>
			species <xsl:value-of select="count(species)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Location Report for <xsl:value-of select="@location-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="location-infoblock">
				<TR>
					<TD COLSPAN="9" CLASS="location-headertext">
						<IMG SRC="images/location.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="location/name"/>
					</TD>
				</TR>
				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="location/city"/>,<BR/>
						<xsl:value-of select="location/state"/>
					</TD>
					<xsl:if test="string-length(location/county) > 0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<xsl:value-of select="location/county"/> county
						</TD>
					</xsl:if>
					<xsl:if test="string-length(location/url)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="location/url"/>
								</xsl:attribute>
								<xsl:value-of select="location/url"/>
							</A>
						</TD>
					</xsl:if>
					<xsl:if test="string-length(location/latitude)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							lat <xsl:value-of select="location/latitude"/><BR/>
							long <xsl:value-of select="location/longitude"/>
							(<xsl:value-of select="location/system"/>)
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						first visited <xsl:value-of select="species/sighting[position()=1]/date"/><BR/>
						last visited <xsl:value-of select="species/sighting[position()=last()]/date"/><BR/>
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<xsl:apply-templates select="location/notes[p[string-length(text())>0]]"/>

			<DIV CLASS="location-headertext">
				<xsl:value-of select="count(species)"/> species observed at <xsl:value-of select="location/name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species"/>
				<xsl:with-param name="in-entry-kind" select="'species'"/>
			</xsl:call-template>

			<DIV CLASS="location-headertext">
				<xsl:value-of select="count(trip)"/> trips taken to <xsl:value-of select="location/name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
				<xsl:with-param name="in-entry-kind" select="'trips'"/>
			</xsl:call-template>

			<xsl:if test="count(trip) > 15">
				<DIV CLASS="location-headertext">
					Distribution of <xsl:value-of select="location/name"/> trips over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="trip"/>
				</xsl:call-template>
	
				<!-- monthly distribution by order -->
				<DIV CLASS="location-headertext">
					Distribution of <xsl:value-of select="location/name"/> sightings over time
				</DIV>

				<xsl:call-template name="order-by-month-table">
					<xsl:with-param name="in-species-with-sightings" select="species"/>
					<xsl:with-param name="in-trips" select="trip"/>
				</xsl:call-template>
			</xsl:if>
	
			<P></P>

			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>

	</xsl:template>

	<xsl:template match="generate-species-report">
		<!-- define my report parameters -->
		<xsl:variable
			name="in-abbreviation"
			select="@abbreviation"/>

		<xsl:message>
			Generating Species Report for '<xsl:value-of select="species/common-name"/>'
			species-sightings <xsl:value-of select="count(trip/sighting)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for <xsl:value-of select="species/common-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-infoblock" CELLPADDING="5" BORDER="0">

			<TR>
				<TD COLSPAN="10" CLASS="species-headertext">
					<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
					<xsl:value-of select="species/common-name"/>
					<xsl:text> </xsl:text><I>(<xsl:value-of select="species/latin-name"/>)</I>
				</TD>
			</TR>

			<TR>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<A>
						<xsl:attribute name="HREF">
							<xsl:value-of select="order/report-url"/>
						</xsl:attribute>
						<I><xsl:value-of select="order/latin-name"/></I><BR/>
						<xsl:value-of select="order/common-name"/>
					</A>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<I><xsl:value-of select="family/latin-name"/></I><BR/>
					<xsl:value-of select="family/common-name"/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<xsl:if test="count(subfamily)>0">
					<TD CLASS="info-block" NOWRAP="TRUE">
						<I><xsl:value-of select="subfamily/latin-name"/></I><BR/>
						<xsl:value-of select="subfamily/common-name"/>
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				</xsl:if>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<I><xsl:value-of select="genus/latin-name"/></I><BR/>
					<xsl:value-of select="genus/common-name"/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<!-- note, the following expressions assume sightings are in chronological order -->
					first seen <xsl:value-of select="trip[position()=1]/sighting/date"/><BR/>
					last seen <xsl:value-of select="trip[position()=last()]/sighting/date"/><BR/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
				</TD>
			</TR>
			</TABLE>

			<xsl:apply-templates select="species/notes[p[string-length(text())>0]]"/>

			<DIV CLASS="species-headertext">
				<xsl:value-of select="species/common-name"/> observed at <xsl:value-of select="count(location)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="location"/>
				<xsl:with-param name="in-entry-kind" select="'locations'"/>
			</xsl:call-template>

			<DIV CLASS="species-headertext">
				<xsl:value-of select="species/common-name"/> observed on <xsl:value-of select="count(trip)"/> trips
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
				<xsl:with-param name="in-entry-kind" select="'trips'"/>
			</xsl:call-template>

			<xsl:if test="count(trip/sighting) > 15">
				<DIV CLASS="species-headertext">
					Distribution of <xsl:value-of select="species/common-name"/> sightings over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="trip/sighting"/>
				</xsl:call-template>
			</xsl:if>

			<P></P>
			
			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-report">
		<xsl:variable
			name="trip-sightings"
			select="species/sighting"/>

		<xsl:variable
			name="trip-species"
			select="species"/>

		<xsl:message>
			Generating Trip Report for '<xsl:value-of select="trip/name"/>'
			species <xsl:value-of select="count($trip-species)"/>
			location <xsl:value-of select="count(location)"/>
			sightings <xsl:value-of select="count($trip-sightings)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Trip Report for <xsl:value-of select="trip/name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="trip-navigationblock" CELLPADDING="5" BORDER="0">
				<TR>
					<TD COLSPAN="6" CLASS="trip-headertext">
						<IMG SRC="images/trip.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="trip/date"/> "<xsl:value-of select="trip/name"/>"
					</TD>
				</TR>
				<TR>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="trip/date"/><BR/>
						<xsl:value-of select="trip/leader"/>
					</TD>
					<xsl:if test="string-length(trip/url)>0">
						<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
						<TD CLASS="info-block" NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="trip/url"/>
								</xsl:attribute>
								<xsl:value-of select="trip/url"/>
							</A>
						</TD>
					</xsl:if>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count(species)"/> species<BR/>
						<xsl:value-of select="count(location)"/> locations
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>


			<xsl:apply-templates select="trip/notes[p[string-length(text())>0]]"/>

			<xsl:for-each select="location">
				<xsl:variable name="this-location-name" select="name"/>
				<xsl:variable name="this-location-sightings" select="$trip-sightings[location=$this-location-name]"/>
				<xsl:variable name="this-location-species" select="$trip-species[sighting/location=$this-location-name]"/>

				<xsl:message>loop name <xsl:value-of select="$this-location-name"/> sightings <xsl:value-of select="count($this-location-sightings)"/> species <xsl:value-of select="count($this-location-species)"/></xsl:message>

				<DIV CLASS="trip-headertext">
					<xsl:value-of select="count($this-location-species)"/> species seen at
					<A>
						<xsl:attribute name="HREF"><xsl:value-of select="report-url"/></xsl:attribute>
						<xsl:value-of select="$this-location-name"/>
					</A>
				</DIV>

				<xsl:call-template name="two-column-table">
					<xsl:with-param name="in-extra-title"><xsl:value-of select="$this-location-name"/></xsl:with-param>
					<xsl:with-param name="in-extra-url"><xsl:value-of select="report-url"/></xsl:with-param>
					<xsl:with-param name="in-entry-list" select="$this-location-species"/>
					<xsl:with-param name="in-entry-kind" select="'species'"/>
				</xsl:call-template>
			</xsl:for-each>

			<P></P>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-order-report">
		<!-- define my report parameters -->
		<xsl:variable name="in-order-id" select="@in-order-id"/>
	
		<xsl:message>
			Generating Order Report for '<xsl:value-of select="order/latin-name"/>'
		</xsl:message>

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Species Report for Order <xsl:value-of select="order/latin-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-navigationblock" CELLPADDING="5" BORDER="0">
				<TR>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count(family)"/> families<BR/>
						<xsl:value-of select="count(subfamily)"/> subfamilies
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count(genus)"/> genera<BR/>
						<xsl:value-of select="count(species)"/> species
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/species.gif"/><BR/>
				Species Report for Order <xsl:value-of select="order/latin-name"/>
				"<xsl:value-of select="order/common-name"/>"
			</H1>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species[sighting]"/>
				<xsl:with-param name="in-entry-kind" select="'species'"/>
			</xsl:call-template>

			<xsl:if test="count(species/sighting) > 15">
				<DIV CLASS="species-headertext">
					Distribution of <xsl:value-of select="order/latin-name"/> sightings over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="species/sighting"/>
				</xsl:call-template>
			</xsl:if>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>
