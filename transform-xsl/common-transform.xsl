<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<!-- define variables containing all the source data -->
	<xsl:variable name="trips" select="document('../flat-trips.xml')"/>
	<xsl:variable name="sightings" select="document('../sightings.xml')"/>
	<xsl:variable name="species" select="document('../flat-species.xml')"/>
	<xsl:variable name="locations" select="document('../locations.xml')"/>
	<xsl:variable name="miscellaneous" select="document('../misc.xml')"/>


	<xsl:template match="p">
		&lt;p&gt;<xsl:value-of select="."/>&lt;/p&gt;
	</xsl:template>

	<xsl:template match="notes">
		&lt;notes&gt;<xsl:apply-templates select="p"/>&lt;/notes&gt;
	</xsl:template>

	<xsl:template match="exclude">
	     &lt;exclude&gt;true&lt;/exclude&gt;
	</xsl:template>

	<xsl:template match="first">
	    &lt;first&gt;true&lt;/first&gt;
	</xsl:template>

	<xsl:template match="photo">
	    &lt;photo&gt;true&lt;/photo&gt;
	</xsl:template>

</xsl:stylesheet>
