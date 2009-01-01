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
			<dml:item property="dct:issued">2008-11-09</dml:item>
			<dml:item property="dct:description">
				<p>DML tables to XSL-FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template match="dml:table">
		<xsl:variable name="width" select="if ( @width ) then @width else '100%'"/>
		<fo:table xsl:use-attribute-sets="table" start-indent="(100% - {$width}) div 2">
			<xsl:call-template name="table.children"/>
		</fo:table>
	</xsl:template>

	<xsl:template name="table.children">
		<xsl:if test="@width">
			<xsl:attribute name="inline-progression-dimension" select="
				(: if ( contains( @width, '%' ) ) then :)
				if ( matches( @width, '\D+' ) ) then 
					@width 
				else 
					concat( @width, 'px' )"/>
			<xsl:attribute name="width" select="@width"/>
		</xsl:if>
		<xsl:call-template name="common.attributes"/>
		<xsl:apply-templates select="dml:group[@role='header']"/>
		<xsl:apply-templates select="dml:group[@role='footer']"/>
		<xsl:choose>
			<xsl:when test="dml:group[not( @role = ( 'header', 'footer' ) ) and dml:group]">
				<xsl:apply-templates select="dml:group[not( @role = ( 'header', 'footer' ) ) and dml:group]"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-body xsl:use-attribute-sets="table.body">
					<xsl:apply-templates select="dml:group"/>
				</fo:table-body>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dml:table/dml:title">
		<xsl:variable name="numbering.table">
			<xsl:call-template name="header.number"/>
			<xsl:number from="dml:section" count="dml:table" level="any" format="-1"/>
		</xsl:variable>
		<xsl:variable name="colspan" select="count( ../dml:group[@role='header']/dml:group/dml:title )"/>
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$colspan}">
				<fo:block xsl:use-attribute-sets="table.title">
					<xsl:if test="xs:boolean( $header.numbers ) and ancestor::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]">
						<fo:inline xsl:use-attribute-sets="table.label">
							<xsl:value-of select="concat( $literals/literals/table.label, ' ', $numbering.table, ': ')"/>
						</fo:inline>
					</xsl:if>
					<xsl:call-template name="common.children"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="dml:group[@role='header']" priority="2">
		<fo:table-header xsl:use-attribute-sets="table.head">
			<xsl:apply-templates select="parent::dml:table/dml:title"/>
			<xsl:call-template name="common.children"/>
		</fo:table-header>
	</xsl:template>
	<xsl:template match="dml:group[@role='footer']" priority="2">
		<fo:table-footer xsl:use-attribute-sets="table.foot">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:table-footer>
	</xsl:template>
	<xsl:template match="dml:group[not( @role = ( 'header', 'footer' ) ) and dml:group]" priority="2.1">
		<fo:table-body xsl:use-attribute-sets="table.body">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:table-body>
	</xsl:template>
	<xsl:template match="dml:group">
		<fo:table-row xsl:use-attribute-sets="table.group">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:table-row>
	</xsl:template>


	<xsl:template match="dml:group[@role='header']/dml:group/dml:title[1]" priority="2.1">
		<xsl:choose>
			<xsl:when test="ancestor::dml:group[@role='header']/following-sibling::dml:group/dml:group/*[1][self::dml:cell]">
				<fo:table-cell xsl:use-attribute-sets="table.head.title">
					<xsl:call-template name="table.cell"/>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-cell xsl:use-attribute-sets="table.head.title.first">
					<xsl:call-template name="table.cell"/>
				</fo:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="dml:group[@role='header']/dml:group/dml:title" priority="2">
		<fo:table-cell xsl:use-attribute-sets="table.head.title">
			<xsl:call-template name="table.cell"/>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="dml:group/dml:title">
		<fo:table-cell xsl:use-attribute-sets="table.group.title">
			<xsl:call-template name="table.cell"/>
		</fo:table-cell>
	</xsl:template>
	<xsl:template match="dml:cell">
		<fo:table-cell>
			<xsl:call-template name="table.cell"/>
		</fo:table-cell>
	</xsl:template>

	<xsl:template name="table.cell">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<!-- TODO: review -->
		<!-- <xsl:attribute name="display-align">from-table-column()</xsl:attribute>
		<xsl:attribute name="relative-align">from-table-column()</xsl:attribute> -->
		<fo:block xsl:use-attribute-sets="table.cell">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>