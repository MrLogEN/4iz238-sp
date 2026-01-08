#!/bin/bash
# Build script for Diet Tracker transformations

set -e

echo "=== Diet Tracker Build Script ==="
echo ""

# Variables
SAXON_CP="bin/saxon-he-12.9.jar:bin/xmlresolver-6.0.9.jar"
XML_SOURCE="xml/diet_tracker.xml"
HTML_XSL="transforms/diet_tracker_to_html5.xsl"
FO_XSL="transforms/diet_tracker_to_fo.xsl"
HTML_OUTPUT="output/www/index.html"
FO_OUTPUT="output/pdf/diet_tracker.fo"
PDF_OUTPUT="output/pdf/diet_tracker.pdf"
FOP_CONFIG="fop.xconf"

# HTML Transformation
echo "1. Transforming XML to HTML..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$HTML_XSL" \
    -s:"$XML_SOURCE" \
    -o:"$HTML_OUTPUT"
echo "   ✓ HTML generated: $HTML_OUTPUT"
echo ""

# PDF Transformation
echo "2. Transforming XML to XSL-FO..."
java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -xsl:"$FO_XSL" \
    -s:"$XML_SOURCE" \
    -o:"$FO_OUTPUT"
echo "   ✓ FO generated: $FO_OUTPUT"
echo ""

echo "3. Converting XSL-FO to PDF..."
fop -c "$FOP_CONFIG" -fo "$FO_OUTPUT" -pdf "$PDF_OUTPUT" 2>&1 | grep -E "(INFO: Rendered page)" | tail -1
echo "   ✓ PDF generated: $PDF_OUTPUT"
echo ""

# Clean up intermediate FO file
echo "4. Cleaning up intermediate files..."
rm -f "$FO_OUTPUT"
echo "   ✓ Removed $FO_OUTPUT"
echo ""

echo "=== Build Complete ==="
echo "HTML: $HTML_OUTPUT"
echo "PDF:  $PDF_OUTPUT"
