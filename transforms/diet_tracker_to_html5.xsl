<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dt="urn:vse:4iz238:chav07:sp:diet_tracker"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dt xs">
    
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" html-version="5.0"/>
    
    <!-- Main template -->
    <xsl:template match="/dt:diet_tracker">
        <html lang="cs">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Diet Tracker - <xsl:value-of select="dt:user/dt:name"/></title>
                <xsl:call-template name="styles"/>
            </head>
            <body>
                <header>
                    <div class="container">
                        <h1>🥗 Diet Tracker</h1>
                        <p class="subtitle">Sledování stravy a výživy</p>
                    </div>
                </header>
                
                <main class="container">
                    <xsl:apply-templates select="dt:user"/>
                </main>
                
                <footer>
                    <div class="container">
                        <p>Diet Tracker v<xsl:value-of select="@version"/> © 2025</p>
                    </div>
                </footer>
                
                <script>
                    <xsl:text disable-output-escaping="yes">
                    <![CDATA[
                    function toggleLog(id) {
                        const content = document.getElementById(id);
                        const icon = document.getElementById('icon-' + id);
                        
                        if (content.style.display === 'none') {
                            content.style.display = 'block';
                            icon.textContent = '▼';
                        } else {
                            content.style.display = 'none';
                            icon.textContent = '▶';
                        }
                    }
                    
                    // Collapse all logs by default except the first one
                    document.addEventListener('DOMContentLoaded', function() {
                        const logs = document.querySelectorAll('.log-content');
                        logs.forEach(function(log, index) {
                            if (index > 0) {
                                log.style.display = 'none';
                                const icon = document.getElementById('icon-' + log.id);
                                if (icon) icon.textContent = '▶';
                            }
                        });
                    });
                    ]]>
                    </xsl:text>
                </script>
            </body>
        </html>
    </xsl:template>
    
    <!-- User template -->
    <xsl:template match="dt:user">
        <section class="user-profile">
            <h2>Profil uživatele</h2>
            <div class="profile-grid">
                <div class="profile-card">
                    <div class="icon">👤</div>
                    <h3>Jméno</h3>
                    <p><xsl:value-of select="dt:name"/></p>
                </div>
                <div class="profile-card">
                    <div class="icon">📧</div>
                    <h3>Email</h3>
                    <p><xsl:value-of select="dt:email"/></p>
                </div>
                <div class="profile-card">
                    <div class="icon">🎂</div>
                    <h3>Datum narození</h3>
                    <p><xsl:value-of select="format-date(dt:date_of_birth, '[D]. [M]. [Y]')"/></p>
                </div>
                <div class="profile-card">
                    <div class="icon">⚧</div>
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
                        <p class="stat-value"><xsl:value-of select="format-number(dt:current_state/dt:height, '0.00')"/> m</p>
                        <p class="stat-label"><xsl:value-of select="format-number(dt:current_state/dt:height * 100, '0')"/> cm</p>
                    </div>
                </div>
                <div class="stat-card weight">
                    <div class="stat-icon">⚖️</div>
                    <div class="stat-content">
                        <h3>Současná váha</h3>
                        <p class="stat-value"><xsl:value-of select="format-number(dt:current_state/dt:weight div 1000, '0.0')"/> kg</p>
                    </div>
                </div>
                <div class="stat-card goal">
                    <div class="stat-icon">🎯</div>
                    <div class="stat-content">
                        <h3>Cílová váha</h3>
                        <p class="stat-value"><xsl:value-of select="format-number(dt:long_term_goals/dt:weight div 1000, '0.0')"/> kg</p>
                        <p class="stat-label">
                            <xsl:variable name="diff" select="dt:current_state/dt:weight - dt:long_term_goals/dt:weight"/>
                            <xsl:choose>
                                <xsl:when test="$diff > 0">
                                    Zhubnout <xsl:value-of select="format-number($diff div 1000, '0.0')"/> kg
                                </xsl:when>
                                <xsl:when test="$diff &lt; 0">
                                    Přibrat <xsl:value-of select="format-number(abs($diff) div 1000, '0.0')"/> kg
                                </xsl:when>
                                <xsl:otherwise>Udržet váhu</xsl:otherwise>
                            </xsl:choose>
                        </p>
                    </div>
                </div>
            </div>
        </section>
        
        <xsl:apply-templates select="dt:daily_logs"/>
    </xsl:template>
    
    <!-- Daily logs template -->
    <xsl:template match="dt:daily_logs">
        <section class="daily-logs">
            <h2>Denní záznamy</h2>
            <xsl:for-each select="dt:daily_log">
                <xsl:sort select="@date" order="descending"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </section>
    </xsl:template>
    
    <!-- Daily log template -->
    <xsl:template match="dt:daily_log">
        <xsl:variable name="log-id" select="generate-id(.)"/>
        <article class="daily-log">
            <div class="log-header collapsible" onclick="toggleLog('{$log-id}')">
                <div class="log-title">
                    <span class="toggle-icon" id="icon-{$log-id}">▼</span>
                    <h3>📅 <xsl:value-of select="format-date(@date, '[D]. [M]. [Y]')"/> (<xsl:value-of select="format-date(@date, '[FNn]')"/>)</h3>
                </div>
                <span class="meal-count"><xsl:value-of select="count(dt:meals/dt:meal)"/> jídel</span>
            </div>
            
            <div class="log-content" id="{$log-id}">
                <xsl:apply-templates select="dt:daily_goal"/>
                <xsl:apply-templates select="dt:meals"/>
            </div>
        </article>
    </xsl:template>
    
    <!-- Daily goal template -->
    <xsl:template match="dt:daily_goal">
        <div class="daily-goals">
            <h4>Denní cíle</h4>
            <div class="goals-grid">
                <div class="goal-item energy">
                    <span class="goal-icon">⚡</span>
                    <div>
                        <span class="goal-label">Energie</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:energy div 4184, '#,##0')"/> kcal</span>
                    </div>
                </div>
                <div class="goal-item water">
                    <span class="goal-icon">💧</span>
                    <div>
                        <span class="goal-label">Voda</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:water div 1000, '0.0')"/> l</span>
                    </div>
                </div>
                <div class="goal-item protein">
                    <span class="goal-icon">🥩</span>
                    <div>
                        <span class="goal-label">Bílkoviny</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:protein, '0.0')"/> g</span>
                    </div>
                </div>
                <div class="goal-item carbs">
                    <span class="goal-icon">🍞</span>
                    <div>
                        <span class="goal-label">Sacharidy</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:carbohydrates/dt:total, '0.0')"/> g</span>
                    </div>
                </div>
                <div class="goal-item fats">
                    <span class="goal-icon">🧈</span>
                    <div>
                        <span class="goal-label">Tuky</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:fats/dt:total, '0.0')"/> g</span>
                    </div>
                </div>
                <div class="goal-item fiber">
                    <span class="goal-icon">🌾</span>
                    <div>
                        <span class="goal-label">Vláknina</span>
                        <span class="goal-value"><xsl:value-of select="format-number(dt:fiber, '0.0')"/> g</span>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- Meals template -->
    <xsl:template match="dt:meals">
        <div class="meals-section">
            <h4>Jídla</h4>
            <xsl:apply-templates select="dt:meal"/>
        </div>
    </xsl:template>
    
    <!-- Meal template -->
    <xsl:template match="dt:meal">
        <div class="meal-card">
            <div class="meal-header">
                <h5>🍽️ <xsl:value-of select="dt:name"/></h5>
                <span class="servings-badge"><xsl:value-of select="dt:servings"/>× porce</span>
            </div>
            <xsl:if test="dt:note">
                <p class="meal-note">💬 <xsl:value-of select="dt:note"/></p>
            </xsl:if>
            
            <div class="ingredients-list">
                <xsl:apply-templates select="dt:ingredients/dt:ingredient"/>
            </div>
        </div>
    </xsl:template>
    
    <!-- Ingredient template -->
    <xsl:template match="dt:ingredient">
        <div class="ingredient">
            <img src="{dt:img}" alt="{dt:name}" class="ingredient-img"/>
            <div class="ingredient-details">
                <div class="ingredient-header">
                    <h6><xsl:value-of select="dt:name"/></h6>
                    <xsl:if test="dt:brand">
                        <span class="brand">🏷️ <xsl:value-of select="dt:brand"/></span>
                    </xsl:if>
                </div>
                
                <p class="serving-info">
                    <strong><xsl:value-of select="dt:serving/dt:count"/>× <xsl:value-of select="dt:serving/dt:weight"/> g</strong>
                    <xsl:if test="dt:serving/dt:specification/dt:size_category">
                        (<xsl:value-of select="dt:serving/dt:specification/dt:size_category"/>)
                    </xsl:if>
                    = <xsl:value-of select="format-number(dt:serving/dt:count * dt:serving/dt:weight, '0.0')"/> g celkem
                </p>
                
                <div class="nutrition-info">
                    <h6>Nutriční hodnoty (na 100g):</h6>
                    <table class="nutrition-table">
                        <tr>
                            <td>Energie:</td>
                            <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:energy div 4184, '0')"/> kcal</td>
                        </tr>
                        <xsl:if test="dt:base_values_per_100g/dt:protein">
                            <tr>
                                <td>Bílkoviny:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:protein, '0.0')"/> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:carbohydrates">
                            <tr>
                                <td>Sacharidy:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:carbohydrates/dt:total, '0.0')"/> g</td>
                            </tr>
                            <tr class="sub">
                                <td>- z toho cukry:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:carbohydrates/dt:sugars, '0.0')"/> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:fats">
                            <tr>
                                <td>Tuky:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:fats/dt:total, '0.0')"/> g</td>
                            </tr>
                            <xsl:if test="dt:base_values_per_100g/dt:fats/dt:saturated_fats">
                                <tr class="sub">
                                    <td>- nasycené:</td>
                                    <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:fats/dt:saturated_fats, '0.0')"/> g</td>
                                </tr>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:fiber">
                            <tr>
                                <td>Vláknina:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:fiber, '0.0')"/> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:salt">
                            <tr>
                                <td>Sůl:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:salt, '0.0')"/> g</td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="dt:base_values_per_100g/dt:water">
                            <tr>
                                <td>Voda:</td>
                                <td class="value"><xsl:value-of select="format-number(dt:base_values_per_100g/dt:water, '0.0')"/> g</td>
                            </tr>
                        </xsl:if>
                    </table>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- Styles template -->
    <xsl:template name="styles">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            :root {
                --primary: #667eea;
                --primary-dark: #5568d3;
                --secondary: #764ba2;
                --success: #48bb78;
                --warning: #ed8936;
                --danger: #f56565;
                --info: #4299e1;
                --light: #f7fafc;
                --dark: #2d3748;
                --gray: #718096;
                --border: #e2e8f0;
            }
            
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                line-height: 1.6;
                color: var(--dark);
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                background-attachment: fixed;
                min-height: 100vh;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            
            header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 2rem 0;
                margin-bottom: 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
            }
            
            header h1 {
                color: var(--primary);
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }
            
            .subtitle {
                color: var(--gray);
                font-size: 1.1rem;
            }
            
            main {
                padding-bottom: 4rem;
            }
            
            section {
                background: white;
                border-radius: 16px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }
            
            h2 {
                color: var(--primary);
                font-size: 1.8rem;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 3px solid var(--primary);
            }
            
            h3 {
                color: var(--dark);
                font-size: 1.4rem;
                margin-bottom: 1rem;
            }
            
            h4 {
                color: var(--primary-dark);
                font-size: 1.2rem;
                margin-bottom: 1rem;
                margin-top: 1.5rem;
            }
            
            h5 {
                color: var(--dark);
                font-size: 1.1rem;
                margin: 0;
            }
            
            h6 {
                color: var(--dark);
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }
            
            /* Profile Grid */
            .profile-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }
            
            .profile-card {
                background: linear-gradient(135deg, var(--light) 0%, white 100%);
                border: 2px solid var(--border);
                border-radius: 12px;
                padding: 1.5rem;
                text-align: center;
                transition: transform 0.3s, box-shadow 0.3s;
            }
            
            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
            }
            
            .profile-card .icon {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }
            
            .profile-card h3 {
                color: var(--gray);
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.5rem;
            }
            
            .profile-card p {
                color: var(--dark);
                font-size: 1.2rem;
                font-weight: 600;
            }
            
            /* Health Stats */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }
            
            .stat-card {
                background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                color: white;
                border-radius: 12px;
                padding: 1.5rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                transition: transform 0.3s, box-shadow 0.3s;
            }
            
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(102, 126, 234, 0.3);
            }
            
            .stat-icon {
                font-size: 3rem;
            }
            
            .stat-content {
                flex: 1;
            }
            
            .stat-content h3 {
                color: rgba(255, 255, 255, 0.9);
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
                margin-bottom: 0.5rem;
            }
            
            .stat-value {
                display: block;
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.25rem;
            }
            
            .stat-label {
                display: block;
                font-size: 0.9rem;
                opacity: 0.9;
            }
            
            /* Daily Log */
            .daily-log {
                background: var(--light);
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 2rem;
                border-left: 5px solid var(--primary);
            }
            
            .log-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                cursor: pointer;
                user-select: none;
                padding: 0.5rem;
                border-radius: 8px;
                transition: background 0.3s;
            }
            
            .log-header:hover {
                background: rgba(102, 126, 234, 0.1);
            }
            
            .collapsible {
                margin-bottom: 0;
            }
            
            .log-title {
                display: flex;
                align-items: center;
                gap: 1rem;
            }
            
            .toggle-icon {
                font-size: 1.2rem;
                color: var(--primary);
                transition: transform 0.3s;
                display: inline-block;
                width: 1.5rem;
                text-align: center;
            }
            
            .log-content {
                margin-top: 1rem;
                animation: fadeIn 0.3s ease-in;
            }
            
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .meal-count {
                background: var(--primary);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
            }
            
            /* Daily Goals */
            .daily-goals {
                background: white;
                border-radius: 8px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .goals-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 1rem;
                margin-top: 1rem;
            }
            
            .goal-item {
                background: var(--light);
                border-radius: 8px;
                padding: 1rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                border-left: 4px solid var(--primary);
            }
            
            .goal-icon {
                font-size: 1.5rem;
            }
            
            .goal-label {
                display: block;
                font-size: 0.85rem;
                color: var(--gray);
                font-weight: 500;
            }
            
            .goal-value {
                display: block;
                font-size: 1.1rem;
                color: var(--dark);
                font-weight: 700;
            }
            
            /* Meals Section */
            .meals-section {
                margin-top: 1.5rem;
            }
            
            .meal-card {
                background: white;
                border: 2px solid var(--border);
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .meal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }
            
            .servings-badge {
                background: var(--success);
                color: white;
                padding: 0.4rem 0.8rem;
                border-radius: 15px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            
            .meal-note {
                background: #fff9e6;
                border-left: 4px solid var(--warning);
                padding: 0.75rem 1rem;
                border-radius: 4px;
                margin-bottom: 1rem;
                font-style: italic;
                color: #8b6914;
            }
            
            /* Ingredients */
            .ingredients-list {
                display: grid;
                gap: 1rem;
            }
            
            .ingredient {
                background: var(--light);
                border-radius: 8px;
                padding: 1rem;
                display: grid;
                grid-template-columns: 120px 1fr;
                gap: 1rem;
                transition: transform 0.2s;
            }
            
            .ingredient:hover {
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            
            .ingredient-img {
                width: 120px;
                height: 120px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid var(--border);
            }
            
            .ingredient-details {
                flex: 1;
            }
            
            .ingredient-header {
                margin-bottom: 0.5rem;
            }
            
            .brand {
                display: inline-block;
                color: var(--gray);
                font-size: 0.85rem;
                margin-top: 0.25rem;
            }
            
            .serving-info {
                color: var(--dark);
                margin-bottom: 1rem;
                padding: 0.5rem;
                background: white;
                border-radius: 4px;
                font-size: 0.95rem;
            }
            
            .nutrition-info {
                margin-top: 1rem;
            }
            
            .nutrition-table {
                width: 100%;
                font-size: 0.9rem;
            }
            
            .nutrition-table tr {
                border-bottom: 1px solid var(--border);
            }
            
            .nutrition-table tr:last-child {
                border-bottom: none;
            }
            
            .nutrition-table td {
                padding: 0.4rem 0.5rem;
            }
            
            .nutrition-table td:first-child {
                color: var(--gray);
                font-weight: 500;
            }
            
            .nutrition-table td.value {
                text-align: right;
                font-weight: 700;
                color: var(--dark);
            }
            
            .nutrition-table tr.sub td:first-child {
                padding-left: 1.5rem;
                font-size: 0.85rem;
            }
            
            /* Footer */
            footer {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 2rem 0;
                margin-top: 2rem;
                text-align: center;
                color: var(--gray);
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                header h1 {
                    font-size: 2rem;
                }
                
                .ingredient {
                    grid-template-columns: 1fr;
                }
                
                .ingredient-img {
                    width: 100%;
                    height: 200px;
                }
                
                .stats-grid,
                .profile-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </xsl:template>
    
</xsl:stylesheet>
