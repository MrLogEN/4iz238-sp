# Schematron Validation Rules for Diet Tracker

This document describes all Schematron validation rules implemented in `schemas/diet_tracker.sch`.

## Overview

Schematron rules enforce business logic constraints that cannot be expressed in XSD alone. For the Diet Tracker application, these rules ensure that nutritional component values do not exceed their total values.

## Validation Rules

### 1. Carbohydrates Validation

**Rule**: Sugars cannot exceed total carbohydrates

**Applies to**:
- `daily_goal/carbohydrates` (in daily logs)
- `base_values_per_100g/carbohydrates` (in ingredients)

**Pattern IDs**:
- `carbohydrates-daily-goal-validation`
- `carbohydrates-ingredient-validation`

**Example of valid data**:
```xml
<carbohydrates>
    <total>230</total>
    <sugars>21</sugars>  <!-- 21 <= 230 ✓ -->
</carbohydrates>
```

**Example of invalid data**:
```xml
<carbohydrates>
    <total>230</total>
    <sugars>250</sugars>  <!-- 250 > 230 ✗ -->
</carbohydrates>
```

### 2. Individual Fat Types Validation

**Rule**: Each individual fat type cannot exceed total fats

**Applies to**:
- `daily_goal/fats` (in daily logs)
- `base_values_per_100g/fats` (in ingredients)

**Fat types checked**:
- Saturated fats
- Trans fats
- Monosaturated fats
- Polysaturated fats

**Pattern IDs**:
- `fats-saturated-daily-goal-validation` / `fats-saturated-ingredient-validation`
- `fats-trans-daily-goal-validation` / `fats-trans-ingredient-validation`
- `fats-monosaturated-daily-goal-validation` / `fats-monosaturated-ingredient-validation`
- `fats-polysaturated-daily-goal-validation` / `fats-polysaturated-ingredient-validation`

**Example of valid data**:
```xml
<fats>
    <total>40</total>
    <saturated_fats>5.93</saturated_fats>      <!-- 5.93 <= 40 ✓ -->
    <trans_fats>2.1</trans_fats>               <!-- 2.1 <= 40 ✓ -->
    <monosaturated_fats>3.7</monosaturated_fats>  <!-- 3.7 <= 40 ✓ -->
    <polysaturated_fats>1.32</polysaturated_fats> <!-- 1.32 <= 40 ✓ -->
</fats>
```

**Example of invalid data**:
```xml
<fats>
    <total>40</total>
    <saturated_fats>45</saturated_fats>  <!-- 45 > 40 ✗ -->
</fats>
```

### 3. Sum of Fat Types Validation

**Rule**: The sum of all fat type components cannot exceed total fats

**Applies to**:
- `daily_goal/fats` (in daily logs)
- `base_values_per_100g/fats` (in ingredients)

**Pattern IDs**:
- `fats-sum-daily-goal-validation`
- `fats-sum-ingredient-validation`

**Calculation**: 
```
sum = saturated_fats + trans_fats + monosaturated_fats + polysaturated_fats
```
(Missing/optional fat types are treated as 0)

**Example of valid data**:
```xml
<fats>
    <total>40</total>
    <saturated_fats>5.93</saturated_fats>
    <trans_fats>2.1</trans_fats>
    <monosaturated_fats>3.7</monosaturated_fats>
    <polysaturated_fats>1.32</polysaturated_fats>
    <!-- Sum: 5.93 + 2.1 + 3.7 + 1.32 = 13.05 <= 40 ✓ -->
</fats>
```

**Example of invalid data**:
```xml
<fats>
    <total>10</total>
    <saturated_fats>5</saturated_fats>
    <trans_fats>3</trans_fats>
    <monosaturated_fats>4</monosaturated_fats>
    <polysaturated_fats>2</polysaturated_fats>
    <!-- Sum: 5 + 3 + 4 + 2 = 14 > 10 ✗ -->
</fats>
```

## Validation Contexts

### Daily Goals Context
These rules validate nutritional targets set for each day. Violations indicate that the daily goals have been set with inconsistent values.

**XML Path**: `/diet_tracker/user/daily_logs/daily_log/daily_goal`

### Ingredient Context
These rules validate nutritional information for ingredients (per 100g). Violations indicate that the ingredient's nutritional data is inconsistent.

**XML Path**: `/diet_tracker/user/daily_logs/daily_log/meals/meal/ingredients/ingredient/base_values_per_100g`

## Error Messages

All error messages include:
1. **Context**: Whether the error is in a daily_goal or an ingredient
2. **Ingredient name**: For ingredient validation errors
3. **Actual values**: The component value and total value that caused the violation
4. **Details**: For sum validation, all individual fat type values

Example error message:
```
In ingredient 'Cheeseburger', the sum of all fat types (14.96) cannot exceed total fats (10.97). 
(saturated: 4.98, trans: 1.76, monosaturated: 3.11, polysaturated: 1.11)
```

## Using Schematron Validation

### Option 1: Simple Python Validator (Recommended, No Setup Required)

This is the easiest way to validate. It implements all Schematron rules in pure Python:

```bash
python3 validate_simple.py xml/diet_tracker.xml
```

**Advantages:**
- No additional software required (just Python 3)
- Fast execution
- Clear error messages with context
- Works on all platforms

### Option 2: Using the full Schematron validation script (requires ISO Schematron)

This converts the Schematron file to XSLT and validates using SVRL output:

1. Download ISO Schematron XSLT implementation:
   ```bash
   mkdir -p bin/iso-schematron
   cd bin/iso-schematron
   # Download from https://github.com/Schematron/schematron
   # Extract trunk/schematron/code/* to this directory
   ```

2. Run validation:
   ```bash
   ./validate_schematron.sh
   ```

### Option 3: Using online validators

Upload both `schemas/diet_tracker.sch` and `xml/diet_tracker.xml` to an online Schematron validator such as:
- https://www.schematron.com/validators/
- https://www.freeformatter.com/schematron-validator.html

### Option 4: Using XML editors with Schematron support

Many XML editors have built-in Schematron support:
- oXygen XML Editor
- XMLSpy
- Visual Studio Code with XML extensions

## Future Enhancements

Potential additional validation rules that could be added:

1. **Water content validation**: Ensure water content in ingredients doesn't exceed 100g per 100g
2. **Macronutrient sum validation**: Verify that protein + carbs + fats doesn't exceed the serving weight (considering caloric density)
3. **Date consistency**: Ensure daily_log dates are unique and chronologically ordered
4. **Serving size validation**: Validate that serving sizes are reasonable for the ingredient type
5. **Energy calculation validation**: Verify energy values match the macronutrient breakdown using standard caloric conversions

## Technical Details

- **Schematron version**: ISO Schematron (DSDL Part 3)
- **Query binding**: XSLT 2.0 (for Saxon compatibility)
- **Namespace**: `urn:vse:4iz238:chav07:sp:diet_tracker`
- **File location**: `schemas/diet_tracker.sch`

## References

- ISO/IEC 19757-3 (Schematron): https://www.schematron.com/
- Diet Tracker XSD Schema: `schemas/diet_tracker.xsd`
- Sample data: `xml/diet_tracker.xml`
