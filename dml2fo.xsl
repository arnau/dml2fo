<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:fnc="http://example.com/ns/functions/" 
	exclude-result-prefixes="xs dml dc rdf fnc">
	
	<xsl:import href="modules/inline.xsl"/>
	<xsl:import href="modules/lists.xsl"/>
	<xsl:import href="modules/tables.xsl"/>
	
	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-11-07</dml:item>
			<dml:item property="dc:description">
				<p>Transforms a DML source to XSL-FO.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="no"/>
	
	<dml:note>Parameters</dml:note>

	<xsl:param name="page.preposition">de</xsl:param>
	

	<!-- page size -->
	<xsl:param name="page-width">auto</xsl:param>
	<xsl:param name="page-height">auto</xsl:param>
	<xsl:param name="page-margin-top">1in</xsl:param>
	<xsl:param name="page-margin-bottom">1in</xsl:param>
	<xsl:param name="page-margin-left">1in</xsl:param>
	<xsl:param name="page-margin-right">1in</xsl:param>

	<!-- page header and footer -->
	<xsl:param name="page.header.margin">0.5in</xsl:param>
	<xsl:param name="page.footer.margin">0.5in</xsl:param>
	<xsl:param name="title-print-in-header">true</xsl:param>
	<xsl:param name="page-number-print-in-footer">true</xsl:param>

	<!-- multi column -->
	<xsl:param name="column-count">1</xsl:param>
	<xsl:param name="column-gap">12pt</xsl:param>

	<!-- writing-mode: lr-tb | rl-tb | tb-rl -->
	<xsl:param name="writing-mode">lr-tb</xsl:param>
	<!-- text-align: justify | start -->
	<xsl:param name="text-align">start</xsl:param>
	<!-- hyphenate: true | false -->
	<xsl:param name="hyphenate">false</xsl:param>



	<dml:note>Attribute Sets</dml:note>

	<xsl:attribute-set name="root">
		<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
		<xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
		<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page">
		<xsl:attribute name="page-width"><xsl:value-of select="$page-width"/></xsl:attribute>
		<xsl:attribute name="page-height"><xsl:value-of select="$page-height"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="body">
		<xsl:attribute name="font-family">sans-serif</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="page.header">
		<xsl:attribute name="font-size">small</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page.footer">
		<xsl:attribute name="font-size">small</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="section"/>

	<xsl:attribute-set name="document.title">
		<xsl:attribute name="font-size">2em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="margin-top">1em</xsl:attribute>
		<xsl:attribute name="space-after">0.67em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="h1">
		<xsl:attribute name="font-size">2em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="space-before">2em</xsl:attribute>
		<xsl:attribute name="space-after">0.67em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="h2">
		<xsl:attribute name="space-before">2em</xsl:attribute>
		<xsl:attribute name="space-after">0.83em</xsl:attribute>
		<xsl:attribute name="font-size">1.8em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="h3">
		<xsl:attribute name="font-size">1.4em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="h4">
		<xsl:attribute name="font-size">1.2em</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="space-before">1.17em</xsl:attribute>
		<xsl:attribute name="space-after">1.17em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="h5">
		<xsl:attribute name="font-size">1.2em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="space-before">1.33em</xsl:attribute>
		<xsl:attribute name="space-after">1.33em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="h6">
	<xsl:attribute name="font-size">0.67em</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-variant">small-caps</xsl:attribute>
		<xsl:attribute name="space-before">1.67em</xsl:attribute>
		<xsl:attribute name="space-after">1.67em</xsl:attribute>

		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="date.issued" use-attribute-sets="p">
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="p">
		<xsl:attribute name="space-before">0.5em</xsl:attribute>
		<xsl:attribute name="space-after">0.5em</xsl:attribute>
	</xsl:attribute-set>




	<xsl:template match="dml:dml">
		<fo:root xsl:use-attribute-sets="root">
			<xsl:call-template name="common.attributes"/>
			<xsl:call-template name="layout.master.set"/>
			<xsl:call-template name="body"/>
		</fo:root>
	</xsl:template>

	<xsl:template name="layout.master.set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="all-pages" xsl:use-attribute-sets="page">
				<fo:region-body 
					margin-top="{$page-margin-top}"
					margin-right="{$page-margin-right}"
					margin-bottom="{$page-margin-bottom}"
					margin-left="{$page-margin-left}"
					column-count="{$column-count}"
					column-gap="{$column-gap}"/>
				
				<xsl:choose>
					<xsl:when test="$writing-mode = 'tb-rl'">
						<fo:region-before extent="{$page-margin-right}" precedence="true"/>
						<fo:region-after extent="{$page-margin-left}" precedence="true"/>
						<fo:region-start 
							region-name="page.header"
							extent="{$page-margin-top}"
							writing-mode="lr-tb"
							display-align="before"/>
						<fo:region-end 
							region-name="page.footer"
							extent="{$page-margin-bottom}"
							writing-mode="lr-tb"
							display-align="after"/>
					</xsl:when>
					<xsl:when test="$writing-mode = 'rl-tb'">
						<fo:region-before 
							region-name="page.header"
							extent="{$page-margin-top}"
							display-align="before"/>
						<fo:region-after 
							region-name="page.footer"
							extent="{$page-margin-bottom}"
							display-align="after"/>
						<fo:region-start extent="{$page-margin-right}"/>
						<fo:region-end extent="{$page-margin-left}"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:region-before 
							region-name="page.header"
							extent="{$page-margin-top}"
							display-align="before"/>
						<fo:region-after 
							region-name="page.footer"
							extent="{$page-margin-bottom}"
							display-align="after"/>
						<fo:region-start extent="{$page-margin-left}"/>
						<fo:region-end extent="{$page-margin-bottom}"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:simple-page-master>
		</fo:layout-master-set>
	</xsl:template>

	<xsl:template name="body">
		<xsl:variable name="title" select="/dml:dml/dml:title"/>
		<fo:page-sequence master-reference="all-pages">
			<fo:title>
				<xsl:value-of select="$title"/>
			</fo:title>
			<fo:static-content flow-name="page.header">
				<xsl:call-template name="header.content"/>
			</fo:static-content>
			<fo:static-content flow-name="page.footer">
				<fo:block space-after.conditionality="retain" space-after="{$page.footer.margin}" xsl:use-attribute-sets="page.footer">
					<fo:block text-align-last="justify">
						<xsl:value-of select="$title"/>
						<fo:leader/>
						<fo:page-number/>
						<xsl:value-of select="(' ',$page.preposition, ' ')"/>
						<fo:page-number-citation ref-id="last-page"/>
					</fo:block>
				</fo:block>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block xsl:use-attribute-sets="document.title">
					<xsl:value-of select="$title"/>
				</fo:block>
				<xsl:call-template name="date.issued"/>
				<fo:block xsl:use-attribute-sets="body">
					<xsl:call-template name="common.attributes"/>
					<xsl:apply-templates select="dml:section"/>

					<!-- calls the endnotes template -->
					<!-- <xsl:call-template name="make.endnotes.list"/> -->
					<fo:block id="last-page"/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	<xsl:template name="date.issued">
		<fo:block xsl:use-attribute-sets="date.issued">
			<xsl:variable name="document.id" select="/dml:dml/@xml:id"/>
			<xsl:variable name="document.metadata" select="if ( $document.id ) then concat( '#', $document.id ) else ''"/>
			<xsl:value-of select="//*[@about=$document.metadata]//*[@property='dc:issued']"/>
		</fo:block>
	</xsl:template>

	<xsl:template name="header.content"/>

	<xsl:template name="common.attributes.and.children">
		<xsl:call-template name="common.attributes"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="common.attributes">
		<xsl:attribute name="role">
			<!-- TODO: it makes sense or need to be something like html:h1? -->
			<xsl:value-of select="concat('dml:', local-name())"/>
		</xsl:attribute>
		<xsl:if test="@xml:lang">
			<xsl:attribute name="xml:lang" select="@xml:lang"/>
		</xsl:if>
		<xsl:if test="@xml:id">
			<xsl:attribute name="id" select="@xml:id"/>
		</xsl:if>
		<xsl:if test="@align">
			<!-- TODO: must be ignored? -->
			<xsl:attribute name="align" select="@align"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dml:section">
		<fo:block xsl:use-attribute-sets="section">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h1">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h2">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:section/dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h3">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:section/dml:section/dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h4">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:section/dml:section/dml:section/dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h5">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:section/dml:section/dml:section/dml:section/dml:section/dml:title">
		<fo:block xsl:use-attribute-sets="h6">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="dml:p">
		<fo:block xsl:use-attribute-sets="p">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>

</xsl:stylesheet>