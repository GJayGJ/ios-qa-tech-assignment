//
//  NewsDetailsViewModel.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Combine
import Foundation

class NewsDetailsViewModel: BaseViewModel {
    @Injected(\.imageAPIService) var imageAPIService: ImageAPIService
    
    // MARK: - Private Properties

    private var dependencies: NewsDetailsViewModel.Dependencies
    
    // MARK: - Public Properties

    var articleImageViewSettings: ImageViewSettings {
        return ImageViewSettings(contentMode: .scaleAspectFill,
                                 roundImage: false,
                                 accessibilityText: self.dependencies.article.leadMedia.attributes.caption)
    }
    
    var imageCreditLabelSettings: LabelSettings {
        return LabelSettings(numberOfLines: 0,
                             textAlignment: .right,
                             fontSize: 12,
                             fontWeight: .light,
                             isItalic: true)
    }
    
    var imageCredit: String {
        return self.dependencies.article.leadMedia.attributes.credit.validValue
    }
    
    var headlineLabelSettings: LabelSettings {
        return LabelSettings(numberOfLines: 0,
                             textAlignment: .left,
                             fontSize: 21,
                             fontWeight: .black)
    }
    
    var headline: String {
        return self.dependencies.article.headline
    }
    
    var fullDescriptionLabelSettings: LabelSettings {
        return LabelSettings(numberOfLines: 0,
                             textAlignment: .left,
                             fontSize: 17,
                             fontWeight: .regular)
    }
    
    var fullDescription: String? {
        return self.dependencies.article.contents.reduce(into: "") { partialResult, content in
            if let text = content.attributes.text, content.type == .text {
                partialResult += text + "<br/><br/>"
            }
        }.htmlString
    }
    
    var tagName: String {
        self.dependencies.article.type.rawValue.capitalized
    }
    
    var contentsWithImages: Int {
        return self.dependencies.article.contents.filter { $0.type == .image && $0.attributes.url != nil }.count
    }
    
    let onBookmarkToggled = PassthroughSubject<Void, Never>()
    
    // MARK: - Bindings

    var leadMediaBind: ((Data?) -> Void)?
    
    var isBookmarked: Bool {
        UserDefaults.standard.bool(forKey: self.dependencies.article.id)
    }
    
    // MARK: - Dependencies

    struct Dependencies {
        let article: Article
    }
    
    // MARK: - Init

    init(dependencies: NewsDetailsViewModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Overrides

    override var title: String {
        return Localized("newsDetails_title")
    }
    
    override func start() {
        // Do more stuff to start the view
        
        self.setupUIBinding?()
        Task {
            try await self.getLeadMedia()
        }
    }
    
    // MARK: - Public Methods

    func getLeadMedia() async throws {
        guard let leadMediaURL = self.dependencies.article.leadMedia.attributes.url, let url = URL(string: leadMediaURL) else { return }
        let imageData = try await imageAPIService.getImageData(for: url)
        self.leadMediaBind?(imageData)
    }
    
    func toggleBookmark() {
        var isBookmarked = UserDefaults.standard.bool(forKey: self.dependencies.article.id)
        
        isBookmarked.toggle()
    
        UserDefaults.standard.set(isBookmarked, forKey: self.dependencies.article.id)
        self.onBookmarkToggled.send()
    }
}
