<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>
	
 	<!-- define variables containing all the source data -->
 	<xsl:variable name="sightings" select="document('../sightings.xml')"/>
 	<xsl:variable name="trips" select="document('../flat-trips.xml')"/>
 	<xsl:variable name="species" select="document('../flat-species.xml')"/>
 	<xsl:variable name="locations" select="document('../locations.xml')"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- ALL-TIME COUNTY SPECIES LIST -->

	<xsl:template match="generate-county-species-index">
		<!-- define my report parameters -->
		<xsl:variable name="in-state" select="@in-state"/>
		<xsl:variable name="in-county" select="@in-county"/>

		<xsl:message>generate index for county <xsl:value-of select="$in-county"/></xsl:message>

		<!-- define my variables -->
		<xsl:variable name="county-locations" select="$locations/locationset/location[(state[text()=$in-state]) and (county[text()=$in-county])]"/>
		<xsl:variable name="county-sightings" select="$sightings/sightingset/sighting[location=$county-locations/name]"/>
		<xsl:variable name="county-species" select="$species/taxonomyset/species[abbreviation=$county-sightings/abbreviation]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="$in-county"/>, <xsl:value-of select="$in-state"/> Species List
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our county list for <xsl:value-of select="$in-county"/> county contains <xsl:value-of select="count($county-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$species/taxonomyset/species[abbreviation=$county-sightings/abbreviation]"/>
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
			<xsl:comment>$Id: indices.xsl,v 1.10 2002/02/06 16:48:24 walker Exp $</xsl:comment>

			<xsl:call-template name="home-navigation-block"/>

			<CENTER>
				<H1><IMG SRC="images/bigtitle.gif"/></H1>
				<P>an XSL-based report generator for birding observations</P>
			</CENTER>

			<DIV CLASS="headertext">How to navigate</DIV>

			<DIV CLASS="report-content">
				<P>
				All the pages on this site have links at the top and bottom leading to the
				indices of 
					<A HREF="./species-index.html">species reports</A>,
					<A HREF="./trip-index.html">trip reports</A>, and
					<A HREF="./location-index.html">location reports</A>.
				In addition, I have generated a species list for each
				year we've been bird watching (
					<A HREF="1996.html">1996</A>,
					<A HREF="1997.html">1997</A>,
					<A HREF="1998.html">1998</A>,
					<A HREF="1999.html">1999</A>,
					<A HREF="2000.html">2000</A>,
					<A HREF="2001.html">2001</A>,
					<A HREF="2002.html">2002</A>),
				each state we've taken trips in (
					<A HREF="ca-species-index.html">California</A>,
					<A HREF="ma-species-index.html">Massachusetts</A>,
					<A HREF="il-species-index.html">Illinois</A>,
					<A HREF="or-species-index.html">Oregon</A>),
				and some of our favorite counties (
					<A HREF="santa-clara-county-species-index.html">Santa Clara</A>,
					<A HREF="monterey-county-species-index.html">Monterey</A>,
					<A HREF="san-mateo-county-species-index.html">San Mateo</A>).
				I've included my
					<A HREF="./photo-index.html">experimental digiscoping photos</A> using a Canon Powershot S40 and Pentax ED spotting scope.
				</P>
			</DIV>

			<DIV CLASS="headertext">How it works</DIV>

			<DIV CLASS="report-content">
				<P>While in the field, I record my observations using a Palm V and its Memo Pad application.
				Each of these trip lists includes a date, location, and collection of six-letter abbreviations,
				one for each species seen.</P>

				<P>After the trip, I import these trip lists into a FileMaker database. The database consists of
				four tables; Sightings, Locations, Trips, and Species. The Species table is prepopulated with
				Mr. Shipman's collection of abbreviations, latin names, and common names for all the species on
				the ABA list. The other three tables are generated from my field notes.</P>
				
				<P>To generate these web page reports, I first export the data from the FileMaker database into XML.
				I transform the XML data into a series of web pages using XSL templates and Apache's Xalan
				(an XSLT engine).</P>
			</DIV>

			<DIV CLASS="headertext">References</DIV>

			<DIV CLASS="report-content">
			<P>
				<A HREF="http://www.nmt.edu/~shipman/z/nom/6home.html">
					<I>A robust bird code system: the six-letter code</I>, John Shipman<BR/>
					http://www.nmt.edu/~shipman/z/nom/6home.html
				</A>
			</P>

			<P>
				<A HREF="http://xml.apache.org/xalan-j/index.html">
					<I>Xalan: An XSLT Engine</I>, the Apache XML Project<BR/>
					http://xml.apache.org/xalan-j/index.html
				</A>
			</P>

			<P>
				<A HREF="http://www.aou.org/aou/birdlist.html">
					Americal Ornithological Union Checklist of North American Birds<BR/>
					http://www.aou.org/aou/birdlist.html
				</A>
			</P>

			<P>
				<A HREF="http://www.filemaker.com/index.html">
					<I>FileMaker Pro</I> database, FileMaker Inc.<BR/>
					http://www.filemaker.com/index.html
				</A>
			</P>

			<P>
				<A HREF="http://www.paradisebirding.com/sys-tmpl/door/">
					Steve Shunk, Paradise Birding<BR/>
					http://www.paradisebirding.com/sys-tmpl/door/
				</A>
			</P>
			</DIV>

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
						<IMG SRC="images/location.gif" ALIGN="MIDDLE"/>
						Index of Location Reports
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains reports on <xsl:value-of select="count($locations/locationset/location)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$locations/locationset/location"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-species-index">
		<xsl:variable
			name="non-excluded-abbreviations"
			select="$sightings/sightingset/sighting[not(exclude)]/abbreviation"/>
	
		<xsl:variable
			name="non-excluded-species"
			select="$species/taxonomyset/species[abbreviation=$non-excluded-abbreviations]"/>
	
		<xsl:variable
			name="table-entries"
			select="$species/taxonomyset/order[order-id=$non-excluded-species/order-id] |  $non-excluded-species"/>
	
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
						<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
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

			<DIV CLASs="headertext">
				Distribution of Sightings over time
			</DIV>

			<xsl:call-template name="time-distributions">
				<xsl:with-param name="in-dated-items" select="$sightings/sightingset/sighting"/>
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
			"<xsl:value-of select="$miscellaneous/miscellaneous/stateset/state[@abbreviation=$in-state]/@name"/>"
		</xsl:message>

		<!-- define my variables -->
		<xsl:variable
			name="state-locations"
			select="$locations/locationset/location[state[text()=$in-state]]"/>

		<xsl:variable
			name="state-sightings"
			select="$sightings/sightingset/sighting[location=$state-locations/name]"/>

		<xsl:variable
			name="state-species"
			select="$species/taxonomyset/species[abbreviation=$state-sightings/abbreviation]"/>

		<xsl:message>generate species index for state <xsl:value-of select="$in-state"/></xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$miscellaneous/miscellaneous/stateset/state[abbreviation=$in-state]/@name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="$in-state"/> State Species List
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our species list for <xsl:value-of select="$in-state"/> contains <xsl:value-of select="count($state-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$state-species"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="$in-state"/> sightings recorded at <xsl:value-of select="count($state-locations)"/> locations
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
						<IMG SRC="images/trip.gif" ALIGN="MIDDLE"/>
						Index of Trip Reports
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains reports on <xsl:value-of select="count($trips/tripset/trip)"/> trips
			</DIV>

			<xsl:for-each select="$miscellaneous/miscellaneous/yearset/year">
				<xsl:sort data-type="number" select="@name" order="descending"/>

				<xsl:variable name="this-year" select="@name"/>

				<DIV CLASS="headertext">
					<xsl:value-of select="$this-year"/> trips
				</DIV>

			 	<xsl:call-template name="two-column-table">
					<xsl:with-param name="in-entry-list" select="$trips/tripset/trip[starts-with(date, $this-year)]"/>
				</xsl:call-template>
			</xsl:for-each>

			<DIV CLASS="headertext">
				Distribution of trips
			</DIV>

			<xsl:call-template name="time-distributions">
				<xsl:with-param name="in-dated-items" select="$trips/tripset/trip"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<!-- special-purpose template for formatting photo links, used only in the photo index -->
	<xsl:template match="sightingset/sighting/photo">
	    <A><xsl:attribute name="HREF">./images/<xsl:value-of select="../date"/>-<xsl:value-of select="../abbreviation"/>.jpg</xsl:attribute>
			<img><xsl:attribute name="SRC">./images/TN_<xsl:value-of select="../date"/>-<xsl:value-of select="../abbreviation"/>.JPG</xsl:attribute></img>
			<xsl:apply-templates select="../date"/>
			<xsl:text>, </xsl:text>
			<xsl:apply-templates select="$species/taxonomyset/species[abbreviation=current()/../abbreviation]/common-name"/><xsl:text> at </xsl:text>
			<xsl:value-of select="../location"/>
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
						<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
						Index of Photos
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				This database contains <xsl:value-of select="count($sightings/sightingset/sighting/photo)"/> photos
			</DIV>

		 	<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$sightings/sightingset/sighting/photo"/>
			</xsl:call-template>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>

