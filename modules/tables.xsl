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
			<dml:item property="dc:issued">2008-11-09</dml:item>
			<dml:item property="dc:description">
				<p>DML tables to XSL-FO.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:attribute-set name="table">
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="space-after">1.5em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="table.title">
		<xsl:attribute name="margin-top">1em</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.8em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="table.label">
		<xsl:attribute name="space-before">0.5em</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="inside-table">
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="end-indent">0pt</xsl:attribute>
		<xsl:attribute name="text-indent">0pt</xsl:attribute>
		<xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="text-align-last">relative</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.head" use-attribute-sets="inside-table"/>
	<xsl:attribute-set name="table.foot" use-attribute-sets="inside-table"/>
	<xsl:attribute-set name="table.body" use-attribute-sets="inside-table"/>
	<xsl:attribute-set name="table.group"/>

	<xsl:attribute-set name="table.group.title">
		<xsl:attribute name="border-right">3pt solid #000</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="padding">4pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="table.head.title" use-attribute-sets="table.group.title">
		<xsl:attribute name="border-bottom">3pt solid #000</xsl:attribute>
		<xsl:attribute name="border-right">0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="table.head.title.first" use-attribute-sets="table.head.title">
		<xsl:attribute name="border-right">3pt solid #000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="table.cell">
		<xsl:attribute name="padding">4pt</xsl:attribute>
	</xsl:attribute-set>


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
		<xsl:apply-templates select="dml:group[@role='head']"/>
		<xsl:apply-templates select="dml:group[@role='foot']"/>
		<xsl:choose>
			<xsl:when test="dml:group[not( @role = ( 'head', 'foot' ) ) and dml:group]">
				<xsl:apply-templates select="dml:group[not( @role = ( 'head', 'foot' ) ) and dml:group]"/>
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
		<xsl:variable name="colspan" select="count( ../dml:group[@role='head']/dml:group/dml:title )"/>
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$colspan}">
				<fo:block xsl:use-attribute-sets="table.title">
					<xsl:if test="xs:boolean( $header.numbers )">
						<fo:inline xsl:use-attribute-sets="table.label">
							<xsl:value-of select="concat( $literals/literals/table.label, ' ', $numbering.table, ': ')"/>
						</fo:inline>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="dml:group[@role='head']" priority="2">
		<fo:table-header xsl:use-attribute-sets="table.head">
			<xsl:apply-templates select="parent::dml:table/dml:title"/>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template>
	<xsl:template match="dml:group[@role='foot']" priority="2">
		<fo:table-footer xsl:use-attribute-sets="table.foot">
			<xsl:apply-templates/>
		</fo:table-footer>
	</xsl:template>
	<xsl:template match="dml:group[not( @role = ( 'head', 'foot' ) ) and dml:group]" priority="2.1">
		<fo:table-body xsl:use-attribute-sets="table.body">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:table-body>
	</xsl:template>
	<xsl:template match="dml:group">
		<fo:table-row xsl:use-attribute-sets="table.group">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:table-row>
	</xsl:template>


	<xsl:template match="dml:group[@role='head']/dml:group/dml:title[1]" priority="2.1">
		<xsl:choose>
			<xsl:when test="ancestor::dml:group[@role='head']/following-sibling::dml:group/dml:group/*[1][self::dml:cell]">
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
	<xsl:template match="dml:group[@role='head']/dml:group/dml:title" priority="2">
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
		<fo:table-cell xsl:use-attribute-sets="table.cell">
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
		<xsl:call-template name="common.attributes"/>
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>