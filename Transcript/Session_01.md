# Crank It: Development Log - Session 01

### The Goal
To build a bespoke iPadOS tool called **Crank It** for a “Quote-Link-Comment” workflow. The app allows the user to highlight text in a browser or RSS reader, fetch the source title, format it into a specific Markdown block, and publish it as a post or draft to a Micro.blog-hosted site (`crank.report`).

### Architectural Decisions
* **Platform:** iPadOS (Built using Swift Playgrounds).
* **Storage:** `Working Copy` for Git/GitHub integration.
* **Licensing:** MIT License.
* **Security:** Avoided hard-coding API keys. Used SwiftUI `@AppStorage` to save the Micro.blog App Token locally on the device’s disk.
* **Protocol:** Used the **Micropub** API to communicate with Micro.blog.
* **Format:** > [Quote]
    > 
    > — [Title](URL)
    >
    > [Optional Comment]

### Setup Phase
1.  **GitHub Repo:** Created `Crank-It` with a README and MIT License.
2.  **Working Copy:** Linked GitHub via OAuth and cloned the repo to the iPad Pro.
3.  **Swift Playgrounds:** Created a new App project.

### Technical Implementation (The “Engine”)
We developed `CrankService.swift`, which contains two primary functions:
1.  **fetchTitle:** A regex-based scraper that hits the shared URL and extracts the `<title>` tag. If it fails, it returns `[TKTitle]` as a placeholder.
2.  **publish:** An asynchronous function that sends a POST request to the Micro.blog Micropub endpoint with the formatted Markdown and category tags.

### UI Implementation
Created `ContentView.swift` using SwiftUI `Form` sections. It includes fields for the URL, Quote, and Comment, as well as a Settings section for the user’s private App Token.

### Next Steps
* Test the API connection with a live post.
* Implement the “Share Extension” or “Incoming Data” logic to capture text from Safari/NetNewsWire automatically.
