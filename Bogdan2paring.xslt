<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<!-- Вывод всех имён и годов рождения -->
		<strong>Näitame kõik nimed ja sünniaastad</strong>
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

		<!-- Таблица с родителями, бабушками/дедушками, детьми и возрастами -->
		<strong>Kõik andmed tabelina (vanem, vanavanaema, lapsevanema vanus)</strong>
		<table border="1" cellpadding="5" cellspacing="0">
			<tr bgcolor="#cccccc">
				<th>Nimi</th>
				<th>Vanem</th>
				<th>Vanaema</th>
				<th>Laps (nimi (vanus))</th>
				<th>Sünniaasta</th>
				<th>Elukoht</th>
				<th>Vanus (2025)</th>
				<th>Vanus lapse sünniaastal (vanem)</th>
			</tr>

			<xsl:for-each select="//inimene">
				<xsl:sort select="@saasta" order="descending"/>
				<tr>
					<!-- Жёлтый фон, если >= 2 детей -->
					<xsl:attribute name="style">
						<xsl:if test="count(lapsed/inimene) &gt;= 2">background-color:yellow;</xsl:if>
					</xsl:attribute>

					<!-- Имя с зелёным фоном, если длина < 7, и красным цветом, если содержит 'a' -->
					<td>
						<xsl:variable name="nimi" select="normalize-space(nimi)"/>
						<xsl:attribute name="style">
							<xsl:if test="string-length($nimi) &lt; 7">background-color:lightgreen;</xsl:if>
						</xsl:attribute>

						<xsl:choose>
							<xsl:when test="contains($nimi, 'a') or contains($nimi, 'A')">
								<span style="color:red">
									<xsl:value-of select="$nimi"/>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$nimi"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>

					<!-- Vanem (родитель) -->
					<td>
						<xsl:choose>
							<xsl:when test="parent::lapsed/parent::inimene">
								<xsl:value-of select="normalize-space(parent::lapsed/parent::inimene/nimi)"/>
							</xsl:when>
							<xsl:otherwise>—</xsl:otherwise>
						</xsl:choose>
					</td>

					<!-- Vanavanaema (бабушка/дедушка) -->
					<td>
						<xsl:choose>
							<xsl:when test="parent::lapsed/parent::inimene/parent::lapsed/parent::inimene">
								<xsl:value-of select="normalize-space(parent::lapsed/parent::inimene/parent::lapsed/parent::inimene/nimi)"/>
							</xsl:when>
							<xsl:otherwise>—</xsl:otherwise>
						</xsl:choose>
					</td>

					<!-- Laps (nimi (vanus)) -->
					<td>
						<xsl:for-each select="lapsed/inimene">
							<xsl:value-of select="normalize-space(nimi)"/> (<xsl:value-of select="2025 - @saasta"/>)
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

					<!-- Vanus lapse sünniaastal (vanem) -->
					<td>
						<xsl:choose>
							<xsl:when test="parent::lapsed/parent::inimene">
								<xsl:value-of select="parent::lapsed/parent::inimene/@saasta - @saasta"/>
							</xsl:when>
							<xsl:otherwise>—</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
		</table>

		<!-- Список имён с >= 2 детьми -->
		<strong>Isikud, kellel vähemalt 2 last</strong>
		<ul>
			<xsl:for-each select="//inimene[count(lapsed/inimene) &gt;= 2]">
				<li>
					<xsl:value-of select="normalize-space(nimi)"/>
				</li>
			</xsl:for-each>
		</ul>

		<!-- Возраст ребёнка относительно родителя -->
		<strong>Mäng: iga inimese vanus oma vanema sünniaastal</strong>
		<ul>
			<xsl:for-each select="//inimene">
				<li>
					<xsl:value-of select="normalize-space(nimi)"/>
					<xsl:if test="parent::lapsed/parent::inimene">
						- lapsevanema vanus oli
						<xsl:value-of select="parent::lapsed/parent::inimene/@saasta - @saasta"/> aastat vana
					</xsl:if>
				</li>
			</xsl:for-each>
		</ul>

		<!-- Поиск имён с длиной >= 5 и содержащих букву 'a' -->
		<strong>Поиск имён с длиной ≥ 5 и содержащих букву 'a'</strong>
		<ul>
			<xsl:for-each select="//inimene[string-length(normalize-space(nimi)) &gt;= 5 and contains(translate(normalize-space(nimi), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'a')]">
				<li>
					<xsl:value-of select="normalize-space(nimi)"/>
				</li>
			</xsl:for-each>
		</ul>

		<!-- Самый старый человек -->
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

		<!-- Пример работы с функциями substring, starts-with -->
		<strong>
			<ol>
				<li>
					Count - kogus - kõik nimed jadas:
					<xsl:value-of select="count(//nimi)"/>
				</li>
				<li>
					Substring - kolm esimest tähte nimest:
					<xsl:for-each select="//inimene">
						<xsl:value-of select="substring(normalize-space(nimi), 1, 3)"/> |
					</xsl:for-each>
				</li>
				<li>
					Substring - kolm viimast tähte nimest:
					<xsl:for-each select="//inimene">
						<xsl:value-of select="substring(normalize-space(nimi), string-length(normalize-space(nimi)) - 2, 3)"/> |
					</xsl:for-each>
				</li>
				<li>
					Starts-with "A":
					<xsl:for-each select="//inimene[starts-with(normalize-space(nimi), 'A')]">
						<xsl:value-of select="normalize-space(nimi)"/> ,
					</xsl:for-each>
				</li>
			</ol>
		</strong>

	</xsl:template>

</xsl:stylesheet>
