<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- *** YEAR REPORT *** -->

	<xsl:template match="generate-year-report">
		<!-- define my report parameter -->
		<xsl:variable name="year-name" select="@year-name"/>

		<xsl:message>generate report for year <xsl:value-of select="$year-name"/></xsl:message>
		<xsl:message>species with non excluded sighting<xsl:value-of select="count(species[sighting[not(exclude)]])"/></xsl:message>
		<xsl:message>species <xsl:value-of select="count(species)"/></xsl:message>

		<xsl:variable
			name="year-sightings"
			select="species/sighting"/>

		<xsl:variable
			name="year-species"
			select="species[sighting[not(exclude)]]"/>

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Index of Species seen in <xsl:value-of select="$year-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="species-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="images/species.gif" ALIGN="MIDDLE"/>
						<xsl:value-of select="$year-name"/> Species List
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our annual list for <xsl:value-of select="$year-name"/> contains <xsl:value-of select="count($year-species)"/> species,
				including <xsl:value-of select="count($year-sightings/first)"/> new species.
			</DIV>

<!--
			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="$year-species"/>
			</xsl:call-template>
-->

			<P></P>


			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">

			<!-- paper checklist-style table, showing trips and species -->

			<xsl:for-each select="/generate-year-report/species">

				<!-- print the headings every 20 rows -->

				<xsl:if test="(position() mod 20) = 1">
					<TR>
						<TD> </TD>
						<xsl:for-each select="/generate-year-report/trip">
							<xsl:variable name="the-trip" select="."/>
							<xsl:variable name="the-trip-index" select="position()"/>
							<xsl:variable name="previous-trip" select="/generate-year-report/trip[position()=($the-trip-index - 1)]"/>

							<!-- only repeat the month part of the column heading if it is different from last time -->
							<xsl:if test="substring($previous-trip/date, 6, 2)!=substring(date/text(), 6, 2)">
								<TD VALIGN="BOTTOM">
									<xsl:variable name="month-num" select="substring($the-trip/date/text(), 6, 2)"/>
									<xsl:variable name="month-trip-count" select="count(/generate-year-report/trip[substring(date, 6, 2)=substring($the-trip/date, 6, 2)])"/>

									<xsl:attribute name="COLSPAN">
										<xsl:value-of select="$month-trip-count"/>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="($month-num mod 2) = 0">
											<xsl:attribute name="class">year-col-color</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="class">year-plain</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>

									<xsl:variable name="the-month" select="$miscellaneous/miscellaneous/monthset/month[@index=$month-num]/@abbreviation"/>
									<xsl:value-of select="substring($the-month, 1, 1)"/>
									<xsl:if test="$month-trip-count > 1">
										<xsl:value-of select="substring($the-month, 2, 1)"/>
									</xsl:if>
									<xsl:if test="$month-trip-count > 2">
										<xsl:value-of select="substring($the-month, 3, 1)"/>
									</xsl:if>
								</TD>
							</xsl:if>
						</xsl:for-each>
					</TR>

					<TR>
						<TD> </TD>
						<xsl:for-each select="/generate-year-report/trip">
							<TD VALIGN="BOTTOM">
								<xsl:choose>
									<xsl:when test="(position() mod 2) = 0">
										<xsl:attribute name="class">year-col-color</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">year-plain</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<A>
									<xsl:attribute name="HREF"><xsl:value-of select="filename-stem"/>.html</xsl:attribute>
									<xsl:value-of select="substring(date/text(), 9, 1)"/><BR/>
									<xsl:value-of select="substring(date/text(), 10, 1)"/>
								</A>
							</TD>
						</xsl:for-each>
					</TR>
				</xsl:if>

				<!-- print the species name, followed by the X's for each trip -->
				<xsl:variable name="the-species" select="."/>
				<TR>
					<!-- alternating background colors -->
					<xsl:choose>
						<xsl:when test="(position() mod 2) = 0">
							<xsl:attribute name="class">year-row-color</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">year-plain</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>

					<TD><A>
						<xsl:attribute name="HREF">./<xsl:value-of select="abbreviation"/>.html</xsl:attribute>
						<xsl:value-of select="common-name"/>
					</A></TD>

					<!-- iterate through all the trips, looking for sightings of this species -->

					<xsl:for-each select="/generate-year-report/trip">
						<xsl:variable name="the-trip" select="."/>

						<TD>
							<!-- alternating background colors -->
							<xsl:choose>
								<xsl:when test="(position() mod 2) = 0">
									<xsl:attribute name="class">year-col-color</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">year-plain</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
	
							<xsl:choose>
								<xsl:when test="count($the-species/sighting[date=$the-trip/date]/first) > 0">F</xsl:when>
								<xsl:when test="count($the-species/sighting[date=$the-trip/date]/exclude) > 0">e</xsl:when>
								<xsl:when test="count($the-species/sighting[date=$the-trip/date][not(exclude)]) > 0">X</xsl:when>
								<xsl:otherwise><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></xsl:otherwise>
							</xsl:choose>
						</TD>
					</xsl:for-each>
				</TR>
			</xsl:for-each>


			<!-- loop through the trips one last time, showing species totals and month species totals -->
				<TR>
					<TD>Month</TD>
					<xsl:for-each select="/generate-year-report/trip">
						<xsl:variable name="the-trip" select="."/>
						<xsl:variable name="the-trip-index" select="position()"/>
						<xsl:variable name="previous-trip" select="/generate-year-report/trip[position()=($the-trip-index - 1)]"/>

						<!-- only repeat the month part of the column heading if it is different from last time -->
						<xsl:if test="substring($previous-trip/date, 6, 2)!=substring(date/text(), 6, 2)">
							<TD VALIGN="BOTTOM" CLASS="year-plain">
								<xsl:attribute name="COLSPAN">
									<xsl:value-of select="count(/generate-year-report/trip[substring(date, 6, 2)=substring($the-trip/date, 6, 2)])"/>
								</xsl:attribute>

								<xsl:variable name="month-count" select="count(/generate-year-report/species[sighting[substring(date, 6, 2)=substring($the-trip/date/text(), 6, 2)]])"/><BR/>
								<xsl:value-of select="substring($month-count, 1, 1)"/><BR/>
								<xsl:value-of select="substring($month-count, 2, 1)"/><BR/>
								<xsl:value-of select="substring($month-count, 3, 1)"/><BR/>
							</TD>
						</xsl:if>
					</xsl:for-each>
				</TR>

				<!-- <TR>
					<TD>Trip</TD>
					<xsl:for-each select="/generate-year-report/trip">
						<xsl:variable name="the-trip" select="."/>
						<TD VALIGN="BOTTOM" CLASS="year-plain">
							<xsl:value-of select="count(/generate-year-report/species[sighting[date=$the-trip/date]])"/><BR/>
						</TD>
					</xsl:for-each>
				</TR> -->
			</TABLE>

			<P>
			</P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>


	<!-- *** LOCATION REPORT *** -->

	<xsl:template match="generate-location-report">
		<xsl:message>
			Generating Location Report for '<xsl:value-of select="@location-name"/>'
			sightings <xsl:value-of select="count(species/sighting)"/>
			trips <xsl:value-of select="count(trip)"/>
			species <xsl:value-of select="count(species)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Location Report for <xsl:value-of select="@location-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="location-navigation-block"/>

			<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="0" CLASS="location-color">
				<TR>
					<TD COLSPAN="9" CLASS="pagetitle">
						<IMG SRC="images/location.gif" ALIGN="LEFT"/>
						<xsl:value-of select="location/name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle">
							<xsl:value-of select="location/city"/><xsl:text>, </xsl:text><xsl:value-of select="location/state"/>
						</SPAN>
					</TD>
				</TR>

				<TR>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="location/county"/> County

						<xsl:if test="string-length(location/url)>0">
							<BR/>
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="location/url"/>
								</xsl:attribute>
								Location Website
							</A>
					</xsl:if>
					</TD>
					<xsl:if test="string-length(location/latitude)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD ALIGN="RIGHT" NOWRAP="TRUE">
							<xsl:text>N </xsl:text><xsl:value-of select="location/latitude"/>&#176;<BR/>
							<xsl:text>W </xsl:text><xsl:value-of select="location/longitude"/>&#176;
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						first visited <xsl:value-of select="species/sighting[position()=1]/date"/><BR/>
						last visited <xsl:value-of select="species/sighting[position()=last()]/date"/><BR/>
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<xsl:apply-templates mode="report-content" select="location/notes"/>

			<DIV CLASS="headertext">
				<xsl:value-of select="count(species)"/> species observed at <xsl:value-of select="location/name"/>,
				including <xsl:value-of select="count(species/sighting/first)"/> first sightings.
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="count(trip)"/> trips taken to <xsl:value-of select="location/name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
			</xsl:call-template>

			<xsl:if test="count(trip) > 15">
				<DIV CLASS="headertext">
					Distribution of <xsl:value-of select="location/name"/> trips over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="trip"/>
				</xsl:call-template>
	
				<!-- monthly distribution by order -->
				<DIV CLASS="headertext">
					Distribution of <xsl:value-of select="location/name"/> sightings over time
				</DIV>

				<xsl:call-template name="order-by-month-table">
					<xsl:with-param name="in-species-with-sightings" select="species"/>
					<xsl:with-param name="in-trips" select="trip"/>
				</xsl:call-template>
			</xsl:if>
	
			<P></P>

			<xsl:call-template name="location-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>

	</xsl:template>

	<xsl:template match="generate-species-report">
		<!-- define my report parameters -->
		<xsl:variable
			name="in-abbreviation"
			select="@abbreviation"/>

		<xsl:message>
			Generating Species Report for '<xsl:value-of select="species/common-name"/>'
			species-sightings <xsl:value-of select="count(trip/sighting)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for <xsl:value-of select="species/common-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-color" CELLPADDING="5" BORDER="0">

			<TR>
				<TD COLSPAN="10" CLASS="pagetitle">
					<IMG SRC="images/species.gif" ALIGN="LEFT"/>
					<xsl:value-of select="species/common-name"/>
					<!-- <xsl:text> </xsl:text> -->
					<BR/>
					<SPAN CLASS="pagesubtitle"><xsl:value-of select="species/latin-name"/></SPAN>
				</TD>
			</TR>

			<TR>
				<TD ALIGN="RIGHT" NOWRAP="TRUE">Order<BR/>Family</TD>
				<TD NOWRAP="TRUE">
					<A>
						<xsl:attribute name="HREF">
							<xsl:value-of select="order/filename-stem"/>.html
						</xsl:attribute>
						<I><xsl:value-of select="order/latin-name"/></I><xsl:text>, </xsl:text><xsl:value-of select="order/common-name"/>
					</A><BR/>
					<I><xsl:value-of select="family/latin-name"/></I><xsl:text>, </xsl:text><xsl:value-of select="family/common-name"/>
				</TD>
				<xsl:if test="string-length(species/url)>0">
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<A>
						<xsl:attribute name="HREF">
						<xsl:value-of select="species/url"/>
						</xsl:attribute>
						Species Website
						</A>
					</TD>
				</xsl:if>
				<TD NOWRAP="TRUE">|<BR/>|</TD>
				<TD NOWRAP="TRUE">
					<!-- note, the following expressions assume sightings are in chronological order -->
					first seen <xsl:value-of select="trip[position()=1]/sighting/date"/><BR/>
					last seen <xsl:value-of select="trip[position()=last()]/sighting/date"/><BR/>
				</TD>
				<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
				</TD>
			</TR>
			</TABLE>

			<xsl:apply-templates mode="report-content" select="species/notes"/>

			<DIV CLASS="headertext">
				<xsl:value-of select="species/common-name"/> observed at <xsl:value-of select="count(location)"/> locations
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="location"/>
			</xsl:call-template>

			<DIV CLASS="headertext">
				<xsl:value-of select="species/common-name"/> observed on <xsl:value-of select="count(trip)"/> trips
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="trip"/>
			</xsl:call-template>

			<xsl:if test="count(trip/sighting) > 15">
				<DIV CLASS="headertext">
					Distribution of <xsl:value-of select="species/common-name"/> sightings over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="trip/sighting"/>
				</xsl:call-template>
			</xsl:if>

			<P></P>
			
			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-trip-report">
		<xsl:variable
			name="trip-sightings"
			select="species/sighting"/>

		<xsl:variable
			name="trip-species"
			select="species"/>

		<xsl:message>
			Generating Trip Report for '<xsl:value-of select="trip/name"/>'
			species <xsl:value-of select="count($trip-species)"/>
			location <xsl:value-of select="count(location)"/>
			sightings <xsl:value-of select="count($trip-sightings)"/>
		</xsl:message>

		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Trip Report for <xsl:value-of select="trip/name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="trip-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="trip-color" CELLPADDING="5" BORDER="0">
				<TR>
					<TD COLSPAN="6" CLASS="pagetitle">
						<IMG SRC="images/trip.gif" ALIGN="LEFT"/>
						<xsl:value-of select="trip/name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle"><xsl:apply-templates select="trip/date"/></SPAN>
					</TD>
				</TR>
				<TR>
					<TD NOWRAP="TRUE">
						Leader
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="trip/leader"/>
					</TD>
					<xsl:if test="string-length(trip/url)>0">
						<TD NOWRAP="TRUE">|<BR/>|</TD>
						<TD NOWRAP="TRUE">
							<A>
								<xsl:attribute name="HREF">
									<xsl:value-of select="trip/url"/>
								</xsl:attribute>
								Trip Website
							</A>
						</TD>
					</xsl:if>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(species)"/> species<BR/>
						<xsl:value-of select="count(location)"/> locations
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>


			<xsl:apply-templates mode="report-content" select="trip/notes"/>

			<xsl:for-each select="location">
				<xsl:variable name="this-location-name" select="name"/>
				<xsl:variable name="this-location-sightings" select="$trip-sightings[location=$this-location-name]"/>
				<xsl:variable name="this-location-species" select="$trip-species[sighting/location=$this-location-name]"/>

				<xsl:message>loop name <xsl:value-of select="$this-location-name"/> sightings <xsl:value-of select="count($this-location-sightings)"/> species <xsl:value-of select="count($this-location-species)"/></xsl:message>

				<DIV CLASS="headertext">
					<xsl:value-of select="count($this-location-species)"/> species seen at
					<A>
						<xsl:attribute name="HREF"><xsl:value-of select="filename-stem"/>.html</xsl:attribute>
						<xsl:value-of select="$this-location-name"/>
					</A>
				</DIV>

				<xsl:call-template name="two-column-table">
					<xsl:with-param name="in-entry-list" select="$this-location-species"/>
				</xsl:call-template>
			</xsl:for-each>

			<P></P>

			<xsl:call-template name="trip-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

	<xsl:template match="generate-order-report">
		<!-- define my report parameters -->
		<xsl:variable name="in-order-id" select="@in-order-id"/>
	
		<xsl:message>
			Generating Order Report for '<xsl:value-of select="order/latin-name"/>'
		</xsl:message>

		<HEAD>
			<xsl:call-template name="style-block"/>
			<TITLE>Species Report for Order <xsl:value-of select="order/latin-name"/></TITLE>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CLASS="species-color" CELLPADDING="5" BORDER="0">
				<TR>
					<TD CLASS="pagetitle" NOWRAP="TRUE" COLSPAN="6">
						<IMG SRC="images/species.gif" ALIGN="LEFT"/>
						<xsl:value-of select="order/latin-name"/>
						<BR/>
						<SPAN CLASS="pagesubtitle"><xsl:value-of select="order/common-name"/></SPAN>
					</TD>
				</TR>

				<TR>
					<TD NOWRAP="TRUE">
						Families<BR/>Subfamilies
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(family)"/><BR/>
						<xsl:value-of select="count(subfamily)"/>
					</TD>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
					<TD NOWRAP="TRUE">
						Genera<BR/>Species
					</TD>
					<TD NOWRAP="TRUE">
						<xsl:value-of select="count(genus)"/><BR/>
						<xsl:value-of select="count(species)"/>
					</TD>
					<TD NOWRAP="TRUE" WIDTH="90%">
						<P><BR/></P>
					</TD>
				</TR>
			</TABLE>

			<DIV CLASS="headertext">
				Our Life List includes <xsl:value-of select="count(species[sighting])"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="order/common-name"/>
			</DIV>

			<xsl:call-template name="two-column-table">
				<xsl:with-param name="in-entry-list" select="species[sighting]"/>
			</xsl:call-template>

			<xsl:if test="count(species/sighting) > 15">
				<DIV CLASS="headertext">
					Distribution of <xsl:value-of select="order/latin-name"/> sightings over time
				</DIV>

				<xsl:call-template name="time-distributions">
					<xsl:with-param name="in-dated-items" select="species/sighting"/>
				</xsl:call-template>
			</xsl:if>

			<P></P>

			<xsl:call-template name="species-navigation-block"/>
			<xsl:call-template name="page-footer"/>
		</BODY>
	</xsl:template>

</xsl:stylesheet>
