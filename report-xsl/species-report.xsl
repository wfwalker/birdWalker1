<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="yes"/>

	<xsl:include href="./common-report.xsl"/>

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
		</HEAD>

		<BODY>
			<xsl:call-template name="navigation-block"/>

			<DIV CLASS="tablehead">
			<TABLE>
			<TR>
				<TD>
					<I><xsl:value-of select="$order-record/latin-name"/></I><BR/>
					<xsl:value-of select="$order-record/common-name"/>
				</TD>
				<TD>&gt;</TD>
				<TD>
					<I><xsl:value-of select="$family-record/latin-name"/></I><BR/>
					<xsl:value-of select="$family-record/common-name"/>
				</TD>
				<TD>&gt;</TD>
				<xsl:if test="count($subfamily-record)>0">
					<TD>
						<I><xsl:value-of select="$subfamily-record/latin-name"/></I><BR/>
						<xsl:value-of select="$subfamily-record/common-name"/>
					</TD>
					<TD>&gt;</TD>
				</xsl:if>
				<TD>
					<I><xsl:value-of select="$genus-record/latin-name"/></I><BR/>
					<xsl:value-of select="$genus-record/common-name"/>
				</TD>
			</TR>
			</TABLE>
			</DIV>

			<H1>
				<IMG SRC="images/species.gif"/><xsl:value-of select="$species-record/common-name"/>
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
				<xsl:with-param name="sighting-list" select="$species-sightings"/>
			</xsl:call-template>

			<xsl:call-template name="navigation-block"/>
		</BODY>

		</HTML>
	</xsl:template>
</xsl:stylesheet>
