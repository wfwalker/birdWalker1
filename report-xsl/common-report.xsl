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
		H1 {font: 18pt Tahoma}
		H2 {font: 12pt Tahoma}
		.tablehead {font: 10pt Tahoma; background-color: #EEEEEE}
		.sightinghead {font: 10pt Tahoma; background-color: #DDDDEE}
		.navigationblock {font: 10pt Tahoma; background-color: #DDDDDD}
		</STYLE>
	</xsl:template>

	<xsl:template name="navigation-block">
		<TABLE WIDTH="100%" CELLPADDING="10">
			<TR>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><CODE>&lt;birdWalker&gt;</CODE></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./species-index.html">Species</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./location-index.html">Locations</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./trip-index.html">Trips</A></TD>
			</TR>
		</TABLE>
	</xsl:template>

	<xsl:template name="tableheader">
		<xsl:param name="title-string"/>

		<TABLE WIDTH="100%" CLASS="tablehead">
			<TR><TD WIDTH="100%"><xsl:value-of select="$title-string"/></TD></TR>
		</TABLE>
	</xsl:template>

	<!-- templates to create table sections used in many kinds of reports -->

	<xsl:template name="species-table">
		<xsl:param name="species-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($species-list)"/> species:
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$species-list[position() &lt;= (count($species-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$species-list[position() &gt; (count($species-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
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
					location<xsl:if test="count($location-list)>1">s</xsl:if>:
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &lt;= (count($location-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &gt; (count($location-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template name="sightings-table">
		<xsl:param name="sighting-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($sighting-list)"/>
					sighting<xsl:if test="count($sighting-list)>1">s</xsl:if>:
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10">
				<xsl:apply-templates select="$sighting-list[position()=1 or position()=last() or string-length(notes)>0]"/>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template name="trip-table">
		<xsl:param name="trip-list"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">
					<xsl:value-of select="count($trip-list)"/>
					trip<xsl:if test="count($trip-list)>1">s</xsl:if>:
				</xsl:with-param>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &lt;= (count($trip-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &gt; (count($trip-list) div 2)]">
							<xsl:with-param name="suffix"><BR/></xsl:with-param>
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template match="notes">
		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="title-string">notes:</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="."/>
		</P>
	</xsl:template>

	<!-- templates for names of and hyperlinks to various entities -->

	<xsl:template match="species">
		<xsl:param name="suffix"/>

		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
		</A>

		<xsl:copy-of select="$suffix"/>
	</xsl:template>

	<xsl:template match="sighting">
		<xsl:variable name="this" select="."/>

		<TR>
			<TD>
				<DIV CLASS="sightinghead">
				<xsl:apply-templates select="$species/taxonomyset/species[abbreviation=$this/abbreviation]">
					<xsl:with-param name="suffix"> * </xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="$trips/tripset/trip[date=$this/date]">
					<xsl:with-param name="suffix"> * </xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="$locations/locationset/location[name=$this/location]"/>
				</DIV>
			</TD>
		</TR>
		<TR>
			<TD>
				<xsl:if test="position()=1">First sighting </xsl:if>
				<xsl:if test="position()=last()">Latest sighting </xsl:if>
				<xsl:value-of select="notes"/>
			</TD>
		</TR>
	</xsl:template>

	<xsl:template match="trip">
		<xsl:param name="suffix"/>

		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			<xsl:value-of select="name"/> (<xsl:value-of select="date"/>, <xsl:value-of select="leader"/>)
		</A>

		<xsl:copy-of select="$suffix"/>
	</xsl:template>

	<xsl:template match="location">
		<xsl:param name="suffix"/>

		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			<xsl:value-of select="name"/> (<xsl:value-of select="city"/>, <xsl:value-of select="state"/>)
		</A>

		<xsl:copy-of select="$suffix"/>
	</xsl:template>

</xsl:stylesheet>
