<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<xsl:param name="in-tstamp"/>

	<!-- a template for inserting cascading style sheets -->

	<xsl:template name="style-block">
		<LINK REL="stylesheet" TYPE="text/css" HREF="../stylesheet.css" TITLE="Style"/>
	</xsl:template>

	<!-- define four different navigation blocks, one for each kind of page -->

	<xsl:template name="home-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class" select="'home-color'"/>
			<xsl:with-param name="species-class" select="'default-color'"/>
			<xsl:with-param name="location-class" select="'default-color'"/>
			<xsl:with-param name="trip-class" select="'default-color'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="species-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class" select="'default-color'"/>
			<xsl:with-param name="species-class" select="'species-color'"/>
			<xsl:with-param name="location-class" select="'default-color'"/>
			<xsl:with-param name="trip-class" select="'default-color'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="location-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class" select="'default-color'"/>
			<xsl:with-param name="species-class" select="'default-color'"/>
			<xsl:with-param name="location-class" select="'location-color'"/>
			<xsl:with-param name="trip-class" select="'default-color'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="trip-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class" select="'default-color'"/>
			<xsl:with-param name="species-class" select="'default-color'"/>
			<xsl:with-param name="location-class" select="'default-color'"/>
			<xsl:with-param name="trip-class" select="'trip-color'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- define the underlying template for all four kinds of navigation block -->

	<xsl:template name="navigation-block">
		<xsl:param name="home-class"/>
		<xsl:param name="species-class"/>
		<xsl:param name="location-class"/>
		<xsl:param name="trip-class"/>

		<TABLE WIDTH="100%" HEIGHT="40" BORDER="0" CELLSPACING="0">
			<TR>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$home-class"/></xsl:attribute>
					<SPAN CLASS="navigation-text"><A HREF="../indices/index.html"><CODE>&lt;birdWalker&gt;</CODE></A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$species-class"/></xsl:attribute>
					<xsl:if test="starts-with($species-class, 'default')"><IMG SRC="../images/species.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="../species/index.html">Species Reports</A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$location-class"/></xsl:attribute>
					<xsl:if test="starts-with($location-class, 'default')"><IMG SRC="../images/location.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="../locations/index.html">Location Reports</A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$trip-class"/></xsl:attribute>
					<xsl:if test="starts-with($trip-class, 'default')"><IMG SRC="../images/trip.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="../trips/index.html">Trip Reports</A></SPAN>
				</TD>
			</TR>
		</TABLE>
		<xsl:comment> $Id: birdwalker.xsl,v 1.9 2003/03/20 01:33:29 walker Exp $ </xsl:comment>
		<xsl:comment> HTML Generated on <xsl:value-of select="$in-tstamp"/></xsl:comment>
	</xsl:template>

	<!-- a footer to contain timestamps and links to me -->
	<xsl:template name="page-footer">
		<P>
			Generated on <xsl:value-of select="$in-tstamp"/> by
			<A HREF="http://www.shout.net/~walker/">Bill Walker</A>,
			<A HREF="mailto:walker@shout.net">walker@shout.net</A>
		</P>
	</xsl:template>

	<!-- templates to create table sections used in many kinds of reports -->

	<xsl:template name="two-column-table">
		<xsl:param name="in-entry-list"/>

		<DIV CLASS="report-content">
			<TABLE WIDTH="90%">
				<TR>
					<TD VALIGN="TOP" WIDTH="50%">
						<xsl:apply-templates select="$in-entry-list[position() &lt; 1 + (count($in-entry-list) div 2)]">
						</xsl:apply-templates>
					</TD>
					<TD VALIGN="TOP" WIDTH="50%">
						<xsl:apply-templates select="$in-entry-list[position() &gt;= 1 + (count($in-entry-list) div 2)]">
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</DIV>
	</xsl:template>

	<!-- displays a set of notes (typically species notes, location notes, or trip notes) -->
	<!-- notes shown either as report content, or as sighting notes -->

	<xsl:template mode="report-content" match="notes">
		<DIV CLASS="report-content"><xsl:apply-templates select="p"/></DIV>
	</xsl:template>

	<xsl:template mode="sighting-notes" match="notes">
		<DIV CLASS="sighting-notes"><xsl:apply-templates select="p"/></DIV>
	</xsl:template>

	<!-- displays a paragraph of text -->

	<xsl:template match="p">
		<P><xsl:value-of select="."/></P>
	</xsl:template>

	<!-- displays a first sighting note, with or without date -->

	<xsl:template mode="with-date" match="sighting/@first">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text><xsl:value-of select="../@date"/>, first sighting</SPAN>
	</xsl:template>

	<xsl:template match="sighting/@first">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text>first sighting</SPAN>
	</xsl:template>

	<!-- how to display a link to a photo -->

	<xsl:template match="species/sighting/@photo">
	    <xsl:message>number one z<xsl:value-of select="../@date"/>z</xsl:message>
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text>
	    <A><xsl:attribute name="HREF">../images/<xsl:value-of select="../@date"/>-<xsl:value-of select="../../@abbreviation"/>.jpg</xsl:attribute>photo</A>
		</SPAN>
	</xsl:template>

	<xsl:template match="generate-species-report/trip/sighting/@photo">
	    <xsl:message>number two</xsl:message>
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text>
	    <A><xsl:attribute name="HREF">../images/<xsl:value-of select="../@date"/>-<xsl:value-of select="../../../species/@abbreviation"/>.jpg</xsl:attribute>photo</A>
		</SPAN>
	</xsl:template>

    <!-- THIS TEMPLATE IS BEING IGNORED BECAUSE OF the general species template below already looking for photo -->
	<xsl:template match="generate-location-report/species/sighting/@photo">
	    <xsl:message>number three</xsl:message>
		<DIV CLASS="sighting-notes">
	    <A><xsl:attribute name="HREF">../images/<xsl:value-of select="../@date"/>-<xsl:value-of select="../../@abbreviation"/>.jpg</xsl:attribute>
			<xsl:value-of select="../@date"/> photo
		</A>
		</DIV>
	</xsl:template>

	<!-- how to display the fact that a sighting has been excluded from life list counting -->

	<xsl:template mode="with-date" match="sighting/@exclude">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text><xsl:value-of select="../@date"/>, excluded</SPAN>
	</xsl:template>

	<xsl:template match="sighting/@exclude">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text>excluded</SPAN>
	</xsl:template>

	<!-- template to display dates -->

	<xsl:template match="@date">
		<xsl:variable name="month-index" select="substring(current(), 6, 2)"/>
		<xsl:variable name="day-index" select="substring(current(), 9, 2)"/>
		<xsl:variable name="year-index" select="substring(current(), 1, 4)"/>

		<xsl:value-of select="document('misc.xml')/miscellaneous/monthset/month[@index=$month-index]/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$day-index"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$year-index"/>
	</xsl:template>
		
	<!-- How to display sightings -->

	<xsl:template match="/generate-species-report/trip/sighting">
		<DIV CLASS="sighting-notes">
			<xsl:value-of select="notes/p"/>
		</DIV>
	</xsl:template>

	<xsl:template match="/generate-trip-report/species/sighting">
		<DIV CLASS="sighting-notes">
			<xsl:value-of select="notes/p"/>
		</DIV>
	</xsl:template>

	<xsl:template match="/generate-location-report/species/sighting">
		<DIV CLASS="sighting-notes">
			<xsl:value-of select="@date"/>, <xsl:value-of select="notes/p"/>
		</DIV>
	</xsl:template>

	<!-- how to display species names -->

	<xsl:template match="species">
		<A>
		    <!-- TODO, xsl:if is slow -->
			<xsl:if test="sighting/notes or sighting/@first">
				<xsl:attribute name="CLASS">noteworthy-species</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="HREF">../species/<xsl:value-of select="@abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="@common-name"/>
		</A>

		<!-- looks like the following trick won't work, because the variable substitution is not happening? -->
 		<xsl:apply-templates select="sighting/@first"/>
 		<xsl:apply-templates select="sighting/@exclude"/>

		<!-- TODO, unwanted line break before this -->
		<xsl:apply-templates select="sighting/@photo"/>
 		<xsl:apply-templates select="sighting[notes]"/>
            
		<BR/>
	</xsl:template>

	<xsl:template match="generate-order-report/species">
		<A>
			<xsl:attribute name="HREF">../species/<xsl:value-of select="@filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="@common-name"/>

		</A>
		<table width="90%">
		  <tr>
		    <td><xsl:apply-templates select="trip/@date"/></td>
		    <td align="right"><xsl:value-of
		    select="trip/@name"/></td>
		  </tr>
		  <tr>
		    <td><xsl:value-of  select="location/@name"/></td>
		    <td align="right">
		      <xsl:value-of select="location/@city"/>,
		      <xsl:value-of select="location/@state"/>
		    </td>
		  </tr>
		  <tr>
		    <td colspan="2"><xsl:value-of select="trip/@leader"/></td>
		  </tr>
		  <tr>
		    <td colspan="2"><xsl:apply-templates select="sighting/notes"/></td>
		  </tr>
		</table>
		<BR/>
	</xsl:template>

	<!-- how to display trip names -->
	<xsl:template match="trip">
		<A>
			<xsl:attribute name="HREF">../trips/<xsl:value-of select="@filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="@name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="@date"/></SPAN>
		</A>

		<xsl:apply-templates select="sighting/@photo"/>
		<BR/>
		<xsl:apply-templates select="sighting[notes]"/>
	</xsl:template>

	<xsl:template match="location">
		<A>
			<xsl:attribute name="HREF">../locations/<xsl:value-of select="@filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="@name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="@city"/>, <xsl:value-of select="@state"/></SPAN>
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="order">
		<B><A>
			<xsl:attribute name="HREF">../orders/<xsl:value-of select="@filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="@common-name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="@latin-name"/></SPAN>
		</A></B>
		<BR/>
	</xsl:template>

	<!-- draw a blue vertical bar using an image tag with height and width attributes -->

	<xsl:template name="vertical-bar">
		<xsl:param name="in-height"/>
		<xsl:param name="in-maximum"/>
		<xsl:param name="in-bar-count"/>

		<TD ALIGN="CENTER" VALIGN="BOTTOM">
			<xsl:value-of select="$in-height"/><BR/>

			<IMG SRC="../images/blue.gif" WIDTH="20">
				<xsl:attribute name="HEIGHT"><xsl:value-of select="1 + ((20 * $in-bar-count * $in-height) div $in-maximum)"/></xsl:attribute>
			</IMG>
		</TD>
	</xsl:template>

	<!-- ************************** REPORT TEMPLATES BEGIN HERE ************************* -->

	<!-- *** YEAR REPORT *** -->

	<xsl:template match="generate-year-report/species/sighting[@first]">F</xsl:template>
	<xsl:template match="generate-year-report/species/sighting[@exclude]">e</xsl:template>
	<xsl:template match="generate-year-report/species/sighting[not(@exclude)]">X</xsl:template>
	<xsl:template match="generate-year-report/species/sighting[@photo]">
	    <A><xsl:attribute name="HREF">../images/<xsl:value-of select="@date"/>-<xsl:value-of select="../@abbreviation"/>.jpg</xsl:attribute>P</A>
	</xsl:template>

	<xsl:template match="generate-year-report/species">
		<!-- print the headings every 20 rows -->
		<xsl:variable name="the-sightings" select="sighting"/>

		<xsl:if test="(position() mod 20) = 1">
			<TR>
				<TD> </TD>
				<xsl:for-each select="document('misc.xml')/miscellaneous/monthset/month">
					<td class="year-report-month-row-color" align="center"><xsl:value-of select="substring(@name, 1, 3)"/></td>
				</xsl:for-each>
			</TR>
		</xsl:if>

		<!-- print the species name, followed by the X's for each trip -->
		<TR>
			<!-- alternating background colors -->
			<xsl:choose>
				<xsl:when test="(position() mod 2) = 0">
					<xsl:attribute name="class">year-row-color</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">year-plain</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<TD><A>
				<xsl:attribute name="HREF">../species/<xsl:value-of select="@abbreviation"/>.html</xsl:attribute>
				<xsl:value-of select="@common-name"/>
			</A></TD>

			<!-- iterate through all the trips, looking for sightings of this species -->
			<xsl:for-each select="document('misc.xml')/miscellaneous/monthset/month">
			    <xsl:variable name="the-month" select="current()"/>
			    <td align="center"><xsl:apply-templates select="$the-sightings[substring(@date, 6, 2)=$the-month/@index][position()=1]"/></td>
			</xsl:for-each>
		</TR>
	</xsl:template>

	<xsl:template match="generate-year-report">
		<!-- define my report parameter -->
		<xsl:variable name="year-name" select="@year-name"/>
		<xsl:variable name="year-species" select="species"/>

		<xsl:message>generate report for year <xsl:value-of select="$year-name"/></xsl:message>
		<xsl:message>species with non excluded sighting<xsl:value-of select="count(species[sighting[not(@exclude)]])"/></xsl:message>
		<xsl:message>species <xsl:value-of select="count(species)"/></xsl:message>
		<xsl:message>trips <xsl:value-of select="count(trip)"/></xsl:message>

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Index of Species seen in <xsl:value-of select="$year-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/species.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="$year-name"/> Species List
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our annual list for <xsl:value-of select="$year-name"/> contains <xsl:value-of select="count(species[sighting[not(@exclude)]])"/> species,
				including <xsl:value-of select="count(species/sighting/@first)"/> new species.
			</DIV>

			<P></P>

			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">

			<!-- paper checklist-style table, showing trips and species -->
			<xsl:apply-templates select="/generate-year-report/species"/>

			<tr>
			<td></td>
			<xsl:for-each select="document('misc.xml')/miscellaneous/monthset/month">
			    <xsl:variable name="the-month" select="current()"/>
			    <td align="center"><xsl:value-of select="count($year-species[sighting[substring(@date, 6, 2)=$the-month/@index]])"/></td>
			</xsl:for-each>
            </tr>

			</TABLE>

			<P>
			</P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
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

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="location-color">
				<TR>
				    <TD VALIGN="TOP" ROWSPAN="2">
						<IMG SRC="../images/location.gif" ALIGN="LEFT"/>
					</TD>
					<TD COLSPAN="9" CLASS="pagetitle">
						<xsl:value-of select="location/@name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle">
							<xsl:value-of select="location/@city"/><xsl:text>, </xsl:text><xsl:value-of select="location/@state"/>
						</SPAN>
					</TD>
				</TR>

				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="location/@county"/> County

						<xsl:if test="string-length(location/@url)>0">
							<BR/>
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="location/@url"/>
								</xsl:attribute>
								Location Website
							</A>
					</xsl:if>
					</TD>
					<xsl:if test="string-length(location/@latitude)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD ALIGN="RIGHT" NOWRAP="TRUE">
							<A>
							    <xsl:attribute name="HREF">http://terraserver.homeadvisor.msn.com/image.aspx?Lon=-<xsl:value-of select="location/@longitude"/>&amp;Lat=<xsl:value-of select="location/@latitude"/></xsl:attribute>
							    <xsl:text>N </xsl:text><xsl:value-of select="location/@latitude"/>&#176;<BR/>
							    <xsl:text>W </xsl:text><xsl:value-of select="location/@longitude"/>&#176;
							</A>
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						first visited <xsl:value-of select="species/sighting[position()=1]/@date"/><BR/>
						last visited <xsl:value-of select="species/sighting[position()=last()]/@date"/><BR/>
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<xsl:apply-templates mode="report-content" select="location/notes"/>

			<DIV CLASS="headertext">
				<xsl:value-of select="count(species)"/> species observed at <xsl:value-of select="location/@name"/>,
				including <xsl:value-of select="count(species/sighting/@first)"/> first sightings.
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="count(trip)"/> trips taken to <xsl:value-of select="location/@name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
			</xsl:call-template>
	
			<P></P>

			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>

	</xsl:template>

	<xsl:template match="generate-species-report">
		<xsl:message>
			Generating Species Report for '<xsl:value-of select="species/@common-name"/>'
			species-sightings <xsl:value-of select="count(trip/sighting)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for <xsl:value-of select="species/@common-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-color" CELLPADDING="5" BORDER="0">

			<TR>
			    <TD VALIGN="TOP" ROWSPAN="2">
				    <!-- optionally replace this image with the photo -->
					<xsl:if test="count(trip[sighting/@photo])=0">
					    <IMG SRC="../images/species.gif" ALIGN="LEFT"/>
					</xsl:if>
					<xsl:if test="count(trip[sighting/@photo])>0">
					<IMG>
					    <xsl:attribute name="SRC">../images/tn_<xsl:value-of select="trip[sighting/@photo]/@date"/>-<xsl:value-of select="species/@abbreviation"/>.jpg</xsl:attribute>
					</IMG>
					</xsl:if>
				</TD>
				<TD COLSPAN="10" CLASS="pagetitle">
					<xsl:value-of select="species/@common-name"/>
					<BR/>
					<SPAN CLASS="pagesubtitle"><xsl:value-of select="species/@latin-name"/></SPAN>
				</TD>
			</TR>

			<TR>
				<TD ALIGN="RIGHT" NOWRAP="TRUE">Order<BR/>Family</TD>
				<TD NOWRAP="TRUE">
					<A>
						<xsl:attribute name="HREF">../orders/<xsl:value-of select="order/@filename-stem"/>.html</xsl:attribute>
						<I><xsl:value-of select="order/@latin-name"/></I><xsl:text>, </xsl:text><xsl:value-of select="order/@common-name"/>
					</A><BR/>
					<I><xsl:value-of select="family/@latin-name"/></I><xsl:text>, </xsl:text><xsl:value-of select="family/@common-name"/>
				</TD>
				<xsl:if test="string-length(species/@url)>0">
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<A>
						<xsl:attribute name="HREF">
						<xsl:value-of select="species/@url"/>
						</xsl:attribute>
						Species Website
						</A>
					</TD>
				</xsl:if>
				<TD NOWRAP="TRUE">|<BR/>|</TD>
				<TD NOWRAP="TRUE">
					<!-- note, the following expressions assume sightings are in chronological order -->
					first seen <xsl:value-of select="trip[position()=1]/sighting/@date"/><BR/>
					last seen <xsl:value-of select="trip[position()=last()]/sighting/@date"/><BR/>
				</TD>
				<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
				</TD>
			</TR>
			</TABLE>

			<xsl:apply-templates mode="report-content" select="species/notes"/>

			<DIV CLASS="headertext">
				<xsl:value-of select="species/@common-name"/> observed at <xsl:value-of select="count(location)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="location"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="species/@common-name"/> observed on <xsl:value-of select="count(trip)"/> trips
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
			</xsl:call-template>

			<P></P>
			
			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-report/location">
		<xsl:variable name="this-location-species" select="../species[sighting/@location-name=current()/@name]"/>

		<DIV CLASS="headertext">
			<xsl:value-of select="count($this-location-species)"/> species seen at
			<A>
				<xsl:attribute name="HREF">../locations/<xsl:value-of select="@filename-stem"/>.html</xsl:attribute>
				<xsl:value-of select="@name"/>
			</A>
		</DIV>

		<xsl:call-template name="two-column-table">
			<xsl:with-param name="in-entry-list" select="$this-location-species"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="generate-trip-report">
		<xsl:message>
			Generating Trip Report for '<xsl:value-of select="trip/@name"/>'
			species <xsl:value-of select="count(species)"/>
			location <xsl:value-of select="count(location)"/>
			sightings <xsl:value-of select="count(species/sighting)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Trip Report for <xsl:value-of select="trip/@name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="trip-color" CELLPADDING="5" BORDER="0">
				<TR>
				    <TD VALIGN="TOP" ROWSPAN="2">
						<IMG SRC="../images/trip.gif" ALIGN="LEFT"/>
					</TD>
					<TD COLSPAN="6" CLASS="pagetitle">
						<xsl:value-of select="trip/@name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle"><xsl:apply-templates select="trip/@date"/></SPAN>
					</TD>
				</TR>
				<TR>
					<TD NOWRAP="TRUE">
						Leader
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="trip/@leader"/>
					</TD>
					<xsl:if test="string-length(trip/@url)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="trip/@url"/>
								</xsl:attribute>
								Trip Website
							</A>
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(species)"/> species<BR/>
						<xsl:value-of select="count(location)"/> locations
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<xsl:apply-templates mode="report-content" select="trip/notes"/>

			<xsl:apply-templates select="location"/>

			<P></P>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-order-report">
		<xsl:message>
			Generating Order Report for '<xsl:value-of select="order/@latin-name"/>'
		</xsl:message>

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Species Report for Order <xsl:value-of select="order/@latin-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-color" CELLPADDING="5" BORDER="0">
				<TR>
				    <TD VALIGN="TOP" ROWSPAN="2">
						<IMG SRC="../images/species.gif" ALIGN="LEFT"/>
					</TD>
					<TD CLASS="pagetitle" NOWRAP="TRUE" COLSPAN="6">
						<xsl:value-of select="order/@latin-name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle"><xsl:value-of select="order/@common-name"/></SPAN>
					</TD>
				</TR>

				<TR>
					<TD NOWRAP="TRUE">
						Families<BR/>Subfamilies
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(family)"/><BR/>
						<xsl:value-of select="count(subfamily)"/>
					</TD>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						Genera<BR/>Species
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(genus)"/><BR/>
						<xsl:value-of select="count(species)"/>
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our Life List includes <xsl:value-of select="count(species[sighting])"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="order/@common-name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species[sighting]"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-county-species-index">
		<!-- define my report parameters -->
		<xsl:variable name="in-state" select="@in-state"/>
		<xsl:variable name="in-county" select="@in-county"/>

		<xsl:message>generate index for county <xsl:value-of select="$in-county"/></xsl:message>

		<!-- define my variables -->
		<xsl:variable name="county-locations" select="document('locations.xml')/locationset/location[(@state=$in-state) and (@county=$in-county)]"/>
		<xsl:variable name="county-sightings" select="document('sightings.xml')/sightingset/sighting[@location-name=$county-locations/@name]"/>
		<xsl:variable name="county-species" select="document('flat-species.xml')/taxonomyset/species[@abbreviation=$county-sightings/@abbreviation]"/>
		<xsl:variable name="state-name" select="document('misc.xml')/miscellaneous/stateset/state[@abbreviation=$in-state]/@name"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$state-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/species.gif" ALIGN="MIDDLE"/>
						Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$state-name"/>
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our list for <xsl:value-of select="$in-county"/> County contains <xsl:value-of select="count($county-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="document('flat-species.xml')/taxonomyset/species[@abbreviation=$county-sightings/@abbreviation]"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				Our county list is based on sightings from <xsl:value-of select="count($county-locations)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$county-locations"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>


	<xsl:template match="generate-cover-page-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>birdWalker - an XSL-based report generator for birding observations</TITLE>
		</HEAD>

		<xsl:message>generate cover page</xsl:message>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:comment>$Id: birdwalker.xsl,v 1.9 2003/03/20 01:33:29 walker Exp $</xsl:comment>

			<xsl:call-template name="home-navigation-block"/>

			<CENTER>
				<H1><IMG SRC="../images/bigtitle.gif"/></H1>
				<P>an XSL-based report generator for birding observations</P>
			</CENTER>

			<xsl:copy-of select="DIV"/>

			<P></P>

			<xsl:call-template name="home-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-location-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Location Reports</TITLE>
		</HEAD>

		<xsl:message>generate location index</xsl:message>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="location-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/location.gif" ALIGN="MIDDLE"/>
						Index of Location Reports
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains reports on <xsl:value-of select="count(document('locations.xml')/locationset/location)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="document('locations.xml')/locationset/location"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-species-index">
		<xsl:variable
			name="non-excluded-abbreviations"
			select="document('sightings.xml')/sightingset/sighting[not(@exclude)]/@abbreviation"/>
	
		<xsl:variable
			name="non-excluded-species"
			select="document('flat-species.xml')/taxonomyset/species[@abbreviation=$non-excluded-abbreviations]"/>
	
		<xsl:variable
			name="table-entries"
			select="document('flat-species.xml')/taxonomyset/order[@order-id=$non-excluded-species/@order-id] | $non-excluded-species"/>
	
		<xsl:message>generate species index</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species Reports (Mary and Bill Life List)</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/species.gif" ALIGN="MIDDLE"/>
						Mary and Bill's Life List
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our life list contains <xsl:value-of select="count($non-excluded-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$table-entries"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-state-species-index">
		<!-- define my report parameters -->
		<xsl:variable name="in-state" select="@in-state"/>

		<xsl:message>
			generate species index for state <xsl:value-of select="$in-state"/>
			"<xsl:value-of select="document('misc.xml')/miscellaneous/stateset/state[@abbreviation=$in-state]/@name"/>"
		</xsl:message>

		<!-- define my variables -->
		<xsl:variable
			name="state-locations"
			select="document('locations.xml')/locationset/location[@state=$in-state]"/>

		<xsl:variable
			name="state-sightings"
			select="document('sightings.xml')/sightingset/sighting[@location-name=$state-locations/@name]/@abbreviation"/>

		<xsl:variable
			name="state-species"
			select="document('flat-species.xml')/taxonomyset/species[@abbreviation=$state-sightings]"/>

		<xsl:variable
		    name="state-name"
			select="document('misc.xml')/miscellaneous/stateset/state[@abbreviation=$in-state]/@name"/>

		<xsl:message>generate species index for state <xsl:value-of select="$in-state"/></xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$state-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/species.gif" ALIGN="MIDDLE"/>
						Index of Species seen in <xsl:value-of select="$state-name"/>
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our species list for <xsl:value-of select="$state-name"/>
				contains <xsl:value-of select="count($state-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$state-species"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="$state-name"/> sightings recorded at <xsl:value-of select="count($state-locations)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$state-locations"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Trip Reports</TITLE>
		</HEAD>

		<xsl:message>generate trip index</xsl:message>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="trip-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/trip.gif" ALIGN="MIDDLE"/>
						Index of Trip Reports
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains reports on <xsl:value-of select="count(document('flat-trips.xml')/tripset/trip)"/> trips
			</DIV>

			<xsl:for-each select="document('misc.xml')/miscellaneous/yearset/year">
				<xsl:sort data-type="number" select="@name" order="descending"/>

				<xsl:variable name="this-year" select="@name"/>

				<DIV CLASS="headertext">
					<xsl:value-of select="$this-year"/> trips
				</DIV>

			 	<xsl:call-template name="two-column-table">
					<xsl:with-param name="in-entry-list" select="document('flat-trips.xml')/tripset/trip[starts-with(@date, $this-year)]"/>
				</xsl:call-template>
			</xsl:for-each>

			<P></P>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<!-- special-purpose template for formatting photo links, used only in the photo index -->
	<xsl:template match="sightingset/sighting/@photo">
	    <A><xsl:attribute name="HREF">../images/<xsl:value-of select="../@date"/>-<xsl:value-of select="../@abbreviation"/>.jpg</xsl:attribute>
			<img align="left"><xsl:attribute name="SRC">../images/tn_<xsl:value-of select="../@date"/>-<xsl:value-of select="../@abbreviation"/>.jpg</xsl:attribute></img>
			<xsl:apply-templates select="../@date"/><br/>
			<xsl:apply-templates select="document('flat-species.xml')/taxonomyset/species[@abbreviation=current()/../@abbreviation]/@common-name"/><br/>
			<xsl:value-of select="../location"/><br clear="all"/>
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="generate-photo-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Photos</TITLE>
		</HEAD>

		<xsl:message>generate photo index</xsl:message>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="../images/species.gif" ALIGN="MIDDLE"/>
						Index of Photos
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains <xsl:value-of select="count(document('sightings.xml')/sightingset/sighting/@photo)"/> photos
			</DIV>

		 	<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="document('sightings.xml')/sightingset/sighting/@photo"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>
