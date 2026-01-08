<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:dt="urn:vse:4iz238:chav07:sp:diet_tracker"
            queryBinding="xslt2">
    
    <sch:title>Diet Tracker Schematron Validation Rules</sch:title>
    
    <sch:ns prefix="dt" uri="urn:vse:4iz238:chav07:sp:diet_tracker"/>
    
    <!-- Carbohydrates validation: sugars cannot exceed total -->
    
    <sch:pattern id="carbohydrates-daily-goal-validation">
        <sch:title>Carbohydrates validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:carbohydrates">
            <sch:assert test="number(dt:sugars) &lt;= number(dt:total)"
                        role="error">
                In daily_goal, sugars (<sch:value-of select="dt:sugars"/>) cannot exceed total carbohydrates (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="carbohydrates-ingredient-validation">
        <sch:title>Carbohydrates validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:carbohydrates">
            <sch:assert test="number(dt:sugars) &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', sugars (<sch:value-of select="dt:sugars"/>) cannot exceed total carbohydrates (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- Fats validation: each fat type cannot exceed total -->
    
    <sch:pattern id="fats-saturated-daily-goal-validation">
        <sch:title>Saturated fats validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:fats[dt:saturated_fats]">
            <sch:assert test="number(dt:saturated_fats) &lt;= number(dt:total)"
                        role="error">
                In daily_goal, saturated fats (<sch:value-of select="dt:saturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-saturated-ingredient-validation">
        <sch:title>Saturated fats validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:fats[dt:saturated_fats]">
            <sch:assert test="number(dt:saturated_fats) &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', saturated fats (<sch:value-of select="dt:saturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-trans-daily-goal-validation">
        <sch:title>Trans fats validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:fats[dt:trans_fats]">
            <sch:assert test="number(dt:trans_fats) &lt;= number(dt:total)"
                        role="error">
                In daily_goal, trans fats (<sch:value-of select="dt:trans_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-trans-ingredient-validation">
        <sch:title>Trans fats validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:fats[dt:trans_fats]">
            <sch:assert test="number(dt:trans_fats) &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', trans fats (<sch:value-of select="dt:trans_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-monosaturated-daily-goal-validation">
        <sch:title>Monosaturated fats validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:fats[dt:monosaturated_fats]">
            <sch:assert test="number(dt:monosaturated_fats) &lt;= number(dt:total)"
                        role="error">
                In daily_goal, monosaturated fats (<sch:value-of select="dt:monosaturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-monosaturated-ingredient-validation">
        <sch:title>Monosaturated fats validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:fats[dt:monosaturated_fats]">
            <sch:assert test="number(dt:monosaturated_fats) &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', monosaturated fats (<sch:value-of select="dt:monosaturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-polysaturated-daily-goal-validation">
        <sch:title>Polysaturated fats validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:fats[dt:polysaturated_fats]">
            <sch:assert test="number(dt:polysaturated_fats) &lt;= number(dt:total)"
                        role="error">
                In daily_goal, polysaturated fats (<sch:value-of select="dt:polysaturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-polysaturated-ingredient-validation">
        <sch:title>Polysaturated fats validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:fats[dt:polysaturated_fats]">
            <sch:assert test="number(dt:polysaturated_fats) &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', polysaturated fats (<sch:value-of select="dt:polysaturated_fats"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- Fats validation: sum of all fat types cannot exceed total -->
    
    <sch:pattern id="fats-sum-daily-goal-validation">
        <sch:title>Sum of fat types validation in daily_goal</sch:title>
        <sch:rule context="dt:daily_goal/dt:fats">
            <sch:let name="saturated" value="if (dt:saturated_fats) then number(dt:saturated_fats) else 0"/>
            <sch:let name="trans" value="if (dt:trans_fats) then number(dt:trans_fats) else 0"/>
            <sch:let name="mono" value="if (dt:monosaturated_fats) then number(dt:monosaturated_fats) else 0"/>
            <sch:let name="poly" value="if (dt:polysaturated_fats) then number(dt:polysaturated_fats) else 0"/>
            <sch:let name="sum" value="$saturated + $trans + $mono + $poly"/>
            <sch:assert test="$sum &lt;= number(dt:total)"
                        role="error">
                In daily_goal, the sum of all fat types (<sch:value-of select="$sum"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>). 
                (saturated: <sch:value-of select="$saturated"/>, trans: <sch:value-of select="$trans"/>, monosaturated: <sch:value-of select="$mono"/>, polysaturated: <sch:value-of select="$poly"/>)
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="fats-sum-ingredient-validation">
        <sch:title>Sum of fat types validation in base_values_per_100g</sch:title>
        <sch:rule context="dt:base_values_per_100g/dt:fats">
            <sch:let name="saturated" value="if (dt:saturated_fats) then number(dt:saturated_fats) else 0"/>
            <sch:let name="trans" value="if (dt:trans_fats) then number(dt:trans_fats) else 0"/>
            <sch:let name="mono" value="if (dt:monosaturated_fats) then number(dt:monosaturated_fats) else 0"/>
            <sch:let name="poly" value="if (dt:polysaturated_fats) then number(dt:polysaturated_fats) else 0"/>
            <sch:let name="sum" value="$saturated + $trans + $mono + $poly"/>
            <sch:assert test="$sum &lt;= number(dt:total)"
                        role="error">
                In ingredient '<sch:value-of select="ancestor::dt:ingredient/dt:name"/>', the sum of all fat types (<sch:value-of select="$sum"/>) cannot exceed total fats (<sch:value-of select="dt:total"/>). 
                (saturated: <sch:value-of select="$saturated"/>, trans: <sch:value-of select="$trans"/>, monosaturated: <sch:value-of select="$mono"/>, polysaturated: <sch:value-of select="$poly"/>)
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
