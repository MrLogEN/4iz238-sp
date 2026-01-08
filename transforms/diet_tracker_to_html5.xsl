<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dt="urn:vse:4iz238:chav07:sp:diet_tracker"
    exclude-result-prefixes="dt">

    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" html-version="5.0"/>

    <!-- Main template matching root element -->
    <xsl:template match="/dt:diet_tracker">
        <!-- Generate index page -->
        <xsl:result-document href="index.html" method="html" version="5.0" encoding="UTF-8"
            indent="yes" html-version="5.0">
            <html lang="cs">
                <head>
                    <meta charset="UTF-8"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                    <title>Diet Tracker - <xsl:value-of select="dt:user/dt:name"/></title>
                    <link rel="stylesheet" href="styles.css"/>
                </head>
                <body>
                    <header>
                        <div class="container">
                            <h1>🥗 Diet Tracker</h1>
                            <p class="subtitle">Sledování stravy a výživy</p>
                        </div>
                    </header>

                    <main class="container">
                        <xsl:apply-templates select="dt:user" mode="index"/>
                    </main>

                    <footer>
                        <div class="container">
                            <p>Diet Tracker v<xsl:value-of select="@version"/> © 2025</p>
                        </div>
                    </footer>
                    <script src="script.js"></script>
                </body>
            </html>
        </xsl:result-document>

        <!-- Generate ingredient detail pages -->
        <xsl:for-each select="//dt:ingredient">
            <xsl:variable name="ingredient-id" select="generate-id(.)"/>
            <xsl:result-document href="ingredient-{$ingredient-id}.html" method="html" version="5.0"
                encoding="UTF-8" indent="yes" html-version="5.0">
                <html lang="cs">
                    <head>
                        <meta charset="UTF-8"/>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                        <title><xsl:value-of select="dt:name"/> - Diet Tracker</title>
                        <link rel="stylesheet" href="styles.css"/>
                    </head>
                    <body>
                        <header>
                            <div class="container">
                                <h1>🥗 Diet Tracker</h1>
                                <p class="subtitle">
                                    <a href="index.html" class="back-link">← Zpět na přehled</a>
                                </p>
                            </div>
                        </header>

                        <main class="container">
                            <section>
                                <xsl:apply-templates select="." mode="detail"/>
                            </section>
                        </main>

                        <footer>
                            <div class="container">
                                <p>Diet Tracker v<xsl:value-of select="//dt:diet_tracker/@version"/>
                                    © 2025</p>
                            </div>
                        </footer>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!-- User template for index page -->
    <xsl:template match="dt:user" mode="index">
        <section class="user-profile">
            <h2>Profil uživatele</h2>
            <div class="profile-grid">
                <div class="profile-card">
                    <div class="icon">👤</div>
                    <h3>Jméno</h3>
                    <p>
                        <xsl:value-of select="dt:name"/>
                    </p>
                </div>
                <div class="profile-card">
                    <div class="icon">📧</div>
                    <h3>Email</h3>
                    <p>
                        <xsl:value-of select="dt:email"/>
                    </p>
                </div>
                <div class="profile-card">
                    <div class="icon">🎂</div>
                    <h3>Datum narození</h3>
                    <p>
                        <xsl:value-of select="format-date(dt:date_of_birth, '[D]. [M]. [Y]')"/>
                    </p>
                </div>
                <div class="profile-card">
                    <div class="icon">
                        <xsl:choose>
                            <xsl:when test="dt:sex = 'male'">♂️</xsl:when>
                            <xsl:when test="dt:sex = 'female'">♀️</xsl:when>
                        </xsl:choose>
                    </div>
                    <h3>Pohlaví</h3>
                    <p>
                        <xsl:choose>
                            <xsl:when test="dt:sex = 'male'">Muž</xsl:when>
                            <xsl:when test="dt:sex = 'female'">Žena</xsl:when>
                        </xsl:choose>
                    </p>
                </div>
            </div>
        </section>

        <section class="health-stats">
            <h2>Zdravotní údaje</h2>
            <div class="stats-grid">
                <div class="stat-card height">
                    <div class="stat-icon">📏</div>
                    <div class="stat-content">
                        <h3>Výška</h3>
                        <p class="stat-value"><xsl:value-of
                                select="format-number(dt:current_state/dt:height, '0.00')"/> m</p>
                        <p class="stat-label"><xsl:value-of
                                select="format-number(dt:current_state/dt:height * 100, '0')"/>
                            cm</p>
                    </div>
                </div>
                <div class="stat-card weight">
                    <div class="stat-icon">⚖️</div>
                    <div class="stat-content">
                        <h3>Současná váha</h3>
                        <p class="stat-value"><xsl:value-of
                                select="format-number(dt:current_state/dt:weight div 1000, '0.0')"/>
                            kg</p>
                    </div>
                </div>
                <div class="stat-card goal">
                    <div class="stat-icon">🎯</div>
                    <div class="stat-content">
                        <h3>Cílová váha</h3>
                        <p class="stat-value"><xsl:value-of
                                select="format-number(dt:long_term_goals/dt:weight div 1000, '0.0')"
                            /> kg</p>
                        <p class="stat-label">
                            <xsl:variable name="diff"
                                select="dt:current_state/dt:weight - dt:long_term_goals/dt:weight"/>
                            <xsl:choose>
                                <xsl:when test="$diff > 0"> Zhubnout <xsl:value-of
                                        select="format-number($diff div 1000, '0.0')"/> kg </xsl:when>
                                <xsl:when test="$diff &lt; 0"> Přibrat <xsl:value-of
                                        select="format-number(abs($diff) div 1000, '0.0')"/> kg </xsl:when>
                                <xsl:otherwise>Udržet váhu</xsl:otherwise>
                            </xsl:choose>
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <xsl:apply-templates select="dt:daily_logs" mode="index"/>
    </xsl:template>

    <!-- Daily logs template -->
    <xsl:template match="dt:daily_logs" mode="index">
        <section class="daily-logs">
            <h2>Denní záznamy</h2>
            <xsl:for-each select="dt:daily_log">
                <xsl:sort select="@date" order="descending"/>
                <xsl:apply-templates select="." mode="index"/>
            </xsl:for-each>
        </section>
    </xsl:template>

    <!-- Daily log template -->
    <xsl:template match="dt:daily_log" mode="index">
        <xsl:variable name="log-id" select="generate-id(.)"/>
        <article class="daily-log">
            <div class="log-header collapsible" onclick="toggleLog('{$log-id}')">
                <div class="log-title">
                    <span class="toggle-icon" id="icon-{$log-id}">▼</span>
                    <h3>📅 <xsl:value-of select="format-date(@date, '[D]. [M]. [Y]')"/>
                            (<xsl:value-of select="format-date(@date, '[FNn]')"/>)</h3>
                </div>
                <span class="meal-count"><xsl:value-of select="count(dt:meals/dt:meal)"/>
                    jídel</span>
            </div>

            <div class="log-content" id="{$log-id}">
                <xsl:apply-templates select="dt:daily_goal" mode="index"/>
                <xsl:apply-templates select="dt:meals" mode="index"/>
            </div>
        </article>
    </xsl:template>

    <!-- Daily goal template -->
    <xsl:template match="dt:daily_goal" mode="index">
        <!-- Calculate totals from all meals in a single pass -->
        <xsl:variable name="all-ingredients" select="../dt:meals/dt:meal/dt:ingredients/dt:ingredient"/>
        <xsl:variable name="total-energy" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:energy * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-water" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:water * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-protein" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:protein * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-carbs" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:carbohydrates/dt:total * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-fats" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:fats/dt:total * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>
        <xsl:variable name="total-fiber" select="sum(for $i in $all-ingredients return $i/dt:base_values_per_100g/dt:fiber * $i/dt:serving/dt:count * $i/dt:serving/dt:weight div 100)"/>

        <div class="daily-goals">
            <h4>Denní cíle a plnění</h4>
            <div class="goals-grid">
                <div class="goal-item energy">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of
                            select="format-number(($total-energy div dt:energy) * 100, '0')"/>
                    </xsl:attribute>
                    <span class="goal-icon">⚡</span>
                    <div>
                        <span class="goal-label">Energie</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-energy div 4184, '#,##0')"/>
                            / <xsl:value-of select="format-number(dt:energy div 4184, '#,##0')"/>
                            kcal </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-energy div dt:energy) * 100, '0')"/>%
                        </span>
                    </div>
                </div>
                <div class="goal-item water">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of select="format-number(($total-water div dt:water) * 100, '0')"
                        />
                    </xsl:attribute>
                    <span class="goal-icon">💧</span>
                    <div>
                        <span class="goal-label">Voda</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-water div 1000, '0.0')"/> /
                                <xsl:value-of select="format-number(dt:water div 1000, '0.0')"/> l </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-water div dt:water) * 100, '0')"/>%
                        </span>
                    </div>
                </div>
                <div class="goal-item protein">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of
                            select="format-number(($total-protein div dt:protein) * 100, '0')"/>
                    </xsl:attribute>
                    <span class="goal-icon">🥩</span>
                    <div>
                        <span class="goal-label">Bílkoviny</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-protein, '0.0')"/> /
                                <xsl:value-of select="format-number(dt:protein, '0.0')"/> g </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-protein div dt:protein) * 100, '0')"
                            />% </span>
                    </div>
                </div>
                <div class="goal-item carbs">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of
                            select="format-number(($total-carbs div dt:carbohydrates/dt:total) * 100, '0')"
                        />
                    </xsl:attribute>
                    <span class="goal-icon">🍞</span>
                    <div>
                        <span class="goal-label">Sacharidy</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-carbs, '0.0')"/> /
                                <xsl:value-of
                                select="format-number(dt:carbohydrates/dt:total, '0.0')"/> g </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-carbs div dt:carbohydrates/dt:total) * 100, '0')"
                            />% </span>
                    </div>
                </div>
                <div class="goal-item fats">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of
                            select="format-number(($total-fats div dt:fats/dt:total) * 100, '0')"/>
                    </xsl:attribute>
                    <span class="goal-icon">🧈</span>
                    <div>
                        <span class="goal-label">Tuky</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-fats, '0.0')"/> /
                                <xsl:value-of select="format-number(dt:fats/dt:total, '0.0')"/> g </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-fats div dt:fats/dt:total) * 100, '0')"
                            />% </span>
                    </div>
                </div>
                <div class="goal-item fiber">
                    <xsl:attribute name="data-progress">
                        <xsl:value-of select="format-number(($total-fiber div dt:fiber) * 100, '0')"
                        />
                    </xsl:attribute>
                    <span class="goal-icon">🌾</span>
                    <div>
                        <span class="goal-label">Vláknina</span>
                        <span class="goal-value">
                            <xsl:value-of select="format-number($total-fiber, '0.0')"/> /
                                <xsl:value-of select="format-number(dt:fiber, '0.0')"/> g </span>
                        <span class="goal-progress">
                            <xsl:value-of
                                select="format-number(($total-fiber div dt:fiber) * 100, '0')"/>%
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- Meals template -->
    <xsl:template match="dt:meals" mode="index">
        <div class="meals-section">
            <h4>Jídla</h4>
            <xsl:apply-templates select="dt:meal" mode="index"/>
        </div>
    </xsl:template>

    <!-- Meal template - simplified for index page -->
    <xsl:template match="dt:meal" mode="index">
        <div class="meal-card">
            <div class="meal-header">
                <h5>🍽️ <xsl:value-of select="dt:name"/></h5>
                <span class="servings-badge"><xsl:value-of select="dt:servings"/>× porce</span>
            </div>
            <xsl:if test="dt:note">
                <p class="meal-note">💬 <xsl:value-of select="dt:note"/></p>
            </xsl:if>

            <div class="ingredients-summary">
                <h6>Ingredience (<xsl:value-of select="count(dt:ingredients/dt:ingredient)"/>):</h6>
                <ul class="ingredient-list">
                    <xsl:for-each select="dt:ingredients/dt:ingredient">
                        <xsl:variable name="ingredient-id" select="generate-id(.)"/>
                        <li>
                            <a href="ingredient-{$ingredient-id}.html" class="ingredient-link">
                                <strong><xsl:value-of select="dt:name"/></strong>
                                <xsl:if test="dt:brand"> (<xsl:value-of select="dt:brand"/>)
                                </xsl:if> - <xsl:value-of select="dt:serving/dt:count"/> ×
                                    <xsl:value-of select="dt:serving/dt:weight"/> g </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
    </xsl:template>

    <!-- Ingredient detail template for separate page -->
    <xsl:template match="dt:ingredient" mode="detail">
        <div class="ingredient-detail">
            <div class="ingredient-hero">
                <img src="{dt:img}" alt="{dt:name}" class="ingredient-img-large"/>
                <div class="ingredient-main-info">
                    <h2>
                        <xsl:value-of select="dt:name"/>
                    </h2>
                    <xsl:if test="dt:brand">
                        <p class="brand-large">🏷️ <xsl:value-of select="dt:brand"/></p>
                    </xsl:if>

                    <div class="serving-info-large">
                        <h3>Informace o porci</h3>
                        <p class="serving-detail">
                            <span class="label">Počet porcí:</span>
                            <span class="value"><xsl:value-of select="dt:serving/dt:count"/>×</span>
                        </p>
                        <p class="serving-detail">
                            <span class="label">Hmotnost jedné porce:</span>
                            <span class="value"><xsl:value-of select="dt:serving/dt:weight"/>
                                g</span>
                        </p>
                        <xsl:if test="dt:serving/dt:specification/dt:size_category">
                            <p class="serving-detail">
                                <span class="label">Velikost:</span>
                                <span class="value">
                                    <xsl:value-of
                                        select="dt:serving/dt:specification/dt:size_category"/>
                                </span>
                            </p>
                        </xsl:if>
                        <p class="serving-detail total">
                            <span class="label">Celková hmotnost:</span>
                            <span class="value"><xsl:value-of
                                    select="format-number(dt:serving/dt:count * dt:serving/dt:weight, '0.0')"
                                /> g</span>
                        </p>
                    </div>
                </div>
            </div>

            <div class="nutrition-detail">
                <h3>Nutriční hodnoty na 100g</h3>
                <table class="nutrition-table-large">
                    <thead>
                        <tr>
                            <th>Živina</th>
                            <th>Hodnota</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="highlight">
                            <td>
                                <strong>Energie</strong>
                            </td>
                            <td class="value">
                                <strong><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:energy div 4184, '0')"
                                    /> kcal</strong>
                            </td>
                        </tr>
                        <xsl:if test="dt:base_values_per_100g/dt:protein">
                            <tr>
                                <td>Bílkoviny</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:protein, '0.00')"
                                    /> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:carbohydrates">
                            <tr>
                                <td>
                                    <strong>Sacharidy</strong>
                                </td>
                                <td class="value">
                                    <strong><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:carbohydrates/dt:total, '0.00')"
                                        /> g</strong>
                                </td>
                            </tr>
                            <tr class="sub">
                                <td>z toho cukry</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:carbohydrates/dt:sugars, '0.00')"
                                    /> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:fats">
                            <tr>
                                <td>
                                    <strong>Tuky</strong>
                                </td>
                                <td class="value">
                                    <strong><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:fats/dt:total, '0.00')"
                                        /> g</strong>
                                </td>
                            </tr>
                            <xsl:if test="dt:base_values_per_100g/dt:fats/dt:saturated_fats">
                                <tr class="sub">
                                    <td>nasycené tuky</td>
                                    <td class="value"><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:fats/dt:saturated_fats, '0.00')"
                                        /> g</td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="dt:base_values_per_100g/dt:fats/dt:trans_fats">
                                <tr class="sub">
                                    <td>trans tuky</td>
                                    <td class="value"><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:fats/dt:trans_fats, '0.00')"
                                        /> g</td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="dt:base_values_per_100g/dt:fats/dt:monosaturated_fats">
                                <tr class="sub">
                                    <td>mononenasycené tuky</td>
                                    <td class="value"><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:fats/dt:monosaturated_fats, '0.00')"
                                        /> g</td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="dt:base_values_per_100g/dt:fats/dt:polysaturated_fats">
                                <tr class="sub">
                                    <td>polynenasycené tuky</td>
                                    <td class="value"><xsl:value-of
                                            select="format-number(dt:base_values_per_100g/dt:fats/dt:polysaturated_fats, '0.00')"
                                        /> g</td>
                                </tr>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:cholesterol">
                            <tr>
                                <td>Cholesterol</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:cholesterol, '0')"
                                    /> mg</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:fiber">
                            <tr>
                                <td>Vláknina</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:fiber, '0.00')"
                                    /> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:sodium">
                            <tr>
                                <td>Sodík</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:sodium, '0')"
                                    /> mg</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:salt">
                            <tr>
                                <td>Sůl</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:salt, '0.00')"
                                    /> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:calcium">
                            <tr>
                                <td>Vápník</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:calcium, '0')"
                                    /> mg</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:water">
                            <tr>
                                <td>Voda</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:water, '0.00')"
                                    /> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:phe">
                            <tr>
                                <td>Fenylalanin (Phe)</td>
                                <td class="value"><xsl:value-of
                                        select="format-number(dt:base_values_per_100g/dt:phe, '0')"
                                    /> mg</td>
                            </tr>
                        </xsl:if>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
