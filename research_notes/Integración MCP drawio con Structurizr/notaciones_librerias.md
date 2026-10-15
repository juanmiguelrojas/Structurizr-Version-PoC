# Notations and draw.io libraries: C4, ArchiMate 3.2 (and 4) and Google Cloud icons (status Oct 2026)

Method note: the draw.io facts below come from reading the jgraph/drawio source on the `dev` branch at tag **v32.4.1 (commit dated 2026-10-08)**. The sidebar files were downloaded from raw.githubusercontent.com, and the git history from a shallow clone. Archi facts come from the archimatetool/archi `master` source (last commit 2026-10-07, bundle version 5.10.0). The sandbox could not reach c4model.com, pubs.opengroup.org, opengroup.org, archimatetool.com or services.google.com (proxy 403 / DNS), so claims about those sites come from web-search snippets. They are marked **[snippet-only]** where relevant.

Source files referenced (all under https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/):
- Sidebar-C4.js — https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js
- Sidebar-ArchiMate3.js — https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js
- Sidebar-ArchiMate4.js — https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate4.js
- Sidebar-GCP2.js / Sidebar-GCP3.js / Sidebar-GCPIcons.js — same folder
- Sidebar.js (library registry) — https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar.js

---

## 1. C4 model: official notation guidance and the draw.io C4 library

### Takeaway
C4 is deliberately notation-independent. It requires a title, a legend/key, explicit element types, descriptions and labelled unidirectional relationships, not specific colours or shapes. draw.io's `c4` library is a small template set (19 entries) that stores C4 metadata as object attributes (`c4Name`, `c4Type`, `c4Technology`, `c4Description`, `c4Application`) with `placeholders="1"`, using the familiar Structurizr-like blue palette. It has **no legend, deployment-node, dynamic-diagram or code-level shapes**.

