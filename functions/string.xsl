<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:fnc="dml2fo:functions" 
	exclude-result-prefixes="xs dml dc rdf xlink fnc">

	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-10-20</dml:item>
			<dml:item property="dc:description">String functions</dml:item>
		</dml:list>
	</dml:note>

	<xsl:function name="fnc:replace">
		<xsl:param name="string"/>
		<xsl:param name="list"/>
		<xsl:value-of select="
			if( empty( $list ) ) 
				then $string 
			else
				fnc:replace( replace( $string,$list[1],$list[2] ), $list[position() &gt; 2] )
		"/>
	</xsl:function>

	<xsl:function name="fnc:capitalize">
		<xsl:param name="string"/>
		<xsl:value-of select="
			concat( upper-case( substring($string, 1, 1) ), substring($string, 2) )
			"/>
	</xsl:function>

	<xsl:function name="fnc:linelength">
		<xsl:param name="context"/>
		<xsl:param name="limit" as="xs:integer"/>
		<xsl:variable name="line" as="xs:string">^(.+)$</xsl:variable>
		<xsl:analyze-string select="$context" regex="{$line}" flags="m">
			<xsl:matching-substring>
				<xsl:value-of select="fnc:linelength.controller( ., $limit )"/>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:function>

	<xsl:function name="fnc:linelength.controller">
		<xsl:param name="context"/>
		<xsl:param name="limit"/>
		<xsl:choose>
			<xsl:when test="string-length( $context ) le $limit">
				<xsl:value-of select="( $context, '&#xA;' )" separator=""/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="second.part.line" select="substring( $context, $limit )"/>
				<xsl:variable name="first.part.line" select="substring-before( $context, $second.part.line )"/>
				<xsl:variable name="indent.spaces.line" select="substring-before( $context, normalize-space( $context ) )"/>
				<xsl:variable name="last.char" select="substring( $first.part.line, string-length( $first.part.line ) )"/>
				<xsl:choose>
					<xsl:when test="not( matches( normalize-space( $first.part.line ), '\s' ) ) or matches( $last.char, '\s' )">
						<xsl:value-of select="
							( 
								$first.part.line, 
								'&#xA;', 
								$indent.spaces.line,
								$second.part.line, 
								'&#xA;'
							)" separator=""/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fnc:linelength.controller( $context, $limit - 1 )"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- count chars -->
	<!-- sum(for $i in preceding-sibling::text() return string-length($i)) -->
	

</xsl:stylesheet>