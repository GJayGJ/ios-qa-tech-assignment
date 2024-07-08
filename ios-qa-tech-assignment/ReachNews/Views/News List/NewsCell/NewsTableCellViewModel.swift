//
//  NewsTableCellViewModel.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Foundation

class NewsTableCellViewModel {
    @Injected(\.imageAPIService) var imageAPIService: ImageAPIService
    
    // MARK: - Private Properties

    private var dependencies: NewsTableCellViewModel.Dependencies
    
    // MARK: - Public Properties

    var cellSettings: TableCellSettings {
        return TableCellSettings(accessoryType: .disclosureIndicator)
    }
    
    var articleTypeLabelSettings: LabelSettings {
        return LabelSettings(numberOfLines: 1,
                             textAlignment: .left,
                             fontSize: 13,
                             fontWeight: .bold)
    }
    
    var articleType: String {
        return dependencies.article.type.rawValue.capitalized
    }
    
    var headlineLabelSettings: LabelSettings {
        return LabelSettings(numberOfLines: 0,
                             textAlignment: .left,
                             fontSize: 15,
                             fontWeight: .light)
    }
    
    var headline: String {
        return dependencies.article.headline
    }
    
    var articleImageViewSettings: ImageViewSettings {
        return ImageViewSettings(contentMode: .scaleAspectFill,
                                 roundImage: true,
                                 accessibilityText: dependencies.article.leadMedia.attributes.caption)
    }
    
    var isBookmarked: Bool {
        UserDefaults.standard.bool(forKey: dependencies.article.id)
    }
    
    // MARK: - Bindings

    var leadMediaBind: ((Data?) -> Void)?
    
    // MARK: - Dependencies

    struct Dependencies {
        let article: Article
    }
    
    // MARK: - Init / Deinit

    init(dependencies: NewsTableCellViewModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Public Methods

    func getLeadMedia() {
        Task { [weak self] in
            guard let self = self else { return }
            guard let leadMediaURL = dependencies.article.leadMedia.attributes.url, let url = URL(string: leadMediaURL) else { return }
            let imageData = try await imageAPIService.getImageData(for: url)
            self.leadMediaBind?(imageData)
        }
    }
    
    func toggleBookmark() {
        var isBookmarked = UserDefaults.standard.bool(forKey: dependencies.article.id)
        
        isBookmarked.toggle()
    
        UserDefaults.standard.set(isBookmarked, forKey: dependencies.article.id)
    }
}
