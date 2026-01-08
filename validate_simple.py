#!/usr/bin/env python3
"""
Simple Schematron-like validator for Diet Tracker XML
Validates that component values don't exceed their totals
"""

import xml.etree.ElementTree as ET
import sys
from typing import List, Tuple

# Namespace
NS = {'dt': 'urn:vse:4iz238:chav07:sp:diet_tracker'}

class ValidationError:
    def __init__(self, context: str, message: str):
        self.context = context
        self.message = message
    
    def __str__(self):
        return f"[{self.context}] {self.message}"

def get_float(element, path: str) -> float:
    """Get float value from element or return 0 if not found"""
    node = element.find(path, NS)
    return float(node.text) if node is not None else 0.0

def validate_carbohydrates(carbs_elem, context: str) -> List[ValidationError]:
    """Validate that sugars <= total carbohydrates"""
    errors = []
    
    total = get_float(carbs_elem, 'dt:total')
    sugars = get_float(carbs_elem, 'dt:sugars')
    
    if sugars > total:
        errors.append(ValidationError(
            context,
            f"Sugars ({sugars}) cannot exceed total carbohydrates ({total})"
        ))
    
    return errors

def validate_fats(fats_elem, context: str) -> List[ValidationError]:
    """Validate that individual fat types and their sum don't exceed total fats"""
    errors = []
    
    total = get_float(fats_elem, 'dt:total')
    saturated = get_float(fats_elem, 'dt:saturated_fats')
    trans = get_float(fats_elem, 'dt:trans_fats')
    mono = get_float(fats_elem, 'dt:monosaturated_fats')
    poly = get_float(fats_elem, 'dt:polysaturated_fats')
    
    # Check individual fat types
    if saturated > total:
        errors.append(ValidationError(
            context,
            f"Saturated fats ({saturated}) cannot exceed total fats ({total})"
        ))
    
    if trans > total:
        errors.append(ValidationError(
            context,
            f"Trans fats ({trans}) cannot exceed total fats ({total})"
        ))
    
    if mono > total:
        errors.append(ValidationError(
            context,
            f"Monosaturated fats ({mono}) cannot exceed total fats ({total})"
        ))
    
    if poly > total:
        errors.append(ValidationError(
            context,
            f"Polysaturated fats ({poly}) cannot exceed total fats ({total})"
        ))
    
    # Check sum of all fat types
    fat_sum = saturated + trans + mono + poly
    if fat_sum > total:
        errors.append(ValidationError(
            context,
            f"Sum of all fat types ({fat_sum:.2f}) cannot exceed total fats ({total}). "
            f"(saturated: {saturated}, trans: {trans}, mono: {mono}, poly: {poly})"
        ))
    
    return errors

def validate_daily_goal(daily_goal, date: str) -> List[ValidationError]:
    """Validate a daily_goal element"""
    errors = []
    context = f"Daily goal for {date}"
    
    # Validate carbohydrates
    carbs = daily_goal.find('dt:carbohydrates', NS)
    if carbs is not None:
        errors.extend(validate_carbohydrates(carbs, context))
    
    # Validate fats
    fats = daily_goal.find('dt:fats', NS)
    if fats is not None:
        errors.extend(validate_fats(fats, context))
    
    return errors

def validate_ingredient(ingredient) -> List[ValidationError]:
    """Validate an ingredient's base_values_per_100g"""
    errors = []
    
    name = ingredient.find('dt:name', NS)
    ingredient_name = name.text if name is not None else "Unknown"
    context = f"Ingredient '{ingredient_name}'"
    
    base_values = ingredient.find('dt:base_values_per_100g', NS)
    if base_values is None:
        return errors
    
    # Validate carbohydrates
    carbs = base_values.find('dt:carbohydrates', NS)
    if carbs is not None:
        errors.extend(validate_carbohydrates(carbs, context))
    
    # Validate fats
    fats = base_values.find('dt:fats', NS)
    if fats is not None:
        errors.extend(validate_fats(fats, context))
    
    return errors

def validate_xml(xml_path: str) -> List[ValidationError]:
    """Validate the entire XML file"""
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    all_errors = []
    
    # Validate all daily goals
    for daily_log in root.findall('.//dt:daily_log', NS):
        date = daily_log.get('date', 'Unknown date')
        daily_goal = daily_log.find('dt:daily_goal', NS)
        if daily_goal is not None:
            all_errors.extend(validate_daily_goal(daily_goal, date))
    
    # Validate all ingredients
    for ingredient in root.findall('.//dt:ingredient', NS):
        all_errors.extend(validate_ingredient(ingredient))
    
    return all_errors

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 validate_simple.py <xml_file>")
        sys.exit(1)
    
    xml_file = sys.argv[1]
    
    print("=== Diet Tracker Validation ===")
    print(f"Validating: {xml_file}")
    print()
    
    try:
        errors = validate_xml(xml_file)
        
        if not errors:
            print("✓ Validation successful! No errors found.")
            print()
            print("All Schematron rules passed:")
            print("  • Sugars don't exceed total carbohydrates")
            print("  • Individual fat types don't exceed total fats")
            print("  • Sum of fat types doesn't exceed total fats")
            return 0
        else:
            print(f"✗ Found {len(errors)} validation error(s):")
            print()
            for i, error in enumerate(errors, 1):
                print(f"{i}. {error}")
            return 1
    
    except ET.ParseError as e:
        print(f"✗ XML parsing error: {e}")
        return 2
    except FileNotFoundError:
        print(f"✗ File not found: {xml_file}")
        return 2
    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        return 2

if __name__ == '__main__':
    sys.exit(main())
