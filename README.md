# 4iz238-sp
Tento projekt je semestrální prací pro předmět 4iz238 - XML

Jedná se o hypotetický scénář aplikace sledující kalorický příjem uživatele.
Data, která se o uživateli budou zaznamenávat jsou zejména údaje jako je výška, hmotnost, datum narození a pohlaví. Tyto údaje mohou sloužit pro výpočet ukazatelů jako je např. BMI.

Z pohledu uživatele jsou důležité jeho cíle, tedy jestli chce váhu shodit, nabrat, nabrat svaly, shodit tuk apod. Proto uživatel takové cíle volí jako své dlouhodobé cíle. Na základě těchto cílů se stanoví jeho energický a nutriční příjem.

Uživatel si každý den zaznamenává veškerá jídla, která skonzumoval. Tato jídla mají v aplikaci své nutriční hodnoty a takto aplikace dosahuje monitorování postupu uživatele.

Co se jídel týče, ty se mohou skládat bud z již hotových jídel, které mají své nutriční hodnoty stejné (hamburger v mekáči) nebo je možné jídlo složit ze základních, ale i jiných složitějších potravin.

## Build Process

### Prerequisites
- Java (for Saxon and Apache FOP)
- Python 3 (for image download script)
- curl (for downloading images)

### Building HTML and PDF outputs

To build both HTML and PDF outputs:
```bash
./build.sh
```

This will:
1. Transform XML to HTML (output to `output/www/`)
2. Transform XML to XSL-FO
3. Convert XSL-FO to PDF (output to `output/pdf/`)
4. Clean up intermediate files

### Image Management

Images are stored locally in the `images/` directory and referenced directly in the XML file.

To download images from external URLs and update the XML to use local references:
```bash
./download_images.sh
```

This creates a backup of the XML file (`xml/diet_tracker.xml.backup`) before making changes.

### Output Structure
- `output/www/` - HTML version with multiple pages
- `output/pdf/` - PDF version with embedded images
- `images/` - Local ingredient images referenced by XML
