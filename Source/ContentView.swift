import SwiftUI

struct ContentView: View {
    @StateObject private var service = CrankService()
    
    // UI State
    @State private var quote: String = ""
    @State private var url: String = ""
    @State private var title: String = "[TKTitle]"
    @State private var comment: String = ""
    @State private var tags: String = ""
    @State private var isDraft: Bool = true
    
    // Settings (Saved locally)
    @AppStorage("microBlogToken") private var token: String = ""
    @AppStorage("microBlogUrl") private var blogUrl: String = "https://micro.blog"
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: pasteSelection) {
                        Label("Paste Selection & Link", systemImage: "doc.on.clipboard")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Section(header: Text("The Source")) {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    HStack {
                        TextField("Title", text: $title)
                        Button("Fetch") {
                            Task {
                                title = await service.fetchTitle(from: url)
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                Section(header: Text("The Quote")) {
                    TextEditor(text: $quote)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Your Comment & Tags")) {
                    TextEditor(text: $comment)
                        .frame(minHeight: 80)
                    TextField("Tags (comma separated)", text: $tags)
                }
                
                Section {
                    Toggle("Keep as Draft", isOn: $isDraft)
                    Button(action: crankIt) {
                        if service.isPosting {
                            ProgressView()
                        } else {
                            Text("Crank It")
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(quote.isEmpty || url.isEmpty || token.isEmpty)
                }
                
                Section(header: Text("Settings"), footer: Text("Token is stored locally on this iPad.")) {
                    SecureField("Micro.blog App Token", text: $token)
                    TextField("Blog URL", text: $blogUrl)
                }
            }
            .navigationTitle("Crank It ⚙️")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Crank It"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Manual paste logic to avoid "auto-eating" code
    func pasteSelection() {
        if let clip = UIPasteboard.general.string {
            if clip.hasPrefix("http") {
                self.url = clip
                Task { self.title = await service.fetchTitle(from: clip) }
            } else {
                self.quote = clip
            }
        }
    }
    
    func crankIt() {
        let tagArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let post = CrankPost(quote: quote, url: url, title: title, comment: comment, isDraft: isDraft, tags: tagArray)
        
        Task {
            service.isPosting = true
            let success = await service.publish(post: post, token: token, blogUrl: blogUrl)
            service.isPosting = false
            alertMessage = success ? "Successfully Cranked!" : "Error. Check token."
            showAlert = true
        }
    }
}
