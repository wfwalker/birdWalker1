<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:param name="in-tstamp"/>

	<xsl:variable name="miscellaneous" select="document('../misc.xml')"/>

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
		<xsl:comment> $Id: common-report.xsl,v 1.14 2001/10/24 16:16:47 walker Exp $ </xsl:comment>
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

	<xsl:template name="two-column-table">
		<xsl:param name="in-entry-list"/>
		<xsl:param name="in-entry-kind"/>
		<xsl:param name="in-extra-title"/>
		<xsl:param name="in-extra-url"/>
		<xsl:param name="in-header-style"/>

		<P>
			<xsl:call-template name="tableheader">
				<xsl:with-param name="in-title-string">
					<xsl:value-of select="count($in-entry-list)"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$in-entry-kind"/>
				</xsl:with-param>
				<xsl:with-param name="in-extra-url" select="$in-extra-url"/>
				<xsl:with-param name="in-extra-title" select="$in-extra-title"/>
				<xsl:with-param name="in-header-style" select="$in-header-style"/>
			</xsl:call-template>

			<TABLE CELLPADDING="10" WIDTH="100%">
				<TR>
					<TD VALIGN="TOP" WIDTH="50%">
						<xsl:apply-templates select="$in-entry-list[position() &lt; 1 + (count($in-entry-list) div 2)]"/>
					</TD>
					<TD VALIGN="TOP" WIDTH="50%">
						<xsl:apply-templates select="$in-entry-list[position() &gt;= 1 + (count($in-entry-list) div 2)]"/>
					</TD>
				</TR>
			</TABLE>
		</P>
	</xsl:template>

	<!-- displays a set of notes (typically species notes, location notes, or trip notes) -->

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
			<xsl:value-of select="date"/>, <xsl:value-of select="notes/p"/>
		</DIV>
	</xsl:template>

	<xsl:template match="species">
		<A>
			<xsl:if test="sighting/notes[p[string-length(text())>0]]">
				<xsl:attribute name="CLASS">noteworthy-species</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
		</A>

		<xsl:apply-templates select="sighting[notes[p[string-length(text())>0]]]"/>

		<BR/>
	</xsl:template>

	<xsl:template match="trip">
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="report-url"/></xsl:attribute>
			<xsl:value-of select="name"/> (<xsl:value-of select="date"/>)
		</A>

		<xsl:apply-templates select="sighting[notes[p[string-length(text())>0]]]"/>

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
		<xsl:with-param name="in-height"/>
		<xsl:with-param name="in-maximum"/>
		<xsl:with-param name="in-bar-count"/>

		<TD ALIGN="CENTER" VALIGN="BOTTOM">
			<IMG SRC="images/blue.gif" WIDTH="20">
				<xsl:attribute name="HEIGHT"><xsl:value-of select="1 + ((20 * $in-bar-count * $in-height) div $in-maximum)"/></xsl:attribute>
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
				<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
					<xsl:variable name="date-prefix" select="concat(@index, '/')"/>

					<xsl:call-template name="vertical-bar">
						<xsl:with-param name="in-height" select="count($dated-items[starts-with(date, $date-prefix)])"/>
						<xsl:with-param name="in-maximum" select="$species-count"/>
						<xsl:with-param name="in-bar-count">12</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</TR>
			<TR>
				<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
					<TD ALIGN="CENTER">
						<xsl:value-of select="@abbreviation"/>
					</TD>
				</xsl:for-each>
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
				<xsl:for-each select="$miscellaneous/miscellaneous/yearset/year">
					<xsl:variable name="year-name" select="@name"/>

					<xsl:call-template name="vertical-bar">
						<xsl:with-param name="in-height" select="count($dated-items[contains(date, $year-name)])"/>
						<xsl:with-param name="in-maximum" select="$species-count"/>
						<xsl:with-param name="in-bar-count" select="count($miscellaneous/miscellaneous/yearset/year)"/>
					</xsl:call-template>
				</xsl:for-each>
			</TR>
			<TR>
				<xsl:for-each select="$miscellaneous/miscellaneous/yearset/year">
					<TD ALIGN="CENTER">
						<xsl:value-of select="@name"/>
					</TD>
				</xsl:for-each>
			</TR>
		</TABLE></CENTER>
	</xsl:template>
</xsl:stylesheet>
