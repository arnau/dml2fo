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
				<p>DML lists to XSL-FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>


	<xsl:param name="leader.pattern">.</xsl:param>
	<xsl:param name="leader.pattern.foot" select="' '"/>

	<xsl:param name="ul.label.1">&#x2022;</xsl:param>
	<xsl:attribute-set name="ul.label.1">
		<xsl:attribute name="font">1.2em serif</xsl:attribute>
	</xsl:attribute-set>

	<xsl:param name="ul.label.2">o</xsl:param>
	<xsl:attribute-set name="ul.label.2">
		<xsl:attribute name="font">0.67em monospace</xsl:attribute>
		<xsl:attribute name="baseline-shift">0.25em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:param name="ul.label.3">-</xsl:param>
	<xsl:attribute-set name="ul.label.3">
		<xsl:attribute name="font">bold 0.9em sans-serif</xsl:attribute>
		<xsl:attribute name="baseline-shift">0.05em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:param name="ol.label.1">1.</xsl:param>
	<xsl:attribute-set name="ol.label.1"/>

	<xsl:param name="ol.label.2">a.</xsl:param>
	<xsl:attribute-set name="ol.label.2"/>

	<xsl:param name="ol.label.3">i.</xsl:param>
	<xsl:attribute-set name="ol.label.3"/>

	<xsl:attribute-set name="list">
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="list.title" use-attribute-sets="h6">
		<xsl:attribute name="space-after">0.5em</xsl:attribute>
		<xsl:attribute name="start-indent">inherited-property-value(start-indent) + 1em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="list.nested">
		<xsl:attribute name="space-before">0pt</xsl:attribute>
		<xsl:attribute name="space-after">0pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="item">
		<xsl:attribute name="relative-align">baseline</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.1em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="item.foot" use-attribute-sets="item">
		<xsl:attribute name="border-top">2pt solid #000</xsl:attribute>
		<xsl:attribute name="space-before">0.5em</xsl:attribute>
		<xsl:attribute name="padding-top">0.5em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="item.group">
		<xsl:attribute name="margin-top">0.5em</xsl:attribute>
		<xsl:attribute name="margin-bottom">0.5em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="item.group.leaded">
		<xsl:attribute name="margin-top">0.2em</xsl:attribute>
		<xsl:attribute name="margin-bottom">0.2em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="item.title">
		<!-- <xsl:attribute name="font-weight">bold</xsl:attribute> -->
		<xsl:attribute name="space-after">0.2em</xsl:attribute>
		<xsl:attribute name="page-break-after">avoid</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="item.content">
		<xsl:attribute name="start-indent">inherited-property-value(start-indent) + 2em</xsl:attribute>
	</xsl:attribute-set>


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

	<xsl:template match="dml:item[not( dml:title )]//dml:list">
		<!-- TODO: review styles -->
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
			<fo:list-item-label start-indent="body-start()">
				<fo:block></fo:block>
			</fo:list-item-label>
			<fo:list-item-body>
				<fo:block xsl:use-attribute-sets="item.group">
					<xsl:apply-templates select="dml:title"/>
					<fo:block xsl:use-attribute-sets="item.content">
						<xsl:apply-templates select="*[not( self::dml:title )]"/>
					</fo:block>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="dml:list[@role]/dml:item[dml:title]" priority="2.1">
		<xsl:choose>
			<xsl:when test="( some $i in tokenize( parent::dml:list/@role, '\s+' ) satisfies $i eq 'leaded' ) and ( @role eq 'foot' )">
				<fo:list-item xsl:use-attribute-sets="item.foot">
					<xsl:call-template name="list.leaded">
						<xsl:with-param name="leader.pattern" select="$leader.pattern.foot"/>
					</xsl:call-template>
				</fo:list-item>
			</xsl:when>
			<xsl:when test="some $i in tokenize( parent::dml:list/@role, '\s+' ) satisfies $i eq 'leaded'">
				<fo:list-item xsl:use-attribute-sets="item">
					<xsl:call-template name="list.leaded">
						<xsl:with-param name="leader.pattern" select="$leader.pattern"/>
					</xsl:call-template>
				</fo:list-item>
			</xsl:when>
			<xsl:when test="some $i in tokenize( parent::dml:list/@role, '\s+' ) satisfies $i eq 'ordered'">
				<fo:list-item xsl:use-attribute-sets="item">
					<xsl:call-template name="item.with.title"/>
				</fo:list-item>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="list.leaded">
		<xsl:param name="leader.pattern">.</xsl:param>
		<xsl:call-template name="common.attributes"/>
		<fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap">
			<fo:block xsl:use-attribute-sets="item.group.leaded">
				<xsl:if test="some $i in tokenize( parent::dml:list/@role, '\s+' ) satisfies $i eq 'ordered'">
					<xsl:call-template name="list.ordered.numbers"/>
				</xsl:if>
			</fo:block>
		</fo:list-item-label>
		<fo:list-item-body>
			<xsl:if test="some $i in tokenize( parent::dml:list/@role, '\s+' ) satisfies $i eq 'ordered'">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
			</xsl:if>
			<fo:block xsl:use-attribute-sets="item.group.leaded" text-align-last="justify">
				<xsl:apply-templates select="dml:title/node()"/>
				<fo:leader leader-pattern="use-content"><xsl:value-of select="$leader.pattern"/></fo:leader>
				<xsl:text> </xsl:text>
				<fo:inline>
					<xsl:apply-templates select="*[not( self::dml:title )]/node()"/>
				</fo:inline>
			</fo:block>
		</fo:list-item-body>
	</xsl:template>

	<xsl:template name="item.with.title">
		<xsl:call-template name="common.attributes"/>
		<fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap">
			<fo:block>
				<xsl:call-template name="list.ordered.numbers"/>
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
	</xsl:template>

	<xsl:template name="list.unordered.labels">
		<xsl:variable name="depth" select="count( ancestor::dml:list[dml:item[not( dml:title )]] )"/>
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