<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<xsl:include href="./common-report.xsl"/>

	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>birdWalker - an XSL-based report generator for birding observations</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="navigation-block"/>

			<CENTER>
				<IMG SRC="images/trip.gif"/>
				<IMG SRC="images/location.gif"/>
				<IMG SRC="images/species.gif"/>

				<H1><TT>&lt;birdWalker&gt;</TT></H1>
				<P>an XSL-based report generator for birding observations</P>
			</CENTER>

			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">how to navigate</xsl:with-param>
			</xsl:call-template>

			<P>
				All the pages on this site have links at the top and bottom leading to the
					<A HREF="./species-index.html">life species list</A>,
					<A HREF="./trip-index.html">life trip list</A>, and
					<A HREF="./location-index.html">life location list</A>.
				In addition, I have generated a species list for each
				year we've been bird watching (
					<A HREF="1996-species-index.html">1996</A>,
					<A HREF="1997-species-index.html">1997</A>,
					<A HREF="1998-species-index.html">1998</A>,
					<A HREF="1999-species-index.html">1999</A>,
					<A HREF="2000-species-index.html">2001</A>,
					<A HREF="2001-species-index.html">2001</A>),
				and each state we've taken trips in (
					<A HREF="ca-species-index.html">CA</A>,
					<A HREF="or-species-index.html">OR</A>).
			</P>

			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">how it works</xsl:with-param>
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

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
