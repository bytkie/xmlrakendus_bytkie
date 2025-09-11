<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"/>
	<xsl:param name="red-letter" select="'a'"/>

	<!-- Ключ для подсчёта людей по elukoht (элемент) -->
	<xsl:key name="people-by-location" match="inimene" use="normalize-space(elukoht)"/>

	<xsl:template match="/">
		<html>
			<head>
				<style>
					table { border-collapse: collapse; width: 100%; }
					th, td { border: 1px solid black; padding: 5px; text-align: left; }
					.red { color: red; }
					.yellow-bg { background-color: yellow; }
				</style>
				<title>Genealoogia</title>
			</head>
			<body>

				

				<!-- Tabel kõikidest inimestest -->
				<h2>Tabel kõikidest inimestest</h2>
				<table>
					<thead>
						<tr style="background:#ccc">
							<th>Nimi</th>
							<th>Sünniaasta</th>
							<th>Elukoht</th>
							<th>Laste arv</th>
							<th>Vanem</th>
							<th>Vanaema</th>
							<th>Vanuse erinevus vanema sünniaastaga</th>
							<th>Laste koguvanus 2025</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="//inimene">
							<tr>
								<xsl:attribute name="class">
									<xsl:if test="count(lapsed/inimene) &gt;= 2">yellow-bg</xsl:if>
								</xsl:attribute>

								<td>
									<xsl:variable name="nimi" select="normalize-space(nimi)"/>
									<xsl:variable name="nimi-lc" select="translate($nimi, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
									<xsl:choose>
										<xsl:when test="contains($nimi-lc, $red-letter)">
											<span class="red">
												<xsl:value-of select="$nimi"/>
											</span>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$nimi"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>

								<td>
									<xsl:value-of select="@saasta"/>
								</td>
								<td>
									<xsl:value-of select="normalize-space(elukoht)"/>
								</td>
								<td>
									<xsl:value-of select="count(lapsed/inimene)"/>
								</td>

								<td>
									<xsl:choose>
										<xsl:when test="parent::lapsed/parent::inimene">
											<xsl:value-of select="normalize-space(parent::lapsed/parent::inimene/nimi)"/>
										</xsl:when>
										<xsl:otherwise>—</xsl:otherwise>
									</xsl:choose>
								</td>

								<td>
									<xsl:choose>
										<xsl:when test="parent::lapsed/parent::inimene/parent::lapsed/parent::inimene">
											<xsl:value-of select="normalize-space(parent::lapsed/parent::inimene/parent::lapsed/parent::inimene/nimi)"/>
										</xsl:when>
										<xsl:otherwise>—</xsl:otherwise>
									</xsl:choose>
								</td>

								<td>
									<xsl:choose>
										<xsl:when test="parent::lapsed/parent::inimene">
											<xsl:value-of select="parent::lapsed/parent::inimene/@saasta - @saasta"/>
										</xsl:when>
										<xsl:otherwise>—</xsl:otherwise>
									</xsl:choose>
								</td>

								<td>
									<xsl:for-each select="lapsed/inimene">
										<xsl:value-of select="2025 - @saasta"/>
										<xsl:if test="position() != last()">, </xsl:if>
									</xsl:for-each>
								</td>


							</tr>
						</xsl:for-each>
					</tbody>
				</table>

				<!-- Inimeste arv elukohtade kaupa -->
				<h2>Inimeste arv elukohtade kaupa</h2>
				<ul>
					<xsl:for-each select="//inimene[generate-id() = generate-id(key('people-by-location', normalize-space(elukoht))[1])]">
						<li>
							<xsl:value-of select="normalize-space(elukoht)"/>
							<xsl:text>: </xsl:text>
							<xsl:value-of select="count(key('people-by-location', normalize-space(elukoht)))"/>
						</li>
					</xsl:for-each>
				</ul>

			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
