<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="*">
		<HTML>
		<xsl:comment> $Id: reports.xsl,v 1.1 2001/10/05 01:29:45 walker Exp $ </xsl:comment>
		<xsl:apply-templates select="*"/>
		</HTML>
	</xsl:template>

	<xsl:template match="sighting">
		<xsl:variable name="this" select="."/>

		<xsl:call-template name="sighting-entry">
			<xsl:with-param name="sighting-record" select="$this"/>
	
			<xsl:with-param name="title-string">
				<xsl:value-of select="$species/taxonomyset/species[abbreviation=$this/abbreviation]/common-name"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="$this/location"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="$this/date"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="generate-location-report">
		<!-- define my report parameters -->
		<xsl:variable
			name="in-location"
			select="@location-name"/>

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

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Location Report for <xsl:value-of select="$in-location"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0">
				<xsl:attribute name="CLASS">location-navigationblock</xsl:attribute>
				<TR>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="$location-record/city"/>,<BR/>
						<xsl:value-of select="$location-record/state"/>
					</TD>
					<xsl:if test="string-length($location-record/county) > 0">
						<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
						<TD CLASS="info-block" NOWRAP="TRUE">
							<xsl:value-of select="$location-record/county"/> county
						</TD>
					</xsl:if>
					<xsl:if test="string-length($location-record/url)>0">
						<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
						<TD CLASS="info-block" NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$location-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$location-record/url"/>
							</A>
						</TD>
					</xsl:if>
					<xsl:if test="string-length($location-record/latitude)>0">
						<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
						<TD CLASS="info-block" NOWRAP="TRUE">
							lat <xsl:value-of select="$location-record/latitude"/><BR/>
							long <xsl:value-of select="$location-record/longitude"/>
							(<xsl:value-of select="$location-record/system"/>)
						</TD>
					</xsl:if>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">
						first visited <xsl:value-of select="$location-sightings[position()=1]/date"/><BR/>
						last visited <xsl:value-of select="$location-sightings[position()=last()]/date"/><BR/>
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/location.gif"/>
				Location Report for <xsl:value-of select="$location-record/name"/>
			</H1>

			<xsl:apply-templates select="$location-record/notes[p[string-length(text())>0]]">
				<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
			</xsl:apply-templates>

			<xsl:call-template name="species-table">
				<xsl:with-param name="in-species-list" select="$location-species"/>
				<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$location-trips"/>
				<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$location-sightings[string-length(notes/p)>0]"/>
				<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
			</xsl:call-template>
	
			<xsl:if test="count($location-trips) > 15">
				<xsl:call-template name="monthly-distribution">
					<xsl:with-param name="dated-items" select="$location-trips"/>
					<xsl:with-param name="item-kind">trips</xsl:with-param>
					<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
				</xsl:call-template>
	
				<xsl:call-template name="yearly-distribution">
					<xsl:with-param name="dated-items" select="$location-trips"/>
					<xsl:with-param name="item-kind">trips</xsl:with-param>
					<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
	
			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>

	</xsl:template>

	<xsl:template match="generate-species-report">
		<!-- define my report parameters -->
		<xsl:variable
			name="in-abbreviation"
			select="@abbreviation"/>

		<xsl:variable
			name="species-record"
			select="$species/taxonomyset/species[abbreviation=$in-abbreviation]"/>

		<xsl:variable
			name="order-record"
			select="$species/taxonomyset/order[order-id=$species-record/order-id]"/>

		<xsl:variable
			name="family-record"
			select="$species/taxonomyset/family[order-id=$species-record/order-id and
													family-id=$species-record/family-id]"/>

		<xsl:variable
			name="family-record"
			select="$species/taxonomyset/family[order-id=$species-record/order-id and
													family-id=$species-record/family-id]"/>

		<xsl:variable
			name="subfamily-record"
			select="$species/taxonomyset/subfamily[order-id=$species-record/order-id and
													family-id=$species-record/family-id and
													subfamily-id=$species-record/subfamily-id]"/>

		<xsl:variable
			name="genus-record"
			select="$species/taxonomyset/genus[order-id=$species-record/order-id and
													family-id=$species-record/family-id and
													subfamily-id=$species-record/subfamily-id and
													genus-id=$species-record/genus-id]"/>

		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[abbreviation=$in-abbreviation]"/>

		<xsl:variable
			name="species-locations"
			select="$locations/locationset/location[name=$species-sightings/location]"/>

		<xsl:variable
			name="species-trips"
			select="$trips/tripset/trip[date=$species-sightings/date]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for <xsl:value-of select="$species-record/common-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0">
				<xsl:attribute name="CLASS">species-navigationblock</xsl:attribute>
			<TR>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<A>
						<xsl:attribute name="HREF">
							<xsl:value-of select="$order-record/report-url"/>
						</xsl:attribute>
						<I><xsl:value-of select="$order-record/latin-name"/></I><BR/>
						<xsl:value-of select="$order-record/common-name"/>
					</A>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<I><xsl:value-of select="$family-record/latin-name"/></I><BR/>
					<xsl:value-of select="$family-record/common-name"/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<xsl:if test="count($subfamily-record)>0">
					<TD CLASS="info-block" NOWRAP="TRUE">
						<I><xsl:value-of select="$subfamily-record/latin-name"/></I><BR/>
						<xsl:value-of select="$subfamily-record/common-name"/>
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				</xsl:if>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<I><xsl:value-of select="$genus-record/latin-name"/></I><BR/>
					<xsl:value-of select="$genus-record/common-name"/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
				<TD CLASS="info-block" NOWRAP="TRUE">
					<!-- note, the following expressions assume sightings are in chronological order -->
					first seen <xsl:value-of select="$species-sightings[position()=1]/date"/><BR/>
					last seen <xsl:value-of select="$species-sightings[position()=last()]/date"/><BR/>
				</TD>
				<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
				</TD>
			</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/species.gif"/>
				Species Report for <xsl:value-of select="$species-record/common-name"/>
				<xsl:text> </xsl:text><I>(<xsl:value-of select="$species-record/latin-name"/>)</I>
			</H1>

			<xsl:apply-templates select="$species-record/notes[p[string-length(text())>0]]">
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:apply-templates>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$species-locations"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$species-trips"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$species-sightings[string-length(notes/p)>0]"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="count($species-sightings) > 15">
				<xsl:call-template name="monthly-distribution">
					<xsl:with-param name="dated-items" select="$species-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
					<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
				</xsl:call-template>
	
				<xsl:call-template name="yearly-distribution">
					<xsl:with-param name="dated-items" select="$species-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
					<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-report">
		<xsl:variable
			name="in-trip-date"
			select="@trip-date"/>

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

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Trip Report for <xsl:value-of select="$trip-record/name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0">
				<xsl:attribute name="CLASS">trip-navigationblock</xsl:attribute>
				<TR>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="$trip-record/date"/><BR/>
						<xsl:value-of select="$trip-record/leader"/>
					</TD>
					<xsl:if test="string-length($trip-record/url)>0">
						<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
						<TD CLASS="info-block" NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="$trip-record/url"/>
								</xsl:attribute>
								<xsl:value-of select="$trip-record/url"/>
							</A>
						</TD>
					</xsl:if>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count($trip-species)"/> species<BR/>
						<xsl:value-of select="count($trip-locations)"/> locations
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/trip.gif"/>
				Trip Report for <xsl:value-of select="$trip-record/date"/>
				"<xsl:value-of select="$trip-record/name"/>"
			</H1>

			<xsl:apply-templates select="$trip-record/notes[p[string-length(text())>0]]">
				<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
			</xsl:apply-templates>

			<xsl:for-each select="$trip-locations">
				<xsl:variable name="this-location-name" select="name"/>
				<xsl:variable name="this-location-sightings" select="$trip-sightings[location=$this-location-name]"/>
				<xsl:variable name="this-location-species" select="$trip-species[abbreviation=$this-location-sightings/abbreviation]"/>

				<xsl:call-template name="species-table">
					<xsl:with-param name="in-extra-title"><xsl:value-of select="$this-location-name"/></xsl:with-param>
					<xsl:with-param name="in-extra-url"><xsl:value-of select="report-url"/></xsl:with-param>
					<xsl:with-param name="in-species-list" select="$this-location-species"/>
					<xsl:with-param name="in-sighting-list" select="$this-location-sightings"/>
					<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$trip-sightings[string-length(notes/p)>0]"/>
				<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-order-report">
		<!-- define my report parameters -->
		<xsl:variable name="in-order-id" select="@in-order-id"/>
	
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

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Species Report for Order <xsl:value-of select="$order-record/latin-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0">
				<xsl:attribute name="CLASS">species-navigationblock</xsl:attribute>

				<TR>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count($order-all-families)"/> families<BR/>
						<xsl:value-of select="count($order-all-subfamilies)"/> subfamilies
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">|<BR/>|</TD>
					<TD CLASS="info-block" NOWRAP="TRUE">
						<xsl:value-of select="count($order-all-genera)"/> genera<BR/>
						<xsl:value-of select="count($order-all-species)"/> species
					</TD>
					<TD CLASS="info-block" NOWRAP="TRUE" WIDTH="90%">
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
				<xsl:with-param name="in-species-list" select="$order-life-species"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$order-sightings[string-length(notes/p)>0]"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="order-table">
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="count($order-sightings) > 15">
				<xsl:call-template name="monthly-distribution">
					<xsl:with-param name="dated-items" select="$order-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
					<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
				</xsl:call-template>
	
				<xsl:call-template name="yearly-distribution">
					<xsl:with-param name="dated-items" select="$order-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
					<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>
