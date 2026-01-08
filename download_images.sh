#!/bin/bash
# Download images from XML and update XML to reference local files

set -e

XML_FILE="xml/diet_tracker.xml"
XML_BACKUP="xml/diet_tracker.xml.backup"
IMAGE_DIR="images"

echo "=== Downloading and updating images ==="
echo ""

# Create backup
if [ ! -f "$XML_BACKUP" ]; then
    echo "Creating backup: $XML_BACKUP"
    cp "$XML_FILE" "$XML_BACKUP"
else
    echo "Using existing backup: $XML_BACKUP"
    cp "$XML_BACKUP" "$XML_FILE"
fi

# Create images directory
mkdir -p "$IMAGE_DIR"

echo "Extracting image URLs from XML..."
echo ""

# Use xmlstarlet or simple grep to extract URLs
# For each ingredient, extract ID and image URL
python3 << 'PYEOF'
import re
import urllib.request
import urllib.parse
from pathlib import Path

xml_file = "xml/diet_tracker.xml"
image_dir = "images"

# Read XML
with open(xml_file, 'r', encoding='utf-8') as f:
    xml_content = f.read()

# Find all ingredients with images
pattern = r'<ingredient id="(\d+)">.*?<img>(.*?)</img>'
matches = re.findall(pattern, xml_content, re.DOTALL)

print(f"Found {len(matches)} ingredients with images\n")

for ing_id, img_url in matches:
    # Decode HTML entities
    img_url = img_url.replace('&amp;', '&')
    
    filename = f"ingredient_{ing_id}.jpg"
    filepath = f"{image_dir}/{filename}"
    
    print(f"Ingredient {ing_id}:")
    print(f"  URL: {img_url[:70]}...")
    
    try:
        # Download image
        urllib.request.urlretrieve(img_url, filepath)
        print(f"  ✓ Saved as {filepath}")
        
        # Update XML content
        # Need to escape & back to &amp; for XML
        old_tag = f"<img>{img_url.replace('&', '&amp;')}</img>"
        new_tag = f"<img>{filepath}</img>"
        xml_content = xml_content.replace(old_tag, new_tag)
        
    except Exception as e:
        print(f"  ✗ Failed: {e}")
    
    print()

# Write updated XML
with open(xml_file, 'w', encoding='utf-8') as f:
    f.write(xml_content)

print("XML updated successfully")
PYEOF

echo ""
echo "=== Complete ==="
echo "Images downloaded to: $IMAGE_DIR/"
echo "XML updated: $XML_FILE"
echo "Backup saved: $XML_BACKUP"
echo ""
ls -lh "$IMAGE_DIR/"
