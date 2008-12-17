<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:fnc="dml2fo:functions" 
	exclude-result-prefixes="xs dml dc rdf fnc">
	
	<xsl:import href="string.xsl"/>

	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-10-20</dml:item>
			<dml:item property="dc:description">Highlighting funcions for code</dml:item>
		</dml:list>
	</dml:note>

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

	<dml:note about="highlight.xml">
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-10-20</dml:item>
			<dml:item property="dc:description">Highlighting XML code</dml:item>
		</dml:list>
	</dml:note>
	<xsl:function name="fnc:xml" xml:id="highlight.xml">
		<xsl:param name="context"/>
		<xsl:param name="limit" as="xs:integer"/>
		<xsl:variable name="comment" as="xs:string">&lt;!--[\w\W-[&lt;&gt;]]*--></xsl:variable>
		<xsl:variable name="tag" as="xs:string">(&lt;/?)([a-zA-Z]+:)?([\w\W-[&lt;&gt;]]+?)(&gt;)</xsl:variable>

		<xsl:variable name="context.formatted">
			<xsl:value-of select="fnc:linelength( $context, $limit )" separator=""/>
		</xsl:variable>

		<xsl:analyze-string select="
			if ( $limit ) then 
				(: strip last &#xA; :)
				replace( $context.formatted, '(.+)\s*$', '$1' )
			else $context
		" regex="{$comment}">
			<xsl:matching-substring>
				<fo:inline xsl:use-attribute-sets="xml.comment">
					<xsl:copy-of select="."/>
				</fo:inline>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="{$tag}">
					<xsl:matching-substring>
						<fo:inline xsl:use-attribute-sets="xml.tag">
							<xsl:value-of select="regex-group(1)"/>
							<xsl:if test="regex-group(1)">
								<fo:inline xsl:use-attribute-sets="xml.ns">
									<xsl:value-of select="regex-group(2)"/>
								</fo:inline>
							</xsl:if>
							<xsl:copy-of select="fnc:xml.attribute( regex-group(3) )"/>
							<xsl:value-of select="regex-group(4)"/>
						</fo:inline>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:copy-of select="fnc:xml.attribute(.)"/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>
	
	<xsl:function name="fnc:xml.attribute">
		<xsl:param name="context"/>
		<xsl:variable name="attribute" as="xs:string">([a-zA-Z]+:)?([a-z\-]+=&#34;)([\w\W-[&#34;]]*)(&#34;)</xsl:variable>
		<xsl:analyze-string select="$context" regex="{$attribute}">
			<xsl:matching-substring>
				<fo:inline xsl:use-attribute-sets="xml.attribute">
					<xsl:if test="regex-group(1)">
						<fo:inline xsl:use-attribute-sets="xml.attribute.ns">
							<xsl:value-of select="regex-group(1)"/>
						</fo:inline>
					</xsl:if>
					<xsl:value-of select="regex-group(2)"/>
					<xsl:if test="regex-group(3)">
						<fo:inline xsl:use-attribute-sets="xml.attribute.value">
							<!-- attempt to control mixin sintax -->
							<!--
							<xsl:choose>
								<xsl:when test="matches( regex-group(2), '(match|select)' )">
									<xsl:copy-of select="fnc:xpath( regex-group(3) )"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="regex-group(3)"/>
								</xsl:otherwise>
							</xsl:choose>
							-->
							<xsl:value-of select="regex-group(3)"/>
						</fo:inline>
					</xsl:if>
					<xsl:value-of select="regex-group(4)"/>
				</fo:inline>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:copy-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>
	
	
	<xsl:function name="fnc:xpath">
		<xsl:param name="context"/>
		<xsl:variable name="rule" as="xs:string">(.+)</xsl:variable>
		<xsl:analyze-string select="$context" regex="{$rule}">
			<xsl:matching-substring>
				<fo:inline xsl:use-attribute-sets="xpath"><xsl:value-of select="regex-group(1)"/></fo:inline>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:copy-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>

	<xsl:function name="fnc:css">
		<xsl:param name="context"/>
		<xsl:param name="limit" as="xs:integer"/>
		<xsl:variable name="rule" as="xs:string">(\s*[\w\W-[\\\{]]+\s+?\\\{)([\w\W-[\\\}]]+)*(\\\})</xsl:variable>
		<xsl:variable name="property" as="xs:string">([\w\W-[:]]+:)([\w\W-[;]]+)(\s?!important)?(;\s*)</xsl:variable>
		<xsl:variable name="arroba-rule" as="xs:string">(\s*@[\w\W-[""\n]]+\s+?)([\w\W]+?)(;\s*)</xsl:variable>

		<xsl:variable name="context.formatted">
			<xsl:value-of select="fnc:linelength( $context, $limit )"/>
		</xsl:variable>

		<xsl:analyze-string select="
			if ( $limit ) then 
				(: strip last &#xA; :)
				replace( $context.formatted, '(.+)\s*$', '$1' )
			else $context
		" regex="{$rule}">
			<xsl:matching-substring>
				<fo:inline xsl:use-attribute-sets="css.rule">
					<fo:inline xsl:use-attribute-sets="css.selector">
						<xsl:value-of select="regex-group(1)"/>
					</fo:inline>
					<xsl:analyze-string select="regex-group(2)" regex="{$property}">
						<xsl:matching-substring>
							<fo:inline xsl:use-attribute-sets="css.property">
								<xsl:value-of select="regex-group(1)"/>
							</fo:inline>
							<fo:inline xsl:use-attribute-sets="css.value">
								<xsl:value-of select="regex-group(2)"/>
							</fo:inline>
							<xsl:if test="regex-group(3)">
								<fo:inline xsl:use-attribute-sets="css.important">
									<xsl:value-of select="regex-group(3)"/>
								</fo:inline>
							</xsl:if>
							<xsl:value-of select="regex-group(4)"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
					<xsl:value-of select="regex-group(3)"/>
				</fo:inline>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="{$arroba-rule}">
					<xsl:matching-substring>
						<fo:inline xsl:use-attribute-sets="css.selector">
							<xsl:value-of select="regex-group(1)"/>
							<fo:inline xsl:use-attribute-sets="css.value">
								<xsl:value-of select="regex-group(2)"/>
							</fo:inline>
							<xsl:value-of select="regex-group(3)"/>
						</fo:inline>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:copy-of select="."/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>

	</xsl:function>

<!--

	<xsl:function name="fnc:javascript">
		<xsl:param name="context"/>
		<xsl:variable name="comment" as="xs:string">(//.*\n)|(/\*.*\*/)</xsl:variable>
		
		<xsl:analyze-string select="$context" regex="{$comment}">
			<xsl:matching-substring>
				<xsl:text>\textcolor{comment}{</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>}</xsl:text>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>
-->

</xsl:stylesheet>