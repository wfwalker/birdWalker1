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
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./species-index.html">Species Reports</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./location-index.html">Location Reports</A></TD>
				<TD ALIGN="CENTER" BGCOLOR="#DDDDDD" WIDTH="25%"><A HREF="./trip-index.html">Trip Reports</A></TD>
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

		<xsl:if test="count($sighting-list) > 0">
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

	<xsl:template name="order-table">
		<xsl:call-template name="tableheader">
			<xsl:with-param name="title-string">
				22 orders
			</xsl:with-param>
		</xsl:call-template>

		<TABLE CELLPADDING="10" WIDTH="100%">
		<TR>
		<TD WIDTH="50%">
		<A HREF="gaviiformes.html"><I>(Gaviiformes)</I> Loons</A><BR/>
		<A HREF="podicipediformes.html"><I>(Podicipediformes)</I> Grebes</A><BR/>
		<A HREF="procellariiformes.html"><I>(Procellariiformes)</I> Tube-nosed Swimmers</A><BR/>
		<A HREF="pelecaniformes.html"><I>(Pelecaniformes)</I> Totipalmate Swimmers</A><BR/>
		<A HREF="ciconiiformes.html"><I>(Ciconiiformes)</I> Herons, Ibises, Storks and Allies</A><BR/>
		<A HREF="phoenicopteriformes.html"><I>(Phoenicopteriformes)</I> Flamingos</A><BR/>
		<A HREF="anseriformes.html"><I>(Anseriformes)</I> Screamers, Swans, Geese and Ducks</A><BR/>
		<A HREF="falconiformes.html"><I>(Falconiformes)</I> Diurnal Birds of Prey</A><BR/>
		<A HREF="galliformes.html"><I>(Galliformes)</I> Gallinaceous Birds</A><BR/>
		<A HREF="gruiformes.html"><I>(Gruiformes)</I> Rails, Cranes and Allies</A><BR/>
		<A HREF="charadriiformes.html"><I>(Charadriiformes)</I> Shorebirds, Gulls, Auks and Allies</A><BR/>
		</TD>
		<TD WIDTH="50%">
		<A HREF="columbiformes.html"><I>(Columbiformes)</I> Sandgrouse, Pigeons and Doves</A><BR/>
		<A HREF="psittaciformes.html"><I>(Psittaciformes)</I> Parrots and Allies</A><BR/>
		<A HREF="cuculiformes.html"><I>(Cuculiformes)</I> Cuckoos and Allies</A><BR/>
		<A HREF="strigiformes.html"><I>(Strigiformes)</I> Owls</A><BR/>
		<A HREF="caprimulgiformes.html"><I>(Caprimulgiformes)</I> Goatsuckers, Oilbirds and Allies</A><BR/>
		<A HREF="apodiformes.html"><I>(Apodiformes)</I> Swifts and Hummingbirds</A><BR/>
		<A HREF="trogoniformes.html"><I>(Trogoniformes)</I> Trogons</A><BR/>
		<A HREF="upupiformes.html"><I>(Upupiformes)</I> Hoopoes and Allies</A><BR/>
		<A HREF="coraciiformes.html"><I>(Coraciiformes)</I> Rollers, Motmots, Kingfishers and Allies</A><BR/>
		<A HREF="piciformes.html"><I>(Piciformes)</I> Puffbirds, Toucans, Woodpeckers and Allies</A><BR/>
		<A HREF="passeriformes.html"><I>(Passeriformes)</I> Passerine Bird</A><BR/>
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

		<xsl:variable name="species-count" select="count($dated-items)"/>

		<xsl:call-template name="tableheader">
			<xsl:with-param name="title-string">
				Monthly distribution of <xsl:value-of select="$species-count"/><xsl:text> </xsl:text><xsl:value-of select="$item-kind"/>
			</xsl:with-param>
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

		<xsl:variable name="species-count" select="count($dated-items)"/>

		<xsl:call-template name="tableheader">
			<xsl:with-param name="title-string">
				Yearly distribution of <xsl:value-of select="count($dated-items)"/><xsl:text> </xsl:text><xsl:value-of select="$item-kind"/>
			</xsl:with-param>
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
