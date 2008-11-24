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
			<dml:item property="dc:issued">2008-11-13</dml:item>
			<dml:item property="dc:description">
				<p>Table of Contents for dml2fo.xsl.</p>
			</dml:item>
			<dml:item property="dc:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:attribute-set name="appendix.prefix"/>

	<xsl:attribute-set name="toc">
		<xsl:attribute name="space-after">3em</xsl:attribute>
		<!-- <xsl:attribute name="page-break-after">always</xsl:attribute> -->
	</xsl:attribute-set>
	<xsl:attribute-set name="toc.number">
		<xsl:attribute name="margin-left">2em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="toc.link">
		<xsl:attribute name="color">#005A9C</xsl:attribute>
	</xsl:attribute-set>


	<xsl:template name="toc">
		<fo:block xsl:use-attribute-sets="h2">
			<xsl:value-of select="$literals/literals/toc.title"/>
		</fo:block>
		<fo:list-block xsl:use-attribute-sets="toc">
		   <xsl:apply-templates select="/dml:dml/dml:section[position() gt xs:integer( $toc.skipped.sections )]" mode="toc"/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="dml:section" mode="toc">
		<fo:list-item xsl:use-attribute-sets="item">
			<!-- <fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap"> -->
			<fo:list-item-label start-indent="body-start()">
				<fo:block></fo:block>
			</fo:list-item-label>
			<!-- <fo:list-item-body start-indent="body-start()"> -->
			<fo:list-item-body>
				<fo:block text-align-last="justify">
					<fo:basic-link xsl:use-attribute-sets="toc.link">
						<xsl:attribute name="internal-destination">
							<xsl:call-template name="get.id"/>
						</xsl:attribute>
						<xsl:if test="@role='appendix'">
							<fo:inline xsl:use-attribute-sets="appendix.prefix">
								<xsl:value-of select="$literals/literals/appendix.prefix"/>
							</fo:inline>
						</xsl:if>
						<xsl:call-template name="header.number">
							<xsl:with-param name="format.number.type">1. </xsl:with-param>
							<xsl:with-param name="appendix.format.number.type" select="concat( $appendix.format.number.type, ' — ' )"/>
						</xsl:call-template>
						<xsl:value-of select="dml:title"/>
					</fo:basic-link>
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">
							<xsl:call-template name="get.id"/>
						</xsl:attribute>
					</fo:page-number-citation>
					<xsl:if test="dml:section and ( count( ancestor::dml:section ) + 1 lt xs:integer( $toc.depth ) )">
						<fo:list-block xsl:use-attribute-sets="list.nested toc.number">
							<xsl:apply-templates select="dml:section" mode="toc"/>
						</fo:list-block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

</xsl:stylesheet>