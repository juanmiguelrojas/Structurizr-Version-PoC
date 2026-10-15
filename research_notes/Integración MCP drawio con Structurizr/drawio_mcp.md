# draw.io MCP server ecosystem (as of Oct 2026) + hands-on test of the draw.io MCP tools in this session

Note on method: the GitHub API (`gh`) was blocked for jgraph/* and lgazo/* repos in this session, so repo facts come from WebFetch of github.com pages / raw.githubusercontent.com files. www.drawio.com was unreachable (DNS failure) from this sandbox. Hands-on results come from calls made in this session on 2026-10-15. The tool output reported `_buildId: 3398377@2026-10-13T16:44:46.185Z`.

## 1. Official jgraph/drawio-mcp: variants, tools, deployment, capabilities

### Takeaway
jgraph/drawio-mcp (Apache-2.0) is the official repo. It ships **four delivery modes**, and all of them **generate new diagrams**. None of them opens, reads or edits an existing `.drawio` file as an MCP tool. Only the Claude Code/Codex/Copilot **plugin (skill)** writes `.drawio` files to disk and exports PNG/SVG/PDF, and it does that through the local draw.io Desktop CLI. The MCP servers give back an interactive viewer or a URL, not a file.

### Cited Findings
- The repo offers four approaches: MCP App Server, MCP Tool Server, Assistant Plugins (skill), and Project Instructions. License is **Apache-2.0**. — [jgraph/drawio-mcp README](https://github.com/jgraph/drawio-mcp)
- **MCP App Server** (dir `mcp-app-server/`):
  - Hosted remote endpoint `https://mcp.draw.io/mcp` over HTTP. It can be self-hosted via Node.js, the Docker image `jgraph/drawio-mcp`, or Cloudflare Workers.
  - Tools: `create_diagram`, `search_shapes`, `get_drawio_reference`.
  - Renders diagrams inline in chat as an interactive viewer with an "Open in draw.io" button. Accepts XML and Mermaid (28 types).
  - Hosts: Claude.ai, ChatGPT, VS Code Copilot, Cursor and Copilot CLI. Hosts without inline rendering get a link.
  - — [README](https://github.com/jgraph/drawio-mcp)
- **MCP Tool Server** `@drawio/mcp` (dir `mcp-tool-server/`):
  - Runs with `npx @drawio/mcp` over stdio.
  - Tools: `open_drawio_xml` and `get_drawio_reference`. The search snippet and README text also cite CSV and Mermaid inputs, so `open_drawio_csv` / `open_drawio_mermaid` likely exist. I did not verify those names.
  - Opens the diagram in the draw.io editor in a browser tab, with lightbox and dark-mode options.
  - Diagram data travels in the URL fragment, which the browser does not send to the server.
  - `routing: "libavoid"` is supported from v1.3.0. ELK `postLayout` is not listed for this server.
  - Cursor versions before 2.6 need this variant.
  - — [README](https://github.com/jgraph/drawio-mcp)
- **Assistant Plugins / skill** (dir `plugins/claude-code/`, `plugins/codex/drawio/`, `plugins/copilot/`):
  - Install in Claude Code with `/plugin marketplace add jgraph/drawio-mcp`, then `/plugin install drawio@drawio`. Equivalent commands exist for Codex CLI and Copilot CLI, and OpenCode reads the skill folder directly.
  - Writes a native `.drawio` file locally and opens it.
  - Exports png/svg/pdf "using the draw.io desktop CLI with `--embed-diagram`".
  - `url` mode "compresses the XML with Node.js's built-in `zlib` and opens the result at `app.diagrams.net`".
  - Layout runs through the Desktop CLI with `--layout` (ELK) or `--layout libavoid`.
  - — [README](https://github.com/jgraph/drawio-mcp)
- Skill SKILL.md details:
  - Export command: `drawio -x -f <format> -e -b 10 -o "<output>" "<input.drawio>"`.
  - Flags: `-x` export, `-f` xml|png|svg|pdf|jpg, `-e` embed diagram (png/svg/pdf), `-b` border, `-t` transparent, `-s` scale, `--width/--height`, `-a` all pages (PDF only), `-p` page (1-based), `--disable-gpu`, `--layout`.
  - Mermaid conversion: `drawio -x -f xml -o diagram.drawio diagram.mmd`.
  - Naming: double extensions such as `name.drawio.png`. The skill deletes the intermediate `.drawio` after export.
  - No dedicated workflow for editing existing files, apart from in-place layout passes where input path = output path.
  - Very large diagrams can exceed URL length limits in url mode.
  - — [SKILL.md](https://raw.githubusercontent.com/jgraph/drawio-mcp/main/plugins/claude-code/skills/drawio/SKILL.md)
- **Project Instructions** (dir `project-instructions/`): text pasted into a Claude Project. Claude builds draw.io URLs with Python code execution. No MCP and no install. — [README](https://github.com/jgraph/drawio-mcp)
- Shared material:
  - `shared/xml-reference.md` and `shared/xml-essentials.md` are the generation references. `shape-search/` builds the shape index.
  - The tool-generated reference links `shared/style-reference.md` and `shared/mxfile.xsd`.
  - — [README](https://github.com/jgraph/drawio-mcp); `get_drawio_reference` output (hands-on)
- The README does not say that any variant edits an existing diagram or returns XML as a feature. Hands-on testing showed that the App Server's `create_diagram` *does* echo the XML back (see section 4). — [README](https://github.com/jgraph/drawio-mcp)
- A directory listing shows version "1.0.3, last updated Aug 3, 2026". This comes from a third-party listing (unverified), and it may refer to only one package. — [search result via Enterprise DNA/aggregators](https://enterprisedna.co/directories/mcp/redhold-diagrams-mcp-app-core)

### Inferences
- For an "Architecture as Code" pipeline, the official MCP servers are **authoring aids for an interactive assistant**. They are not pipeline components. They have no file I/O, no export, and no read/patch of existing files.
- The App Server's echoed XML lets an agent copy the XML into a repo file itself, for example with the Write tool.
- The plugin/skill is the only official route to persisted `.drawio` files and image exports, and it relies on draw.io Desktop being installed.

### Gaps
- The exact parameters of `open_drawio_xml` / `open_drawio_csv` / `open_drawio_mermaid` and the current npm version of `@drawio/mcp` were not verified, because the GitHub API was blocked and npm was not fetched.
- I found no official statement on whether multi-page `<mxfile>` input is accepted by `create_diagram`. Its schema documents a single `<mxGraphModel>`.

## 2. Community draw.io MCP servers

### Takeaway
**lgazo/drawio-mcp-server** (MIT, v2.3.0) is the most capable community option for *editing*. It drives a live draw.io instance, either through a browser extension or its own built-in editor, and exposes roughly 30 granular tools. These cover cells, pages, layers, import/export (XML/SVG/PNG) and save. Several smaller servers manipulate `.drawio` XML files directly on disk.

### Cited Findings
- lgazo/drawio-mcp-server:
  - Two modes: a built-in draw.io editor (`--editor`, served at `http://localhost:3000/`, "no browser extension required"), or a browser extension that connects to draw.io running in the user's browser. TLS (HTTPS/WSS) is optional.
  - License MIT. Latest version shown is v2.3.0, with no date on the page.
  - — [lgazo/drawio-mcp-server](https://github.com/lgazo/drawio-mcp-server)
  - The browser extension connects over WebSocket on port 3333 by default. This comes from a search snippet and was not verified on the repo page. — [search result](https://github.com/lgazo/drawio-mcp-server)
- lgazo tool list, verbatim names:
  - Document: `list-documents`, `set-document-title`, `save-document`
  - Inspection: `get-selected-cell`, `get-shape-categories`, `get-shapes-in-category`, `get-shape-by-name`, `list-paged-model` (paginated cells, not full XML)
  - Modification: `add-rectangle`, `add-edge`, `delete-cell-by-id`, `add-cell-of-shape`, `set-cell-shape`, `set-cell-data`, `edit-cell`, `edit-edge`, `set-cell-parent`
  - Pages: `list-pages`, `get-current-page`, `create-page`, `copy-page`, `rename-page`
  - Layers (since v1.7.0): `list-layers`, `set-active-layer`, `move-cell-to-layer`, `get-active-layer`, `create-layer`
  - Import/export: `export-diagram` (SVG/PNG/XML), `import-diagram` (XML, or SVG/PNG with embedded XML, in modes replace/add/new-page), `import-mermaid`
  - — [TOOLS.md](https://raw.githubusercontent.com/lgazo/drawio-mcp-server/main/TOOLS.md)
- Other community servers. Their listings were seen, but none of these were verified at the repo level:
  - **abossard/drawio-mcp** parses existing `.drawio` files, adds, removes and updates nodes and edges, keeps undo/redo history, and pairs with the VS Code draw.io extension. — [Glama listing](https://glama.ai/mcp/servers/a6d2k02ugw)
  - **rf-santos/drawio-mcp** (Python) writes and reads XML to and from file paths, adds shapes and connections, and parses existing files. — [Glama](https://glama.ai/mcp/servers/rf-santos/drawio-mcp)
  - **yohasacura/drawio-mcp** (PyPI, `uvx drawio-mcp`, v1.0.2, Feb 9 2026) is "for creating and editing draw.io / diagrams.net XML files programmatically". — [search listing](https://www.getdrio.com/mcp/io-github-yohasacura-drawio-mcp)
  - **ekusiadadus/draw-mcp** is a Claude Code plugin that "generate[s], validate[s], and export[s] draw.io diagrams". — [skillselion](https://skillselion.com/plugin/ekusiadadus/draw-mcp)
  - **RedHold diagrams-mcp** (for Diagrams.so) claims 23 tools for generating, editing and reviewing cloud architecture diagrams as native draw.io files. — [Enterprise DNA](https://enterprisedna.co/directories/mcp/redhold-diagrams-mcp-app-core)
  - There are also Gitee mirrors of drawio-mcp, which are unofficial. — [gitee](https://gitee.com/openminds/drawio-mcp)

### Inferences
- If the PoC needs an agent to *modify an existing* `.drawio` file generated from Structurizr, there are two practical routes. One is lgazo with the built-in editor (`import-diagram` → edit → `export-diagram` format xml → save). The other is a file-based Python server such as rf-santos or yohasacura.
- lgazo needs a running editor or browser session, which makes it awkward in headless CI.

### Gaps
- Maintenance status, stars and release dates were not verified for the community servers other than lgazo.

## 3. Headless export in CI (SVG/PNG/PDF)

### Takeaway
CI export is done with **draw.io Desktop's CLI under Xvfb**. The usual wrapper is rlespinasse's Docker image or GitHub Action. jgraph's old `export-server` image is **end-of-life**.

### Cited Findings
- **rlespinasse/drawio-export-action@v2**:
  - Inputs: `path`, `format` (default `pdf`; also `adoc`, `md`, `jpg`, `png`, `svg`, `xml`), `output` (default `export`), `remove-page-suffix`, `border`, `scale`, `width`/`height`, `crop`, `embed-diagram`, `transparent`, `quality`, `uncompressed`, `all-pages`, `embed-svg-fonts`, `svg-theme`, `svg-links-target`, `action-mode` (`recent|all|reference|auto`), `since-reference`.
  - Needs `fetch-depth: 0` unless `action-mode: all`.
  - Built on the `rlespinasse/drawio-export` Docker image. The README's example auto-commits exports with `stefanzweifel/git-auto-commit-action`.
  - — [drawio-export-action](https://github.com/rlespinasse/drawio-export-action)
- The `rlespinasse/drawio-export` image on Docker Hub shows tag v4.47.0. Example: `docker run -v $(pwd):/data rlespinasse/drawio-export --format pdf --output 'dist/{basename}.{ext}' diagrams/`. — [Docker Hub](https://hub.docker.com/r/rlespinasse/drawio-export); [search summary](https://skills.cat/skills/rlespinasse/agent-skills/drawio-export-tools)
- `rlespinasse/docker-drawio-desktop-headless` wraps draw.io Desktop with a configurable Xvfb (`XVFB_DISPLAY`, `XVFB_OPTIONS`). — [README](https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/982088cf01fb272ec6747a362645cbaf5fc956ad/README.adoc)
- Raw pattern: `xvfb-run -a drawio -x -f png -o output.png input.drawio`. Running as root in a container needs `--no-sandbox`. The Snap package cannot reach arbitrary directories, so the .deb is preferred. These come from secondary sources. — [linuxcommandlibrary](https://linuxcommandlibrary.com/man/drawio); [sphinxcontrib-drawio](https://pypi.org/project/sphinxcontrib-drawio/)
- The official skill's flag set is listed in section 1. — [SKILL.md](https://raw.githubusercontent.com/jgraph/drawio-mcp/main/plugins/claude-code/skills/drawio/SKILL.md)
- **jgraph/docker-drawio**: the `jgraph/export-server` image "has reached end of life and is no longer built or configured by this project".
  - `EXPORT_URL` and `DRAWIO_SELF_CONTAINED` no longer have any effect.
  - PDF export uses the browser print dialog, and server-rendered PNG/JPEG export is hidden.
  - Browser-side PNG/JPEG/SVG export still works.
  - `?offline=1` disables cloud storage.
  - — [docker-drawio README](https://raw.githubusercontent.com/jgraph/docker-drawio/dev/README.md)

### Inferences
- A GitHub Actions pipeline could run Structurizr DSL → (exporter or script) → `.drawio` committed → `rlespinasse/drawio-export-action@v2` (svg/png with `embed-diagram`) → artifacts or auto-commit.
- MCP is not needed in that pipeline. An agent with the draw.io MCP can still author or refine the `.drawio` interactively before it is committed.

### Gaps
- The official drawio.com CLI documentation page could not be fetched (DNS failure). The flags above come from the official skill and from secondary sources.

## 4. Hands-on test of the draw.io MCP tools in this session

### Takeaway
This session's `mcp__draw_io__*` tools are the official App Server toolset (`create_diagram`, `get_drawio_reference`, `search_shapes`). `create_diagram` **returns the XML as given, plus an `app.diagrams.net` URL with the diagram deflate-compressed in the `#R` fragment**, plus a `_buildId`. It writes no file, does no export, and applies layout or routing only client-side.

`search_shapes` finds ArchiMate (`mxgraph.archimate3.*`) and some `mxgraph.gcp2.*` stencils. It does **not** index the C4 stencils (`mxgraph.c4.*`). Core GCP products such as Cloud Run, Cloud SQL, Pub/Sub and Apigee come back as `shape=image` data-URI SVGs, not `mxgraph.gcp2.*` stencil names.

### Cited Findings (all hands-on, 2026-10-15; source = tool output in this session)

**get_drawio_reference("xml"): key rules**
- The skeleton is `<mxGraphModel adaptiveColors="auto"><root><mxCell id="0"/><mxCell id="1" parent="0"/>...`.
- No XML comments. `html=1` goes in every style, and HTML in values must be XML-escaped.
- Every edge needs a child `<mxGeometry relative="1" as="geometry"/>`.
- Rigid grid: x = col*180+40, y = row*120+40. Node sizes: 140×60 rect, 140×80 diamond, 100×70 cylinder.
- Do not add `<Array as="points">` waypoints or exit/entry overrides.
- Containers:
  - `swimlane;startSize=30;`, `group;`, or `container=1;pointerEvents=0;`. Children use `parent=` and relative coordinates.
  - For nested architecture, use swimlanes with `startSize=24`.
  - "An edge belongs to the innermost container that holds BOTH of its endpoints." Auto-layout reads edge coordinates in the parent frame.
- Layers are `mxCell` elements with `parent="0"` and no vertex/edge attribute. Later layers render on top, and `visible="0"` hides a layer.
- Tags need an `<object id=".." label=".." tags="a b">` wrapper around the `mxCell`. They are space-separated and viewers filter them via Edit > Tags.
- Metadata: custom attributes on `<object>`, with `placeholders="1"` enabling `%key%` in labels. Predefined placeholders include `%id%`, `%page%`, `%pagenumber%`, `%pagecount%`, `%filename%`, `%date%`.
- Dark mode: `adaptiveColors="auto"`. Explicit colors are auto-inverted, or set with `light-dark(#light,#dark)`.
- Routing and layout:
  - `routing: "libavoid"` keeps your positions and re-routes edges orthogonally around shapes.
  - `postLayout: "elk"` re-places vertices (ELK layered) and has a `direction` of `vertical|horizontal`.
  - These two are alternatives and should not be stacked.
- Pointers given in the reference: the full style reference at `github.com/jgraph/drawio-mcp/blob/main/shared/style-reference.md` and the XSD at `shared/mxfile.xsd`.
- Mermaid input supports 28 types, including `C4Context/C4Container/C4Component` and `architecture-beta`. The tool description says to prefer Mermaid for every type it has a header for.

**search_shapes: exact style strings returned**
- "c4 person" / "c4 container" / "c4" / "software system":
  - **No `mxgraph.c4.*` results.**
  - "c4 person" returned `shape=umlActor;...`, `shape=mxgraph.cisco.people.androgenous_person`, `shape=mxgraph.aws4.c4_instance` (an AWS EC2 C4 instance type, a false positive), and icon-service images.
  - "c4 container" returned Alibaba ACR (`shape=mxgraph.alibaba_cloud.acr_cloud_container_registry`) and Kubernetes icons.
  - "software system" returned ArchiMate System Software (`shape=mxgraph.archimate3.application;appType=sysSw;archiType=square;`).
- C4 styles therefore come from the draw.io source (`Sidebar-C4.js`):
  - Person: `html=1;fontSize=11;dashed=0;whiteSpace=wrap;fillColor=#083F75;strokeColor=#06315C;fontColor=#ffffff;shape=mxgraph.c4.person2;align=center;metaEdit=1;points=[...];resizable=0;` with c4Type `Person`
  - Software System: `rounded=1;whiteSpace=wrap;html=1;labelBackgroundColor=none;fillColor=#1061B0;fontColor=#ffffff;align=center;arcSize=10;strokeColor=#0D5091;metaEdit=1;resizable=0;...`
  - Container: `rounded=1;whiteSpace=wrap;html=1;fontSize=11;labelBackgroundColor=none;fillColor=#23A2D9;fontColor=#ffffff;align=center;arcSize=10;strokeColor=#0E7DAD;metaEdit=1;resizable=0;...`
  - DB container: `shape=cylinder3;size=15;...;fillColor=#23A2D9;...`
  - Component: `fillColor=#63BEF2;...;arcSize=6;strokeColor=#2086C9`
  - System Scope Boundary: `dashed=1;arcSize=20;fillColor=none;strokeColor=#666666;...` with c4Type `SystemScopeBoundary`
  - Relationship: `endArrow=blockThin;html=1;fontSize=10;fontColor=#404040;strokeWidth=1;endFill=1;strokeColor=#828282;elbow=vertical;metaEdit=1;endSize=14;startSize=14;jumpStyle=arc;jumpSize=16;rounded=0;edgeStyle=orthogonalEdgeStyle;`
  - Apart from the Person shape, C4 elements in draw.io are styled rectangles and cylinders carrying `c4Type`, `c4Name`, `c4Technology` and `c4Description` metadata, not dedicated stencils.
  - — [Sidebar-C4.js](https://raw.githubusercontent.com/jgraph/drawio/dev/src/main/webapp/js/diagramly/sidebar/Sidebar-C4.js)
- "archimate application component":
  - `html=1;outlineConnect=0;whiteSpace=wrap;fillColor=#99ffff;shape=mxgraph.archimate3.application;appType=comp;archiType=square;` (150×75)
  - Legacy: `shape=mxgraph.archimate.application;appType=comp`
  - Also `shape=mxgraph.archimate3.application;appType=interface;archiType=square;` and `shape=mxgraph.archimate3.component;` (48×40)
- "archimate business actor":
  - `html=1;outlineConnect=0;whiteSpace=wrap;fillColor=#ffff99;shape=mxgraph.archimate3.application;appType=actor;archiType=square;` (150×75)
  - Stick-figure: `html=1;outlineConnect=0;whiteSpace=wrap;fillColor=#ffff99;verticalLabelPosition=bottom;verticalAlign=top;align=center;shape=mxgraph.archimate3.actor;` (27×50)
  - Legacy: `shape=mxgraph.archimate.application;appType=actor`
- "gcp cloud run" / "gcp2 cloud run":
  - Title "Cloud Run": `editableCssRules=.*;html=1;shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=data:image/svg+xml,PHN2ZyB4bWxucz0i...` (base64 SVG; 20×20)
  - A second variant with `sketch=0;...fontColor=#999999;shape=image;...` (42×42)
  - **No `mxgraph.gcp2.cloud_run`.**
- "google cloud sql": title "Cloud SQL", same `editableCssRules=.*;html=1;shape=image;...image=data:image/svg+xml,...` pattern (30×40). Also returned `shape=mxgraph.gcp2.bucket_scale`, `mxgraph.gcp2.scale`, `mxgraph.gcp2.check_scale` (false positives).
- "gcp pub sub": title "Pub Sub", `shape=image;...data:image/svg+xml...` (36×40).
- "apigee": titles "Apigee API Platform" and "Apigee Sense", both `shape=image` data-URI SVGs (40×40).
- "google cloud platform compute": AppEngine, Cloud Functions, Cloud GPU and Cloud Run as data-URI images, and **`sketch=0;html=1;aspect=fixed;strokeColor=none;shadow=0;fillColor=#3B8DF1;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;shape=mxgraph.gcp2.compute_engine_2`** (54×100). This was the only product-level `mxgraph.gcp2.*` stencil seen.

**create_diagram test** (C4 Person `mxgraph.c4.person2` + C4 Container rounded rectangle, both wrapped in `<object>` with `c4Type`/`structurizrId`/`tags` metadata, plus the Cloud Run data-URI image, 2 edges, `routing: "libavoid"`)
- Return value:
  1. JSON `{"xml": "<mxGraphModel ...>" , "routing":"libavoid", "_buildId":"3398377@2026-10-13T16:44:46.185Z"}`. The XML is the **input echoed back verbatim**. It carries **no libavoid waypoints**, because routing runs in the client viewer.
  2. A text line: "If this client doesn't show the diagram inline, open it in the draw.io editor", followed by `https://app.diagrams.net/?pv=0&grid=0#R<deflate+base64 XML>`.
- No file is written, no PNG/SVG/PDF is produced, and no server-side ID or persistence exists. Custom attributes (`structurizrId`, `c4Type`, `tags`) and `<object>` wrappers were accepted and preserved.
- The tool did not complain about the non-indexed `mxgraph.c4.person2` style. It does no validation feedback beyond well-formedness.

### Inferences
- **Limitations observed:**
  - Create-only: no tool to load or patch an existing diagram.
  - Single `mxGraphModel`, so single page per call.
  - Libavoid/ELK geometry is not returned, so a repo copy of the echoed XML lacks routed points unless the user saves from the editor.
  - C4 stencils are not searchable.
  - GCP icons come as large base64 data URIs, which bloat XML and make diffs noisy in git.
  - The hosted endpoint path implies diagram content leaves the machine.
- Because metadata such as `structurizrId` survives, a Structurizr→draw.io generator can embed element IDs in `<object>` attributes. That would make diffs and round-trips traceable, and the MCP viewer will render such XML unchanged.
- The `#R` URL holds the full diagram in the fragment. It is shareable without a server copy, but anyone holding the link has the content, and long diagrams can exceed URL limits.

### Gaps
- I could not observe whether the inline viewer actually rendered `mxgraph.c4.person2` correctly, because this client returned no rendered image.
- I did not test whether `<mxfile>` with multiple `<diagram>` pages is accepted.

## 5. Security / data residency, and CI/CD vs interactive use

### Takeaway
The hosted App Server (`mcp.draw.io`) **receives diagram content**. The self-hosted App Server, the `@drawio/mcp` stdio server and the plugin keep content local, but there are outbound calls to the viewer CDN and the icon service. The LLM provider sees everything regardless of which variant is used. In CI, the deterministic path is the draw.io Desktop CLI (rlespinasse action). MCP belongs to the interactive authoring and review step.

### Cited Findings
- Hosted App Server: diagram content is sent to the draw.io server. Self-hosted App Server, Tool Server and plugins keep diagram content local. — [README](https://github.com/jgraph/drawio-mcp)
- Outbound calls:
  - Viewer code loads from `app.diagrams.net` and `viewer.diagrams.net`.
  - `search_shapes` queries `icons.diagrams.net` with the search terms unless `DRAWIO_ICON_SERVICE_URL=off`.
  - `VIEWER_PATH` and `DRAWIO_BASE_URL` can point these at self-hosted copies.
  - The README recommends testing with egress blocked.
  - — [README](https://github.com/jgraph/drawio-mcp)
- Logging: request metadata only by default. The Cloudflare App Server logs response bodies only when `DEBUG=true`. — [README](https://github.com/jgraph/drawio-mcp)
- "A hosted model still generates the diagram in the provider's cloud". Full isolation requires a local model. — [README](https://github.com/jgraph/drawio-mcp)
- `@drawio/mcp` passes data in the URL fragment, which is not sent to the server. — [README](https://github.com/jgraph/drawio-mcp)
- Self-hosted draw.io editor: `jgraph/docker-drawio` with `?offline=1`. The export-server is EOL. — [docker-drawio](https://raw.githubusercontent.com/jgraph/docker-drawio/dev/README.md)

### Inferences
- **CI/CD (GitHub Actions)** suggested pattern:
  1. Structurizr DSL is the source of truth.
  2. A script or exporter generates `.drawio` deterministically. No LLM is needed, and Structurizr IDs go into `<object>` metadata.
  3. `rlespinasse/drawio-export-action@v2` exports SVG/PNG with `embed-diagram`.
  4. Results are published as artifacts or Pages, or auto-committed.
- MCP servers are not suitable as CI steps. They are non-deterministic (LLM in the loop), interactive by design, and output viewer URLs rather than files. Some, like lgazo, require a running editor. An MCP stdio server could technically be scripted from an Actions job through an MCP client, but nothing in the sources documents or supports that.
- **Interactive use:** an assistant with the App Server or plugin drafts or edits views, and a human saves the `.drawio` into the repo or opens a PR. CI then validates and exports. lgazo's built-in editor could also serve agent-driven edits of existing committed files.
- For a regulated or EU context, prefer one of two setups:
  - Self-host `jgraph/drawio-mcp` (Docker) with `DRAWIO_ICON_SERVICE_URL=off` and a self-hosted viewer, or
  - use the plugin + local Desktop CLI.
- Avoid `mcp.draw.io` for confidential architecture. Note that this session's tools appear to be the hosted App Server, though I did not verify the endpoint in use.

### Gaps
- I found no published SLA, data-retention policy or region information for `mcp.draw.io` beyond the README statements.
- I found no first-party GitHub Action from jgraph for export, only the community rlespinasse action.
