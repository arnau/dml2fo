<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:cdml="http://purl.oclc.org/NET/cdml/1.0" 
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:fnc="dml2fo:functions" 
	exclude-result-prefixes="xs dml cdml dc fnc">
	
	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-11-22</dml:item>
			<dml:item property="dc:description">
				<p>Code DML to FO.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:attribute-set name="code.block" use-attribute-sets="monospace">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="padding">0 3pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="code.inline" use-attribute-sets="monospace"/>

	<xsl:template match="cdml:code">
		<fo:inline xsl:use-attribute-sets="code.inline">
			<xsl:call-template name="code.languages"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[( self::dml:section, self::dml:example )]/cdml:code">
		<fo:block xsl:use-attribute-sets="code.block">
			<xsl:call-template name="code.languages"/>
		</fo:block>
	</xsl:template>

	<xsl:template name="code.languages">
		<xsl:variable name="limit" select="85"/>
		<xsl:choose>
			<xsl:when test="@language='xml'">
				<xsl:copy-of select="fnc:xml( ., $limit )"/>
			</xsl:when>
			<xsl:when test="@language='css'">
				<xsl:copy-of select="fnc:css( ., $limit )"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="context">
					<xsl:value-of select="fnc:linelength( ., $limit )"/>
				</xsl:variable>
				<xsl:copy-of select="replace( $context, '(.+)\s*$', '$1' )"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>