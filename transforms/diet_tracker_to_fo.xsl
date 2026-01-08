<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dt="urn:vse:4iz238:chav07:sp:diet_tracker" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="dt">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <!-- Main template matching root element -->
    <xsl:template match="/dt:diet_tracker">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="DejaVu Sans, Liberation Sans, sans-serif">
            <!-- Layout master set -->
            <fo:layout-master-set>
                <!-- Page master for content -->
                <fo:simple-page-master master-name="content-page" 
                    page-height="297mm" page-width="210mm"
                    margin-top="20mm" margin-bottom="20mm" 
                    margin-left="20mm" margin-right="20mm">
                    <fo:region-body margin-top="15mm" margin-bottom="15mm"/>
                    <fo:region-before extent="15mm"/>
                    <fo:region-after extent="15mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <!-- Page sequence for content -->
            <fo:page-sequence master-reference="content-page">
                <!-- Header -->
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center" font-size="10pt" color="#666666" 
                        border-bottom="1pt solid #cccccc" padding-bottom="3mm">
                        Diet Tracker - Přehled stravy a výživy
                    </fo:block>
                </fo:static-content>

                <!-- Footer -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" font-size="9pt" color="#666666" 
                        border-top="1pt solid #cccccc" padding-top="3mm">
                        Strana <fo:page-number/> z <fo:page-number-citation ref-id="last-page"/>
                        | Diet Tracker v<xsl:value-of select="@version"/> © 2025
                    </fo:block>
                </fo:static-content>

                <!-- Body -->
                <fo:flow flow-name="xsl-region-body">
                    <!-- Title page -->
                    <fo:block font-size="24pt" font-weight="bold" text-align="center" 
                        space-after="10mm" color="#2c3e50">
                        Diet Tracker
                    </fo:block>
                    <fo:block font-size="14pt" text-align="center" space-after="20mm" color="#7f8c8d">
                        Přehled stravy a výživy
                    </fo:block>

                    <!-- User profile -->
                    <xsl:apply-templates select="dt:user"/>

                    <!-- Last page marker for page numbering -->
                    <fo:block id="last-page"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <!-- User template -->
    <xsl:template match="dt:user">
        <!-- Table of contents -->
        <fo:block font-size="18pt" font-weight="bold" space-before="10mm" 
            space-after="5mm" color="#2c3e50" id="toc">
            Obsah
        </fo:block>
        
        <fo:block space-after="10mm">
            <fo:block space-after="2mm">
                <fo:basic-link internal-destination="user-profile" color="#3498db">
                    <fo:inline text-decoration="underline">1. Profil uživatele</fo:inline>
                </fo:basic-link>
            </fo:block>
            <fo:block space-after="2mm">
                <fo:basic-link internal-destination="health-stats" color="#3498db">
                    <fo:inline text-decoration="underline">2. Zdravotní údaje</fo:inline>
                </fo:basic-link>
            </fo:block>
            <fo:block space-after="2mm">
                <fo:basic-link internal-destination="daily-logs" color="#3498db">
                    <fo:inline text-decoration="underline">3. Denní záznamy</fo:inline>
                </fo:basic-link>
            </fo:block>
            <xsl:for-each select="dt:daily_logs/dt:daily_log">
                <xsl:sort select="@date" order="descending"/>
                <fo:block start-indent="10mm" space-after="2mm">
                    <fo:basic-link internal-destination="log-{generate-id(.)}" color="#3498db">
                        <fo:inline text-decoration="underline">
                            3.<xsl:value-of select="position()"/>. <xsl:value-of select="format-date(@date, '[D]. [M]. [Y]')"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:block>
            </xsl:for-each>
        </fo:block>

        <!-- User profile section -->
        <fo:block break-before="page" font-size="18pt" font-weight="bold" 
            space-before="10mm" space-after="5mm" color="#2c3e50" id="user-profile">
            1. Profil uživatele
        </fo:block>

        <fo:table table-layout="fixed" width="100%" space-after="10mm" 
            border="1pt solid #bdc3c7">
            <fo:table-column column-width="40%"/>
            <fo:table-column column-width="60%"/>
            <fo:table-body>
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Jméno</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="dt:name"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Email</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="dt:email"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Datum narození</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-date(dt:date_of_birth, '[D]. [M]. [Y]')"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="3mm">
                        <fo:block font-weight="bold">Pohlaví</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="dt:sex = 'male'">Muž</xsl:when>
                                <xsl:when test="dt:sex = 'female'">Žena</xsl:when>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Health stats section -->
        <fo:block font-size="18pt" font-weight="bold" space-before="10mm" 
            space-after="5mm" color="#2c3e50" id="health-stats">
            2. Zdravotní údaje
        </fo:block>

        <fo:table table-layout="fixed" width="100%" space-after="10mm" 
            border="1pt solid #bdc3c7">
            <fo:table-column column-width="40%"/>
            <fo:table-column column-width="60%"/>
            <fo:table-body>
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Výška</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>
                            <xsl:value-of select="format-number(dt:current_state/dt:height, '0.00')"/> m
                            (<xsl:value-of select="format-number(dt:current_state/dt:height * 100, '0')"/> cm)
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Současná váha</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>
                            <xsl:value-of select="format-number(dt:current_state/dt:weight div 1000, '0.0')"/> kg
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="3mm">
                        <fo:block font-weight="bold">Cílová váha</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3mm">
                        <fo:block>
                            <xsl:value-of select="format-number(dt:long_term_goals/dt:weight div 1000, '0.0')"/> kg
                            <xsl:variable name="diff" select="dt:current_state/dt:weight - dt:long_term_goals/dt:weight"/>
                            <xsl:if test="$diff != 0">
                                (<xsl:choose>
                                    <xsl:when test="$diff > 0">
                                        Zhubnout <xsl:value-of select="format-number($diff div 1000, '0.0')"/> kg
                                    </xsl:when>
                                    <xsl:when test="$diff &lt; 0">
                                        Přibrat <xsl:value-of select="format-number(abs($diff) div 1000, '0.0')"/> kg
                                    </xsl:when>
                                </xsl:choose>)
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <!-- Daily logs -->
        <xsl:apply-templates select="dt:daily_logs"/>
    </xsl:template>

    <!-- Daily logs template -->
    <xsl:template match="dt:daily_logs">
        <fo:block break-before="page" font-size="18pt" font-weight="bold" 
            space-before="10mm" space-after="5mm" color="#2c3e50" id="daily-logs">
            3. Denní záznamy
        </fo:block>

        <xsl:for-each select="dt:daily_log">
            <xsl:sort select="@date" order="descending"/>
            <xsl:apply-templates select=".">
                <xsl:with-param name="log-number" select="position()"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

    <!-- Daily log template -->
    <xsl:template match="dt:daily_log">
        <xsl:param name="log-number" select="1"/>
        
        <!-- Czech day names -->
        <xsl:variable name="day-of-week" select="format-date(@date, '[F]')"/>
        <xsl:variable name="czech-day">
            <xsl:choose>
                <xsl:when test="$day-of-week = 'Monday'">pondělí</xsl:when>
                <xsl:when test="$day-of-week = 'Tuesday'">úterý</xsl:when>
                <xsl:when test="$day-of-week = 'Wednesday'">středa</xsl:when>
                <xsl:when test="$day-of-week = 'Thursday'">čtvrtek</xsl:when>
                <xsl:when test="$day-of-week = 'Friday'">pátek</xsl:when>
                <xsl:when test="$day-of-week = 'Saturday'">sobota</xsl:when>
                <xsl:when test="$day-of-week = 'Sunday'">neděle</xsl:when>
                <xsl:otherwise><xsl:value-of select="$day-of-week"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <fo:block break-before="page" font-size="16pt" font-weight="bold" 
            space-after="5mm" color="#34495e" id="log-{generate-id(.)}">
            3.<xsl:value-of select="$log-number"/>. <xsl:value-of select="format-date(@date, '[D]. [M]. [Y]')"/>
            (<xsl:value-of select="$czech-day"/>)
        </fo:block>

        <!-- Daily goals -->
        <xsl:apply-templates select="dt:daily_goal"/>

        <!-- Meals -->
        <xsl:apply-templates select="dt:meals"/>
    </xsl:template>

    <!-- Daily goal template -->
    <xsl:template match="dt:daily_goal">
        <fo:block font-size="14pt" font-weight="bold" space-before="5mm" 
            space-after="3mm" color="#34495e">
            Denní cíle a plnění
        </fo:block>

        <!-- Calculate totals from all meals in a single pass -->
        <xsl:variable name="all-ingredients" select="../dt:meals/dt:meal/dt:ingredients/dt:ingredient"/>
        <xsl:variable name="total-energy" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:energy * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-water" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:water * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-protein" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:protein * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-carbs" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:carbohydrates/dt:total * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-fats" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:fats/dt:total * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-fiber" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:fiber * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>

        <!-- Nutrition goals table -->
        <fo:table table-layout="fixed" width="100%" space-after="5mm" 
            border="1pt solid #bdc3c7">
            <fo:table-column column-width="30%"/>
            <fo:table-column column-width="25%"/>
            <fo:table-column column-width="25%"/>
            <fo:table-column column-width="20%"/>
            <fo:table-header>
                <fo:table-row background-color="#34495e" color="white">
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Živina</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Skutečnost</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Cíl</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block font-weight="bold">Plnění</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <!-- Energy -->
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>Energie</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number($total-energy div 4184, '#,##0')"/> kcal</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(dt:energy div 4184, '#,##0')"/> kcal</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(($total-energy div dt:energy) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- Water -->
                <fo:table-row>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>Voda</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number($total-water div 1000, '0.0')"/> l</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(dt:water div 1000, '0.0')"/> l</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(($total-water div dt:water) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- Protein -->
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>Bílkoviny</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number($total-protein, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(dt:protein, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(($total-protein div dt:protein) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- Carbohydrates -->
                <fo:table-row>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>Sacharidy</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number($total-carbs, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(dt:carbohydrates/dt:total, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(($total-carbs div dt:carbohydrates/dt:total) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- Fats -->
                <fo:table-row background-color="#ecf0f1">
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block>Tuky</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number($total-fats, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(dt:fats/dt:total, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm" border-bottom="1pt solid #bdc3c7">
                        <fo:block><xsl:value-of select="format-number(($total-fats div dt:fats/dt:total) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <!-- Fiber -->
                <fo:table-row>
                    <fo:table-cell padding="2mm">
                        <fo:block>Vláknina</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm">
                        <fo:block><xsl:value-of select="format-number($total-fiber, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm">
                        <fo:block><xsl:value-of select="format-number(dt:fiber, '0.0')"/> g</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="2mm">
                        <fo:block><xsl:value-of select="format-number(($total-fiber div dt:fiber) * 100, '0')"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- Meals template -->
    <xsl:template match="dt:meals">
        <fo:block font-size="14pt" font-weight="bold" space-before="5mm" 
            space-after="3mm" color="#34495e">
            Jídla (<xsl:value-of select="count(dt:meal)"/>)
        </fo:block>

        <xsl:for-each select="dt:meal">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>

    <!-- Meal template -->
    <xsl:template match="dt:meal">
        <fo:block font-size="12pt" font-weight="bold" space-before="5mm" 
            space-after="3mm" color="#2c3e50" border-top="2pt solid #3498db" padding-top="3mm">
            <xsl:value-of select="dt:name"/>
            (Porce: <xsl:value-of select="dt:servings"/>×)
        </fo:block>

        <xsl:if test="dt:note">
            <fo:block space-after="3mm" font-style="italic" color="#7f8c8d">
                Poznámka: <xsl:value-of select="dt:note"/>
            </fo:block>
        </xsl:if>

        <!-- Display ingredients with full details -->
        <xsl:for-each select="dt:ingredients/dt:ingredient">
            <xsl:apply-templates select="." mode="inline"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Ingredient inline template - shows within meal -->
    <xsl:template match="dt:ingredient" mode="inline">
        <fo:block space-before="3mm" space-after="5mm" 
            background-color="#f8f9fa" padding="3mm" border="1pt solid #dee2e6">
            
            <!-- Ingredient name and brand -->
            <fo:block font-size="11pt" font-weight="bold" space-after="2mm" color="#2c3e50">
                <xsl:value-of select="dt:name"/>
                <xsl:if test="dt:brand"> (<xsl:value-of select="dt:brand"/>)</xsl:if>
            </fo:block>

            <!-- Serving info -->
            <fo:block font-size="9pt" space-after="2mm" color="#6c757d">
                Porce: <xsl:value-of select="dt:serving/dt:count"/> × <xsl:value-of select="dt:serving/dt:weight"/> g
                <xsl:if test="dt:serving/dt:specification/dt:size_category">
                    (<xsl:value-of select="dt:serving/dt:specification/dt:size_category"/>)
                </xsl:if>
            </fo:block>

            <!-- Image - smaller size for inline display -->
            <xsl:if test="dt:img">
                <fo:block text-align="center" space-after="3mm">
                    <fo:external-graphic src="url('{dt:img}')" 
                        content-width="scale-to-fit" 
                        content-height="scale-to-fit"
                        width="50mm" 
                        height="50mm"
                        scaling="uniform"/>
                </fo:block>
            </xsl:if>

            <!-- Nutritional values for this serving -->
            <xsl:variable name="total-weight" select="dt:serving/dt:count * dt:serving/dt:weight"/>
            <xsl:variable name="multiplier" select="$total-weight div 100"/>

            <fo:block font-size="10pt" font-weight="bold" space-after="2mm" color="#34495e">
                Nutriční hodnoty (celková porce)
            </fo:block>

            <fo:table table-layout="fixed" width="100%" font-size="9pt" 
                border="1pt solid #dee2e6">
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-body>
                    <fo:table-row background-color="#e9ecef">
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block>Energie</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block><xsl:value-of select="format-number(dt:base_values_per_100g/dt:energy * $multiplier div 4184, '#,##0')"/> kcal</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block>Bílkoviny</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block><xsl:value-of select="format-number(dt:base_values_per_100g/dt:protein * $multiplier, '#,##0.0')"/> g</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row background-color="#e9ecef">
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block>Sacharidy</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block><xsl:value-of select="format-number(dt:base_values_per_100g/dt:carbohydrates/dt:total * $multiplier, '#,##0.0')"/> g</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block>Tuky</fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding="2mm" border-bottom="1pt solid #dee2e6">
                            <fo:block><xsl:value-of select="format-number(dt:base_values_per_100g/dt:fats/dt:total * $multiplier, '#,##0.0')"/> g</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:if test="dt:base_values_per_100g/dt:fiber">
                        <fo:table-row background-color="#e9ecef">
                            <fo:table-cell padding="2mm">
                                <fo:block>Vláknina</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2mm">
                                <fo:block><xsl:value-of select="format-number(dt:base_values_per_100g/dt:fiber * $multiplier, '#,##0.0')"/> g</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>


</xsl:stylesheet>
