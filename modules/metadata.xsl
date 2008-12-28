<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	exclude-result-prefixes="xs dml dc">

	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-12-28</dml:item>
			<dml:item property="dc:description">
				<p>Metadata for dml2fo.xsl</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:variable name="document.metadata" select="/(dml:dml, dml:note)/dml:metadata"/>

	<xsl:variable name="document.title" select="/(dml:dml, dml:note)/dml:title"/>
	<xsl:variable name="document.description" select="$document.metadata//*[@property='dc:description']"/>
	<xsl:variable name="document.rights" select="$document.metadata//*[@property='dc:rights']"/>

	<xsl:variable name="document.creator" select="$document.metadata//*[@property='dc:creator']/node()"/>
	<xsl:variable name="document.subject" select="$document.metadata//*[@property='dc:subject']/node()"/>
	<xsl:variable name="document.publisher" select="$document.metadata//*[@property='dc:publisher']/node()"/>

	<xsl:template name="metadata">
		<fo:declarations>
			<x:xmpmeta xmlns:x="adobe:ns:meta/">
				<rdf:RDF>
					<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
						<dc:title><xsl:value-of select="$document.title"/></dc:title>
						<xsl:if test="$document.creator">
							<dc:creator><xsl:apply-templates select="$document.creator" mode="metadata.rdf"/></dc:creator>
						</xsl:if>
						<xsl:if test="$document.subject">
							<dc:subject><xsl:apply-templates select="$document.subject" mode="metadata.rdf"/></dc:subject>
						</xsl:if>
						<xsl:if test="$document.description">
							<dc:description><xsl:value-of select="$document.description"/></dc:description>
						</xsl:if>
						<xsl:if test="$document.publisher">
							<dc:publisher><xsl:value-of select="$document.publisher"/></dc:publisher>
						</xsl:if>
						<xsl:if test="$document.rights">
							<dc:rights><xsl:value-of select="$document.rights"/></dc:rights>
						</xsl:if>
					</rdf:Description>
					<rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
						<xmp:CreatorTool>DML2FO</xmp:CreatorTool>
					</rdf:Description>
				</rdf:RDF>
			</x:xmpmeta>
		</fo:declarations>
	</xsl:template>

	<xsl:template match="dml:list" mode="metadata.rdf">
		<rdf:Bag>
			<xsl:apply-templates mode="metadata.rdf"/>
		</rdf:Bag>
	</xsl:template>
	<xsl:template match="dml:item" mode="metadata.rdf">
		<rdf:li><xsl:value-of select="."/></rdf:li>
	</xsl:template>


</xsl:stylesheet>