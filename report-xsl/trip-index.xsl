<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:variable name="my-header-style">trip-navigationblock</xsl:variable>

	<!-- define my report parameters -->
	<xsl:param name="in-trip-date"/>
	
	<xsl:template match="*">
		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Index of Trip Reports</TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<H1><IMG SRC="images/trip.gif"/>Index of Trip Reports</H1>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$trips/tripset/trip"/>
			</xsl:call-template>

			<xsl:call-template name="monthly-distribution">
				<xsl:with-param name="dated-items" select="$trips/tripset/trip"/>
				<xsl:with-param name="item-kind">total trips</xsl:with-param>
			</xsl:call-template>
	
			<xsl:call-template name="yearly-distribution">
				<xsl:with-param name="dated-items" select="$trips/tripset/trip"/>
				<xsl:with-param name="item-kind">total trips</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
