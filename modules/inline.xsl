<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	exclude-result-prefixes="xs dml dc rdf">
	
	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-11-09</dml:item>
			<dml:item property="dc:description">
				<p>DML inline elements to XSL-FO.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:attribute-set name="strong">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="em.strong">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="cite">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="em">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="code">
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="kbd">
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="sub">
		<xsl:attribute name="baseline-shift">sub</xsl:attribute>
		<xsl:attribute name="font-size">smaller</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sup">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size">smaller</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="del">
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="ins">
	<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="abbr"/>

	<xsl:attribute-set name="span"/>

	<xsl:attribute-set name="quote"/>
	<xsl:attribute-set name="quote.nested"/>

	<xsl:attribute-set name="object"/>


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