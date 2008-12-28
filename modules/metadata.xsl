<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:fnc="dml2fo:functions"
	xmlns:x="adobe:ns:meta/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xmp="http://ns.adobe.com/xap/1.0/"
	exclude-result-prefixes="xs dml dct fnc">

	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-12-28</dml:item>
			<dml:item property="dct:description">
				<p>Metadata for dml2fo.xsl</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:variable name="document.metadata" select="/(dml:dml, dml:note)/dml:metadata"/>

	<xsl:variable name="document.title" select="/(dml:dml, dml:note)/dml:title"/>
	<xsl:variable name="document.description" select="fnc:dc.extractor( $document.metadata, 'description' )"/>
	<xsl:variable name="document.rights" select="fnc:dc.extractor( $document.metadata, 'rights' )"/>
	<xsl:variable name="document.creator" select="fnc:dc.extractor( $document.metadata, 'creator' )"/>
	<xsl:variable name="document.subject" select="fnc:dc.extractor( $document.metadata, 'subject' )"/>
	<xsl:variable name="document.publisher" select="fnc:dc.extractor( $document.metadata, 'publisher' )"/>

	<xsl:template name="metadata">
		<fo:declarations>
			<x:xmpmeta>
				<rdf:RDF>
					<rdf:Description rdf:about="">
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
					<rdf:Description rdf:about="">
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

	<xsl:function name="fnc:dc.extractor">
		<xsl:param name="context"/>
		<xsl:param name="type" as="xs:string"/>
		<xsl:variable name="dc.ns" select="( 'http://purl.org/dc/elements/1.1/', 'http://purl.org/dc/terms/' )"/>
		<xsl:sequence select="
			$context//*[
				( replace( @property, '.+:(.+)', '$1' ) eq $type ) and
				( some $i in $dc.ns satisfies $i eq namespace-uri-for-prefix( replace( @property, '(.+):.+', '$1' ), /* ) )
			]/node()
		"/>
	</xsl:function>


</xsl:stylesheet>