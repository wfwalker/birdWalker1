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
					<SPAN CLASS="navigation-text"><A HREF="./index.html"><CODE>&lt;birdWalker&gt;</CODE></A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$species-class"/></xsl:attribute>
					<xsl:if test="starts-with($species-class, 'default')"><IMG SRC="images/species.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="./species-index.html">Species Reports</A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$location-class"/></xsl:attribute>
					<xsl:if test="starts-with($location-class, 'default')"><IMG SRC="images/location.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="./location-index.html">Location Reports</A></SPAN>
				</TD>
				<TD ALIGN="CENTER" WIDTH="25%">
					<xsl:attribute name="CLASS"><xsl:value-of select="$trip-class"/></xsl:attribute>
					<xsl:if test="starts-with($trip-class, 'default')"><IMG SRC="images/trip.gif" ALIGN="MIDDLE"/></xsl:if>
					<SPAN CLASS="navigation-text"><A HREF="./trip-index.html">Trip Reports</A></SPAN>
				</TD>
			</TR>
		</TABLE>
		<xsl:comment> $Id: common-report.xsl,v 1.21 2002/01/22 17:27:30 walker Exp $ </xsl:comment>
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

	<xsl:template mode="with-date" match="sighting/first">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text><xsl:value-of select="../date"/>, first sighting</SPAN>
	</xsl:template>

	<xsl:template mode="without-date" match="sighting/first">
		<SPAN CLASS="anchor-subtitle"><xsl:text> </xsl:text>first sighting</SPAN>
	</xsl:template>

	<!-- template to display dates -->

	<xsl:template match="date">
		<xsl:variable name="month-index" select="substring(text(), 6, 2)"/>
		<xsl:variable name="day-index" select="substring(text(), 9, 2)"/>
		<xsl:variable name="year-index" select="substring(text(), 1, 4)"/>

		<xsl:value-of select="$miscellaneous/miscellaneous/monthset/month[@index=$month-index]/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$day-index"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$year-index"/>
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

	<xsl:template match="/generate-order-report/species/sighting">
		<DIV CLASS="sighting-notes">
			<xsl:value-of select="date"/>, <xsl:value-of select="location"/>, <xsl:value-of select="notes/p"/>
		</DIV>
	</xsl:template>

	<!-- templates to display the names of, and links to, the basic report pages -->

	<xsl:template match="species">
		<A>
			<xsl:if test="sighting/notes or sighting/first">
				<xsl:attribute name="CLASS">noteworthy-species</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
		</A>

		<xsl:apply-templates mode="without-date" select="sighting/first"/>
		<BR/>

		<xsl:apply-templates select="sighting[notes]"/>
	</xsl:template>

	<xsl:template match="generate-year-report/species">
		<A>
			<xsl:if test="sighting/first">
				<xsl:attribute name="CLASS">noteworthy-species</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
		</A>

		<xsl:apply-templates mode="with-date" select="sighting/first"/>
		<BR/>
	</xsl:template>

	<xsl:template match="trip">
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="date"/></SPAN>
		</A>

		<BR/>
		<xsl:apply-templates select="sighting[notes]"/>

	</xsl:template>

	<xsl:template match="location">
		<A>
			<xsl:attribute name="HREF">./<xsl:value-of select="filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="city"/>, <xsl:value-of select="state"/></SPAN>
		</A>
		<BR/>
	</xsl:template>

	<xsl:template match="order">
		<B><A>
			<xsl:attribute name="HREF"><xsl:value-of select="filename-stem"/>.html</xsl:attribute>
			<xsl:value-of select="common-name"/>
			<xsl:text> </xsl:text>
			<SPAN CLASS="anchor-subtitle"><xsl:value-of select="latin-name"/></SPAN>
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

			<IMG SRC="images/blue.gif" WIDTH="20">
				<xsl:attribute name="HEIGHT"><xsl:value-of select="1 + ((20 * $in-bar-count * $in-height) div $in-maximum)"/></xsl:attribute>
			</IMG>
		</TD>
	</xsl:template>

	<xsl:template name="time-distributions">
		<xsl:param name="in-dated-items"/>

		<xsl:variable name="item-count" select="count($in-dated-items)"/>

		<DIV CLASS="report-content">
		<TABLE WIDTH="90%">
			<!-- one big cell for monthly distribution -->
			<TD WIDTH="50%">
				<TABLE>
					<TR>
						<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
							<xsl:variable name="date-prefix" select="concat('-', @index, '-')"/>
		
							<xsl:call-template name="vertical-bar">
								<xsl:with-param name="in-height" select="count($in-dated-items[contains(date, $date-prefix)])"/>
								<xsl:with-param name="in-maximum" select="$item-count"/>
								<xsl:with-param name="in-bar-count" select="'12'"/>
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
				</TABLE>
			</TD>

			<!-- one big cell for yearly distribution -->
			<TD WIDTH="50%">
				<TABLE>
					<TR>
						<xsl:for-each select="$miscellaneous/miscellaneous/yearset/year">
							<xsl:variable name="year-name" select="@name"/>
		
							<xsl:call-template name="vertical-bar">
								<xsl:with-param name="in-height" select="count($in-dated-items[contains(date, $year-name)])"/>
								<xsl:with-param name="in-maximum" select="$item-count"/>
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
				</TABLE>
			</TD>
		</TABLE>
		</DIV>
	</xsl:template>

	<xsl:template name="order-by-month-table">
		<xsl:param name="in-species-with-sightings"/>
		<xsl:param name="in-trips"/>

		<DIV CLASS="report-content">
		<TABLE WIDTH="90%" CELLSPACING="0" BORDER="0">
			<TR>
				<TD ALIGN="RIGHT">Order</TD>
				<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
					<TD ALIGN="RIGHT"><xsl:value-of select="@abbreviation"/></TD>	
				</xsl:for-each>
			</TR>

			<!-- spacer row -->
			<TR>
				<TD COLSPAN="13"><IMG SRC="images/spacer.gif" HEIGHT="5" WIDTH="5"/></TD>
			</TR>

			<xsl:for-each select="$miscellaneous/miscellaneous/orderset/order[order-id=$in-species-with-sightings/order-id]">
				<TR>
					<xsl:variable name="the-order" select="."/>

					<xsl:variable
						name="order-sightings-this-location"
						select="$in-species-with-sightings[order-id=$the-order/order-id]/sighting"/>

					<TD ALIGN="RIGHT">
						<A>
							<xsl:attribute name="HREF"><xsl:value-of select="$the-order/filename-stem"/>.html</xsl:attribute>
							<xsl:value-of select="$the-order/common-name"/>
						</A>
					</TD>

					<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
						<xsl:variable
							name="date-prefix"
							select="concat('-', @index, '-')"/>

						<xsl:variable
							name="trips-this-month"
							select="$in-trips[contains(date, $date-prefix)]"/>

						<xsl:variable
							name="order-sightings-this-month"
							select="$order-sightings-this-location[date=$trips-this-month/date]"/>

						<TD ALIGN="RIGHT">
							<xsl:choose>
								<xsl:when test="count($trips-this-month)=0">
									<xsl:attribute name="CLASS">density0</xsl:attribute>
									-
								</xsl:when>
								<xsl:when test="count($order-sightings-this-month) > 0">
									<xsl:variable
										name="density"
										select="ceiling(count($order-sightings-this-month) div count($trips-this-month))"/>

									<xsl:attribute name="CLASS">density<xsl:value-of select="$density"/></xsl:attribute>
									<xsl:value-of select="$density"/>
								</xsl:when>
							</xsl:choose>
						</TD>
					</xsl:for-each>
				</TR>

				<!-- spacer row -->
				<TR>
					<TD COLSPAN="13"><IMG SRC="images/spacer.gif" HEIGHT="5" WIDTH="5"/></TD>
				</TR>
			</xsl:for-each>

			<TR>
				<TD ALIGN="RIGHT">Total Trips</TD>
				<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
					<xsl:variable name="date-prefix" select="concat(@index, '/')"/>

					<TD ALIGN="RIGHT">
						<xsl:value-of select="count($in-trips[starts-with(date, $date-prefix)])"/>
					</TD>	
				</xsl:for-each>
			</TR>

			<TR>
				<TD ALIGN="RIGHT">Total Sightings</TD>
				<xsl:for-each select="$miscellaneous/miscellaneous/monthset/month">
					<xsl:variable name="date-prefix" select="concat(@index, '/')"/>

					<xsl:variable
						name="trips-this-month"
						select="$in-trips[starts-with(date, $date-prefix)]"/>

					<xsl:variable
						name="sightings-this-month"
						select="$in-species-with-sightings/sighting[date=$trips-this-month/date]"/>

					<TD ALIGN="RIGHT">
						<xsl:value-of select="count($sightings-this-month)"/>
					</TD>	
				</xsl:for-each>
			</TR>
		</TABLE>
		</DIV>
	</xsl:template>

</xsl:stylesheet>
