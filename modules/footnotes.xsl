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
			<dml:item property="dct:issued">2008-12-17</dml:item>
			<dml:item property="dct:description">
				<p>DML footnotes.</p>
				<p>Footnotes inside lists or tables doesn't work in FOP 0.95 or earlier. Try SVN trunk.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template name="xref.footnote">
		<xsl:param name="idref"/>
		<fo:footnote>
			<fo:inline>
				<fo:basic-link xsl:use-attribute-sets="toc.xref">
					<xsl:attribute name="internal-destination" select="$idref"/>
					<xsl:apply-templates/>
				</fo:basic-link>
				<xsl:call-template name="footnote.number"/>
			</fo:inline>
			<fo:footnote-body>
				<fo:block xsl:use-attribute-sets="footnote">
					<xsl:attribute name="id" select="$idref"/>
					<xsl:call-template name="footnote.number"/>
					<xsl:apply-templates select="//dml:note[( @role eq 'footnote' ) and ( @xml:id eq $idref )]/node()"/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="dml:note[@role eq 'footnote']"/>

	<xsl:template name="footnote.number">
		<fo:inline xsl:use-attribute-sets="xref.footnote">
			<xsl:number count="dml:*[substring-after( @href, '#' ) = //dml:note[@role eq 'footnote']/@xml:id]" level="any" format="[1]"/>
		</fo:inline>
	</xsl:template>

</xsl:stylesheet>