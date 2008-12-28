<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0" 
	xmlns:cdml="http://purl.oclc.org/NET/cdml/1.0" 
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:fnc="dml2fo:functions" 
	exclude-result-prefixes="xs dml cdml dct fnc">
	
	<xsl:import href="config.xsl"/>
	<xsl:import href="modules/inline.xsl"/>
	<xsl:import href="modules/lists.xsl"/>
	<xsl:import href="modules/tables.xsl"/>
	<xsl:import href="modules/code.xsl"/>
	<xsl:import href="modules/bookmarks.xsl"/>
	<xsl:import href="modules/toc.xsl"/>
	<xsl:import href="modules/footnotes.xsl"/>
	<xsl:import href="modules/metadata.xsl"/>

	<xsl:import href="functions/highlight.xsl"/>
	
	<dml:note>
		<dml:list>
			<dml:item property="dct:creator">Arnau Siches</dml:item>
			<dml:item property="dct:issued">2008-11-07</dml:item>
			<dml:item property="dct:description">
				<p>Transforms a DML source to XSL-FO.</p>
			</dml:item>
			<dml:item property="dct:license">
				<!-- todo -->
			</dml:item>
		</dml:list>
	</dml:note>
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="no"/>

	<xsl:template match="/dml:dml | /dml:note">
		<fo:root xsl:use-attribute-sets="root">
			<xsl:call-template name="common.attributes"/>
			<xsl:call-template name="layout.master.set"/>
			<xsl:if test="xs:boolean( $bookmarks )">
				<fo:bookmark-tree>
					<xsl:apply-templates select="
						if ( xs:boolean( $debug ) )
							then /(dml:dml, dml:note)/dml:section
						else 
							/(dml:dml, dml:note)/dml:section[not( @status = $status.hidden.values )]
					" mode="bookmark"/>
				</fo:bookmark-tree>
			</xsl:if>
			<xsl:call-template name="body"/>
		</fo:root>
	</xsl:template>

	<xsl:template name="layout.master.set">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="all.pages" xsl:use-attribute-sets="page">
				<fo:region-body 
					margin-top="{$page.margin.top}"
					margin-right="{$page.margin.right}"
					margin-bottom="{$page.margin.bottom}"
					margin-left="{$page.margin.left}"
					column-count="{$column.count}"
					column-gap="{$column.gap}"/>
				
				<xsl:choose>
					<xsl:when test="$writing.mode = 'tb-rl'">
						<fo:region-before extent="{$page.margin.right}" precedence="true"/>
						<fo:region-after extent="{$page.margin.left}" precedence="true"/>
						<fo:region-start 
							region-name="page.header"
							extent="{$page.margin.top}"
							writing-mode="lr-tb"
							display-align="before"/>
						<fo:region-end 
							region-name="page.footer"
							extent="{$page.margin.bottom}"
							writing-mode="lr-tb"
							display-align="after"/>
					</xsl:when>
					<xsl:when test="$writing.mode = 'rl-tb'">
						<fo:region-before 
							region-name="page.header"
							extent="{$page.margin.top}"
							display-align="before"/>
						<fo:region-after 
							region-name="page.footer"
							extent="{$page.margin.bottom}"
							display-align="after"/>
						<fo:region-start extent="{$page.margin.right}"/>
						<fo:region-end extent="{$page.margin.left}"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:region-before 
							region-name="page.header"
							extent="{$page.margin.top}"
							display-align="before"/>
						<fo:region-after 
							region-name="page.footer"
							extent="{$page.margin.bottom}"
							display-align="after"/>
						<fo:region-start extent="{$page.margin.left}"/>
						<fo:region-end extent="{$page.margin.bottom}"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:simple-page-master>
		</fo:layout-master-set>
		<xsl:call-template name="metadata"/>
	</xsl:template>

	<xsl:template name="body">
		<fo:page-sequence master-reference="all.pages">
			<fo:title>
				<xsl:value-of select="$document.title"/>
			</fo:title>
			<fo:static-content flow-name="page.header">
				<xsl:call-template name="header.content"/>
			</fo:static-content>
			<fo:static-content flow-name="page.footer">
				<fo:block space-after.conditionality="retain" space-after="{$page.footer.margin}" xsl:use-attribute-sets="page.footer">
					<fo:block text-align-last="justify">
						<xsl:value-of select="$document.title"/>
						<fo:leader/>
						<fo:page-number/>
						<xsl:value-of select="( ' ', $literals/literals/pagenumber.preposition, ' ' )"/>
						<fo:page-number-citation ref-id="last.page"/>
					</fo:block>
				</fo:block>
			</fo:static-content>
			<fo:static-content flow-name="xsl-footnote-separator">
				<fo:block>
					<fo:leader leader-pattern="rule"
						leader-length="10%"
						rule-style="solid"
						rule-thickness="0.5pt"/>
					</fo:block>
				</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block xsl:use-attribute-sets="document.title">
					<xsl:apply-templates select="$document.title"/>
				</fo:block>
				<xsl:call-template name="date.issued"/>

				<fo:block xsl:use-attribute-sets="body">
					<xsl:call-template name="common.attributes"/>

					<xsl:if test="xs:boolean( $toc ) and ( xs:integer( $toc.position ) eq 0 )">
						<xsl:call-template name="toc"/>
					</xsl:if>
					<xsl:apply-templates select="dml:*[not( self::dml:title or self::dml:metadata )]"/>

					<xsl:if test="xs:boolean( $toc ) and ( xs:integer( $toc.position ) eq -1 )">
						<xsl:call-template name="toc"/>
					</xsl:if>

					<fo:block id="last.page"/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

	<!-- todo -->
	<xsl:template match="dml:metadata"/>
	
	<xsl:template name="date.issued">
		<xsl:variable name="document.id" select="/( dml:dml, dml:note )/@xml:id"/>
		<xsl:variable name="document.metadata" select="if ( $document.id ) then concat( '#', $document.id ) else ()"/>
		<xsl:variable name="document.metadata.node" select="/( dml:dml, dml:note )/dml:metadata[@about=$document.metadata]"/>
		<xsl:variable name="date.property" select="if ( fnc:dc.extractor( $document.metadata.node, 'modified' ) ) then 'modified' else 'issued'"/>
		<!-- <xsl:variable name="date.property" select="if ( //dml:metadata[@about=$document.metadata]//@property='dct:modified' ) then 'dct:modified' else 'dct:issued'"/> -->
		<xsl:variable name="isodate" select="fnc:dc.extractor( $document.metadata.node, $date.property )"/>
		<!-- <xsl:variable name="isodate" select="//dml:metadata[@about=$document.metadata]//*[@property eq $date.property]"/> -->

		<xsl:if test="xs:boolean( $date.issued )">
			<fo:block xsl:use-attribute-sets="date.issued">
				<xsl:choose>
					<xsl:when test="$isodate castable as xs:date">
						<xsl:variable name="day" select="number( format-date( $isodate, '[F1]' ) )"/>
						<xsl:variable name="month" select="number( format-date( $isodate, '[M1]' ) )"/>
						<xsl:value-of select="
							if ( lang('ca') or lang('es') ) then
								( $literals/literals/month/item[$month], $literals/literals/date.preposition, year-from-date( $isodate ) )
							else
								( $literals/literals/month/item[$month], year-from-date( $isodate ) )
						"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$isodate/node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="header.content">
		<fo:block></fo:block>
	</xsl:template>

	<xsl:template name="common.attributes.and.children">
		<xsl:call-template name="common.attributes"/>
		<xsl:choose>
			<xsl:when test="not( xs:boolean( $debug ) ) and ( @status = $status.hidden.values )"/>
			<xsl:otherwise>
				<xsl:call-template name="common.children"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="common.children">
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
			<xsl:when test="//dml:note[( @role eq 'footnote' ) and ( @xml:id eq $idref )] and $href">
				<xsl:call-template name="xref.footnote">
					<xsl:with-param name="idref" select="$idref"/>
				</xsl:call-template>
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
				<fo:inline xsl:use-attribute-sets="xref">
					<xsl:text> (</xsl:text>
					<xsl:choose>
						<xsl:when test="$first.char eq '#'">
							<xsl:if test="xs:boolean( $header.numbers ) and id( $idref )[ancestor-or-self::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]]">
								<xsl:for-each select="id( $idref )">
									<xsl:variable name="number">
										<xsl:call-template name="header.number"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$element.name eq 'table'">
											<xsl:value-of select="concat( $literals/literals/table.label, ' ', $number )"/>
											<xsl:number from="dml:section" count="dml:table" level="any" format="-1"/>
										</xsl:when>
										<xsl:when test="$element.name eq 'figure'">
											<xsl:value-of select="concat( $literals/literals/figure.label, ' ', $number )"/>
											<xsl:number from="dml:section" count="dml:figure" level="any" format="-1"/>
										</xsl:when>
										<xsl:when test="$element.name eq 'example'">
											<xsl:value-of select="concat( $literals/literals/example.label, ' ', $number )"/>
											<xsl:number from="dml:section" count="dml:example" level="any" format="-1"/>
										</xsl:when>
										<xsl:when test="id( $idref )/ancestor-or-self::*[@role='appendix']">
											<xsl:value-of select="concat( $literals/literals/appendix.prefix, ' ', $number )"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat( $literals/literals/section, ' ', $number )"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="concat( $literals/literals/page/@abbr, ' ' )"/>
							<fo:page-number-citation ref-id="{$idref}"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$href"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>)</xsl:text>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="common.attributes">
		<xsl:attribute name="role">
			<xsl:value-of select="concat( 'dml:', local-name() )"/>
		</xsl:attribute>
		<xsl:if test="@xml:lang">
			<xsl:attribute name="xml:lang" select="@xml:lang"/>
			<xsl:if test="@xml:lang ne /*/@xml:lang">
				<xsl:call-template name="foreign.language"/>
			</xsl:if>
		</xsl:if>

		<xsl:call-template name="set.id"/>
		<xsl:if test="@align">
			<!-- TODO: must be ignored? -->
			<xsl:attribute name="align" select="@align"/>
		</xsl:if>
		<xsl:if test="xs:boolean( $debug )">
			<xsl:call-template name="debug.attributes"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="debug.attributes">
		<xsl:choose>
			<xsl:when test="@status eq 'draft'">
				<xsl:call-template name="draft.attribute.set"/>
				<fo:inline>(<xsl:value-of select="$literals/literals/debug.draft"/>) </fo:inline>
			</xsl:when>
			<xsl:when test="@status eq 'review'">
				<xsl:call-template name="review.attribute.set"/>
				<fo:inline>(<xsl:value-of select="$literals/literals/debug.review"/>) </fo:inline>
			</xsl:when>
			<xsl:when test="@status eq 'added'">
				<xsl:call-template name="added.attribute.set"/>
				<fo:inline><xsl:value-of select="$literals/literals/debug.added"/> </fo:inline>
			</xsl:when>
			<xsl:when test="@status eq 'deleted'">
				<xsl:call-template name="deleted.attribute.set"/>
				<fo:inline><xsl:value-of select="$literals/literals/debug.deleted"/> </fo:inline>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="get.id">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<xsl:value-of select="@xml:id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="generate-id()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="set.id">
		<xsl:attribute name="id">
			<xsl:call-template name="get.id"/>
		</xsl:attribute>
	</xsl:template>


	<xsl:template match="dml:section">
		<fo:block xsl:use-attribute-sets="section">
			<xsl:call-template name="common.attributes"/>
			<xsl:if test="xs:boolean( $toc ) and parent::dml:dml and ( count( preceding-sibling::dml:section ) eq xs:integer( $toc.skipped.sections ) )">
				<xsl:call-template name="toc"/>
			</xsl:if>
			<xsl:call-template name="common.children"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:section/dml:title">
		<xsl:variable name="section.counter" select="count( ancestor::dml:section )"/>
		<xsl:choose>
			<xsl:when test="$section.counter eq 1">
				<fo:block xsl:use-attribute-sets="h1">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$section.counter eq 2">
				<fo:block xsl:use-attribute-sets="h2">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$section.counter eq 3">
				<fo:block xsl:use-attribute-sets="h3">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$section.counter eq 4">
				<fo:block xsl:use-attribute-sets="h4">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$section.counter eq 5">
				<fo:block xsl:use-attribute-sets="h5">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="h6">
					<xsl:call-template name="header.children"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="header.children">
		<xsl:call-template name="common.attributes"/>
		<xsl:call-template name="header.children.number"/>
		<xsl:call-template name="common.children"/>
	</xsl:template>
	<xsl:template name="header.children.number">
		<xsl:variable name="number">
			<xsl:call-template name="header.number">
				<xsl:with-param name="format.number.type">1. </xsl:with-param>
				<xsl:with-param name="appendix.format.number.type" select="concat( $appendix.format.number.type, ' ' )"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="
			if ( parent::dml:section[@role='appendix'] and xs:boolean( $appendix.format.number ) ) then
				concat( $literals/literals/appendix.prefix, ' ', $number, $appendix.separator )
			else
				$number
		"/>
	</xsl:template>
	
	<xsl:template name="header.number">
		<xsl:param name="format.number.type"/>
		<xsl:param name="appendix.format.number.type" select="$appendix.format.number.type"/>
		<xsl:if test="xs:boolean( $header.numbers )">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::dml:*[parent::dml:dml and @role='appendix'] and xs:boolean( $appendix.format.number )">
					<xsl:number count="dml:section[ancestor-or-self::dml:*[parent::dml:dml and @role='appendix']]" level="multiple" format="{$appendix.format.number.type}"/>
				</xsl:when>
				<xsl:when test="ancestor-or-self::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]">
					<xsl:number count="dml:section[ancestor-or-self::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]]" level="multiple" format="{$format.number.type}"/>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dml:p">
		<fo:block xsl:use-attribute-sets="p">
			<xsl:call-template name="common.attributes.and.children"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="dml:figure">
		<fo:block xsl:use-attribute-sets="figure">
			<xsl:call-template name="common.attributes"/>
			<xsl:apply-templates select="*[not( self::dml:title )]"/>
			<xsl:apply-templates select="dml:title"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="dml:figure/dml:title">
		<xsl:variable name="numbering.figure">
			<xsl:call-template name="header.number"/>
			<xsl:number from="dml:section" count="dml:figure" level="any" format="-1"/>
		</xsl:variable>
		
		<fo:block xsl:use-attribute-sets="figure.title">
			<xsl:call-template name="common.attributes"/>
			<xsl:if test="xs:boolean( $header.numbers ) and ancestor::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]">
				<fo:inline xsl:use-attribute-sets="figure.label">
					<xsl:value-of select="concat( $literals/literals/figure.label, ' ', $numbering.figure, ': ')"/>
				</fo:inline>
			</xsl:if>
			<xsl:call-template name="common.children"/>
		</fo:block>
	</xsl:template>


	<xsl:template match="dml:example">
		<xsl:choose>
			<xsl:when test="dml:title">
				<fo:block xsl:use-attribute-sets="example.with.title">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="example">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dml:example/dml:title">
		<xsl:variable name="numbering.example">
			<xsl:call-template name="header.number"/>
			<xsl:number from="dml:section" count="dml:example" level="any" format="-1"/>
		</xsl:variable>
		
		<fo:block xsl:use-attribute-sets="example.title">
			<xsl:call-template name="common.attributes"/>
			<xsl:if test="xs:boolean( $header.numbers ) and ancestor::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]">
				<fo:inline xsl:use-attribute-sets="example.label">
					<xsl:value-of select="concat( $literals/literals/example.label, ' ', $numbering.example, ': ')"/>
				</fo:inline>
			</xsl:if>
			<xsl:call-template name="common.children"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="dml:note[@role='warning']">
		<xsl:choose>
			<xsl:when test="dml:title">
				<fo:block xsl:use-attribute-sets="warning.with.title">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="warning">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dml:note[@role='warning']/dml:title">
		<fo:block xsl:use-attribute-sets="warning.title">
			<xsl:call-template name="common.attributes"/>
			<!-- <fo:inline xsl:use-attribute-sets="warning.label">
				<xsl:value-of select="concat( $literals/literals/warning.label, ': ')"/>
			</fo:inline> -->
			<xsl:call-template name="common.children"/>
		</fo:block>
	</xsl:template>


	<xsl:template match="dml:note[@role='tip']">
		<xsl:choose>
			<xsl:when test="dml:title">
				<fo:block xsl:use-attribute-sets="tip.with.title">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="tip">
					<xsl:call-template name="common.attributes.and.children"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dml:note[@role='tip']/dml:title">
		<fo:block xsl:use-attribute-sets="tip.title">
			<xsl:call-template name="common.attributes"/>
			<xsl:call-template name="common.children"/>
		</fo:block>
	</xsl:template>


</xsl:stylesheet>