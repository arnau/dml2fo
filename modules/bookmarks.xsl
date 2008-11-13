<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="xs dml dc">
	
	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-11-11</dml:item>
			<dml:item property="dc:description">
				<p>XSL-FO Bookmarks for dml2fo.xsl.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<!-- $numbering.bookmarks: true | false -->
	<xsl:param name="bookmark.numbers">false</xsl:param>

	<xsl:template match="dml:section" mode="bookmark">
		<fo:bookmark>
			<xsl:attribute name="internal-destination">
				<xsl:call-template name="get.id"/>
			</xsl:attribute>
			<fo:bookmark-title>
				<xsl:if test="( $header.numbers eq 'true' ) and ( $bookmark.numbers eq 'true' )">
					<xsl:number count="dml:section" level="multiple" format="1. "/>
				</xsl:if>
				<xsl:if test="@role='appendix'">
					<xsl:value-of select="$literals/literals/appendix.prefix"/>
				</xsl:if>
				<xsl:value-of select="dml:title"/>
			</fo:bookmark-title>
			<xsl:apply-templates select="dml:section" mode="bookmark"/>
		</fo:bookmark>
	</xsl:template>

</xsl:stylesheet>