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
			<dml:item property="dct:issued">2008-11-13</dml:item>
			<dml:item property="dct:description">
				<p>Table of Contents for dml2fo.xsl.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<xsl:template name="toc">
		<fo:block xsl:use-attribute-sets="h2">
			<xsl:value-of select="$literals/literals/toc.title"/>
		</fo:block>
		<fo:list-block xsl:use-attribute-sets="toc">
			<xsl:apply-templates select="
				if ( xs:boolean( $debug ) )
					then /dml:dml/dml:section[( position() gt xs:integer( $toc.skipped.sections ) )]
				else 
					/dml:dml/dml:section[( position() gt xs:integer( $toc.skipped.sections ) ) and not( @status = $status.hidden.values )]
			" mode="toc"/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="dml:section" mode="toc">
		<xsl:variable name="number">
			<xsl:call-template name="header.number">
				<xsl:with-param name="format.number.type">1. </xsl:with-param>
				<xsl:with-param name="appendix.format.number.type" select="concat( $appendix.format.number.type, ' ' )"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:list-item xsl:use-attribute-sets="item">
			<!-- <fo:list-item-label end-indent="label-end()" text-align="end" wrap-option="no-wrap"> -->
			<fo:list-item-label start-indent="body-start()">
				<fo:block></fo:block>
			</fo:list-item-label>
			<!-- <fo:list-item-body start-indent="body-start()"> -->
			<fo:list-item-body>
				<fo:block text-align-last="justify">
					<fo:basic-link xsl:use-attribute-sets="toc.xref">
						<xsl:attribute name="internal-destination">
							<xsl:call-template name="get.id"/>
						</xsl:attribute>
						<xsl:value-of select="
							if ( @role='appendix' and xs:boolean( $appendix.format.number ) ) then
								concat( $literals/literals/appendix.prefix, ' ', $number, $appendix.separator, ' ' )
							else
								$number
						"/>
						<xsl:apply-templates select="dml:title" mode="toc"/>
					</fo:basic-link>
					<!-- <fo:leader leader-pattern="dots"/> -->
					<fo:leader leader-pattern="use-content">. </fo:leader>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">
							<xsl:call-template name="get.id"/>
						</xsl:attribute>
					</fo:page-number-citation>
					<xsl:if test="dml:section and ( count( ancestor::dml:section ) + 1 lt xs:integer( $toc.depth ) )">
						<xsl:choose>
							<xsl:when test="not( xs:boolean( $debug ) ) and dml:section[not( @status = $status.hidden.values )] and dml:section[@status = $status.hidden.values]">
								<fo:list-block xsl:use-attribute-sets="list.nested toc.number">
									<xsl:apply-templates select="dml:section[not( @status = $status.hidden.values )]" mode="toc"/>
								</fo:list-block>
							</xsl:when>
							<xsl:when test="not( xs:boolean( $debug ) ) and dml:section[@status = $status.hidden.values]"/>
							<xsl:otherwise>
								<fo:list-block xsl:use-attribute-sets="list.nested toc.number">
									<xsl:apply-templates select="dml:section" mode="toc"/>
								</fo:list-block>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

</xsl:stylesheet>