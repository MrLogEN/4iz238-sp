# Sample XML Files

This directory contains sample XML files for testing validation rules.

## test_invalid.xml

An intentionally invalid XML file that violates multiple Schematron validation rules. Used to demonstrate that the validation is working correctly.

### Validation Errors Present

1. **Daily Goal Carbohydrates**: Sugars (250) exceed total carbohydrates (200)
2. **Daily Goal Fats**: Saturated fats (50) exceed total fats (40)
3. **Daily Goal Fats Sum**: Sum of all fat types (52) exceeds total fats (40)
4. **Ingredient Carbohydrates**: Sugars (60) exceed total carbohydrates (50)
5. **Ingredient Fats Sum**: Sum of all fat types (14) exceeds total fats (10)

### Testing

To test validation with this file:

```bash
# Python validator
python3 validate_simple.py samples/test_invalid.xml

# Expected: 5 validation errors
```

The file should fail validation with 5 distinct error messages, demonstrating that the Schematron rules are properly catching violations of business logic constraints.
