<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<strong>Näitame kõik nimed</strong>
		<ul>
			<xsl:for-each select="//inimene">
				<xsl:sort select="@saasta" order="descending"/>
				<li>
					<xsl:value-of select="normalize-space(nimi)"/>,
					<xsl:value-of select="@saasta"/>,
					<xsl:value-of select="elukoht"/>,
					vanus: <xsl:value-of select="2025 - @saasta"/>
				</li>
			</xsl:for-each>
		</ul>

		<strong>Kõik andmed tabelina</strong>
		<table border="1">
			<tr>
				<th>Nimi</th>
				<th>Laps</th>
				<th>Sünniaasta</th>
				<th>Elukoht</th>
				<th>Vanus (2025)</th>
			</tr>

			<xsl:for-each select="//inimene">
				<xsl:sort select="@saasta" order="descending"/>
				<tr>
					<!-- Жёлтый фон, если ≥ 2 детей -->
					<xsl:attribute name="style">
						<xsl:if test="count(lapsed/inimene) &gt;= 2">background-color:yellow;</xsl:if>
					</xsl:attribute>

					<!-- Имя с красным цветом, если содержит "a" -->
					<td>
						<xsl:choose>
							<xsl:when test="contains(normalize-space(nimi), 'a') or contains(normalize-space(nimi), 'A')">
								<span style="color:red">
									<xsl:value-of select="normalize-space(nimi)"/>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(nimi)"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>

					<td>
						<xsl:for-each select="lapsed/inimene">
							<xsl:value-of select="normalize-space(nimi)"/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</td>
					<td>
						<xsl:value-of select="@saasta"/>
					</td>
					<td>
						<xsl:value-of select="elukoht"/>
					</td>
					<td>
						<xsl:value-of select="2025 - @saasta"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>

		<strong>Mäng: iga inimese vanus oma vanema sünniaastal</strong>
		<ul>
			<xsl:for-each select="//inimene">
				<li>
					<xsl:value-of select="normalize-space(nimi)"/>
					<xsl:if test="../..">
						- lapsevanema vanus oli
						<xsl:value-of select="../../@saasta - @saasta"/> aastat vana
					</xsl:if>
				</li>
			</xsl:for-each>
		</ul>

		<strong>Mina oma ülesanne: kõige vanem inimene</strong>
		<xsl:for-each select="//inimene">
			<xsl:sort select="@saasta" order="ascending"/>
			<xsl:if test="position() = 1">
				<p style="color:green; font-weight:bold">
					Kõige vanem inimene on:
					<xsl:value-of select="normalize-space(nimi)"/>
					(sündinud <xsl:value-of select="@saasta"/>)
				</p>
			</xsl:if>
		</xsl:for-each>

		<strong>
			<ol>
				<li>
					Count - kogus - üldkogus - kõik nimed jadas:
					<xsl:value-of select="count(//nimi)"/>
				</li>
				<li>
					substring() - eralda kolm esimest tähte nimest
					<xsl:for-each select="//inimene">
						<xsl:value-of select="substring(normalize-space(nimi), 1, 3)"/> |
					</xsl:for-each>
				</li>
				<li>
					substring() - eralda kolm viimast tähte nimest
					<xsl:for-each select="//inimene">
						<xsl:value-of select="substring(normalize-space(nimi), string-length(normalize-space(nimi)) - 2, 3)"/> |
					</xsl:for-each>
				</li>
				<li>
					starts-with "A"
					<xsl:for-each select="//inimene[starts-with(normalize-space(nimi), 'A')]">
						<xsl:value-of select="normalize-space(nimi)"/> ,
					</xsl:for-each>
				</li>
			</ol>
		</strong>

	</xsl:template>

</xsl:stylesheet>
