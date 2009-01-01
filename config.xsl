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

	<!-- Parameters -->
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
	<xsl:param name="appendix.separator">—</xsl:param>

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

	<!-- Code parameters -->
	<xsl:param name="code.linelength">80</xsl:param>
	<xsl:param name="node.element.prefix">/</xsl:param>
	<xsl:param name="node.attribute.prefix">@</xsl:param>

</xsl:stylesheet>