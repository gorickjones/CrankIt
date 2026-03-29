# The Process: Building Crank It

I started this project because I wanted a very specific workflow for my personal blog. I looked at a few existing options—Drafts App, the Micro.blog extension, and iOS Shortcuts. While those worked to a point, none of them did exactly what I wanted. I decided to build a small app from scratch using Gemini to solve that gap and to see what I could learn along the way.

### Choosing the Tools
The first hurdle was just figuring out where to build. I started with Swift Playgrounds on the iPad because I followed the initial advice I got from Gemini. Looking back, my collaboration with Gemini stumbled here. I didn't know enough to ask the right questions, and Gemini gave me a "simple" start that didn't actually match what I wanted to build. We spent a lot of time cutting and pasting code that didn't fit the final vision, which eventually forced the move to a more robust setup.

I eventually landed on a core set of tools that worked:
* **[Gemini](https://gemini.google.com):** My primary collaborator for code generation and troubleshooting.
* **[Xcode](https://developer.apple.com/xcode/):** For the actual construction.
* **[GitHub Desktop](https://desktop.github.com):** For version control.
* **[Obsidian](https://obsidian.md):** For documenting the intent and the logic.

I wasted some time trying to force myself to use the Terminal for GitHub because I felt like that’s what a "real" developer would do. I eventually realized that leaning into visual tools like GitHub Desktop was just more efficient. It’s better to get the project moving than to struggle with the ego of using the "harder" tool.

### What was hard
The most difficult part wasn't writing the Swift code—Gemini handled that logic well. The real difficulty was the "plumbing." 
* **The Environment:** Xcode is a maze. Even when I knew exactly what I wanted, like adding a simple settings icon, finding the right menu or "Asset Catalog" felt like a scavenger hunt. 
* **The Learning Curve:** I started the GitHub part of the project too early, before I had the app's structure settled. This led to a lot of time spent moving files and cleaning up folder structures when I should have been focused on the product itself.

### What Worked
The most effective way to move past a block was to stop guessing. I started taking screenshots of exactly what I was seeing in Xcode and asking Gemini for instructions from that specific spot. It turned the process into a coaching session rather than a struggle.

Using the Simulator was a highlight. It wasn't necessarily a turning point, but it was fun. It let me see the actual results of the code, which improved my ability to give better instructions and fine-tune what was required. It made all the technical effort feel real.

### Final Thoughts
Crank It isn't a complex app, but building it taught me a lot about the reality of "vibe coding." It’s a mix of holding a very tight product vision and being willing to navigate the technical friction of the tools. I'm less worried about knowing everything now and more focused on having a system that helps me find the next step.