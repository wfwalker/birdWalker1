<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>
	
 	<!-- define variables containing all the source data -->
 	<xsl:variable name="sightings" select="document('../sightings.xml')"/>
 	<xsl:variable name="trips" select="document('../flat-trips.xml')"/>
 	<xsl:variable name="species" select="document('../flat-species.xml')"/>
 	<xsl:variable name="locations" select="document('../locations.xml')"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="generate-annual-species-index">
		<!-- define my report parameter -->
		<xsl:variable name="in-year" select="@in-year"/>

		<xsl:message>generate index for year <xsl:value-of select="$in-year"/></xsl:message>

		<xsl:variable
			name="year-abbreviations"
			select="$sightings/sightingset/sighting[not(exclude) and contains(date, $in-year)]/abbreviation"/>

		<xsl:variable
			name="year-species"
			select="$species/taxonomyset/species[abbreviation=$year-abbreviations]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-year"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/><BR/>Index of Species seen in <xsl:value-of select="$in-year"/></H1>

			<DIV CLASS="species-headertext">
				Our annual list for <xsl:value-of select="$in-year"/> contains <xsl:value-of select="count($year-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$year-species"/>
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
		<xsl:variable name="county-locations" select="$locations/locationset/location[(state[text()=$in-state]) and (county[text()=$in-county])]"/>
		<xsl:variable name="county-sightings" select="$sightings/sightingset/sighting[location=$county-locations/name]"/>
		<xsl:variable name="county-species" select="$species/taxonomyset/species[abbreviation=$county-sightings/abbreviation]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/><BR/>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$in-state"/></H1>
			<DIV CLASS="species-headertext">
				Our county list for <xsl:value-of select="$in-county"/> county contains <xsl:value-of select="count($county-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$species/taxonomyset/species[abbreviation=$county-sightings/abbreviation]"/>
			</xsl:call-template>

			<DIV CLASS="species-headertext">
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
			<xsl:comment>$Id: indices.xsl,v 1.3 2001/10/24 16:16:23 walker Exp $</xsl:comment>

			<xsl:call-template name="home-navigation-block"/>

			<CENTER>
				<IMG SRC="images/trip.gif"/>
				<IMG SRC="images/location.gif"/>
				<IMG SRC="images/species.gif"/>

				<H1><IMG SRC="images/bigtitle.gif"/></H1>
				<P>an XSL-based report generator for birding observations</P>
			</CENTER>

			<DIV CLASS="home-headertext">How to navigate</DIV>

			<DIV CLASS="report-content">
				<P>
				All the pages on this site have links at the top and bottom leading to the
				indices of 
					<A HREF="./species-index.html">species reports</A>,
					<A HREF="./trip-index.html">trip reports</A>, and
					<A HREF="./location-index.html">location reports</A>.
				In addition, I have generated a species list for each
				year we've been bird watching (
					<A HREF="1996-species-index.html">1996</A>,
					<A HREF="1997-species-index.html">1997</A>,
					<A HREF="1998-species-index.html">1998</A>,
					<A HREF="1999-species-index.html">1999</A>,
					<A HREF="2000-species-index.html">2000</A>,
					<A HREF="2001-species-index.html">2001</A>),
				each state we've taken trips in (
					<A HREF="ca-species-index.html">California</A>,
					<A HREF="ma-species-index.html">Massachusetts</A>,
					<A HREF="il-species-index.html">Illinois</A>,
					<A HREF="or-species-index.html">Oregon</A>),
				and some of our favorite counties (
					<A HREF="santa-clara-county-species-index.html">Santa Clara</A>,
					<A HREF="monterey-county-species-index.html">Monterey</A>,
					<A HREF="san-mateo-county-species-index.html">San Mateo</A>).
				</P>
			</DIV>

			<DIV CLASS="home-headertext">How it works</DIV>

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

			<DIV CLASS="home-headertext">References</DIV>

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
				<A HREF="http://www.filemaker.com/index.html">
					<I>FileMaker Pro</I> database, FileMaker Inc.<BR/>
					http://www.filemaker.com/index.html
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

			<H1><IMG SRC="images/location.gif"/><BR/>Index of Location Reports</H1>

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
		<TITLE>Index of Species Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/><BR/>Index of Species Reports</H1>

			<DIV CLASS="species-headertext">
				Our life list contains <xsl:value-of select="count($non-excluded-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$table-entries"/>
			</xsl:call-template>

			<DIV CLASs="species-headertext">
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
		<TITLE>Index of Species seen in <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/><BR/>Index of Species seen in <xsl:value-of select="$in-state"/></H1>

			<DIV CLASS="species-headertext">
				Our species list for <xsl:value-of select="$in-state"/> contains <xsl:value-of select="count($state-species)"/> species
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$state-species"/>
			</xsl:call-template>

			<DIV CLASS="species-headertext">
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

			<H1><IMG SRC="images/trip.gif"/><BR/>Index of Trip Reports</H1>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$trips/tripset/trip"/>
			</xsl:call-template>

			<DIV CLASS="trip-headertext">
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

</xsl:stylesheet>

