<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="no"/>

	<xsl:template match="taxonomy">
		<HTML>
		<BODY>
		<PRE>
&lt;phylum common-name="Birds"&gt;
		<xsl:apply-templates select="taxonomy1"/>
&lt;/phylum&gt;
		</PRE>
		</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="taxonomy1">
		<xsl:variable name="this-order" select="order"/>

   &lt;order common-name="<xsl:value-of select="common-name"/>"&gt;
		<xsl:apply-templates select="/taxonomy/taxonomy2[order=$this-order]"/>
   &lt;/order&gt;
	</xsl:template>

	<xsl:template match="taxonomy2">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>

      &lt;family common-name="<xsl:value-of select="common-name"/>"&gt;
		<xsl:if test="count(/taxonomy/taxonomy3[order=$this-order and family=$this-family])=0">
			<xsl:apply-templates select="/taxonomy/taxonomy4[order=$this-order and family=$this-family]"/>
		</xsl:if>

		<xsl:if test="count(/taxonomy/taxonomy3[order=$this-order and family=$this-family])>0">
			<xsl:apply-templates select="/taxonomy/taxonomy3[order=$this-order and family=$this-family]"/>
		</xsl:if>
      &lt;/family&gt;
	</xsl:template>

	<xsl:template match="taxonomy3">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>
		<xsl:variable name="this-subfamily" select="subfamily"/>

         &lt;subfamily common-name="<xsl:value-of select="common-name"/>"&gt;
		<xsl:apply-templates select="/taxonomy/taxonomy4[order=$this-order and family=$this-family and subfamily=$this-subfamily]"/>
         &lt;/subfamily&gt;
	</xsl:template>

	<xsl:template match="taxonomy4">
		<xsl:variable name="this-order" select="order"/>
		<xsl:variable name="this-family" select="family"/>
		<xsl:variable name="this-subfamily" select="subfamily"/>
		<xsl:variable name="this-genus" select="genus"/>

            &lt;genus common-name="<xsl:value-of select="common-name"/>"&gt;
 		<xsl:apply-templates select="/taxonomy/taxonomy5[order=$this-order and family=$this-family and subfamily=$this-subfamily and genus=$this-genus]"/>
            &lt;/genus&gt;
	</xsl:template>

	<xsl:template match="taxonomy5">
               &lt;species common-name="<xsl:value-of select="common-name"/>"&gt;
	</xsl:template>


</xsl:stylesheet>
