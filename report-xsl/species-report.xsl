<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<!-- include common templates -->
	<xsl:include href="./common-report.xsl"/>

	<!-- define my background color, used for table headers, etc -->
	<xsl:variable name="my-header-style">species-navigationblock</xsl:variable>

	<!-- define my report parameters -->
	<xsl:param name="in-abbreviation"/>

	<xsl:template match="*">
		<xsl:variable
			name="species-record"
			select="$species/taxonomyset/species[abbreviation=$in-abbreviation]"/>

		<xsl:variable
			name="order-record"
			select="$species/taxonomyset/order[order-id=$species-record/order-id]"/>

		<xsl:variable
			name="family-record"
			select="$species/taxonomyset/family[order-id=$species-record/order-id and
													family-id=$species-record/family-id]"/>

		<xsl:variable
			name="family-record"
			select="$species/taxonomyset/family[order-id=$species-record/order-id and
													family-id=$species-record/family-id]"/>

		<xsl:variable
			name="subfamily-record"
			select="$species/taxonomyset/subfamily[order-id=$species-record/order-id and
													family-id=$species-record/family-id and
													subfamily-id=$species-record/subfamily-id]"/>

		<xsl:variable
			name="genus-record"
			select="$species/taxonomyset/genus[order-id=$species-record/order-id and
													family-id=$species-record/family-id and
													subfamily-id=$species-record/subfamily-id and
													genus-id=$species-record/genus-id]"/>

		<xsl:variable
			name="species-sightings"
			select="$sightings/sightingset/sighting[abbreviation=$in-abbreviation]"/>

		<xsl:variable
			name="species-locations"
			select="$locations/locationset/location[name=$species-sightings/location]"/>

		<xsl:variable
			name="species-trips"
			select="$trips/tripset/trip[date=$species-sightings/date]"/>

		<HTML>
		<HEAD>
		<xsl:call-template name="style-block"/>
		<TITLE>Species Report for <xsl:value-of select="$species-record/common-name"/></TITLE>
		<xsl:comment> $Id: species-report.xsl,v 1.6 2001/09/13 15:44:55 walker Exp $ </xsl:comment>
		</HEAD>

		<BODY BGCOLOR="#FFFFFF">
			<xsl:call-template name="species-navigation-block"/>

			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="5" BORDER="0">
				<xsl:attribute name="CLASS"><xsl:value-of select="$my-header-style"/></xsl:attribute>
			<TR>
				<TD NOWRAP="TRUE">
					<A>
						<xsl:attribute name="HREF">
							<xsl:value-of select="$order-record/report-url"/>
						</xsl:attribute>
						<I><xsl:value-of select="$order-record/latin-name"/></I><BR/>
						<xsl:value-of select="$order-record/common-name"/>
					</A>
				</TD>
				<TD NOWRAP="TRUE">|<BR/>|</TD>
				<TD NOWRAP="TRUE">
					<I><xsl:value-of select="$family-record/latin-name"/></I><BR/>
					<xsl:value-of select="$family-record/common-name"/>
				</TD>
				<TD NOWRAP="TRUE">|<BR/>|</TD>
				<xsl:if test="count($subfamily-record)>0">
					<TD NOWRAP="TRUE">
						<I><xsl:value-of select="$subfamily-record/latin-name"/></I><BR/>
						<xsl:value-of select="$subfamily-record/common-name"/>
					</TD>
					<TD NOWRAP="TRUE">|<BR/>|</TD>
				</xsl:if>
				<TD NOWRAP="TRUE">
					<I><xsl:value-of select="$genus-record/latin-name"/></I><BR/>
					<xsl:value-of select="$genus-record/common-name"/>
				</TD>
				<TD NOWRAP="TRUE" WIDTH="90%">
					<P><BR/></P>
				</TD>
			</TR>
			</TABLE>

			<H1>
				<IMG SRC="images/species.gif"/>
				Species Report for <xsl:value-of select="$species-record/common-name"/>
				<xsl:text> </xsl:text><I>(<xsl:value-of select="$species-record/latin-name"/>)</I>
			</H1>

			<xsl:apply-templates select="$species-record/notes[p[string-length(text())>0]]"/>

			<xsl:call-template name="location-table">
				<xsl:with-param name="location-list" select="$species-locations"/>
			</xsl:call-template>

			<xsl:call-template name="trip-table">
				<xsl:with-param name="trip-list" select="$species-trips"/>
			</xsl:call-template>

			<xsl:call-template name="sightings-table">
				<xsl:with-param name="sighting-list" select="$species-sightings[string-length(notes/p)>0]"/>
			</xsl:call-template>

			<xsl:if test="count($species-sightings) > 15">
				<xsl:call-template name="monthly-distribution">
					<xsl:with-param name="dated-items" select="$species-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
				</xsl:call-template>
	
				<xsl:call-template name="yearly-distribution">
					<xsl:with-param name="dated-items" select="$species-sightings"/>
					<xsl:with-param name="item-kind">sightings</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="species-navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>

	<xsl:template match="sighting">
		<xsl:variable name="this" select="."/>

		<xsl:call-template name="sighting-entry">
			<xsl:with-param name="sighting-record" select="$this"/>

			<!-- <xsl:with-param name="aux-record-3" select="$species/taxonomyset/species[abbreviation=$this/abbreviation]"/> -->
			<xsl:with-param name="aux-record-1" select="$trips/tripset/trip[date=$this/date]"/>
			<xsl:with-param name="aux-record-2" select="$locations/locationset/location[name=$this/location]"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
