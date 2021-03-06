<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
	xmlns:pml="http://purl.oclc.org/NET/pml/1.0/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:fnc="dml2fo:functions"
	exclude-result-prefixes="xs dml pml dct fnc">
	
	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-11-22</dml:item>
			<dml:item property="dct:description">
				<p>Code DML to FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:strip-space elements="pml:node pml:value"/>

	<xsl:template match="pml:code">
		<fo:inline xsl:use-attribute-sets="code.inline">
			<xsl:call-template name="code.languages"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[( self::dml:dml, self::dml:section, self::dml:example, self::dml:item[dml:example | dml:figure | dml:p | dml:title] )]/pml:code">
		<fo:block xsl:use-attribute-sets="code.block">
			<xsl:call-template name="code.languages"/>
		</fo:block>
	</xsl:template>

	<xsl:template name="code.languages">
		<xsl:choose>
			<xsl:when test="@language='xml'">
				<xsl:copy-of select="fnc:xml( ., xs:integer( $code.linelength ) )"/>
			</xsl:when>
			<xsl:when test="@language='css'">
				<xsl:copy-of select="fnc:css( ., xs:integer( $code.linelength ) )"/>
			</xsl:when>
			<xsl:when test="@language='ebnf'">
				<xsl:copy-of select="fnc:ebnf( ., xs:integer( $code.linelength ) )"/>
			</xsl:when>
			<xsl:when test="@language='xpath'">
				<xsl:copy-of select="fnc:xpath( ., xs:integer( $code.linelength ) )"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="context">
					<xsl:value-of select="fnc:linelength( ., xs:integer( $code.linelength ) )"/>
				</xsl:variable>
				<xsl:copy-of select="replace( $context, '(.+)\s*$', '$1' )"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="pml:node">
		<xsl:variable name="node.prefix">
			<xsl:call-template name="get.node.prefix"/>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="code.node">
			<xsl:call-template name="common.attributes"/>
			<xsl:if test="$node.prefix ne ''"><fo:character character="{$node.prefix}"/></xsl:if><xsl:call-template name="common.children"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="pml:node" mode="toc">
		<!-- prevent duplicate IDs in ToC -->
		<xsl:variable name="node.prefix">
			<xsl:call-template name="get.node.prefix"/>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="code.node">
			<xsl:if test="$node.prefix ne ''"><fo:character character="{$node.prefix}"/></xsl:if><xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="pml:node" mode="bookmark">
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

	<xsl:template match="pml:value">
		<fo:inline xsl:use-attribute-sets="code.value">
			<xsl:call-template name="common.attributes"/>
			<xsl:value-of select="$value.prefix"/>
			<xsl:call-template name="common.children"/>
			<xsl:value-of select="$value.suffix"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="pml:param">
		<fo:inline xsl:use-attribute-sets="code.param">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
		<xsl:if test="@type eq 'optional'">
			<fo:inline xsl:use-attribute-sets="em">
				<xsl:value-of select="concat( ' (', $literals/literals/param.optional.label, ')' )"/>
			</fo:inline>
		</xsl:if>

	</xsl:template>

	<xsl:template match="pml:variable">
		<fo:inline xsl:use-attribute-sets="code.variable">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="pml:datatype">
		<fo:inline xsl:use-attribute-sets="code.datatype">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:inline>
	</xsl:template>

</xsl:stylesheet>