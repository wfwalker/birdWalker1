<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="*">

		<HTML>

		<xsl:apply-templates select="*"/>

		</HTML>
	</xsl:template>

	<xsl:template match="generate-annual-species-index">
		<!-- define my report parameter -->
		<xsl:variable name="in-year" select="@in-year"/>

		<xsl:variable
			name="year-abbreviations"
			select="$sightings/sightingset/sighting[not(exclude) and contains(date, $in-year)]/abbreviation"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-year"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species seen in <xsl:value-of select="$in-year"/></H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="in-species-list" select="$species/taxonomyset/species[abbreviation=$year-abbreviations]"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-county-species-index">
		<!-- define my report parameters -->
		<xsl:variable name="in-state" select="@in-state"/>
		<xsl:variable name="in-county" select="@in-county"/>

		<!-- define my variables -->
		<xsl:variable name="county-locations" select="$locations/locationset/location[(state[text()=$in-state]) and (county[text()=$in-county])]"/>
		<xsl:variable name="county-sightings" select="$sightings/sightingset/sighting[location=$county-locations/name]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species seen in <xsl:value-of select="$in-county"/> County, <xsl:value-of select="$in-state"/></H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="in-species-list" select="$species/taxonomyset/species[abbreviation=$county-sightings/abbreviation]"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$county-locations"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>


	<xsl:template match="generate-cover-page-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>birdWalker - an XSL-based report generator for birding observations</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:comment>$Id: indices.xsl,v 1.1 2001/10/04 15:38:43 walker Exp $</xsl:comment>

			<xsl:call-template name="home-navigation-block"/>

			<CENTER>
				<IMG SRC="images/trip.gif"/>
				<IMG SRC="images/location.gif"/>
				<IMG SRC="images/species.gif"/>

				<H1><IMG SRC="images/bigtitle.gif"/></H1>
				<P>an XSL-based report generator for birding observations</P>
			</CENTER>

			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">how to navigate</xsl:with-param>
				<xsl:with-param name="in-header-style">home-navigationblock</xsl:with-param>
			</xsl:call-template>

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
					<A HREF="ca-species-index.html">CA</A>,
					<A HREF="or-species-index.html">OR</A>),
				and some of our favorite counties (
					<A HREF="santa-clara-county-species-index.html">Santa Clara</A>,
					<A HREF="san-mateo-county-species-index.html">San Mateo</A>).
			</P>

			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">how it works</xsl:with-param>
				<xsl:with-param name="in-header-style">home-navigationblock</xsl:with-param>
			</xsl:call-template>

			<P>
				While in the field, I record my observations using a Palm V and its Memo Pad application.
				Each of these trip lists includes a date, location, and collection of six-letter abbreviations,
				one for each species seen.
			</P>
			<P>
				After the trip, I import these trip lists into a FileMaker database. The database consists of
				four tables; Sightings, Locations, Trips, and Species. The Species table is prepopulated with
				Mr. Shipman's collection of abbreviations, latin names, and common names for all the species on
				the ABA list. The other three tables are generated from my field notes.
			</P>
			<P>
				To generate these web page reports, I first export the data from the FileMaker database into XML.
				I transform the XML data into a series of web pages using XSL templates and Apache's Xalan
				(an XSLT engine).
			</P>

			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">references</xsl:with-param>
				<xsl:with-param name="in-header-style">home-navigationblock</xsl:with-param>
			</xsl:call-template>

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

			<xsl:call-template name="home-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-location-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Location Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<H1><IMG SRC="images/location.gif"/>Index of Location Reports</H1>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$locations/locationset/location"/>
				<xsl:with-param name="in-header-style">location-navigationblock</xsl:with-param>
			</xsl:call-template>

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
	
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species Reports</H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="in-species-list" select="$non-excluded-species"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="order-table">
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="monthly-distribution">
				<xsl:with-param name="dated-items" select="$sightings/sightingset/sighting"/>
				<xsl:with-param name="item-kind">total sightings</xsl:with-param>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>
	
			<xsl:call-template name="yearly-distribution">
				<xsl:with-param name="dated-items" select="$sightings/sightingset/sighting"/>
				<xsl:with-param name="item-kind">total sightings</xsl:with-param>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-state-species-index">
		<!-- define my report parameters -->
		<xsl:variable name="in-state" select="@in-state"/>

		<!-- define my variables -->
		<xsl:variable name="state-locations" select="$locations/locationset/location[state[text()=$in-state]]"/>
		<xsl:variable name="state-sightings" select="$sightings/sightingset/sighting[location=$state-locations/name]"/>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Species seen in <xsl:value-of select="$in-state"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<H1><IMG SRC="images/species.gif"/>Index of Species seen in <xsl:value-of select="$in-state"/></H1>

			<xsl:call-template name="species-table">
				<xsl:with-param name="in-species-list" select="$species/taxonomyset/species[abbreviation=$state-sightings/abbreviation]"/>
				<xsl:with-param name="in-header-style">species-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-index">
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Trip Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<H1><IMG SRC="images/trip.gif"/>Index of Trip Reports</H1>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$trips/tripset/trip"/>
				<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="monthly-distribution">
				<xsl:with-param name="dated-items" select="$trips/tripset/trip"/>
				<xsl:with-param name="item-kind">total trips</xsl:with-param>
				<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
			</xsl:call-template>
	
			<xsl:call-template name="yearly-distribution">
				<xsl:with-param name="dated-items" select="$trips/tripset/trip"/>
				<xsl:with-param name="item-kind">total trips</xsl:with-param>
				<xsl:with-param name="in-header-style">trip-navigationblock</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>

