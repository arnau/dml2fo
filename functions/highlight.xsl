<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:fnc="dml2fo:functions"
	exclude-result-prefixes="xs dml dct rdf fnc">
	
	<xsl:import href="string.xsl"/>

	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-10-20</dml:item>
			<dml:item property="dct:description">Highlighting funcions for code</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>

	<dml:note about="#highlight.xml">
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-10-20</dml:item>
			<dml:item property="dct:description">Highlighting XML code</dml:item>
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
		<xsl:param name="limit" as="xs:integer"/>
		<xsl:variable name="variable">(\$[^\[\]\(\)\s\*\+\?]+)</xsl:variable>
		<xsl:variable name="comment">(\(:.+?:\))</xsl:variable>
		<xsl:variable name="predicate">(\[|\])</xsl:variable>
		<xsl:variable name="storage">(\(|\))</xsl:variable>
		<xsl:variable name="operator">(\s)(or|\||,|and|lt|gt|ne|eq)(\s)</xsl:variable>
		<xsl:variable name="modifier">(\*|\+|\?)</xsl:variable>
		<xsl:variable name="axis">((self|parent|ancestor|ancestor-or-self|preceding|preceding-sibling|following|following-sibling|child|descendant|descendant-or-self)::)</xsl:variable>
		<xsl:variable name="function">([a-zA-Z-_\.]+)(\()</xsl:variable>
		<xsl:variable name="node">(@?\i\c*)</xsl:variable>

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
				<fo:inline xsl:use-attribute-sets="xpath.comment"><xsl:value-of select="regex-group(1)"/></fo:inline>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="{$variable}">
					<xsl:matching-substring>
						<fo:inline xsl:use-attribute-sets="xpath.variable"><xsl:value-of select="regex-group(1)"/></fo:inline>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:analyze-string select="." regex="{$function}">
							<xsl:matching-substring>
								<fo:inline xsl:use-attribute-sets="xpath.function"><xsl:value-of select="regex-group(1)"/></fo:inline>
								<fo:inline xsl:use-attribute-sets="xpath.storage"><xsl:value-of select="regex-group(2)"/></fo:inline>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
								<xsl:analyze-string select="." regex="{$operator}">
									<xsl:matching-substring>
										<xsl:value-of select="regex-group(1)"/>
										<fo:inline xsl:use-attribute-sets="xpath.operator"><xsl:value-of select="regex-group(2)"/></fo:inline>
										<xsl:value-of select="regex-group(3)"/>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:analyze-string select="." regex="{$modifier}">
											<xsl:matching-substring>
												<fo:inline xsl:use-attribute-sets="xpath.modifier"><xsl:value-of select="regex-group(1)"/></fo:inline>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:analyze-string select="." regex="{$axis}">
													<xsl:matching-substring>
														<fo:inline xsl:use-attribute-sets="xpath.axis"><xsl:value-of select="regex-group(1)"/></fo:inline>
													</xsl:matching-substring>
													<xsl:non-matching-substring>
														<xsl:analyze-string select="." regex="{$storage}">
															<xsl:matching-substring>
																<fo:inline xsl:use-attribute-sets="xpath.storage"><xsl:value-of select="regex-group(1)"/></fo:inline>
															</xsl:matching-substring>
															<xsl:non-matching-substring>
																<xsl:analyze-string select="." regex="{$node}">
																	<xsl:matching-substring>
																		<fo:inline xsl:use-attribute-sets="xpath.node"><xsl:value-of select="regex-group(1)"/></fo:inline>
																	</xsl:matching-substring>
																	<xsl:non-matching-substring>
																		<xsl:analyze-string select="." regex="{$predicate}">
																			<xsl:matching-substring>
																				<fo:inline xsl:use-attribute-sets="xpath.predicate"><xsl:value-of select="regex-group(1)"/></fo:inline>
																			</xsl:matching-substring>
																			<xsl:non-matching-substring>
																				<xsl:copy-of select="."/>
																			</xsl:non-matching-substring>
																		</xsl:analyze-string>
																	</xsl:non-matching-substring>
																</xsl:analyze-string>
															</xsl:non-matching-substring>
														</xsl:analyze-string>
													</xsl:non-matching-substring>
												</xsl:analyze-string>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>

	<xsl:function name="fnc:css">
		<xsl:param name="context"/>
		<xsl:param name="limit" as="xs:integer"/>
		<xsl:variable name="rule" as="xs:string">(\s*[\w\W-[\{]]+\s+?)(\{)([\w\W-[\}]]+)*(\})?</xsl:variable>
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
					<xsl:value-of select="regex-group(2)"/>
					<xsl:analyze-string select="regex-group(3)" regex="{$property}">
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
					<xsl:value-of select="regex-group(4)"/>
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

	<xsl:function name="fnc:ebnf">
		<xsl:param name="context"/>
		<xsl:param name="limit" as="xs:integer"/>

		<xsl:apply-templates select="$context/node()" mode="code"/>
	</xsl:function>

	<xsl:template match="dml:span" mode="code">
		<xsl:variable name="href" select="@href"/>
		<xsl:variable name="first.char" select="substring( $href, 1, 1 )"/>
		<xsl:variable name="idref" select="substring-after( $href, '#' )"/>
		<xsl:variable name="element.name" select="id( $idref )/local-name()"/>
		<xsl:choose>
			<xsl:when test="not( id( $idref ) ) and $first.char eq '#'">
				<xsl:choose>
					<xsl:when test="xs:boolean( $debug )">
						<fo:inline xsl:use-attribute-sets="xref.error">
							<xsl:apply-templates/> (xref error)
						</fo:inline>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$href">
				<fo:basic-link xsl:use-attribute-sets="toc.xref">
					<xsl:choose>
						<xsl:when test="$first.char eq '#'">
							<xsl:attribute name="internal-destination" select="$idref"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="external-destination" select="$href"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

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