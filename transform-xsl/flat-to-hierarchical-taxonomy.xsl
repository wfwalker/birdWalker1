<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="taxonomy">
		<taxonomyset>
			<phylum common-name="Birds">
				<xsl:apply-templates select="taxonomy1"/>
			</phylum>
		</taxonomyset>
	</xsl:template>

	<xsl:template match="taxonomy1">
		<xsl:variable name="this-order" select="order"/>

  		<order>
			<xsl:attribute name="common-name"><xsl:value-of select="common-name"/></xsl:attribute>
			<xsl:attribute name="latin-name"><xsl:value-of select="latin-name"/></xsl:attribute>
			 
			<taxonomy>
				<id><xsl:value-of select="taxonomy-id"/></id>
				<order-id><xsl:value-of select="order"/></order-id>
			</taxonomy>
			 
			<xsl:apply-templates select="/taxonomy/taxonomy2[order=$this-order]"/>
		</order>
	</xsl:template>

	<xsl:template match="taxonomy2">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>

		<family>
			<xsl:attribute name="common-name"><xsl:value-of select="common-name"/></xsl:attribute>
			<xsl:attribute name="latin-name"><xsl:value-of select="latin-name"/></xsl:attribute>

			<taxonomy>
				<id><xsl:value-of select="taxonomy-id"/></id>
				<order-id><xsl:value-of select="order"/></order-id>
				<family-id><xsl:value-of select="family"/></family-id>
			</taxonomy>

			<xsl:if test="count(/taxonomy/taxonomy3[order=$this-order and family=$this-family])=0">
				<xsl:apply-templates select="/taxonomy/taxonomy4[order=$this-order and family=$this-family]"/>
			</xsl:if>

			<xsl:if test="count(/taxonomy/taxonomy3[order=$this-order and family=$this-family])>0">
				<xsl:apply-templates select="/taxonomy/taxonomy3[order=$this-order and family=$this-family]"/>
			</xsl:if>
		</family>
	</xsl:template>

	<xsl:template match="taxonomy3">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>
		<xsl:variable name="this-subfamily" select="subfamily"/>

		<subfamily>
			<xsl:attribute name="common-name"><xsl:value-of select="common-name"/></xsl:attribute>
			<xsl:attribute name="latin-name"><xsl:value-of select="latin-name"/></xsl:attribute>

			<taxonomy>
				<id><xsl:value-of select="taxonomy-id"/></id>
				<order-id><xsl:value-of select="order"/></order-id>
				<family-id><xsl:value-of select="family"/></family-id>
				<subfamily-id><xsl:value-of select="subfamily"/></subfamily-id>
			</taxonomy>

			<xsl:apply-templates select="/taxonomy/taxonomy4[order=$this-order and family=$this-family and subfamily=$this-subfamily]"/>
		</subfamily>
	</xsl:template>

	<xsl:template match="taxonomy4">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>
		<xsl:variable name="this-subfamily" select="subfamily"/>
		<xsl:variable name="this-genus" select="genus"/>

		<genus>
			<xsl:attribute name="common-name"><xsl:value-of select="common-name"/></xsl:attribute>
			<xsl:attribute name="latin-name"><xsl:value-of select="latin-name"/></xsl:attribute>

			<taxonomy>
				<id><xsl:value-of select="taxonomy-id"/></id>
				<order-id><xsl:value-of select="order"/></order-id>
				<family-id><xsl:value-of select="family"/></family-id>
				<subfamily-id><xsl:value-of select="subfamily"/></subfamily-id>
				<genus-id><xsl:value-of select="genus"/></genus-id>
			</taxonomy>

 			<xsl:apply-templates select="/taxonomy/taxonomy5[order=$this-order and family=$this-family and subfamily=$this-subfamily and genus=$this-genus]"/>
		</genus>
	</xsl:template>

	<xsl:template match="taxonomy5">
		<species>
			<xsl:attribute name="common-name"><xsl:value-of select="common-name"/></xsl:attribute>
			<xsl:attribute name="latin-name"><xsl:value-of select="latin-name"/></xsl:attribute>
			<xsl:attribute name="abbreviation"><xsl:value-of select="abbreviation"/></xsl:attribute>

			<taxonomy>
				<id><xsl:value-of select="taxonomy-id"/></id>
				<order-id><xsl:value-of select="order"/></order-id>
				<family-id><xsl:value-of select="family"/></family-id>
				<subfamily-id><xsl:value-of select="subfamily"/></subfamily-id>
				<genus-id><xsl:value-of select="genus"/></genus-id>
				<species-id><xsl:value-of select="species"/></species-id>
			</taxonomy>
		</species>
	</xsl:template>


</xsl:stylesheet>
