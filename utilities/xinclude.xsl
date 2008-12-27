<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dml="http://purl.oclc.org/NET/dml/1.0"
	xmlns:cdml="http://purl.oclc.org/NET/cdml/1.0"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xifnc="xi:functions"
	exclude-result-prefixes="xs dml cdml dc">

	<dml:note>
		<dml:list>
			<dml:item property="dc:creator">Arnau Siches</dml:item>
			<dml:item property="dc:issued">2008-12-20</dml:item>
			<dml:item property="dc:description">
				<p>Process all <cdml:node role="element">xi:include</cdml:node> elements with <cdml:node role="attribute">xpointer</cdml:code> attribute.</p>
				<p>It supports <cdml:code>xpointer()</cdml:code> scheme and <cdml:code>xmlns()</cdml:code> scheme partially.</p>
				<p>XPointer Expressions allowed:</p>
				<list>
					<item><cdml:code>xpointer(/e)</cdml:code></item>
					<item><cdml:code>xpointer(/e/f)</cdml:code></item>
					<item><cdml:code>xpointer(//e)</cdml:code></item>
					<item><cdml:code>xpointer(/e[1])</cdml:code></item>
					<item><cdml:code>xpointer(/e[@attr])</cdml:code></item>
					<item><cdml:code>xpointer(/e[@attr='value'])</cdml:code></item>
					<item><cdml:code>xpointer(id('value'))</cdml:code></item>
					<item><cdml:code>xmlns(p=http://example/ns) xpointer(/p:e)</cdml:code></item>
				</list>
				<p>This stylesheet is heavily inspired in <span href="http://dret.net/projects/xipr/">XInclude Processor (XIPr)</span>. Thanks to <span href="http://dret.net/netdret/">Erik Wilde</span> for it.</p>
			</dml:item>
			<dml:item property="dc:license">
				<p>This stylesheet is licensed under the <span href="http://creativecommons.org/licenses/LGPL/2.1/">GNU Lesser General Public License (LGPL)</span>.</p>
			</dml:item>
		</dml:list>
	</dml:note>
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
	<!-- <xsl:strip-space elements="*"/> -->

	<xsl:template match="/*">
		<xsl:apply-templates select="." mode="xi"/>
	</xsl:template>

	<xsl:template match="@* | node()" mode="xi">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="xi"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="xi:include" mode="xi">
		<xsl:if test="count( xi:fallback ) gt 1 or exists( xi:*[local-name() ne 'fallback'] )">
			<xsl:sequence select="xifnc:message('/xi:include elements may only have no or one single xi:fallback element as their only xi:* child.', 'fatal')"/>
		</xsl:if>
		<xsl:if test="exists( @accept )">
			<xsl:sequence select="xifnc:message('The @accept attribute is not supported.', 'info')"/>
		</xsl:if>
		<xsl:if test="exists(@accept-language)">
			<xsl:sequence select="xifnc:message('The @accept-language attribute is not supported.', 'info')"/>
		</xsl:if>

		<xsl:variable name="uri" select="
			if ( empty( @href ) and empty( @xpointer ) ) then
				xifnc:message( 'If the @xpointer attribute is absent, the @href attribute must be present.', 'fatal' )
			else if ( empty( @href ) ) then
				document-uri(/)
			else
				resolve-uri( @href, document-uri(/) )
		"/>
		<xsl:choose>
			<xsl:when test="@parse eq 'xml' or empty( @parse )">
				<xsl:choose>
					<xsl:when test="doc-available( $uri )">
						<xsl:variable name="document" select="doc( $uri )"/>
						<xsl:sequence select="
							if ( empty( @xpointer ) ) then
								xifnc:include( $document, 0 )
							else
								xifnc:include( $document, @xpointer )
						"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="xifnc:message( concat( 'Could not read document ', $uri ), 'resource' )"/>
						<xsl:call-template name="fallback"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@parse eq 'text'">
				<xsl:value-of select="
					if ( unparsed-text-available( $uri ) ) then
						if ( empty( @encoding ) ) then
							unparsed-text( $uri )
						else
							unparsed-text( $uri, @encoding )
					else
						xifnc:message( concat( 'Could not read document ', $uri ), 'resource' )
				"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="xifnc:message( concat( 'Unknow `', $uri, '` for xi:include[@parse]' ), 'fatal' )"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="xifnc:include">
		<xsl:param name="context"/>
		<xsl:param name="xpointer"/>

		<xsl:variable name="schemes" select="tokenize( normalize-space( string( $xpointer ) ), '\s+' )"/>
		<xsl:variable name="xpointer.scheme" select="
			for $i in $schemes return
				if ( matches( $i, '^xpointer\(\s*.+?\s*\)$' ) ) then $i else ()
		"/>
		<xsl:variable name="xmlns.scheme" select="
			(: FORECAST: Support multiple xmlns() scheme for same prefix :)
			for $i in $schemes return
				if ( matches( $i, '^xmlns\(\s*.+?\s*\)$' ) ) then replace( $i, 'xmlns\(\s*(.+)\s*\)', '$1' ) else ()
		"/>

		<xsl:variable name="xpath" select="
			(: FORECAST: Support multiple xpointer() scheme :)
			if ( $xpointer ) then
				(: FORECAST: Support element() scheme :)
				if ( some $i in $schemes satisfies not( matches( $i, '(^|\s+)(xpointer|xmlns)\(\s*.+\s*\)(\s+|$)' ) ) ) then
					xifnc:message( 'This processor only supports xpointer() and xmlns() schemes', 'fatal' )
				else if ( count( $xpointer.scheme ) eq 1 ) then
					tokenize(
						replace( $xpointer.scheme, 'xpointer\(\s*/?(.+)\s*\)', '$1' ),
						'/'
					)
				else
					xifnc:message( 'Multiple xpointer() schemes are not supported', 'fatal' )
			else
				string( $xpointer ) (: Empty xpointer :)
		"/>
		<xsl:variable name="immutable.xmlns" select="
			(:
				XPointer xmlns() Scheme (http://www.w3.org/TR/xptr-xmlns/):
				The xml prefix bind to the URI http:/www.w3.org/XML/1998/namespace.
				The xmlns prefix bind to the URI http://www.w3.org/2000/xmlns/
			:)
			(
				'xml=http:/www.w3.org/XML/1998/namespace',
				'xmlns=http://www.w3.org/2000/xmlns/'
			)
		"/>
		<xsl:variable name="xmlns" select="
			insert-before(
				$immutable.xmlns, 1,
				for $i in $xmlns.scheme return
					if ( matches( $i, '^(xml|xmlns)=.+$' ) ) then
						xifnc:message( '`xml` prefix bind to `http:/www.w3.org/XML/1998/namespace` and `xmlns` prefix bind to `http://www.w3.org/2000/xmlns/` automatically', 'warning' )
					else
						$i
			)
		"/>
		<xsl:sequence select="xifnc:include.step( $context, $xpath, $xmlns )"/>
	</xsl:function>

	<xsl:function name="xifnc:include.step">
		<xsl:param name="context"/>
		<xsl:param name="xpath"/>
		<xsl:param name="xmlns"/>

		<xsl:variable name="context.with.step" select="xifnc:step.parser( $context, $xpath[1], $xmlns )"/>

		<xsl:choose>
			<xsl:when test="exists( $xpath[2] )">
				<xsl:sequence select="xifnc:include.step( $context.with.step, remove( $xpath, 1 ), $xmlns )"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$context.with.step">
					<xsl:apply-templates select="." mode="xi"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="xifnc:step.parser">
		<xsl:param name="context"/>
		<xsl:param name="step"/>
		<xsl:param name="xmlns"/>
		<!-- Name and NCName uses XML 1.0 fourth edition pattern -->
		<!-- http://www.w3.org/TR/xmlschema-2/#NCName -->
		<xsl:variable name="NCName.pattern">[\i-[:]][\c-[:]]*</xsl:variable>
		<!-- http://www.w3.org/TR/REC-xml#NT-Name -->
		<xsl:variable name="Name.pattern">\i\c*</xsl:variable>
		<xsl:variable name="QName.pattern">(<xsl:value-of select="$NCName.pattern"/>):(<xsl:value-of select="$NCName.pattern"/>)</xsl:variable>
		<xsl:variable name="EntityRef.pattern">&amp;<xsl:value-of select="$NCName.pattern"/>;</xsl:variable>
		<xsl:variable name="CharRef.pattern">&amp;#x?[0-9a-zA-Z]+;</xsl:variable>

		<xsl:variable name="AttrValue.pattern">([^&lt;&amp;']|<xsl:value-of select="$EntityRef.pattern"/>|<xsl:value-of select="$CharRef.pattern"/>)*</xsl:variable>
		<xsl:variable name="Attribute.pattern">@(<xsl:value-of select="$Name.pattern"/>)(\s*=\s*'(<xsl:value-of select="$AttrValue.pattern"/>)?')?</xsl:variable>

		<xsl:variable name="position.pattern">(position\(\s*\)\s*=\s*)?(\d+)</xsl:variable>

		<xsl:choose>
			<xsl:when test="$step eq ''">
				<!-- double slash (//) step. ie. //a -->
				<xsl:sequence select="$context//*"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:analyze-string select="$step" regex="^0$">
					<xsl:matching-substring>
						<!-- without @xpointer -->
						<xsl:sequence select="$context"/>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:analyze-string select="." regex="^id\(\s*'({$NCName.pattern})'\s*\)$">
							<xsl:matching-substring>
								<!-- id() -->
								<xsl:sequence select="$context/id( regex-group(1) )"/>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
								<xsl:analyze-string select="." regex="^({$Name.pattern}|\*)(\[\s*(.+)\s*\])?$">
									<xsl:matching-substring>
										<xsl:variable name="QName.prefix.pattern" select="replace( regex-group(1), $QName.pattern, '$1' )"/>
										<xsl:variable name="xmlns.scheme.pattern">^<xsl:value-of select="$QName.prefix.pattern"/>=(.+)$</xsl:variable>
										<xsl:variable name="xmlns.uri" select="
											for $i in $xmlns return
												if ( matches( $i, $xmlns.scheme.pattern ) ) then
													replace( $i, $xmlns.scheme.pattern, '$1' )
												else
													()
										"/>
										<xsl:variable name="context.with.element.name" select="
											$context/*[
												if ( regex-group(1) ne '*' ) then
													local-name() eq replace( regex-group(1), $QName.pattern, '$2' ) (: strip prefix :)
												else
													local-name()
											]
										"/>
										<xsl:variable name="context.with.element" select="
											if ( matches( regex-group(1), $QName.pattern ) ) then
												if ( $xmlns.uri[1] ) then (: prevent multiple values for same xmlns :)
													$context.with.element.name[namespace-uri() eq $xmlns.uri[1]]
												else
													xifnc:message( 'QName prefix not defined with xmlns() scheme', 'fatal' )
											else
												$context.with.element.name
										"/>

										<xsl:choose>
											<xsl:when test="regex-group(2)">
												<!-- with predicate -->
												<xsl:analyze-string select="regex-group(3)" regex="{$position.pattern}">
													<xsl:matching-substring>
														<xsl:sequence select="
															(: position():  *[1], a[position()=1] :)
															$context.with.element[
																number( regex-group(2) )
															]
														"/>
													</xsl:matching-substring>
													<xsl:non-matching-substring>
														<xsl:analyze-string select="." regex="{$Attribute.pattern}">
															<xsl:matching-substring>
																<xsl:sequence select="
																	(: @attribute:  *[@attr], a[@attr='val'] :)
																	$context.with.element[
																		if ( regex-group(2) ) then
																			@*[name() eq regex-group(1)][. eq regex-group(3)]
																		else
																			@*[name() eq regex-group(1)]
																	]
																"/>
															</xsl:matching-substring>
															<xsl:non-matching-substring>
																<xsl:sequence select="xifnc:message( concat( $step, ' predicate in XPointer expression is not supported' ), 'fatal' )"/>
															</xsl:non-matching-substring>
														</xsl:analyze-string>
													</xsl:non-matching-substring>
												</xsl:analyze-string>
											</xsl:when>
											<xsl:otherwise>
												<!-- without predicate -->
												<xsl:sequence select="$context.with.element"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:sequence select="xifnc:message( concat( $step, ' step in XPointer expression is not supported' ), 'fatal' )"/>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="fallback">
		<xsl:choose>
			<xsl:when test="count( xi:fallback ) eq 1">
				<xsl:apply-templates select="xi:fallback/node()" mode="xi"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="xifnc:message( 'No xi:fallback for resource error', 'fatal' )"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="xifnc:message">
		<xsl:param name="message"/>
		<xsl:param name="level"/>
		<xsl:variable name="levels" select="( 'info', 'warning', 'resource' )"/>
		<xsl:variable name="condition" select="some $i in $levels satisfies $i eq $level"/>
		<xsl:message terminate="{ if ( $condition ) then 'no' else 'yes' }">
			<xsl:value-of select="
				if ( $condition ) then
					( upper-case( $level ), $message )
				else
					( 'FATAL ERROR', $message )
			" separator=": "/>
		</xsl:message>
	</xsl:function>

</xsl:stylesheet>