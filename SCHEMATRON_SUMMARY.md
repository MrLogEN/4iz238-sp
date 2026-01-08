# Schematron Rules Summary - All Validation Points

This document lists all places in the Diet Tracker XML where Schematron validation rules are applied.

## Validation Rule Categories

### 1. Carbohydrates: Sugars ≤ Total

| Location | Context | Element Path | Rule |
|----------|---------|--------------|------|
| Daily Goals | Daily nutritional targets | `daily_log/daily_goal/carbohydrates` | `sugars ≤ total` |
| Ingredients | Nutritional values per 100g | `ingredient/base_values_per_100g/carbohydrates` | `sugars ≤ total` |

**Count in current XML**: 3 daily goals + 16 ingredients = **19 validation points**

### 2. Fats: Individual Fat Types ≤ Total

| Fat Type | Daily Goal Path | Ingredient Path | Rule |
|----------|----------------|-----------------|------|
| Saturated | `daily_log/daily_goal/fats` | `ingredient/base_values_per_100g/fats` | `saturated_fats ≤ total` |
| Trans | `daily_log/daily_goal/fats` | `ingredient/base_values_per_100g/fats` | `trans_fats ≤ total` |
| Monosaturated | `daily_log/daily_goal/fats` | `ingredient/base_values_per_100g/fats` | `monosaturated_fats ≤ total` |
| Polysaturated | `daily_log/daily_goal/fats` | `ingredient/base_values_per_100g/fats` | `polysaturated_fats ≤ total` |

**Count in current XML**: 
- Daily goals with fats: 3
- Ingredients with fats: 15
- **Total validation points**: 18 (each location has 4 fat type checks)

### 3. Fats: Sum of All Types ≤ Total

| Location | Context | Formula |
|----------|---------|---------|
| Daily Goals | Daily nutritional targets | `saturated + trans + mono + poly ≤ total` |
| Ingredients | Nutritional values per 100g | `saturated + trans + mono + poly ≤ total` |

**Count in current XML**: 3 daily goals + 15 ingredients = **18 validation points**

## Complete List of Validated Elements in Current XML

### Daily Goals (3 entries)

1. **Date: 2025-11-21**
   - Carbohydrates: total=230, sugars=21 ✓
   - Fats: total=40, saturated=5.93, trans=2.1, mono=3.7, poly=1.32, sum=13.05 ✓

2. **Date: 2025-11-22**
   - Carbohydrates: total=250, sugars=25 ✓
   - Fats: total=45, saturated=6, trans=2, mono=4, poly=1.5, sum=13.5 ✓

3. **Date: 2025-11-23**
   - Carbohydrates: total=270, sugars=30 ✓
   - Fats: total=50, saturated=7, trans=2.5, mono=4.5, poly=2, sum=16 ✓

### Ingredients (16 entries)

1. **Řecký jogurt bílý 0% tuku** (ID: 1)
   - Carbohydrates: total=3.77, sugars=3.77 ✓
   - Fats: total=0.32, saturated=0.22, sum=0.22 ✓

2. **rohlík bílý** (ID: 2)
   - Carbohydrates: total=56.14, sugars=1.05 ✓
   - Fats: total=3.60, saturated=1.16, mono=1.05, poly=1.05, sum=3.26 ✓

3. **Vejce slepičí** (ID: 3)
   - Carbohydrates: total=1.57, sugars=0.57 ✓
   - Fats: total=18.12, saturated=5.62, mono=7.17, poly=2.97, sum=15.76 ✓

4. **Cheeseburger** (ID: 4)
   - Carbohydrates: total=24.92, sugars=5.98 ✓
   - Fats: total=10.97, saturated=4.98, trans=1.76, mono=3.11, poly=1.11, sum=10.96 ✓

5. **Voda** (ID: 5)
   - No carbohydrates or fats (only water content)

6. **Ovesné vločky** (ID: 6)
   - Carbohydrates: total=58.7, sugars=0.7 ✓
   - Fats: total=7.0, saturated=1.3, mono=2.4, poly=2.7, sum=6.4 ✓

7. **Banán** (ID: 7)
   - Carbohydrates: total=22.84, sugars=12.23 ✓
   - Fats: total=0.33, saturated=0.11, sum=0.11 ✓

8. **Mléko polotučné** (ID: 8)
   - Carbohydrates: total=4.8, sugars=4.8 ✓
   - Fats: total=1.5, saturated=1.0, sum=1.0 ✓

9. **Kuřecí prsa** (ID: 9)
   - Carbohydrates: total=0, sugars=0 ✓
   - Fats: total=3.6, saturated=1.0, mono=1.2, poly=0.8, sum=3.0 ✓

10. **Rýže bílá vařená** (ID: 10)
    - Carbohydrates: total=28.2, sugars=0.1 ✓
    - Fats: total=0.3, saturated=0.1, sum=0.1 ✓

11. **Ledový salát** (ID: 11)
    - Carbohydrates: total=2.97, sugars=1.97 ✓
    - Fats: total=0.14, saturated=0.02, sum=0.02 ✓

12. **Tvaroh měkký** (ID: 12)
    - Carbohydrates: total=3.5, sugars=3.5 ✓
    - Fats: total=4.5, saturated=2.8, sum=2.8 ✓

13. **Med** (ID: 13)
    - Carbohydrates: total=82.4, sugars=82.1 ✓
    - Fats: total=0, saturated=0, sum=0 ✓

14. **Losos** (ID: 14)
    - Carbohydrates: total=0, sugars=0 ✓
    - Fats: total=13.4, saturated=3.1, mono=4.5, poly=4.2, sum=11.8 ✓

15. **Brokolice vařená** (ID: 15)
    - Carbohydrates: total=7.2, sugars=1.4 ✓
    - Fats: total=0.4, saturated=0.1, sum=0.1 ✓

16. **Jahody** (ID: 16)
    - Carbohydrates: total=7.68, sugars=4.89 ✓
    - Fats: total=0.3, saturated=0.02, sum=0.02 ✓

## Total Validation Points Summary

| Rule Type | Daily Goals | Ingredients | Total |
|-----------|-------------|-------------|-------|
| Carbohydrates (sugars ≤ total) | 3 | 16 | **19** |
| Saturated fats ≤ total | 3 | 15 | **18** |
| Trans fats ≤ total | 3 | 2 | **5** |
| Monosaturated fats ≤ total | 3 | 7 | **10** |
| Polysaturated fats ≤ total | 3 | 7 | **10** |
| Sum of fats ≤ total | 3 | 15 | **18** |
| **TOTAL CHECKS** | **18** | **62** | **80** |

## Schematron Patterns

The Schematron file (`schemas/diet_tracker.sch`) implements **12 patterns**:

1. `carbohydrates-daily-goal-validation`
2. `carbohydrates-ingredient-validation`
3. `fats-saturated-daily-goal-validation`
4. `fats-saturated-ingredient-validation`
5. `fats-trans-daily-goal-validation`
6. `fats-trans-ingredient-validation`
7. `fats-monosaturated-daily-goal-validation`
8. `fats-monosaturated-ingredient-validation`
9. `fats-polysaturated-daily-goal-validation`
10. `fats-polysaturated-ingredient-validation`
11. `fats-sum-daily-goal-validation`
12. `fats-sum-ingredient-validation`

## Validation Status

Current XML (`xml/diet_tracker.xml`): **All validation rules pass ✓**

To validate:
```bash
# Simple Python validator (no setup required)
python3 validate_simple.py xml/diet_tracker.xml

# Full Schematron validator (requires ISO Schematron setup)
./validate_schematron.sh
```
