<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method = "html" indent="no"/>

	<!-- <xsl:include href="sightings-common.xsl"/> -->

	<xsl:template match="sightingset">
		<HTML>
		<HEAD><TITLE>Sightings by Location</TITLE></HEAD>
		
		<BODY>

		<!-- compute lists of location -->

		<xsl:variable name="location-list" select="sighting/location[not(.=following::location)]" />

		<H1 STYLE="font:18pt Tahoma">Sightings by Location</H1>

		<P>
		<xsl:for-each select="$location-list">
			<xsl:element name="A">
				<xsl:attribute name="HREF">
					#<xsl:value-of select="."/>
				</xsl:attribute>

				<xsl:value-of select="."/>
			</xsl:element>, 
		</xsl:for-each>
		</P>

		<!-- SIGHTINGS BY LOCATION DETAILS TABLES -->

		<xsl:for-each select="$location-list">
			<xsl:variable name="this" select="." />
			<xsl:variable name="location-sightings" select="/sightingset/sighting[location=$this]"/>
			<xsl:variable name="location-dates" select="$location-sightings/date[not(.=following::sighting[location=$this]/date)]"/>

			<xsl:element name="A">
				<xsl:attribute name="NAME">
					<xsl:value-of select="."/>
				</xsl:attribute>

				<H2 STYLE="font: 14pt Tahoma"><xsl:value-of select="$this"/></H2>
			</xsl:element>

			<P STYLE="font: 12pt Tahoma">
				<xsl:value-of select="count($location-sightings)"/> sightings on
				<xsl:value-of select="count($location-dates)"/> date(s)
			</P>

			<P>
				<xsl:for-each select="$location-dates">
					<xsl:value-of select="."/>, 
				</xsl:for-each>
			</P>
			
			<TABLE WIDTH="50%">
				<xsl:for-each select="$location-sightings">
					<TR>
						<TD STYLE="font: 10pt Tahoma">
							<xsl:value-of select="common-name"/>
						</TD>
						<TD STYLE="font: 10pt Courier">
							<xsl:value-of select="abbreviation"/>
						</TD>
						<TD STYLE="font: 10pt Tahoma"><xsl:value-of select="date"/></TD>

					</TR>
				</xsl:for-each>
			</TABLE>

		</xsl:for-each>

		</BODY>

		</HTML>
	</xsl:template>

</xsl:stylesheet>