### Cited Findings
**Official guidance (c4model.com, Simon Brown)**
- The C4 notation page asks that every diagram have a **key/legend** explaining the notation in use (shapes, colours, border styles, line types). It also asks for a **title stating diagram type and scope**, and says this applies to UML/ArchiMate/SysML too **[snippet-only]**. Sources: [c4model.com/diagrams/notation](https://c4model.com/diagrams/notation); [Wikipedia C4 model](https://en.wikipedia.org/wiki/C4_model)
- The legend should also cover **acronyms**, colours and line styles, even when the notation seems obvious to the author **[snippet-only]**. Source: [InfoQ – The C4 model for visualising software architecture](https://www.infoq.com/articles/c4-architecture-model/)
- The following c4model.com content was **not re-fetched in this session** (site unreachable). It is stated from the long-standing content of [c4model.com/diagrams](https://c4model.com/diagrams) and [c4model.com/diagrams/notation](https://c4model.com/diagrams/notation); verify before quoting verbatim:
  - Abstractions: Person, Software System, Container (an application or data store: a separately runnable/deployable unit), Component, plus Code.
  - Core diagrams: System Context, Container, Component, Code.
  - Supplementary diagrams: **System Landscape**, **Dynamic** (numbered interactions, collaboration- or sequence-style) and **Deployment** (deployment nodes, which can be nested, plus infrastructure nodes and container instances).
  - Notation checklist: each element should show its name, its **type** (e.g. "[Container: Java/Spring]"), technology where applicable, and a short description. Relationships should be **unidirectional** lines, each labelled with intent/description and, for containers, technology/protocol. Colour and shape are optional, but if used they must be explained in the key. Avoid unexplained acronyms. Boundaries (system/container/enterprise) are drawn as dashed groupings.
  - c4model.com also publishes a **diagram review checklist** (general / elements / relationships questions).

**draw.io C4 library (Sidebar-C4.js, v32.4.1)**
- Registered as library id `c4`, title "C4" (`addPaletteFunctions('c4', 'C4', ...)`). It is listed in "More shapes" as `{title: 'C4', id: 'c4'}`. Source: [Sidebar-C4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js), [Sidebar.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar.js)
- Entries, by search key (all prefixed `c4 `): person, external person, software system, external software system, container, data container, microservice container, message bus container, web browser container, mobile device app phone container, component, relationship description technology, relationship description, relationship, system scope boundary, container scope boundary, system context diagram title, container diagram title, component diagram title. Source: [Sidebar-C4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)
- Each vertex is an `<object>` (user object) with `placeholders="1"` and the attributes `c4Name`, `c4Type`, `c4Description` (plus `c4Technology` on containers, components and relationships, and `c4Application` on boundaries). The HTML label is a template, e.g. `<b>%c4Name%</b>…[%c4Type%]…%c4Description%` (containers: `[%c4Type%:&nbsp;%c4Technology%]`). All styles include `metaEdit=1`, and most vertices `resizable=0`. Source: same file
- `c4Type` values used: `Person`, `Software System`, `Container`, `Component`, `Relationship`, `SystemScopeBoundary`, `ContainerScopeBoundary`, `ContainerDiagramTitle`. Quirk: the "System Context diagram title" entry also uses `c4Type="ContainerScopeBoundary"`. `c4Application` holds `Software System` or `Container` on boundaries. Source: same file
- Exact vertex styles (verbatim):
  - Person: `html=1;fontSize=11;dashed=0;whiteSpace=wrap;fillColor=#083F75;strokeColor=#06315C;fontColor=#ffffff;shape=mxgraph.c4.person2;align=center;metaEdit=1;points=[[0.5,0,0],[1,0.5,0],[1,0.75,0],[0.75,1,0],[0.5,1,0],[0.25,1,0],[0,0.75,0],[0,0.5,0]];resizable=0;`
  - External person: the same with `fillColor=#6C6477;strokeColor=#4D4D4D`
  - Software System: `rounded=1;whiteSpace=wrap;html=1;labelBackgroundColor=none;fillColor=#1061B0;fontColor=#ffffff;align=center;arcSize=10;strokeColor=#0D5091;metaEdit=1;resizable=0;` + points
  - External Software System: `fillColor=#8C8496;…strokeColor=#736782`
  - Container: `rounded=1;whiteSpace=wrap;html=1;fontSize=11;labelBackgroundColor=none;fillColor=#23A2D9;fontColor=#ffffff;align=center;arcSize=10;strokeColor=#0E7DAD;metaEdit=1;resizable=0;`
  - Data container: `shape=cylinder3;size=15;…fillColor=#23A2D9;…strokeColor=#0E7DAD`. Message bus container: the same `cylinder3` with `direction=south`
  - Microservice container: `shape=hexagon;size=50;perimeter=hexagonPerimeter2;…fillColor=#23A2D9;…strokeColor=#0E7DAD`
  - Web browser container: `shape=mxgraph.c4.webBrowserContainer2;…fillColor=#23A2D9;strokeColor=#118ACD;strokeColor2=#0E7DAD`
  - Mobile container: `shape=mxgraph.c4.mobileDeviceContainer;…fillColor=#23A2D9;strokeColor=#118ACD;strokeColor2=#0E7DAD`
  - Component: `rounded=1;…fillColor=#63BEF2;fontColor=#ffffff;align=center;arcSize=6;strokeColor=#2086C9;metaEdit=1;resizable=0;`
  - Boundaries: `rounded=1;fontSize=11;whiteSpace=wrap;html=1;dashed=1;arcSize=20;fillColor=none;strokeColor=#666666;fontColor=#333333;labelBackgroundColor=none;align=left;verticalAlign=bottom;…dashPattern=8 4;metaEdit=1;…connectable=0;…absoluteArcSize=1;`
  - Titles: `text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=top;…`
  - Relationship edge (all 3 variants): `endArrow=blockThin;html=1;fontSize=10;fontColor=#404040;strokeWidth=1;endFill=1;strokeColor=#828282;elbow=vertical;metaEdit=1;endSize=14;startSize=14;jumpStyle=arc;jumpSize=16;rounded=0;edgeStyle=orthogonalEdgeStyle;` with `c4Type=Relationship`, `c4Description` and optional `c4Technology`.
  - Source: [Sidebar-C4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)
- The full fill palette is exactly the six colours #083F75 (person), #6C6477 (external person), #1061B0 (system), #8C8496 (external system), #23A2D9 (containers, 6 uses), #63BEF2 (component). Source: same file
- Recent history: Sidebar-C4.js changed in releases 30.2.7 (2026-06-30), 31.6.1 (2026-10-01) and 32.4.1 (2026-10-08). The mobile-device container entry was added in 2026. Source: [jgraph/drawio commit history](https://github.com/jgraph/drawio/commits/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)

### Inferences
- The library offers **no legend/key shape, no deployment node / infrastructure node shapes, no dynamic-diagram numbering helper and no System Landscape title**. A team that needs C4 conformance must add its own legend template and deployment-node style, e.g. as a custom library (.xml) or a `customLibraries` config.
- Because C4 metadata lives in attributes (`c4Type` etc.), a validator can check **semantics, not just look**: every vertex must have `c4Type` ∈ the allowed set, `c4Name` must be non-empty, containers and components must have a non-empty `c4Technology`, every edge must have `c4Type=Relationship` and a non-empty `c4Description`, and every page must have one title object and one legend group.
- The palette closely matches Structurizr's default C4 styling, which makes round-tripping with Structurizr exports visually consistent. The match is an inference; the Structurizr hex values were not verified here.

### Gaps
- The verbatim current text of c4model.com notation and review-checklist pages could not be fetched (site blocked). Re-verify wording before quoting. It is unknown whether c4model.com changed its notation guidance in 2025–2026.
- The `mxgraph.c4.*` stencil definitions (`person2`, `webBrowserContainer2`, `mobileDeviceContainer`) live in the shapes bundle. They were not inspected; only their names are confirmed.

---

## 2. ArchiMate 3.2: specification, colours, draw.io coverage, exchange format, Archi, and the C4 mapping

### Takeaway
draw.io's library `archimate3` (titled **"ArchiMate 3.2"**) covers the full 3.2 element catalogue, all 11 relationships and both junctions. Elements are encoded **only in the style string** (`shape=mxgraph.archimate3.*`, `appType=`, `archiType=`), with no model/repository, no relationship-validity rules and no viewpoints. Its default colours differ from Archi's widely used defaults. Since August 2026 draw.io also ships an **"ArchiMate 4"** library (`archimate4`, `mxgraph.archimate4.*`) reflecting the new Open Group ArchiMate 4 specification, while Archi (master, Oct 2026) still models ArchiMate 3.2.

### Cited Findings
**Specification**
- ArchiMate 3.x layers/aspects: Strategy, Business, Application, Technology (with Physical elements), Motivation, Implementation & Migration, plus composite elements (Grouping, Location) and relationships/junctions. The exact catalogue is confirmed by the draw.io and Archi element lists below. Source: [Sidebar-ArchiMate3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js); [Archi model package](https://github.com/archimatetool/archi/tree/master/com.archimatetool.model/src/com/archimatetool/model)
- The specification says colour conventions are **not a requirement of the standard**. Common practice is yellow for business, blue/turquoise for application, and green for technology/physical **[snippet-only]**. Source: [Visual Paradigm ArchiMate guide](https://archimate.visual-paradigm.com/?p=610)
- 3.1 → 3.2 changes (secondary sources; the official appendix was not fetchable). Sources: [Open Group – Changes from Version 2.1 to Version 3.2](https://digital-portfolio.opengroup.org/archimate-specs/latest/99-appendices/05-changes-v3.html); [Goode e-Learning – What's changed in ArchiMate 3.2](https://goodelearning.com/articles/whats-changed-in-archimate-3-2/); [Visual Paradigm – What's new in ArchiMate 3](https://guides.visual-paradigm.com/whats-new-in-archimate-3-enhancing-enterprise-architecture/)
  - An **optional layer letter** in the top-left corner of an element (M, S, B, A, T, P, I) **[snippet-only]**.
  - New icon notations, e.g. for Meaning, Communication Network and Work Package, plus alternative box notations for Value, Business Object, Contract, Representation and Work Package **[snippet-only]**.
  - Physical elements moved into the Technology Layer chapter. Devices, system software, facilities and equipment are described as technology internal active structure elements rather than kinds of Node **[snippet-only]**.
  - Corrections/clarifications to relationship tables and derivation rules **[snippet-only]**; the Facility→Material assignment restriction is cited by Visual Paradigm and is unverified.
  - No new element types were added in 3.2 (consistent with draw.io and Archi element lists). This is an inference.
- **ArchiMate 4**: The Open Group announced the final **ArchiMate 4 Specification**, described as focused on continuity and user-level compatibility **[snippet-only; announcement date not confirmed]**. Source: [The Open Group announcement](https://www.opengroup.org/The-Open-Group-Announces-ArchiMate%C2%AE-4-Specification)
  - Secondary sources say it removes **seven 3.2 concepts**: Business/Application/Technology Interaction, Contract, Constraint, Gap and Representation. They also say Composition is removed from the core relationship set in favour of Aggregation, and relationship multiplicity is added. Sources: [Alfabet – ArchiMate 4 changes](https://alfabet.com/blog/archimate-4-changes); [Visual Paradigm – ArchiMate 4](https://archimate.visual-paradigm.com/archimate-next-a-new-era-in-enterprise-architecture-modeling/). An earlier "Snapshot 1" (mid-2025) was a non-normative draft.
  - **Conflict:** draw.io's ArchiMate 4 palette still contains a "Composition" relationship (see below). Composition's status in the final spec is therefore unconfirmed.

**Standard/default colours**
- **Archi defaults** (from `AbstractArchimateElementUIProvider.java`, verbatim RGB): Business `new Color(255, 255, 181)` = **#FFFFB5**; Application `181, 255, 255` = **#B5FFFF**; Technology and Physical `201, 231, 183` = **#C9E7B7**; Motivation `204, 204, 255` = **#CCCCFF**; Strategy `245, 222, 170` = **#F5DEAA**; Implementation & Migration (incl. Plateau, Gap) `255, 224, 224` = **#FFE0E0**; Location `237, 207, 226` = **#EDCFE2**; Grouping `255,255,255`. Element→colour assignment: Business = BusinessActor…Product, Contract, Representation; Application = ApplicationComponent…DataObject; Technology = Node, Device, SystemSoftware, Tech*, Path, CommunicationNetwork, Artifact, Equipment, Facility, DistributionNetwork, Material; Motivation = Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, Constraint, Meaning, Value; Strategy = Resource, Capability, ValueStream, CourseOfAction; I&M = WorkPackage, Deliverable, ImplementationEvent, Plateau, Gap. Source: [archi/AbstractArchimateElementUIProvider.java](https://github.com/archimatetool/archi/blob/master/com.archimatetool.editor/src/com/archimatetool/editor/ui/factory/elements/AbstractArchimateElementUIProvider.java), [LocationUIProvider.java](https://github.com/archimatetool/archi/blob/master/com.archimatetool.editor/src/com/archimatetool/editor/ui/factory/elements/LocationUIProvider.java)
- **draw.io archimate3 defaults** (verbatim from the palette prefixes). Each prefix is `html=1;outlineConnect=0;whiteSpace=wrap;fillColor=<X>;shape=mxgraph.archimate3.` with X as follows:
  - Generic `#EBEBEB`
  - Application `#99ffff`
  - Business `#ffff99`
  - Motivation `#CCCCFF`
  - Strategy `#F5DEAA`
  - Technology/Physical `#AFFFAF`
  - Implementation & Migration `#FFE0E0` (a second prefix uses `#E0FFE0`)
  - Location `#efd1e4`
  - Source: [Sidebar-ArchiMate3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js)
- **draw.io archimate4 defaults** (new palette, verbatim). Prefix `…shape=mxgraph.archimate4.` with:
  - Common `#E5DFD3`
  - Motivation `#D1BADC`
  - Strategy `#EFBD5D`
  - Business `#EDD779`
  - Application `#B0D0D9`
  - Technology `#BCD9AE`
  - Implementation & Migration `#F1BBB7`
  - Source: [Sidebar-ArchiMate4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate4.js). Whether these match colours recommended in the ArchiMate 4 spec is unverified.

**draw.io ArchiMate 3.2 library (`archimate3`)**
- Sidebar file header: "Adds ArchiMate v3.2 shapes". Registered sub-libraries: Application, Business, Generic, Implementation and Migration, Motivation, Relationships, Strategy, Technology. The "More shapes" entry is titled **"ArchiMate 3.2"** (id `archimate3`) next to **"ArchiMate 4"** (id `archimate4`). The legacy `archimate` (2.x) library still exists. Sources: [Sidebar-ArchiMate3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js), [Sidebar.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar.js)
- Element encoding:
  - **Box form**: `shape=mxgraph.archimate3.application;appType=<type>;archiType=<square|rounded|oct>;`, where `square` = structure, `rounded` = behaviour, `oct` = motivation (cut corners).
  - **Icon form**: `shape=mxgraph.archimate3.<icon>` (e.g. `process`, `function`, `interaction`, `event`, `service`, `interface`, `collaboration`, `businessObject`, `contract`, `representation`, `product`, `workPackage`, `deliverable`, `plateau`, `gapIcon`, `equipment`, `facility`, `distribution`, `material`, `locationIcon`, `grouping`).
  - Source: same file
- `appType` values found (full list): actor, amValue, artifact, assess, capability, collab, comp, constraint, contract, course, deliverable, device, distribution, driver, equipment, event, facility, func, gap, generic, goal, grouping, interaction, interface, location, material, meaning, netw, node, outcome, passive, path, plateau, principle, proc, product, representation, requirement, resource, role, serv, sysSw, valueStream, workPackage. Source: same file
- Entry names cover every 3.2 element. Examples: Business Actor/Role/Collaboration/Interface/Process/Function/Interaction/Event/Service/Object, Contract, Representation, Product; Application Component/…/Data Object; Node, Device, System Software, Technology Collaboration/Interface/Function/Process/Interaction/Event/Service, Path, Communication Network, Artifact; Equipment, Facility, Distribution Network, Material; Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, Constraint, Meaning, Value; Resource, Capability, Value Stream, Course of Action; Work Package, Deliverable, Implementation Event, Plateau, Gap; Grouping, Location; generic elements. Source: same file
- Relationship styles (verbatim, as in the palette):
  - Composition: `html=1;startArrow=diamondThin;startFill=1;edgeStyle=elbowEdgeStyle;elbow=vertical;startSize=10;endArrow=none;endFill=0;`
  - Aggregation: `html=1;startArrow=diamondThin;startFill=0;edgeStyle=elbowEdgeStyle;elbow=vertical;startSize=10;endArrow=none;endFill=0;`
  - Assignment: `endArrow=block;html=1;endFill=1;startArrow=oval;startFill=1;edgeStyle=elbowEdgeStyle;elbow=vertical;`
  - Realization: `edgeStyle=elbowEdgeStyle;html=1;endArrow=block;elbow=vertical;endFill=0;dashed=1;`
  - Serving: `edgeStyle=elbowEdgeStyle;html=1;endArrow=open;elbow=vertical;endFill=1;`
  - Access (3 variants): `edgeStyle=elbowEdgeStyle;html=1;endArrow=none;elbow=vertical;dashed=1;startFill=0;dashPattern=1 4;` / `…endArrow=open;elbow=vertical;endFill=0;dashed=1;startArrow=open;startFill=0;dashPattern=1 4;` / `…endArrow=open;elbow=vertical;endFill=0;dashed=1;dashPattern=1 4;`
  - Influence: `edgeStyle=elbowEdgeStyle;html=1;endArrow=open;elbow=vertical;endFill=0;dashed=1;dashPattern=6 4;`
  - Association: `edgeStyle=elbowEdgeStyle;html=1;endArrow=none;elbow=vertical;` (directed: `…endArrow=openAsync;elbow=vertical;rounded=0;endFill=0;`)
  - Triggering: `edgeStyle=elbowEdgeStyle;html=1;endArrow=block;dashed=0;elbow=vertical;endFill=1;`
  - Flow: `edgeStyle=elbowEdgeStyle;html=1;endArrow=block;dashed=1;elbow=vertical;endFill=1;dashPattern=6 4;`
  - Specialization: `endArrow=block;html=1;endFill=0;edgeStyle=elbowEdgeStyle;elbow=vertical;`
  - Junctions: And `ellipse;html=1;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;fillColor=strokeColor`; Or `…fillColor=#ffffff`
  - Source: same file
- History: Sidebar-ArchiMate3.js last changed in 30.0.1 (2026-05-11) and 28.2.0 (2025-09-05). Sidebar-ArchiMate4.js was added in **31.1.8 (2026-08-07)**, with shapes in `shapes/mxArchiMate4.js`. The stencil registry loads `mxArchiMate3.js` + `mxArchiMate4.js` for `archimate4`. Source: [jgraph/drawio repo](https://github.com/jgraph/drawio/tree/dev/src/main/webapp)
- draw.io's ArchiMate 4 palette sections are Common, Relationships and Junctions, Motivation, Strategy, Business, Application, Technology, Implementation and Migration. Entries **do not include** Interaction elements, Contract, Representation, Constraint, Gap, Implementation Event or Influence. They **do include** Composition, Aggregation, Assignment, Realization, Serving, Access, Flow, Triggering, Specialization, Association and And/Or Junction. Box form uses `shape=mxgraph.archimate4.element`. Source: [Sidebar-ArchiMate4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate4.js)

**Exchange format and Archi tooling**
- Archi implements the Open Group **ArchiMate Model Exchange File Format** in bundle `org.opengroup.archimate.xmlexchange`, with XSDs `archimate3_Model.xsd`, `archimate3_View.xsd`, `archimate3_Diagram.xsd` (+ `dc.xsd`, `xml.xsd`). Namespace `http://www.opengroup.org/xsd/archimate/3.0/`; schemaLocation `http://www.opengroup.org/xsd/archimate/3.1/archimate3_Diagram.xsd`. Source: [archi/IXMLExchangeGlobals.java](https://github.com/archimatetool/archi/blob/master/org.opengroup.archimate.xmlexchange/src/org/opengroup/archimate/xmlexchange/IXMLExchangeGlobals.java)
- Archi master (Oct 2026, v5.10.0) still includes `IBusinessInteraction`, `IContract`, `IConstraint`, `IGap` etc. In other words it still models **ArchiMate 3.2**, not 4. archimatetool.com states Archi supports the ArchiMate 3.2 language. Sources: [archi model package](https://github.com/archimatetool/archi/tree/master/com.archimatetool.model/src/com/archimatetool/model); [archimatetool.com](https://archimatetool.com/)
- Archi bundles: CSV import/export (`com.archimatetool.csv`), Open Exchange XML, Jasper/HTML reports, SVG export, command-line variants. **No draw.io import/export exists in Archi or its official plug-ins** (jArchi = JavaScript scripting, coArchi = Git-based collaboration). Sources: [archi repo](https://github.com/archimatetool/archi); [Archi Plug-ins](https://www.archimatetool.com/?p=918)
- Practical bridges, which must be built: jArchi scripts can read the model/views and write any text (e.g. mxGraph XML). Alternatively, convert Open Exchange XML ↔ .drawio with a custom script. No published, maintained converter was found. Source: [Archi Plug-ins](https://www.archimatetool.com/?p=918) (jArchi capability); search found none.

**C4 ↔ ArchiMate mapping (community, not normative)**
- No official Open Group C4↔ArchiMate mapping was found.
- Common practitioner mapping: Person → Business Actor; Software System and Container → Application Component (Container often specialised, e.g. data store → Data Object/Artifact or System Software); Component → Application Component (nested) or Application Function. Each C4 diagram type can be treated as a viewpoint. Sources: [DEV – Agile software architecture using ArchiMate and the C4 model](https://dev.to/jbrocher/agile-software-architecture-using-archimate-and-the-c4-model-54f4); [Archi blog on C4](https://www.archimatetool.com/?p=2015); [MooD and the C4 model](https://supportportal.moodinternational.com/hc/en-us/articles/360015465100-MooD-and-the-C4-model)
- C4's level-based view selection has no direct ArchiMate equivalent. Source: [CaseTalk ticket](https://casetalk.com/tickets/view.php?id=5838)

### Inferences
- **Coverage verdict:** draw.io `archimate3` is complete for the 3.2 element and relationship catalogue. The gaps are semantic. There is no element-type attribute: the type must be derived from `shape` + `appType` + `archiType`. There is no layer letter notation, no viewpoint filtering, no relationship-validity table (Appendix B), and no derivation. Draw.io colours (#ffff99/#99ffff/#AFFFAF) differ from Archi's (#FFFFB5/#B5FFFF/#C9E7B7). Teams should pick one palette and enforce it.
- Relationship types in draw.io are recognisable only by **arrow signature** (endArrow/startArrow/endFill/dashed/dashPattern). A validator must classify edges by that signature, e.g. Flow vs Triggering differ only in `dashed=1;dashPattern=6 4`. Influence vs Access differ by `dashPattern=6 4` vs `1 4`.
- For 2026 decisions: the "ArchiMate 3.2" library suits Archi round-trip (Archi = 3.2). The "ArchiMate 4" library suits new models only if tooling (Archi) catches up. Mixing `mxgraph.archimate3.*` and `mxgraph.archimate4.*` in one file should be flagged.

### Gaps
- The official 3.1→3.2 change appendix text and the ArchiMate 4 publication date/final relationship set could not be fetched; the Composition conflict is unresolved.
- The official spec's illustrative colour scheme for 3.2 (if any) and 4 is not verified.
- No authoritative Open Group C4 mapping exists or was found.

---

## 3. Google Cloud icons: official set and draw.io libraries

### Takeaway
Google replaced its icon system in **early 2025**. It moved from more than 250 unique icons to about 40: unique **core product** icons (4-colour) plus 2-colour **product category** icons shared across many products. draw.io added a matching library **"Google Cloud Platform 2026"** (`gcp3`, `shape=mxgraph.gcp3.*`) in May 2026 with 19 core products + 26 categories. The older `gcp2` and `gcpicons` libraries still exist and are the only place with per-product icons for Pub/Sub, Memorystore, Cloud Armor, IAP, Dataflow and Data Fusion.

### Cited Findings
- cloud.google.com/icons (fetched 2026-10-15): "in early 2025, we updated our product iconography. This collection includes new icons for both our core products and general product categories. Please review the Product icons overview document…". Downloads:
  - Product icons overview PDF: https://services.google.com/fh/files/misc/google-cloud-product-icons.pdf
  - Category icons ZIP (SVG+PNG): https://services.google.com/fh/files/misc/category-icons.zip
  - Core product icons ZIP: https://services.google.com/fh/files/misc/core-products-icons.zip
  - Legacy console icons ZIP: https://services.google.com/fh/files/misc/google-cloud-legacy-icons.zip
  - Source: [Google Cloud product icons](https://cloud.google.com/icons)
- The overview PDF (updated Sept 2025) describes: the icon set cut from 250+ unique icons to ~40; two formats, 4-colour unique core-product icons and 2-colour category icons; "the same category icon will be used for multiple products across our Google Cloud portfolio" **[snippet-only]**. Source: [google-cloud-product-icons.pdf](https://services.google.com/fh/files/misc/google-cloud-product-icons.pdf)
- Licensing/usage: "Products logos contained in this icon library may be used freely and without permission to accurately reference Google's technology and tools, for instance in books or architecture diagrams" (Google icon slide deck) **[snippet-only]**. Source: [Google Cloud product icons](https://cloud.google.com/icons). Third-party repackagings list the older set as Apache-2.0 (unverified): [allsvgicons](https://allsvgicons.com/pack/gcp/)
- **draw.io `gcp3` ("Google Cloud Platform 2026")**:
  - Sub-libraries are "Categories" and "Core Products". It was added in 30.0.4 (2026-05-27) and last changed 2026-10-03.
  - Style prefix (verbatim): `sketch=0;html=1;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fontSize=11;fontStyle=0;fontColor=#000000;aspect=fixed;pointerEvents=1;shape=mxgraph.gcp3.<name>;fillColor=<…>`
  - **Core products** (`fillColor=#4285f4`): aihypercomputer, alloydb, anthos, apigee, bigquery, cloudrun, cloudspanner (label "Spanner"), cloudsql, cloud_storage, computeengine, distributedcloud, gke, hyperdisk, looker, mandiant, securitycommandcenter, secops, threatintelligence, vertexai.
  - **Categories** (`fillColor=#9aa0a6`): agents, aimachinelearning, businessintelligence, collaboration, compute, containers, dataanalytics, databases, developer_tools, devops, hybridmulticloud, integrationservices, managementtools, mapsgeospatial, marketplace, mediaservices, migration, mixedreality, networking, observability, operations, securityidentity, serverlesscomputing, storage, webmobile, web3.
  - Sources: [Sidebar-GCP3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-GCP3.js), [Sidebar.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar.js) (`{title: 'Google Cloud Platform 2026', id: 'gcp3'}`)
- **draw.io `gcp2` ("Google Cloud Platform")**:
  - Sub-libraries: Paths, Zones, Service Cards, User Device Cards, Compute, API Management, Security, Data Analytics, Data Transfer, Cloud AI, Internet of Things, Databases, Storage, Management Tools, Networking, Developer Tools, Expanded Product Cards, Product Cards, General Icons, and "Icons …" sets (AI and ML, Compute, Serverless, Data Analytics, Operations, Networking, CI CD, Integration Services, API Management, IoT, Databases, Storage, Security, Migration, Hybrid and Multi Cloud, Open Source).
  - Most icons are **embedded SVG images** (`shape=image;…image=data:image/svg+xml,…`), not named stencils. Only ~10 `mxgraph.gcp2.*` stencil names are used (zones, hexIcon, doubleRect, google_cloud_platform, external_data_center, …).
  - Labels present include Cloud Run, Apigee API Platform/Management, Pub/Sub (Cloud Pub/Sub), Cloud SQL, AlloyDB, Identity-Aware Proxy, Vertex AI.
  - Changed in 30.0.4, 30.2.4 and 32.4.1 (2026).
  - Alias: `gcp` → `gcp2` (`libAliases`).
  - Source: [Sidebar-GCP2.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-GCP2.js)
- **gcp2 "Zones"** (old Google diagramming convention), verbatim fills:
  - user `#ffffff`
  - Infrastructure System `#F3E5F5`
  - colo / dc / on-premises `#EFEBE9`
  - system `#F1F8E9`
  - External SaaS Providers `#FFEBEE`
  - External Data Sources `#FFF8E1`
  - `#E0F2F1`
  - Project Zone / Cloud Service Provider `#E1F5FE`
  - Title bar `#4DA1F5`
  - Project Zone `#F6F6F6`
  - Markers / legend markers (`strokeColor=#BDBDBD`)
  - Product cards use `fillColor=#3B8DF1` hex icons and grey text (`fontColor=#999999` / `#757575`).
  - Source: same file
- **draw.io `gcpicons` ("GCP Icons")**: Embedded-SVG product icons with prefix `editableCssRules=.*;html=1;shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=data:image/svg+xml,`. Includes Cloud Run, Cloud SQL, MemoryStore, Cloud Storage, Cloud Load Balancing, CloudArmor, Cloud Dataflow, Cloud Data Fusion, Cloud Spanner, BigQuery, Kubernetes Engine, Apigee API Platform. Last changed 30.0.2 (2026-05-16). Source: [Sidebar-GCPIcons.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-GCPIcons.js)
- draw.io claims its GCP library "always contains the most recent version of the icons" **[snippet-only]**. Its March 2022 post updated GCP network/cloud libraries. Sources: [drawio blog – Updated shapes for GCP and AWS](https://www.drawio.com/blog/gcp-aws-shapes-network-diagrams); [drawio blog – More cloud shapes](https://www2.drawio.com/blog/more-cloud-shapes)
- Google diagramming tools: Google offers an online Architecture Diagramming Tool (community thread) **[snippet-only]**. Source: [Google Developer forums – Google Cloud Architecture Diagramming Tools](https://discuss.google.dev/t/google-cloud-architecture-diagramming-tools/164977)

### Inferences
- Required products map as follows under the **2025 Google system**:
  - Cloud Run, Apigee, Cloud SQL, Cloud Storage (GCS), BigQuery, GKE, AlloyDB, Spanner, Vertex AI: own core icon (`mxgraph.gcp3.cloudrun`, `.apigee`, `.cloudsql`, `.cloud_storage`, …).
  - Pub/Sub, Dataflow, Data Fusion: no core icon. Use the category icon (`integrationservices` / `dataanalytics`) plus a text label.
  - Memorystore: `databases`.
  - Cloud Load Balancing: `networking`.
  - Cloud Armor, IAP: `securityidentity`.
  - Teams wanting distinct per-product glyphs must use the **legacy** `gcp2`/`gcpicons` icons, which predate the 2025 refresh and mix old styles. That mapping follows Google's "category icon shared across products" rule. It is an inference, not a published Google mapping table.
- The gcp3 core-product stencils carry a single `fillColor=#4285f4`. This suggests draw.io renders them as recolourable monochrome stencils rather than Google's 4-colour artwork. **Unverified**: the stencil XML for `mxgraph.gcp3` was not inspected.
- draw.io has **no 2025-style boundary/zone shapes** (project, region, zone, VPC) in gcp3. The boundary conventions available are the older gcp2 "Zones". A team convention must define region/zone/project/VPC containers (e.g. dashed rounded rectangles with fixed fills).
- For validation, gcp2/gcpicons are hard to whitelist by name because the icon is an inline SVG data URI. You need to whitelist by a **hash of the `image=` value** or by the cell's tooltip/label. gcp3 is easy: `shape=mxgraph.gcp3.<name>`.

### Gaps
- The overview PDF and icon ZIPs could not be downloaded (proxy 403). The official hex colour spec for category vs core icons, the exact core-product list in Google's ZIP, and any 2026 additions are not verified against draw.io's 19 entries.
- Google Architecture Center diagram conventions (product cards, region/zone/project boundaries) for the post-2025 style were not found in an authoritative source.
- The full licence text for the 2025 icon ZIPs was not retrieved.

---

## 4. AWS / Azure (brief comparison)

### Takeaway
draw.io's AWS and Azure libraries are maintained alongside the GCP ones. AWS has the `aws4` and `aws4b` libraries (current AWS Architecture Icons, with group shapes). Azure has `azure2` (31 categories). Both use named stencils/images that can be whitelisted the same way.

### Cited Findings
- The registry lists `aws4` (Arrows, General Resources, Illustrations, Groups, Analytics, Application Integration, AI, …), `aws4b` (… Groups Light / Groups Dark …), `azure2` (AI Machine Learning … Web) and legacy `aws3`, `azure`. Sidebar-AWS4.js and Sidebar-Azure2.js were updated 2026-10-03. Source: [Sidebar.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar.js)
- A December 2024 draw.io post updated the main AWS and Azure shape libraries **[snippet-only]**. Source: [drawio blog](https://www.drawio.com/blog/gcp-aws-shapes-network-diagrams)

### Inferences
- AWS publishes formal group/boundary icons (AWS Cloud, Region, VPC, subnet) that draw.io mirrors in "Groups". GCP's 2025 system lacks an equivalent in draw.io gcp3, so GCP needs more in-house convention.

### Gaps
- Not researched in depth (out of scope).

---

## 5. Automatic validation of a .drawio file against a notation whitelist

### Takeaway
Validation is straightforward because every notation's identity lives in each `mxCell`'s `style` string, and for C4 also in `<object>` attributes. Decode the file, iterate cells, parse `style` into key/value pairs, then check `shape` (and `appType`/`archiType` for ArchiMate), allowed `fillColor`/`strokeColor`, edge arrow signatures, and required metadata.

### Cited Findings
- Style vocabulary to whitelist (all verbatim from draw.io source):
  - **C4**: `shape` ∈ {`mxgraph.c4.person2`, `mxgraph.c4.webBrowserContainer2`, `mxgraph.c4.mobileDeviceContainer`, `cylinder3`, `hexagon`}, or no `shape` with `rounded=1`. `fillColor` ∈ {#083F75, #6C6477, #1061B0, #8C8496, #23A2D9, #63BEF2, none}. Edge `endArrow=blockThin;strokeColor=#828282`. Attributes `c4Type`, `c4Name`, `c4Technology`, `c4Description`. Source: [Sidebar-C4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)
  - **ArchiMate 3.2**: `shape` prefix `mxgraph.archimate3.`; `appType` (list in §2); `archiType` ∈ {square, rounded, oct}; layer fills as in §2; junctions `ellipse`. Source: [Sidebar-ArchiMate3.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate3.js)
  - **ArchiMate 4**: prefix `mxgraph.archimate4.` (`element`, `grouping`, icon names). Source: [Sidebar-ArchiMate4.js](https://github.com/jgraph/drawio/blob/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-ArchiMate4.js)
  - **GCP**: `mxgraph.gcp3.*` (45 names listed in §3); `mxgraph.gcp2.*`; `shape=image` with `image=data:image/svg+xml,…` for gcp2/gcpicons. Sources: Sidebar-GCP3.js / Sidebar-GCP2.js / Sidebar-GCPIcons.js (links above)

### Inferences (recommended validator design)
1. **Decode**: a `.drawio` is `<mxfile><diagram>`. Diagram content is either plain `<mxGraphModel>` or compressed (base64 → raw inflate → URL-decode). Handle both. This is general draw.io knowledge, not re-verified in this session.
2. **Walk** `mxCell` elements, including those wrapped in `<object>`/`<UserObject>` whose attributes hold `label`, `c4*` and `placeholders`. Skip id 0/1 root cells.
3. **Parse style**: split on `;`. The first token without `=` is a base style name (e.g. `text`, `ellipse`, `shape=…`). Normalise case for colours.
4. **Classify notation per cell** by prefix: `mxgraph.c4.` or `c4Type` attribute → C4; `mxgraph.archimate3.` → AM3.2; `mxgraph.archimate4.` → AM4; `mxgraph.gcp3.` / `mxgraph.gcp2.` / gcp image → GCP; `mxgraph.aws4.` / `mxgraph.azure*` → other cloud. Anything else is "free shape". Allow it only for whitelisted helpers (text, legend, boundary) per the page's declared notation, e.g. a page-level `notation=c4` attribute on `<diagram>` or the root cell.
5. **Rules per notation**:
   - C4: `c4Type` required and in the allowed set; `fillColor` in the palette; edges must carry `c4Description` (+ `c4Technology` for container/component level); one title and one legend per page; no bidirectional arrows (`startArrow` must be none).
   - ArchiMate: derive the element type from `shape`/`appType`/`archiType`; check `fillColor` against the chosen palette (Archi or draw.io; pick one); classify edges by arrow signature into the 11 relationship types; optionally check the source/target pair against the ArchiMate relationship table (would require embedding Appendix B); forbid mixing archimate3 and archimate4 shapes.
   - GCP: whitelist `mxgraph.gcp3.*` names (or approved gcp2 image hashes); require a text label on category icons (since categories are shared across products); require boundary containers for project/region from the team's own style.
6. **Report** cell id, page, offending key/value and rule. Run it in CI (pre-commit/GitHub Action) and/or from the draw.io MCP before saving.
- Implementation note: no off-the-shelf "draw.io notation linter" for C4/ArchiMate/GCP was found during this research. Treat that as a gap (absence not exhaustively verified).

### Gaps
- No published, maintained validator for draw.io notation conformance was found.
- The exact compressed-diagram encoding was not re-verified against current draw.io docs in this session.
