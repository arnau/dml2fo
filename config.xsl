<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0"
	xmlns:dct="http://purl.org/dc/terms/"
	exclude-result-prefixes="xs dml dct">

	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-12-27</dml:item>
			<dml:item property="dct:description">
				<p>Basic parameters and attribute set definitions for dml2fo.xsl</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<dml:note>Parameters</dml:note>
	<xsl:variable name="literals" select="document( concat( 'literals/', /dml:dml/@xml:lang, '.xml' ) )"/>
	<xsl:variable name="status.hidden.values" select="('deleted', 'draft')"/>

	<!-- page size -->
	<xsl:param name="page.width">auto</xsl:param>
	<xsl:param name="page.height">auto</xsl:param>
	<xsl:param name="page.margin.top">1.1in</xsl:param>
	<xsl:param name="page.margin.bottom">1in</xsl:param>
	<xsl:param name="page.margin.left">1in</xsl:param>
	<xsl:param name="page.margin.right">1in</xsl:param>

	<!-- page header and footer -->
	<xsl:param name="page.header.margin">0.5in</xsl:param>
	<xsl:param name="page.footer.margin">0.5in</xsl:param>
	<xsl:param name="title.print.in.header">true</xsl:param>
	<xsl:param name="page.number.print.in.footer">true</xsl:param>

	<!-- multi column -->
	<xsl:param name="column.count">1</xsl:param>
	<xsl:param name="column.gap">12pt</xsl:param>

	<!-- $writing.mode: lr-tb | rl-tb | tb-rl -->
	<xsl:param name="writing.mode">lr-tb</xsl:param>
	<!-- $text.align: justify | start -->
	<xsl:param name="text.align">start</xsl:param>
	<!-- $hyphenate: true | false -->
	<xsl:param name="hyphenate">false</xsl:param>

	<!-- $date.issued: true | false -->
	<xsl:param name="date.issued">true</xsl:param>

	<!-- $header.numbers: true | false -->
	<xsl:param name="header.numbers">true</xsl:param>
	<!-- $appendix.format.number.type: 1. | I. | A. -->
	<xsl:param name="format.number.type">1</xsl:param>
	<!-- $appendix.format.number: true | false -->
	<xsl:param name="appendix.format.number">true</xsl:param>
	<!-- $appendix.format.number.type: 1. | I. | A. -->
	<xsl:param name="appendix.format.number.type">A.1</xsl:param>
	<!-- $appendix.separator: string -->
	<xsl:param name="appendix.separator"> — </xsl:param>

	<!-- $bookmarks: true | false -->
	<xsl:param name="bookmarks">true</xsl:param>
	<!-- $numbering.bookmarks: true | false -->
	<xsl:param name="bookmark.numbers">false</xsl:param>

	<!-- $toc: true | false -->
	<xsl:param name="toc">true</xsl:param>
	<!-- $toc.deep: integer-->
	<xsl:param name="toc.depth">3</xsl:param>
	<!-- $toc.skipped.sections: integer -->
	<xsl:param name="toc.skipped.sections">1</xsl:param>
	<!-- $toc.position: -1 | 0 | 1 (-1 puts ToC after all content, 0 puts ToC before all content and 1 puts ToC before first non $toc.skipped.sections) -->
	<xsl:param name="toc.position">1</xsl:param>

	<!-- $debug: true | false -->
	<xsl:param name="debug">true</xsl:param>


	<dml:note>Attribute Sets</dml:note>

	<xsl:attribute-set name="root">
		<xsl:attribute name="writing-mode"><xsl:value-of select="$writing.mode"/></xsl:attribute>
		<xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
		<xsl:attribute name="text-align"><xsl:value-of select="$text.align"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page">
		<xsl:attribute name="page-width"><xsl:value-of select="$page.width"/></xsl:attribute>
		<xsl:attribute name="page-height"><xsl:value-of select="$page.height"/></xsl:attribute>
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
		<xsl:attribute name="font-size">1em</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
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

	<xsl:attribute-set name="figure">
		<xsl:attribute name="space-before">1em</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure.title">
		<xsl:attribute name="space-after">2em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="figure.label">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="example">
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
		<xsl:attribute name="space-after">1.5em</xsl:attribute>
		<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		<xsl:attribute name="border-bottom">2pt solid #ccc</xsl:attribute>
		<xsl:attribute name="border-top">2pt solid #ccc</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="example.with.title" use-attribute-sets="example">
		<xsl:attribute name="border-top">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="example.title">
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="border-bottom">2pt solid #ccc</xsl:attribute>
		<xsl:attribute name="padding">3pt 0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="example.label">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="warning">
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
		<xsl:attribute name="space-after">1.5em</xsl:attribute>
		<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		<xsl:attribute name="border-bottom">3pt solid #000</xsl:attribute>
		<xsl:attribute name="border-top">3pt solid #000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="warning.with.title" use-attribute-sets="warning">
		<xsl:attribute name="border-top">0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="warning.title">
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="border-bottom">3pt solid #000</xsl:attribute>
		<xsl:attribute name="padding">3pt 0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="warning.label">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tip">
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
		<xsl:attribute name="space-after">1.5em</xsl:attribute>
		<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		<xsl:attribute name="border-bottom">3pt solid #999</xsl:attribute>
		<xsl:attribute name="border-top">3pt solid #999</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tip.with.title" use-attribute-sets="tip">
		<xsl:attribute name="border-top">0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tip.title">
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="border-bottom">3pt solid #999</xsl:attribute>
		<xsl:attribute name="padding">3pt 0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tip.label">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="sidebar">
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
		<xsl:attribute name="space-after">1.5em</xsl:attribute>
		<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		<xsl:attribute name="border">3pt solid #999</xsl:attribute>
		<xsl:attribute name="padding">1em</xsl:attribute>
		<xsl:attribute name="margin">0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sidebar.title">
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="border-bottom">1pt solid #999</xsl:attribute>
		<xsl:attribute name="padding">3pt 0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sidebar.label">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="monospace">
		<xsl:attribute name="font-size">0.85em</xsl:attribute>
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="xref"/>

	<xsl:attribute-set name="xref.error">
		<xsl:attribute name="color">red</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="draft.attribute.set">
		<xsl:attribute name="background-color">#FFE862</xsl:attribute>
	</xsl:template>
	<xsl:template name="review.attribute.set">
		<xsl:attribute name="background-color">#6cf</xsl:attribute>
	</xsl:template>
	<xsl:template name="added.attribute.set">
		<xsl:attribute name="background-color">#DFD</xsl:attribute>
	</xsl:template>
	<xsl:template name="deleted.attribute.set">
		<xsl:attribute name="background-color">#FDD</xsl:attribute>
	</xsl:template>

	<xsl:template name="foreign.language">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:template>


</xsl:stylesheet>