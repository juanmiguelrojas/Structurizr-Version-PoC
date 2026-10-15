# Interoperability: Structurizr ↔ draw.io ↔ ArchiMate for an Architecture-as-Code pipeline (as of Oct 2026)

> Method note: docs.structurizr.com, likec4.dev and patreon.com could not be fetched directly from this research environment (DNS/proxy refusals), so facts about them come from search-result summaries of those pages and are marked as such. GitHub metadata comes from the GitHub search API. Its `updated_at` field changes on any repo activity, including stars, so it is not the same as the last commit date. Dates below are "last activity (updated_at)" unless they say "pushed_at".

## (a) Generating .drawio from a Structurizr model: Structurizr export formats today, and the community and indirect routes

### Takeaway
Structurizr has **no official draw.io exporter**. The official exporters cover PlantUML (Structurizr and C4-PlantUML flavours), Mermaid, DOT, WebSequenceDiagrams, Ilograph, JSON and a static site. To get .drawio you have three options: (1) write your own generator from workspace JSON with a draw.io XML library, (2) go through an intermediate format (C4-PlantUML → puml2drawio, or Mermaid → draw.io's native Mermaid import), or (3) switch modelling tool. LikeC4 has a first-class `likec4 export drawio` and `likec4 import drawio`.

### Cited Findings
**Official Structurizr export**
- CLI `export -format` options: PlantUML (Structurizr style and C4-PlantUML style), Mermaid, WebSequenceDiagrams, DOT and Ilograph. The docs warn that "the export formats do not support all available shapes/features when compared to the Structurizr cloud service/on-premises installation/Lite". WebSequenceDiagrams exports only dynamic views. Ilograph exports the whole workspace as YAML. Mermaid output needs `securityLevel: loose`. — [Structurizr CLI export docs (via search summary)](https://docs.structurizr.com/cli/export); [Structurizr exporters](https://docs.structurizr.com/exporters)
- The exporters live in the open-source `structurizr-export` library, which the CLI uses and which is on Maven Central. — [Structurizr exporters](https://docs.structurizr.com/export); Simon Brown: "The Structurizr JSON/DSL -> PlantUML, C4-PlantUML, Mermaid, WebSequenceDiagrams, DOT, and Ilograph exporters are all free and open source" — [X post](https://x.com/simonbrown/status/1386995903211446275?lang=en)
- More recent comparison posts (2025–2026) describe current tooling as exporting "to PlantUML, Mermaid or a static HTML site". — [jeffbailey.us, 2026-09-20](https://jeffbailey.us/blog/2026/09/20/structurizr-vs-mermaid-vs-plantuml/); [paval.io, 2025-05-11](https://paval.io/posts/2025-05-11-structurizr-vs-likec4/)
- PNG/SVG come only from the browser UI (Lite, on-premises or cloud). Automating them needs a headless browser such as Puppeteer. The official `structurizr/puppeteer` example scripts repo is **archived** (41★). — [Structurizr UI diagram export](https://docs.structurizr.com/ui/diagrams/export); [github.com/structurizr/puppeteer](https://github.com/structurizr/puppeteer)
- Third-party comparison of Structurizr export capabilities: PNG, JSON, REST API, PlantUML, Mermaid. ArchiMate and draw.io are not listed. — [IcePanel vs Structurizr](https://icepanel.io/blog/icepanel-vs-structurizr)

**Structurizr "vNext" (consolidated tool)**
- The vNext announcement folds CLI, Lite and on-premises into one tool and one repo, `github.com/structurizr/structurizr`, compatible with existing data storage, on Spring Boot with embedded Tomcat. — [Patreon "Introducing Structurizr vNext" (via search summary; post dated "January 2", year not shown)](https://www.patreon.com/posts/146923136)
- The standalone `structurizr/cli` repo says it "is currently being deprecated in favor of new consolidated tooling … no longer receiving updates". — [Structurizr CLI docs index (search snapshot)](https://docsearch.algolia.com/mcp/docs/repo/structurizr/cli)
- `structurizr/structurizr` has modules `structurizr-dsl`, `structurizr-export`, `structurizr-import`, `structurizr-json`, `structurizr-autolayout`, `structurizr-mcp` and `structurizr-themes`, plus `structurizr.sh` and `mcp.sh`. Repo topics include `ai` and `mcp-server`. License Apache-2.0. About 466★, 68 forks, 468 commits. The README does not mention draw.io. — [github.com/structurizr/structurizr](https://github.com/structurizr/structurizr)
- There is a separate Patreon post about "PlantUML exporters and dark mode", so the exporters are still maintained. — [Patreon](https://www.patreon.com/posts/plantuml-and-140095618)

**Community exporters and converters (Structurizr → other formats)**
- `goto1134/structurizr-d2-exporter`: Structurizr views to D2. 22★, active (updated 2026-07-24). — [GitHub](https://github.com/goto1134/structurizr-d2-exporter)
- `cloudflightio/structurizr-export-c4plantuml`: **archived** (last update 2024-06-27). — [GitHub](https://github.com/cloudflightio/structurizr-export-c4plantuml)
- `AndriyKalashnykov/puml2drawio`: "Editable draw.io diagrams from PlantUML C4 & sequence diagrams, automated in CI". Accepts file, directory, glob or stdin input, ships a multi-arch GHCR image and a reusable GitHub Action. Created 2026-04-16, updated 2026-10-15, 0★. **Very new and unproven.** — [GitHub](https://github.com/AndriyKalashnykov/puml2drawio)
- `localgod/catalyst`: converts PlantUML C4 diagrams to draw.io C4 diagrams. — [GitHub](https://github.com/localgod/catalyst)
- Other tools that mention Structurizr plus draw.io are Claude/agent skills and plugins rather than converters, for example `sinxy-sai/software-diagrams` (created 2026-10, 0★, MIT) and `alexcristea/c4-plugin` (Structurizr DSL scaffolding plus multi-format export). — [software-diagrams](https://github.com/sinxy-sai/software-diagrams); [c4-plugin](https://github.com/alexcristea/c4-plugin)
- `sergey-chekriy/c4c`: a local-first Structurizr DSL compiler in Rust that exports diagrams. 0★, created 2026-06. — [GitHub](https://github.com/sergey-chekriy/c4c)

**draw.io native import of diagram-as-code**
- Mermaid: Arrange > Insert > Mermaid converts by default to **native draw.io shapes**, auto-laid-out inside a Mermaid container group that keeps the source for re-editing. Choosing "Image" keeps an SVG instead. — [draw.io: insert Mermaid](https://www.drawio.com/docs/manual/insert/insert-mermaid/); [Mermaid updates](https://www.drawio.com/blog/mermaid-updates/)
- PlantUML: Arrange > Insert > Advanced > PlantUML. draw.io warned that PlantUML support in the online editor would be **phased out by end of 2025**, and it was never available in desktop because it needs the server. draw.io recommends migrating PlantUML to Mermaid. — [draw.io: Insert PlantUML](https://www.drawio.com/docs/manual/insert/insert_plantuml/); [Migrate PlantUML to Mermaid and draw.io](https://www.drawio.com/blog/plantuml-to-mermaid)

**LikeC4 (alternative model-as-code tool)**
- `likec4 export drawio -o ./diagrams` writes one .drawio file per view by default. `--all-in-one` merges all views into one multi-tab file. `--profile leanix` adds LeanIX metadata. LikeC4 positions itself as the source of truth and draw.io as an interchange format. — [LikeC4 Draw.io integration (via search summary)](https://likec4.dev/tooling/drawio/); [npm likec4](https://www.npmjs.com/package/likec4)
- Repo `likec4/likec4`: TypeScript, about 5.9k★, 401 forks, very active (updated 2026-10-15). — [GitHub](https://github.com/likec4/likec4)

**IcePanel and Ilograph**
- IcePanel imports model objects from Structurizr, Backstage and its REST API. It exports SVG, PNG, PDF, JSON, CSV, Markdown, HTML, LLMs.txt, Structurizr and REST API. No draw.io or ArchiMate export was found. — [IcePanel vs Structurizr](https://icepanel.io/blog/icepanel-vs-structurizr); [IcePanel vs Visio](https://icepanel.io/blog/comparison-icepanel-vs-visio); [IcePanel export docs](https://docs.icepanel.io/core-features/export)

### Inferences
- The most controllable way to produce .drawio from Structurizr is a **custom generator from workspace JSON**. The JSON already holds element/relationship ids, tags, properties and, if you saved layouts, x/y coordinates. Write the XML with drawpyo, N2G or raw mxGraph XML and put the Structurizr ids into the cell attributes.
- Structurizr → Mermaid (official exporter) → draw.io's Mermaid import is zero-code but loses C4 styling and Structurizr ids, and it needs the draw.io UI or a headless browser. Treat it as a one-off migration route, not something to put in a pipeline.
- Structurizr → C4-PlantUML → puml2drawio can run in CI but depends on a 0-star project created in 2026. It needs piloting before you rely on it.
- If draw.io output is a hard requirement and switching modelling tool is acceptable, LikeC4 is the only mature tool found with a built-in bidirectional draw.io bridge.

### Gaps
- I could not fetch docs.structurizr.com directly, so I could not confirm the exact current `-format` list in vNext (for example whether `static`, `json`, `theme` or `ilograph` are still CLI formats) or the vNext command names.
- I could not confirm the vNext release date. The Patreon post has no year in the snippet; the repo's existence and the CLI deprecation notice suggest late 2025 or early 2026.
- I could not confirm what `structurizr-import` imports. I found no evidence that it handles draw.io.
- Searches found no Structurizr → draw.io exporter of any maturity.

## (b) Importing .drawio into Structurizr

### Takeaway
Structurizr has no official draw.io importer. Three very young (2026, 0★) community projects convert draw.io C4 diagrams to Structurizr DSL. LikeC4 offers `likec4 import drawio`. Treat draw.io → model conversion as a heuristic one-off migration, not a sync mechanism.

### Cited Findings
- `veritas-sovereign/drawio-structurizr`: "Validate draw.io C4 diagrams and convert them to Structurizr DSL and Excel". Python, MIT, created 2026-10-05, pushed_at 2026-10-12, 0★. — [GitHub](https://github.com/veritas-sovereign/drawio-structurizr)
- `miguesj-hub/drawio-to-structurizr`: a Claude Code plugin that converts draw.io C4 diagrams into Structurizr DSL. It "recovers connector labels, infers unattached endpoints from geometry, and flags what it cannot resolve instead of guessing". Python, MIT, created and last pushed 2026-07-25, 0★. Effectively a single-commit-day project. — [GitHub](https://github.com/miguesj-hub/drawio-to-structurizr)
- `MilanVlaski/c4gui`: a diagramming web app that exports to Structurizr DSL, not to draw.io. 2★, last update 2025-11. — [GitHub](https://github.com/MilanVlaski/c4gui)
- LikeC4: `likec4 import drawio diagram.drawio -o src/model.c4`. — [npm likec4](https://www.npmjs.com/package/likec4)

### Inferences
- Freehand draw.io C4 diagrams have no fixed semantics. Edges may be unattached and element types are only implied by style, so any importer has to guess, which is why the miguesj tool flags what it cannot resolve. Import works best when the drawio file was originally generated with Structurizr ids in the cell attributes (see (e)).

### Gaps
- No production references or user reports found for any draw.io → Structurizr importer.

## (c) Generating ArchiMate views from the same model

### Takeaway
No maintained Structurizr ↔ ArchiMate converter was found. The practical route is a custom transform from Structurizr workspace JSON to the **Open Group ArchiMate Model Exchange File Format** (XML). Load that headlessly into **Archi** with its CLI (`--xmlexchange.import`), then use jArchi scripts (`--script.runScript`) to build views and lay them out, and export an HTML report, CSV or Jasper output. A common C4 → ArchiMate mapping is Software System and Container → Application Component.

### Cited Findings
- **Archi** (`archimatetool/archi`): the reference open-source ArchiMate tool. Java, about 1.29k★, 344 forks, active (updated 2026-10-14). — [GitHub](https://github.com/archimatetool/archi)
- Archi CLI options:
  - Models: `--createEmptyModel`, `--loadModel`, `--saveModel`, `--importModel` (+ `.update`, `.updateAll`)
  - Open Exchange: `--xmlexchange.import <*.xml>`, `--xmlexchange.export <path>`, `--xmlexchange.exportFolders`, `--xmlexchange.exportLang`
  - CSV: `--csv.import` / `--csv.export` with options
  - Reports: `--html.createReport <path>`, `--jasper.createReport` (requires `--jasper.filename` and `--jasper.title`)
  - Scripts: `--script.runScript <script file>`
  - Collaboration models (coArchi): `--modelrepository.cloneModel` / `loadModel` / `userName` / `passFile` / `identityFile`
  - On Linux headless: "you may need to install and run certain libraries like gtk3 and xvfb" (`apt -y install libgtk3.0-cil xvfb`, `xvfb-run`)
  — [Archi Command Line Interface wiki](https://github.com/archimatetool/archi/wiki/Archi-Command-Line-Interface)
- Older ACLI invocation form: `Archi -consoleLog -console -nosplash -application com.archimatetool.commandline.app …`. — [Archi 4.1 release](https://www.archimatetool.com/?p=725); [ACLI devlog 2017](https://devlog.archimatetool.com/2017/07/28/archi-command-line-interface-acli/)
- **jArchi** (`archimatetool/archi-scripting-plugin`): JavaScript scripting for Archi. 173★, active (updated 2026-10-01). — [GitHub](https://github.com/archimatetool/archi-scripting-plugin)
- **coArchi / coArchi2**: Git-based model collaboration plugins. Both active (updated 2026-10). — [coArchi](https://github.com/archimatetool/archi-modelrepository-plugin); [coArchi2](https://github.com/archimatetool/archi-modelrepository-plugin2)
- The old standalone `archimatetool/OpenGroupXMLExchange` plugin repo is **archived** (last update 2024-01-26). Exchange import/export is now built into Archi and exposed by the CLI options above. — [GitHub](https://github.com/archimatetool/OpenGroupXMLExchange)
- The Open Group publishes the "Standard for exchange of ArchiMate® 3.0/3.1 models". — [search summary referencing Open Group catalog]; also implemented by commercial tools such as MEGA Hopex. — [Hopex ArchiMate import/export](https://doc.mega.com/hopex-aquila-en/ARCI/MEGA_Archimate_Metamodel.ArchiMate_Model_import_-_Export.html)
- C4 → ArchiMate mapping in practice: "C4 software systems and containers are mapped to ArchiMate application components". — [DEV: Agile software architecture using ArchiMate and the C4 model](https://dev.to/jbrocher/agile-software-architecture-using-archimate-and-the-c4-model-54f4). MooD International publishes a C4 mapping onto its ArchiMate blueprint. — [MooD and the C4 model](https://supportportal.moodinternational.com/hc/en-us/articles/360015465100-MooD-and-the-C4-model). An ARIS practitioner reports mapping C4 → ArchiMate was "doable". — [ARIS community](https://ariscommunity.com/users/glauberhenrique/2022-09-15-c4-model-notation)
- The only GitHub repo matching "structurizr archimate" is `gauravs19/enterprise-architecture-skill`, a Claude Code skill covering C4/Structurizr, ArchiMate, TOGAF and arc42. It is guidance and templates for an LLM, not a converter. MIT, 16★, pushed 2026-10-12. — [GitHub](https://github.com/gauravs19/enterprise-architecture-skill)
- IcePanel and Structurizr do not list ArchiMate export. — [IcePanel vs Structurizr](https://icepanel.io/blog/icepanel-vs-structurizr)

### Inferences
- Suggested mapping, built from the sources above plus standard ArchiMate semantics. It is not an official standard, so validate it with your EA team:

  | C4 / Structurizr | ArchiMate |
  |---|---|
  | Person | Business Actor (or Business Role) |
  | Software System | Application Component, optionally grouped |
  | Container | Application Component (data stores as Data Object, or System Software / Node for the DB engine) |
  | Component | Application Component (nested) or Application Function |
  | Relationship | Serving / Flow / Access, depending on its semantics |
  | Deployment Node | Node / Device / System Software |
  | Infrastructure Node | Technology Service / Node |

- Pipeline sketch:
  1. Run `structurizr export -format json`, or use the workspace.json directly.
  2. A small script (Python or Node) emits Exchange XML, using Structurizr element ids or properties as `identifier` values for stable diffs.
  3. Run `xvfb-run Archi -application com.archimatetool.commandline.app --xmlexchange.import model.xml --script.runScript make-views.ajs --saveModel model.archimate --html.createReport out/`.
- Views can be created through Exchange XML `<views>` with coordinates, or generated with jArchi. jArchi is the more flexible option for auto-layout and styling.
- Choose one master: either Structurizr owns these elements, or the EA repository does. Bidirectional sync between C4 and ArchiMate has no known tooling.

### Gaps
- I could not open the Open Group exchange-format spec page directly. Version details (3.1 vs 3.2) and the XSD URL are unverified here.
- I found no maintained `structurizr-archimate` converter or Archi plugin that imports Structurizr. A search for "archimate exchange format generator" on GitHub returned 0 results with my query.
- I could not verify how jArchi's headless script runner behaves in CI (the license/registration requirements of jArchi's binary distribution are unverified).

## (d) Exporting .drawio to SVG/PNG/PDF in CI

### Takeaway
All reliable options wrap the **draw.io Desktop (Electron) CLI** (`drawio -x -f <fmt> -o <out> <in>`), which needs a virtual X display (Xvfb). The de facto standard is rlespinasse's Docker image `drawio-export` plus the `drawio-export-action` GitHub Action. Both are actively maintained, MIT-licensed, community projects (not official jgraph). Expect occasional hangs, so use timeouts.

### Cited Findings
- `drawio-desktop` "does not run without an x-server (e.g. when in a CI environment)". The usual pattern is `xvfb-run -a drawio -x -f png -o output.png input.drawio`. — [sphinxcontrib-drawio (PyPI)](https://pypi.org/project/sphinxcontrib-drawio/); [linuxcommandlibrary drawio](https://linuxcommandlibrary.com/man/drawio)
- Running as root inside a container reportedly also needs `--no-sandbox`. This comes from a single non-official source and was not confirmed. — [linuxcommandlibrary drawio](https://linuxcommandlibrary.com/man/drawio)
- `rlespinasse/docker-drawio-desktop-headless`: a headless Draw.io Desktop image. Running as non-root needs `HOME` set to the working dir, and a passwd mount has been needed since v24.4.6. It has a **timeout capability "since the application can hang sometimes"** and font-support image variants. — [README](https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/982088cf01fb272ec6747a362645cbaf5fc956ad/README.adoc); [awesome.ecosyste.ms](https://awesome.ecosyste.ms/projects/github.com%2Frlespinasse%2Fdocker-drawio-desktop-headless)
- Snap-installed draw.io cannot write to /tmp because of confinement. — [skills.cat drawio-export-tools](https://skills.cat/skills/rlespinasse/agent-skills/drawio-export-tools)
- `rlespinasse/drawio-export` (Docker image): 93★, active (updated 2026-10-14), default branch `v4.x`. Formats: jpg, pdf, png, svg, xml. — [GitHub](https://github.com/rlespinasse/drawio-export); [Docker Hub](https://hub.docker.com/r/rlespinasse/drawio-export)
- `rlespinasse/drawio-export-action@v2` (MIT, 44★):
  - Inputs: `path`, `format` (adoc, md, jpg, pdf, png, svg, xml), `output`, `transparent`, `crop`, `embed-diagram`, `remove-page-suffix`, `border`, `scale`, `width`, `height`, `quality`, `uncompressed`, `all-pages`, `embed-svg-fonts`, `svg-theme` (light/dark), `svg-links-target`.
  - `action-mode`: `recent`, `all`, `reference` or `auto`. Incremental export of only changed files needs `fetch-depth: 0`.
  - The README shows a sample workflow that commits exports back to `main` with a concurrency group.
  — [GitHub](https://github.com/rlespinasse/drawio-export-action)
- The rlespinasse tools describe themselves as "Third-party ecosystem by @rlespinasse – NOT official Draw.io". — [skills.cat](https://skills.cat/skills/rlespinasse/agent-skills/drawio-export-tools). The author's write-up: [Keep your draw.io diagrams in sync inside your repository (DEV)](https://dev.to/rlespinasse/keep-your-draw-io-diagrams-in-sync-inside-your-repository-bka)
- Alternatives:
  - `LukeCarrier/mkdocs-drawio-exporter`: **archived** (last update 2026-01-14). — [GitHub](https://github.com/LukeCarrier/mkdocs-drawio-exporter)
  - `b1f6c1c4/draw.io-export`: converts draw.io XML to PDF/PNG on the command line (Puppeteer-based). — [GitHub](https://github.com/b1f6c1c4/draw.io-export)
  - `mattiash/drawio-export`. — [GitHub](https://github.com/mattiash/drawio-export)
  - `sphinxcontrib-drawio` for Sphinx docs. — [PyPI](https://pypi.org/project/sphinxcontrib-drawio/)
- A source summary mentions draw.io versions in this ecosystem ranging from v22.1.11 to v29.6.6, so flags and container behaviour vary by version. — [search summary of rlespinasse docs](https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/982088cf01fb272ec6747a362645cbaf5fc956ad/README.adoc)

### Inferences
- In GitHub Actions, use `rlespinasse/drawio-export-action@v2` with `format: svg` (plus png/pdf jobs if needed), `action-mode: recent`, and `fetch-depth: 0`.
- In other CI systems, run the `rlespinasse/drawio-export` Docker image directly.
- Pin the image version and enable the timeout to guard against hangs.
- Electron startup costs a few seconds per invocation, so batch whole folders in one container run rather than calling once per file. This is inferred from the architecture; I found no benchmark.
- `embed-diagram` on PNG/SVG/PDF keeps the source inside the image, so the exports remain editable in draw.io.

### Gaps
- I found no published performance or reliability benchmarks (per-diagram export time, failure rates).
- I did not confirm whether jgraph currently publishes an official `jgraph/docker-drawio` export image. jgraph's official Docker image is for serving the web app, not for exporting.

## (e) Keeping model ↔ diagram in sync (round-trip, drift detection) and positioning (Structurizr as source of truth vs draw.io as source)

### Takeaway
Round-trip tooling between Structurizr and draw.io does not exist. The workable pattern is **one-way generation**: Structurizr is the source of truth and .drawio is a generated, regenerable artifact. Put model ids and metadata into draw.io cell attributes (`<object>`/UserObject with custom properties, `placeholders="1"`), store diagrams **uncompressed**, and detect drift by comparing the id sets and relationships in the drawio XML against workspace.json. LikeC4 states the same positioning: the model is the source of truth and draw.io is an interchange format.

### Cited Findings
- draw.io shape data (custom properties) is stored on `UserObject`/`<object>` wrappers around `mxCell`. Placeholders such as `%name%` in labels and tooltips resolve only when `placeholders="1"` is set on the UserObject or as a style on a plain mxCell. Values resolve from the nearest shape or ancestor container. File-level properties (File > Properties > Edit Data) are available on every page. — [draw.io placeholders manual](https://www.drawio.com/docs/manual/advanced/placeholders/); [Placeholders blog](https://drawio.com/blog/placeholders); [Shape data manual](https://www.drawio.com/docs/manual/shapes/shape-data/); [Placeholder scope](https://www.drawio.com/blog/placeholder-scope)
- draw.io publishes an official FAQ on generating and validating draw.io diagrams with AI, including an `<mxfile vars=…>` example (I did not verify the detail). jgraph also publishes an official `drawio-mcp`. — [draw.io AI generation FAQ](https://www.drawio.com/doc/faq/ai-drawio-generation); [skills.cat jgraph/drawio-mcp](https://skills.cat/skills/jgraph/drawio-mcp/drawio)
- Compression: compressed .drawio XML is "a thin envelope around a binary blob … opaque to Git's text-based diff". INNOQ's workaround is a visual diff with ImageMagick `compare`. — [INNOQ "Draw the diff" (2023)](https://www.innoq.com/en/blog/draw-the-diff)
- A 2020 third-party post says the default save format changed to deflate-compressed XML. The official docs say to untick "Compressed" in File > Export as > XML. Extras > Edit Diagram shows the raw XML. — [drawio-app.com (2020)](https://drawio-app.com/?p=515); [draw.io export to XML](https://www.drawio.com/docs/manual/export/export-to-xml/)
- `compressXml=true` is a documented draw.io configuration key, but the docs mention it in the context of custom shape libraries. — [draw.io custom shape library format](https://drawio.com/doc/faq/format-custom-shape-library)
- `drawio-export-action` has an `uncompressed` input for XML output. — [GitHub](https://github.com/rlespinasse/drawio-export-action)
- LikeC4's draw.io docs: "LikeC4 stays the source of truth, and draw.io is treated as an interchange format". — [LikeC4 Draw.io (via search summary)](https://likec4.dev/tooling/drawio/)
- Vendor comparisons describe draw.io as general-purpose and needing "more work to maintain consistency" than model-based tools. These are vendor marketing claims. — [IcePanel vs draw.io](https://icepanel.io/blog/2025-05-29-comparison-icepanel-vs-drawio)
- The `veritas-sovereign/drawio-structurizr` project includes **validation** of draw.io C4 diagrams. This is a drift and linting angle, but the project is very new. — [GitHub](https://github.com/veritas-sovereign/drawio-structurizr)

**Libraries for writing draw.io XML (for the generator and the drift checker)**
- **drawpyo** (`MerrimanInd/drawpyo`): "A Python library for programmatically generating Draw.io charts". About 411★, 58 forks, 23 open issues, on PyPI and conda-forge, active (updated 2026-10-04; a tracker reports last push 2026-03-21). License not captured. — [GitHub](https://github.com/MerrimanInd/drawpyo); [PyPI](https://pypi.org/project/drawpyo); [gittrend](https://gittrend.io/repo/MerrimanInd/drawpyo)
- **N2G** (`dmulyalin/N2G`, "Need To Graph"): Python, generates draw.io and yEd diagrams. 177★, updated 2026-08-29. — [GitHub](https://github.com/dmulyalin/N2G)
- **mxGraph JS**: the original jgraph mxGraph library is end-of-life (from my own knowledge, not verified in this session). draw.io itself keeps a maintained fork internally.

### Inferences
**Recommended pattern for a Structurizr-centred pipeline**
- Steps:
  1. Generate .drawio from workspace.json with drawpyo.
  2. Put every element in an `<object>` carrying `structurizr_id`, `structurizr_type`, `tags`, `technology` and the canonical name. Label it with `%name%` and set `placeholders="1"`, so renaming in the model propagates on regeneration.
  3. Set a deterministic `id` attribute, for example `sz-<elementId>` for elements and `sz-rel-<relationshipId>` for relationships.
  4. Save uncompressed (`compressed="false"` on `<diagram>`, or the `uncompressed` option in the export action).
  5. Run SVG export in CI.
- **Drift detection**: a CI job that parses the drawio XML and workspace.json and checks for:
  - cells without `structurizr_id`, meaning someone added freehand content
  - ids in the drawio that are missing from the model, meaning stale content
  - model elements in the view that are missing from the drawio
  - label mismatches
  Fail the PR or open an issue on any of these. Text diff on uncompressed XML works for review. INNOQ-style image diffs help reviewers see layout changes.
- **Preserving manual layout**: when regenerating, keep the existing x/y and styling from the previous .drawio for ids that still exist, and only add or remove cells. This gives draw.io "presentation-only" ownership of geometry and style, while the model keeps ownership of semantics.
- **Structurizr as single source of truth, draw.io for rendering and presentation**:
  - Pros: one model with many views; consistency checks; ArchiMate and other exports come from the same source; the MCP and LLM tooling in `structurizr-mcp` works against the model.
  - Cons: draw.io editors can't change semantics; a custom generator has to be maintained; C4 shape fidelity in draw.io depends on your own style mapping.
- **draw.io as source**:
  - Pros: low barrier, rich visuals, familiar to non-developers.
  - Cons: no model, so no cross-view consistency; import into Structurizr is heuristic and comes from 2026 0★ tools; compression and layout noise in git; drift is the norm.
  - Acceptable only for one-off migration into Structurizr.

### Gaps
- I found no published case studies or conference talks (2025–2026) that report a Structurizr → draw.io production pipeline, or teams using draw.io as a presentation layer over Structurizr.
- I could not confirm whether current draw.io desktop saves compressed or uncompressed by default, or whether there is a global "compressed" preference. I believe draw.io switched to uncompressed by default around 2021 (unverified), so check it against the current drawio-desktop release notes.
- Licenses for drawpyo and N2G were not captured in this session. Check them in their repos.
