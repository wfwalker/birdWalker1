<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:param name="in-tstamp"/>

	<!-- define variables containing all the source data -->
	<xsl:variable name="sightings" select="document('../sightings.xml')"/>
	<xsl:variable name="trips" select="document('../flat-trips.xml')"/>
	<xsl:variable name="species" select="document('../flat-species.xml')"/>
	<xsl:variable name="locations" select="document('../locations.xml')"/>

	<!-- a template for inserting cascading style sheets -->

	<xsl:template name="style-block">
		<LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
	</xsl:template>

	<!-- define four different navigation blocks, one for each kind of page -->

	<xsl:template name="home-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class">home-navigationblock</xsl:with-param>
			<xsl:with-param name="species-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="location-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="trip-class">default-navigationblock</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="species-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="species-class">species-navigationblock</xsl:with-param>
			<xsl:with-param name="location-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="trip-class">default-navigationblock</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="location-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="species-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="location-class">location-navigationblock</xsl:with-param>
			<xsl:with-param name="trip-class">default-navigationblock</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="trip-navigation-block">
		<xsl:call-template name="navigation-block">
			<xsl:with-param name="home-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="species-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="location-class">default-navigationblock</xsl:with-param>
			<xsl:with-param name="trip-class">trip-navigationblock</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- define the underlying template for all four kinds of navigation block -->

	<xsl:template name="navigation-block">
		<xsl:param name="home-class"/>
		<xsl:param name="species-class"/>
		<xsl:param name="location-class"/>
		<xsl:param name="trip-class"/>

		<TABLE WIDTH="100%" CELLPADDING="10" BORDER="0" CELLSPACING="0">
			<TR>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$home-class"/></xsl:attribute>
					<A HREF="./index.html"><CODE>&lt;birdWalker&gt;</CODE></A>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$species-class"/></xsl:attribute>
					<A HREF="./species-index.html">Species Reports</A>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$location-class"/></xsl:attribute>
					<A HREF="./location-index.html">Location Reports</A>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$trip-class"/></xsl:attribute>
					<A HREF="./trip-index.html">Trip Reports</A>
				</TD>
			</TR>
		</TABLE>
		<xsl:comment> $Id: common-report.xsl,v 1.12 2001/10/10 16:11:27 walker Exp $ </xsl:comment>
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

	<!-- define the template for tableheaders -->
	<!-- note that this template uses a background color that must be defined in any XSL that includes common-report.xsl -->

	<xsl:template name="tableheader">
		<xsl:param name="in-title-string"/>
		<xsl:param name="in-extra-title"/>
		<xsl:param name="in-extra-url"/>
		<xsl:param name="in-header-style"/>

		<TABLE WIDTH="100%">
			<TR>
				<TD WIDTH="100%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$in-header-style"/></xsl:attribute>

					<xsl:if test="string-length($in-extra-title)">
						<A>
							<xsl:attribute name="HREF"><xsl:value-of select="$in-extra-url"/></xsl:attribute>
							<xsl:value-of select="$in-extra-title"/>
						</A>
						<xsl:text>, </xsl:text>
					</xsl:if>

					<xsl:value-of select="$in-title-string"/>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>

	<!-- templates to create table sections used in many kinds of reports -->

	<xsl:template name="species-table">
		<xsl:param name="in-species-list"/>
		<xsl:param name="in-extra-title"/>
		<xsl:param name="in-extra-url"/>
		<xsl:param name="in-header-style"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">
					<xsl:value-of select="count($in-species-list)"/> species
				</xsl:with-param>
				<xsl:with-param name="in-extra-url" select="$in-extra-url"/>
				<xsl:with-param name="in-extra-title" select="$in-extra-title"/>
				<xsl:with-param name="in-header-style" select="$in-header-style"/>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$in-species-list[position() &lt; 1 + (count($in-species-list) div 2)]"/>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$in-species-list[position() &gt;= 1 + (count($in-species-list) div 2)]"/>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template name="location-table">
		<xsl:param name="location-list"/>
		<xsl:param name="in-header-style"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">
					<xsl:value-of select="count($location-list)"/>
					location<xsl:if test="count($location-list)!=1">s</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="in-header-style" select="$in-header-style"/>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &lt; 1 + (count($location-list) div 2)]">
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$location-list[position() &gt;= 1 + (count($location-list) div 2)]">
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<!-- displays a collection of noteworthy sightings -->

	<xsl:template name="sightings-table">
		<xsl:param name="sighting-list"/>
		<xsl:param name="in-header-style"/>

		<xsl:if test="count($sighting-list) > 0">
			<P>
				<xsl:call-template name="tableheader">
					<xsl:with-param name="in-title-string">
						<xsl:value-of select="count($sighting-list)"/>
						sighting note<xsl:if test="count($sighting-list)!=1">s</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="in-header-style" select="$in-header-style"/>
				</xsl:call-template>
	
				<TABLE WIDTH="100%" CELLPADDING="10">
					<xsl:apply-templates select="$sighting-list"/>
				</TABLE>
			</P>
		</xsl:if>
	</xsl:template>

	<!-- displays a list of trips -->

	<xsl:template name="trip-table">
		<xsl:param name="trip-list"/>
		<xsl:param name="in-header-style"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">
					<xsl:value-of select="count($trip-list)"/>
					trip<xsl:if test="count($trip-list)!=1">s</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="in-header-style" select="$in-header-style"/>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &lt; 1 + (count($trip-list) div 2)]">
						</xsl:apply-templates>
					</TD>
					<TD WIDTH="50%">
						<xsl:apply-templates select="$trip-list[position() &gt;= 1 + (count($trip-list) div 2)]">
						</xsl:apply-templates>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<xsl:template match="notes">
		<xsl:param name="in-header-style"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">notes</xsl:with-param>
				<xsl:with-param name="in-header-style" select="$in-header-style"/>
			</xsl:call-template>

			<xsl:copy-of select="."/>
		</P>
	</xsl:template>

	<!-- templates for names of and hyperlinks to various entities -->

	<xsl:template match="species">
		<xsl:param name="this" select="."/>
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
		</A>
		<BR/>
	</xsl:template>

	<!-- this template to be called by the sighting template provided by each report -->

	<xsl:template name="sighting-entry">
		<xsl:param name="sighting-record"/>
		<xsl:param name="title-string"/>

		<TR>
			<TD>
				<!-- nested table for displaying the two aux records and their links -->
				<TABLE WIDTH="100%">
					<TR>
						<TD VALIGN="TOP" WIDTH="25%" ALIGN="LEFT" CLASS="sightinghead">
							<xsl:value-of select="$title-string"/>
						</TD>
						<TD WIDTH="75%" VALIGN="TOP" ALIGN="LEFT">
							<xsl:value-of select="notes"/>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</xsl:template>

	<xsl:template match="trip">
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			<xsl:value-of select="name"/> (<xsl:value-of select="date"/>)
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="location">
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			<xsl:value-of select="name"/> (<xsl:value-of select="city"/>, <xsl:value-of select="state"/>)
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="order">
		<A>
			<xsl:attribute name="HREF"><xsl:value-of select="report-url"/></xsl:attribute>
			<I>(<xsl:value-of select="latin-name"/>)</I>
			<xsl:text> </xsl:text><xsl:value-of select="common-name"/>
		</A>
		<BR/>
	</xsl:template>

	<xsl:template name="order-table">
		<xsl:param name="in-header-style"/>

		<xsl:variable name="order-list" select="$species/taxonomyset/order"/>

		<xsl:call-template name="tableheader">
			<xsl:with-param name="in-title-string">
				<xsl:value-of select="count($order-list)"/> orders
			</xsl:with-param>
			<xsl:with-param name="in-header-style" select="$in-header-style"/>
		</xsl:call-template>

		<TABLE CELLPADDING="10" WIDTH="100%">
			<TR>
				<TD WIDTH="50%">
					<xsl:apply-templates select="$order-list[position() &lt; 1 + (count($order-list) div 2)]">
					</xsl:apply-templates>
				</TD>
				<TD WIDTH="50%">
					<xsl:apply-templates select="$order-list[position() &gt;= 1 + (count($order-list) div 2)]">
					</xsl:apply-templates>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>

	<!-- draw a blue vertical bar using an image tag with height and width attributes -->
	<xsl:template name="vertical-bar">
		<xsl:with-param name="height"/>
		<xsl:with-param name="total"/>

		<TD VALIGN="BOTTOM">
			<IMG SRC="images/blue.gif" WIDTH="20">
				<xsl:attribute name="HEIGHT"><xsl:value-of select="1 + ((300 * $height) div $total)"/></xsl:attribute>
			</IMG>
		</TD>
	</xsl:template>

	<xsl:template name="monthly-distribution">
		<xsl:param name="dated-items"/>
		<xsl:param name="item-kind"/>
		<xsl:param name="in-header-style"/>

		<xsl:variable name="species-count" select="count($dated-items)"/>

		<xsl:call-template name="tableheader">
			<xsl:with-param name="in-title-string">
				Monthly distribution of <xsl:value-of select="$species-count"/><xsl:text> </xsl:text><xsl:value-of select="$item-kind"/>
			</xsl:with-param>
			<xsl:with-param name="in-header-style" select="$in-header-style"/>
		</xsl:call-template>

		<CENTER><TABLE>
			<TR>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '1/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '2/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '3/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '4/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '5/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '6/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '7/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '8/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '9/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '10/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '11/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[starts-with(date, '12/')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
			</TR>
			<TR>
				<TD>Jan</TD>
				<TD>Feb</TD>
				<TD>Mar</TD>
				<TD>Apr</TD>
				<TD>May</TD>
				<TD>Jun</TD>
				<TD>Jul</TD>
				<TD>Aug</TD>
				<TD>Sep</TD>
				<TD>Oct</TD>
				<TD>Nov</TD>
				<TD>Dec</TD>
			</TR>
		</TABLE></CENTER>
	</xsl:template>

	<xsl:template name="yearly-distribution">
		<xsl:param name="dated-items"/>
		<xsl:param name="item-kind"/>
		<xsl:param name="in-header-style"/>

		<xsl:variable name="species-count" select="count($dated-items)"/>

		<xsl:call-template name="tableheader">
			<xsl:with-param name="in-title-string">
				Yearly distribution of <xsl:value-of select="count($dated-items)"/><xsl:text> </xsl:text><xsl:value-of select="$item-kind"/>
			</xsl:with-param>
			<xsl:with-param name="in-header-style" select="$in-header-style"/>
		</xsl:call-template>

		<CENTER><TABLE>
			<TR>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '1996')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '1997')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '1998')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '1999')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '2000')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
				<xsl:call-template name="vertical-bar">
					<xsl:with-param name="height" select="count($dated-items[contains(date, '2001')])"/>
					<xsl:with-param name="total" select="$species-count"/>
				</xsl:call-template>
			</TR>
			<TR>
				<TD>1996</TD>
				<TD>1997</TD>
				<TD>1998</TD>
				<TD>1999</TD>
				<TD>2000</TD>
				<TD>2001</TD>
			</TR>
		</TABLE></CENTER>
	</xsl:template>
</xsl:stylesheet>
