## XSD Rules

### Design
- Use XSD 1.0 unless stated otherwise
- Prefer complexType + sequence
- Avoid xsd:any and xsd:anyType
- Use simpleType restrictions for enums
- Always define types outside of the element. Use simpleType or complexType

### Naming
- Elements: snake_case
- Types: snake_case
- Attributes: snake_case

### Stability
- Do not remove elements unless approved
- New elements must be optional unless approved
- Version schemas using namespaces, not filenames
- Add documentation to new types

