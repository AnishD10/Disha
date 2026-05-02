# Disha Project - Mermaid Diagrams

This folder contains all class diagrams and architectural diagrams in Mermaid format.

## Files

1. **01-Model-Layer-ClassDiagram.mmd**
   - All entity/model classes (User, StudentProfile, Assessment, etc.)
   - Class attributes and methods
   - Relationships between entities
   - Inheritance hierarchy

2. **02-DAO-Layer-ClassDiagram.mmd**
   - Abstract BaseDAO class with common methods
   - All DAO implementations (UserDAO, StudentProfileDAO, etc.)
   - Inheritance from BaseDAO
   - CRUD operation signatures

3. **03-Service-Layer-ClassDiagram.mmd**
   - Business logic services
   - Service dependencies and integrations
   - Method signatures for core operations
   - Service layer responsibilities

4. **04-Controller-Layer-ClassDiagram.mmd**
   - All Servlet controllers
   - HTTP method handlers (doGet, doPost)
   - Service dependencies
   - API endpoint organization

5. **05-Complete-Architecture-Layered.mmd**
   - Full system architecture overview
   - All 8 layers with relationships
   - Data flow through layers
   - Color-coded by layer type

6. **06-Entity-Relationship-Diagram.mmd**
   - Database table relationships
   - Cardinality (one-to-one, one-to-many)
   - Foreign key relationships
   - Data model structure

## How to Use

### Option 1: Online Viewer
1. Go to https://mermaid.live
2. Copy the content of any .mmd file
3. Paste into the editor
4. View rendered diagram

### Option 2: VS Code
1. Install "Markdown Preview Mermaid Support" extension
2. Open any .mmd file
3. View in Markdown preview

### Option 3: Mermaid CLI
```bash
npm install -g mermaid-cli
mmdc -i 01-Model-Layer-ClassDiagram.mmd -o 01-Model-Layer-ClassDiagram.png
```

### Option 4: Export to Other Tools
- Copy diagram code into Lucidchart
- Copy into Draw.io
- Use Mermaid plugins in Confluence/Notion

## Diagram Reference

### Model Layer (01)
- Shows all data entities used by the application
- Includes User with Role enum
- Displays relationships between models
- Complete attribute listing

### DAO Layer (02)
- Base class with common database operations
- Concrete implementations for each entity
- CRUD method patterns
- Resource management methods

### Service Layer (03)
- 8 major services for business logic
- Dependencies between services
- Method signatures for key operations
- Integration points

### Controller Layer (04)
- 7 Servlet controllers for API endpoints
- HTTP method handling
- Service integration
- Request/response handling

### Architecture Overview (05)
- Complete system layers
- Data flow and dependencies
- Cross-cutting concerns (middleware)
- Database integration

### Entity Relationships (06)
- Database structure
- Foreign key relationships
- One-to-many and many-to-many relationships
- Data model visualization

## Color Coding (Architecture Diagram)

- 🔵 Blue: View/Presentation Layer
- 🟣 Purple: Controller Layer
- 🟢 Green: Service Layer
- 🟡 Yellow: DAO/Persistence Layer
- 🔴 Red: Model/Entity Layer
- ⚪ Gray: Utility Layer
- 🔴 Pink: Middleware/Filter Layer
- 🔵 Teal: Database Layer

## Integration with Development

### For Developers
Use these diagrams to:
- Understand project architecture
- Know what classes to create
- Understand class relationships
- Follow established patterns

### For Code Generation
- Use as reference for class structure
- Follow method signatures
- Implement relationship patterns
- Match layer organization

### For Documentation
- Include in technical specifications
- Share with team for onboarding
- Use in design reviews
- Reference in code comments

## Updates

When making architectural changes:
1. Update the relevant diagram file
2. Follow Mermaid syntax
3. Regenerate PNG/SVG exports
4. Update this README with changes

## Additional Resources

- [Mermaid Syntax](https://mermaid.js.org/)
- [Class Diagram Guide](https://mermaid.js.org/syntax/classDiagram.html)
- [ER Diagram Guide](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)
- [Graph Syntax](https://mermaid.js.org/syntax/graph.html)

---

**Project**: Disha - Nepal Career Intelligence Portal
**Version**: 1.0
**Last Updated**: May 2, 2026
