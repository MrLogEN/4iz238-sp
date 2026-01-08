#!/bin/bash
# Schematron validation script for Diet Tracker
# This script converts the Schematron file to XSLT and validates the XML

set -e

echo "=== Schematron Validation ==="
echo ""

# Variables
SAXON_CP="bin/saxon-he-12.9.jar:bin/xmlresolver-6.0.9.jar"
XML_SOURCE="${1:-xml/diet_tracker.xml}"
SCHEMATRON="schemas/diet_tracker.sch"
ISO_SCHEMATRON_DIR="bin/iso-schematron"
TEMP_DIR="output/validation"

# Create temp directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Check if ISO Schematron stylesheets exist
if [ ! -d "$ISO_SCHEMATRON_DIR" ]; then
    echo "ERROR: ISO Schematron stylesheets not found in $ISO_SCHEMATRON_DIR"
    echo ""
    echo "To use this script, you need to download the ISO Schematron XSLT files:"
    echo "1. Download from: https://github.com/Schematron/schematron"
    echo "2. Extract the 'trunk/schematron/code' directory to $ISO_SCHEMATRON_DIR"
    echo ""
    echo "Alternatively, you can use online Schematron validators or other tools."
    exit 1
fi

echo "Validating: $XML_SOURCE"
echo ""

# Step 1: Expand includes (if any)
echo "1. Preprocessing Schematron..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$ISO_SCHEMATRON_DIR/iso_dsdl_include.xsl" \
    -s:"$SCHEMATRON" \
    -o:"$TEMP_DIR/step1.sch"
echo "   ✓ Includes expanded"

# Step 2: Expand abstract patterns
echo "2. Expanding abstract patterns..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$ISO_SCHEMATRON_DIR/iso_abstract_expand.xsl" \
    -s:"$TEMP_DIR/step1.sch" \
    -o:"$TEMP_DIR/step2.sch"
echo "   ✓ Abstract patterns expanded"

# Step 3: Compile to XSLT
echo "3. Compiling Schematron to XSLT..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$ISO_SCHEMATRON_DIR/iso_schematron_message_xslt2.xsl" \
    -s:"$TEMP_DIR/step2.sch" \
    -o:"$TEMP_DIR/validator.xsl"
echo "   ✓ XSLT validator generated"

# Step 4: Run validation
echo "4. Validating XML against Schematron rules..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$TEMP_DIR/validator.xsl" \
    -s:"$XML_SOURCE"
echo ""
echo "   ✓ Validation complete"

echo ""
echo "=== Validation Results ==="
echo ""
echo "If no errors were shown above, validation passed successfully."
echo ""
