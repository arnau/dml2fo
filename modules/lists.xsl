<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
	xmlns:dct="http://purl.org/dc/terms/"
	exclude-result-prefixes="xs dml dct">
	
	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-11-09</dml:item>
			<dml:item property="dct:description">
				<p>DML lists to XSL-FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template match="dml:list">
		<xsl:if test="dml:title">
			<fo:block xsl:use-attribute-sets="list.title">
				<xsl:apply-templates select="dml:title"/>
			</fo:block>
		</xsl:if>
		<fo:list-block xsl:use-attribute-sets="list">
			<xsl:call-template name="common.attributes"/>
			<xsl:apply-templates select="*[not( self::dml:title )]"/>
		</fo:list-block>
	</xsl:template>

	<!-- <xsl:template match="dml:item[not( dml:title )]//dml:list"> -->
	<!-- <xsl:template match="dml:item[count(dml:*) le 2]//dml:list[position() eq 1 or preceding-sibling::dml:title]"> -->
	<xsl:template match="dml:item[*[1][self::dml:title]]//dml:list[count( preceding-sibling::*[1][self::dml:title] ) eq 1 and count( following-sibling::* ) eq 0]">
		<fo:list-block xsl:use-attribute-sets="list.nested">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="dml:list/dml:item">
		<fo:list-item xsl:use-attribute-sets="item">
			<xsl:call-template name="common.attributes"/>
			<fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap">
				<fo:block>
					<xsl:choose>
						<xsl:when test="parent::dml:list/@role eq 'ordered'">
							<xsl:call-template name="list.ordered.numbers"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="list.unordered.labels"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:call-template name="common.children"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="dml:list/dml:item[dml:title]" priority="2">
		<fo:list-item xsl:use-attribute-sets="item">
			<xsl:call-template name="common.attributes"/>
			<fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap">
				<fo:block xsl:use-attribute-sets="item.group.label">
					<xsl:choose>
						<xsl:when test="parent::dml:list/@role eq 'ordered'">
							<xsl:call-template name="list.ordered.numbers"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="list.unordered.labels"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block xsl:use-attribute-sets="item.group">
					<xsl:apply-templates select="dml:title"/>
					<fo:block xsl:use-attribute-sets="item.content">
						<xsl:apply-templates select="*[not( self::dml:title )]"/>
					</fo:block>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template name="list.unordered.labels">
		<xsl:param name="ul.label.1" select="$ul.label.1" tunnel="yes"/>
		<xsl:param name="ul.label.2" select="$ul.label.2" tunnel="yes"/>
		<xsl:param name="ul.label.3" select="$ul.label.3" tunnel="yes"/>

		<!-- <xsl:variable name="depth" select="count( ancestor::dml:list[dml:item[not( dml:title )]] )"/> -->
		<xsl:variable name="depth" select="count( ancestor::dml:list )"/>
		<xsl:choose>
			<xsl:when test="$depth = 1">
				<fo:inline xsl:use-attribute-sets="ul.label.1">
					<xsl:value-of select="$ul.label.1"/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="$depth = 2">
				<fo:inline xsl:use-attribute-sets="ul.label.2">
					<xsl:value-of select="$ul.label.2"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="ul.label.3">
					<xsl:value-of select="$ul.label.3"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="list.ordered.numbers">
		<xsl:param name="ol.label.1" select="$ol.label.1" tunnel="yes"/>
		<xsl:param name="ol.label.2" select="$ol.label.2" tunnel="yes"/>
		<xsl:param name="ol.label.3" select="$ol.label.3" tunnel="yes"/>

		<xsl:variable name="depth" select="count( ancestor::dml:list[some $i in tokenize( @role, '\s+' ) satisfies $i eq 'ordered'] )"/>
		<xsl:choose>
			<xsl:when test="$depth = 1">
				<fo:inline xsl:use-attribute-sets="ol.label.1">
					<xsl:number format="{$ol.label.1}"/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="$depth = 2">
				<fo:inline xsl:use-attribute-sets="ol.label.2">
					<xsl:number format="{$ol.label.2}"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="ol.label.3">
					<xsl:number format="{$ol.label.3}"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dml:list/dml:item/dml:title">
		<fo:block xsl:use-attribute-sets="item.title">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>