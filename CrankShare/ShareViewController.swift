import SwiftUI
import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupView()
    }
    
    private func setupView() {
        let group = DispatchGroup()
        var quoteText = ""
        var urlString = ""

        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let attachments = item.attachments {
            
            for attachment in attachments {
                // 1. Fetch Text (Quote)
                if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    group.enter()
                    attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                        if let text = data as? String {
                            quoteText = text
                        }
                        group.leave()
                    }
                }
                
                // 2. Fetch URL
                if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    group.enter()
                    attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (data, error) in
                        if let url = data as? URL {
                            urlString = url.absoluteString
                        }
                        group.leave()
                    }
                }

                // 3. Safari Property List fallback
                if attachment.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier) {
                    group.enter()
                    attachment.loadItem(forTypeIdentifier: UTType.propertyList.identifier, options: nil) { (item, error) in
                        if let dictionary = item as? [String: Any],
                           let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] {
                            let safariURL = results["URL"] as? String ?? ""
                            if !safariURL.isEmpty {
                                urlString = safariURL
                            }
                        }
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            let contentView = CrankShareView(
                quote: quoteText,
                url: urlString,
                extensionContext: self.extensionContext
            )
            
            let hostingController = UIHostingController(rootView: contentView)
            hostingController.modalPresentationStyle = .formSheet
            hostingController.preferredContentSize = CGSize(width: 540, height: 600)
            
            self.present(hostingController, animated: true)
        }
    }
}

struct CrankShareView: View {
    @State var quote: String
    @State var url: String
    @State var title: String = ""
    @State var comment: String = ""
    @State var isDraft: Bool = true
    
    @StateObject private var service = CrankService()
    var extensionContext: NSExtensionContext?

    @AppStorage("microBlogToken", store: UserDefaults(suiteName: "group.blog.marniewebb.crankit"))
    private var token: String = ""
    @AppStorage("microBlogUrl", store: UserDefaults(suiteName: "group.blog.marniewebb.crankit"))
    private var blogUrl: String = "https://micro.blog"

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("The Quote")) {
                    // This is now editable and paste-friendly
                    TextEditor(text: $quote)
                        .font(.system(.body, design: .serif))
                        .italic()
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("The Source")) {
                    TextField("Title", text: $title).bold()
                    TextField("URL", text: $url)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Your Comment")) {
                    VStack(alignment: .trailing) {
                        TextEditor(text: $comment)
                            .frame(minHeight: 100)
                        
                        Text("\(comment.count) / 280")
                            .font(.caption2)
                            .monospacedDigit()
                            .foregroundColor(comment.count > 280 ? .red : .secondary)
                            .padding(.top, 4)
                    }
                }
                
                Section {
                    Toggle("Save as Draft", isOn: $isDraft)
                }
                
                Button(action: { postToMicroBlog() }) {
                    Text("Crank It")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .disabled(token.isEmpty || comment.count > 280)
            }
            .navigationTitle("Crank It ⚙️")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            }
            .onAppear {
                if !url.isEmpty {
                    Task {
                        let fetchedTitle = await service.fetchTitle(from: url)
                        if !fetchedTitle.isEmpty {
                            self.title = fetchedTitle
                        } else {
                            self.title = "New Post" // Fallback if fetch fails
                        }
                    }
                }
            }
        }
    }
    
    func postToMicroBlog() {
        let post = CrankPost(
            quote: quote,
            url: url,
            title: title,
            comment: comment,
            isDraft: isDraft,
            tags: []
        )
        
        Task {
            let success = await service.publish(post: post, token: token, blogUrl: blogUrl)
            if success {
                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
}
