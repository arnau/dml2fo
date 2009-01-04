<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
	xmlns:dct="http://purl.org/dc/terms/"
	exclude-result-prefixes="xs dml dct">

	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-12-29</dml:item>
			<dml:item property="dct:description">
				<p>Original styles for dml2fo.xsl</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<!-- Block Styles -->
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
		<xsl:attribute name="keep-together">1</xsl:attribute>
		<xsl:attribute name="border">1pt solid #000</xsl:attribute>
		<xsl:attribute name="padding">2em</xsl:attribute>
		<xsl:attribute name="margin">0</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sidebar.title">
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<!-- Table Styles -->
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

	<!-- List Styles -->
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

	<!-- ToC Styles -->
	<xsl:attribute-set name="appendix.prefix"/>

	<xsl:attribute-set name="toc">
		<xsl:attribute name="space-after">3em</xsl:attribute>
		<xsl:attribute name="keep-together">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="toc.number">
		<xsl:attribute name="margin-left">2em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="toc.xref">
		<xsl:attribute name="color">#005A9C</xsl:attribute>
	</xsl:attribute-set>

	<!-- Debug Styles -->
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

	<!-- Generic Styles -->
	<xsl:template name="foreign.language">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:template>
	<xsl:attribute-set name="monospace">
		<xsl:attribute name="font-size">0.87em</xsl:attribute>
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>

	<!-- Footnotes Styles -->
	<xsl:attribute-set name="xref.footnote">
		<xsl:attribute name="vertical-align">super</xsl:attribute>
		<xsl:attribute name="font-size">0.8em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="footnote">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:attribute name="padding">0</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<!-- Inline Styles -->
	<xsl:attribute-set name="xref"/>

	<xsl:attribute-set name="xref.error">
		<xsl:attribute name="color">red</xsl:attribute>
	</xsl:attribute-set>

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

	<!-- Code Styles -->
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

	<xsl:attribute-set name="code.param" use-attribute-sets="monospace">
	</xsl:attribute-set>

	<xsl:attribute-set name="code.variable" use-attribute-sets="monospace">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<!-- XML Highlighting Styles -->
	<xsl:attribute-set name="xml.comment">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xml.tag">
		<xsl:attribute name="color">#067</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xml.ns">
		<xsl:attribute name="color">#056</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xml.attribute">
		<xsl:attribute name="color">#067</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xml.attribute.ns" use-attribute-sets="xml.ns"/>
	<xsl:attribute-set name="xml.attribute.value">
		<xsl:attribute name="color">#090</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="xpath">
		<xsl:attribute name="color">#900</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.comment">
		<xsl:attribute name="color">#555</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.variable">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.predicate">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.operator">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.modifier">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.storage">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.axis">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.node">
		<xsl:attribute name="color">#090</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xpath.function"/>

	<xsl:attribute-set name="css.rule"/>
	<xsl:attribute-set name="css.selector">
		<xsl:attribute name="color">#056</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="css.property">
		<xsl:attribute name="color">#900</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="css.value">
		<xsl:attribute name="color">#090</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="css.important">
		<xsl:attribute name="color">#f00</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

</xsl:stylesheet>