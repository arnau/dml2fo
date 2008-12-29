<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:dct="http://purl.org/dc/terms/"
	exclude-result-prefixes="xs dml dct">
	
	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-11-11</dml:item>
			<dml:item property="dct:description">
				<p>XSL-FO Bookmarks for dml2fo.xsl.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template match="dml:section" mode="bookmark">
		<xsl:variable name="number">
			<xsl:if test="xs:boolean( $bookmark.numbers )">
				<xsl:call-template name="header.number">
					<xsl:with-param name="format.number.type">1. </xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<fo:bookmark>
			<xsl:attribute name="internal-destination">
				<xsl:call-template name="get.id"/>
			</xsl:attribute>
			<fo:bookmark-title>
				<xsl:value-of select="
					if ( @role='appendix' and xs:boolean( $appendix.format.number ) ) then
						concat( $literals/literals/appendix.prefix, ' ', $number, $appendix.separator )
					else
						$number
				"/>
				<xsl:apply-templates select="dml:title" mode="bookmark"/>
			</fo:bookmark-title>
			<xsl:choose>
				<xsl:when test="not( xs:boolean( $debug ) ) and dml:section[not( @status = $status.hidden.values )] and dml:section[@status = $status.hidden.values]">
					<xsl:apply-templates select="dml:section[not( @status = $status.hidden.values )]" mode="bookmark"/>
				</xsl:when>
				<xsl:when test="not( xs:boolean( $debug ) ) and dml:section[@status = $status.hidden.values]"/>
				<xsl:otherwise>
					<xsl:apply-templates select="dml:section" mode="bookmark"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:bookmark>
	</xsl:template>

</xsl:stylesheet>