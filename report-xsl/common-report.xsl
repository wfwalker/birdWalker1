<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:variable name="sightings" select="document('../sightings.xml')"/>
	<xsl:variable name="trips" select="document('../flat-trips.xml')"/>
	<xsl:variable name="species" select="document('../flat-species.xml')"/>
	<xsl:variable name="locations" select="document('../locations.xml')"/>

	<!-- a template for inserting cascading style sheets -->

	<xsl:template name="style-block">
		<STYLE>
		TD {font: 10pt Tahoma}
		BODY {font: 10pt Tahoma}
		P {font: 10pt Tahoma}
		H1 {font: 18pt Tahoma}
		H2 {font: 12pt Tahoma}
		.tablehead {font: 10pt Tahoma; font-weight: bold; background-color: #EEEEEE}
		.sightinghead {font: 10pt Tahoma; background-color: #EEEEFF}
		.navigationblock {font: 10pt Tahoma; background-color: #DDDDDD}
		</STYLE>
	</xsl:template>

	<xsl:template name="navigation-block">
		<TABLE WIDTH="100%" CELLPADDING="10">
			<TR>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./cover-page.html"><CODE>&lt;birdWalker&gt;</CODE></A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./species-index.html">Species List</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./location-index.html">Location List</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./trip-index.html">Trip List</A></TD>
			</TR>
		</TABLE>
	</xsl:template>

	<xsl:template name="tableheader">
		<xsl:param name="title-string"/>

		<TABLE WIDTH="100%">
			<TR><TD CLASS="tablehead" WIDTH="100%"><xsl:value-of select="$title-string"/></TD></TR>
		</TABLE>
	</xsl:template>

	<!-- templates to create table sections used in many kinds of reports -->

	<xsl:template name="species-table">
		<xsl:param name="species-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($species-list)"/> species
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$species-list[position() &lt; 1 + (count($species-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$species-list[position() &gt;= 1 + (count($species-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template name="location-table">
		<xsl:param name="location-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($location-list)"/>
					location<xsl:if test="count($location-list)>1">s</xsl:if>
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &lt; 1 + (count($location-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &gt;= 1 + (count($location-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<!-- displays a collection of noteworthy sightings -->

	<xsl:template name="sightings-table">
		<xsl:param name="sighting-list"/>

		<xsl:if test="count($sighting-list) > 1">
			<P>
				<xsl:call-template name="tableheader">
					<xsl:with-param name="title-string">
						<xsl:value-of select="count($sighting-list)"/>
						sighting note<xsl:if test="count($sighting-list)>1">s</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
	
				<TABLE WIDTH="100%" CELLPADDING="10">
					<xsl:apply-templates select="$sighting-list"/>
				</TABLE>
			</P>
		</xsl:if>
	</xsl:template>

	<xsl:template name="trip-table">
		<xsl:param name="trip-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($trip-list)"/>
					trip<xsl:if test="count($trip-list)>1">s</xsl:if>
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &lt; 1 + (count($trip-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &gt;= 1 + (count($trip-list) div 2)]">
							<xsl:with-param name="create-link">true</xsl:with-param>
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template match="notes">
		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">notes</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="."/>
		</P>
	</xsl:template>

	<!-- templates for names of and hyperlinks to various entities -->

	<xsl:template match="species">
		<xsl:param name="create-link"/>

		<A>
			<xsl:if test="string-length($create-link) > 0">
				<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="common-name"/>
		</A>
		<BR/>
	</xsl:template>

	<xsl:template name="sighting-entry">
		<xsl:param name="sighting-record"/>
		<xsl:param name="aux-record-1"/>
		<xsl:param name="aux-record-2"/>

		<TR>
			<TD>
				<!-- nested table for displaying the two aux records and their links -->
				<TABLE WIDTH="100%">
					<TR>
						<TD WIDTH="25%" ALIGN="LEFT" CLASS="sightinghead">
							<xsl:apply-templates select="$aux-record-1">
							</xsl:apply-templates>
							<xsl:apply-templates select="$aux-record-2">
							</xsl:apply-templates>
						</TD>
						<TD WIDTH="75%" ALIGN="LEFT">
							<xsl:value-of select="notes"/>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</xsl:template>

	<xsl:template match="trip">
		<xsl:param name="create-link"/>

		<A>
			<xsl:if test="string-length($create-link)>0">
				<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/> (<xsl:value-of select="date"/>)
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="location">
		<xsl:param name="create-link"/>

		<A>
			<xsl:if test="string-length($create-link) > 0">
				<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			</xsl:if>

			<xsl:value-of select="name"/> (<xsl:value-of select="city"/>, <xsl:value-of select="state"/>)
		</A>
		<BR/>
	</xsl:template>

</xsl:stylesheet>
