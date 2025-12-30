## XSD Rules

### Design
- Use XSD 1.0 unless stated otherwise
- Prefer complexType + sequence
- Avoid xsd:any and xsd:anyType
- Use simpleType restrictions for enums

### Naming
- Elements: PascalCase
- Types: PascalCaseType
- Attributes: camelCase

### Stability
- Do not remove elements
- New elements must be optional unless approved
- Version schemas using namespaces, not filenames

