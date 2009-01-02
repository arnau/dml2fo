<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
	xmlns:cdml="http://purl.oclc.org/NET/cdml/1.0/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:fnc="dml2fo:functions"
	exclude-result-prefixes="xs dml cdml dct fnc">
	
	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-11-09</dml:item>
			<dml:item property="dct:description">
				<p>DML inline elements to XSL-FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template match="dml:em">
		<fo:inline xsl:use-attribute-sets="em">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:em[@role='strong']" priority="2">
		<fo:inline xsl:use-attribute-sets="strong">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:sub">
		<fo:inline xsl:use-attribute-sets="sub">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:sup">
		<fo:inline xsl:use-attribute-sets="sup">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:abbr">
		<fo:inline xsl:use-attribute-sets="abbr">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:span">
		<fo:inline xsl:use-attribute-sets="span">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:quote">
		<fo:inline xsl:use-attribute-sets="quote">
			<xsl:call-template name="common.attributes"/>
			<xsl:choose>
				<xsl:when test="lang('ca') or lang('es')">
					<xsl:text>«</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>»</xsl:text>
				</xsl:when>
				<xsl:when test="lang('ja')">
					<xsl:text>「</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>」</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- lang('en') -->
					<xsl:text>“</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>”</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dml:quote//dml:quote">
		<fo:inline xsl:use-attribute-sets="quote.nested">
			<xsl:call-template name="common.attributes"/>
			<xsl:choose>
				<xsl:when test="lang('ca') or lang('es')">
					<xsl:text>“</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>”</xsl:text>
				</xsl:when>
				<xsl:when test="lang('ja')">
					<xsl:text>『</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>』</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- lang('en') -->
					<xsl:text>‘</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>’</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>


	<xsl:template match="dml:object">
		<fo:external-graphic xsl:use-attribute-sets="object">
			<xsl:call-template name="object.content"/>
		</fo:external-graphic>
	</xsl:template>

	<xsl:template name="object.content">
		<xsl:attribute name="src" select="concat( 'url(', @src, ')' )"/>
		<xsl:if test="@width">
			<xsl:choose>
				<xsl:when test="contains( @width, '%' )">
					<xsl:attribute name="width">
						<xsl:value-of select="@width"/>
					</xsl:attribute>
					<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="content-width" select="concat( @width, 'px' )"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="@height">
			<xsl:choose>
				<xsl:when test="contains( @height, '%' )">
					<xsl:attribute name="height">
						<xsl:value-of select="@height"/>
					</xsl:attribute>
					<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="content-height" select="concat( @height, 'px' )"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="common.attributes"/>
	</xsl:template>

</xsl:stylesheet>