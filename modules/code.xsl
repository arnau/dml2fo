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

	<xsl:param name="code.linelength" select="85"/>

	<xsl:param name="node.element.prefix">/</xsl:param>
	<xsl:param name="node.attribute.prefix">@</xsl:param>

	<xsl:attribute-set name="code.block" use-attribute-sets="monospace">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="padding">0 3pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="code.inline" use-attribute-sets="monospace"/>

	<xsl:attribute-set name="code.node" use-attribute-sets="monospace">
		<xsl:attribute name="color">#090</xsl:attribute>
		<xsl:attribute name="font-size">0.95em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="code.value" use-attribute-sets="code.node"/>

	<xsl:attribute-set name="code.param"/>


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
		<xsl:choose>
			<xsl:when test="@language='xml'">
				<xsl:copy-of select="fnc:xml( ., $code.linelength )"/>
			</xsl:when>
			<xsl:when test="@language='css'">
				<xsl:copy-of select="fnc:css( ., $code.linelength )"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="context">
					<xsl:value-of select="fnc:linelength( ., $code.linelength )"/>
				</xsl:variable>
				<xsl:copy-of select="replace( $context, '(.+)\s*$', '$1' )"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cdml:node">
		<xsl:variable name="node.prefix">
			<xsl:call-template name="get.node.prefix"/>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="code.node">
			<xsl:call-template name="common.attributes"/>
			<fo:character character="{$node.prefix}"/><xsl:call-template name="common.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="cdml:node" mode="toc">
		<!-- prevent duplicate IDs in ToC -->
		<xsl:variable name="node.prefix">
			<xsl:call-template name="get.node.prefix"/>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="code.node">
			<fo:character character="{$node.prefix}"/><xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="cdml:node" mode="bookmark">
		<!-- prevent duplicate IDs in bookmarks -->
		<xsl:variable name="node.prefix">
			<xsl:call-template name="get.node.prefix"/>
		</xsl:variable>
		<xsl:value-of select="$node.prefix"/><xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="get.node.prefix">
		<xsl:value-of select="
			if ( @role eq 'element' ) 
				then $node.element.prefix 
			else 
				if ( @role eq 'attribute' ) 
					then $node.attribute.prefix 
				else ' '
		"/>
	</xsl:template>

	<xsl:template match="cdml:value">
		<fo:inline xsl:use-attribute-sets="code.value">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="cdml:param">
		<fo:inline xsl:use-attribute-sets="code.param">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
		<xsl:if test="@type eq 'optional'">
			<fo:inline xsl:use-attribute-sets="em">
				<xsl:value-of select="concat( ' (', $literals/literals/param.optional.label, ')' )"/>
			</fo:inline>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>