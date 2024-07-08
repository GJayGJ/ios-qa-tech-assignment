//
//  NewsListViewModel.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

class NewsListViewModel: BaseViewModel {
    @Injected(\.newsAPIService) var newsAPIService: NewsAPIService
    
    // MARK: - Private Properties
    private var articles: [Article]?
    
    // MARK: - Public Properties

    var pullToRefreshTitle: String {
        return Localized("refreshControl_title")
    }
    
    // MARK: - Bindings

    var updateUIBind: (() -> Void)?
    var newsErrorBind: ((String) -> Void)?
    
    // MARK: - Overrides

    override var title: String {
        return Localized("newsList_title")
    }
    
    override func start() {
        // Do more stuff to start the view
        
        setupUIBinding?()
    }
    
    // MARK: - Public Methods

    func getNews() {
        Task {
            do {
                let retrievedArticles = try await newsAPIService.getNewsData()
                self.articles = retrievedArticles
                self.sort(mode: self.currentSortMode)
                self.updateUIBind?()
            } catch {
                self.newsErrorBind?(error.localizedDescription)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return articles?.count ?? 0
    }
    
    func cellViewModel(at index: IndexPath) -> NewsTableCellViewModel? {
        guard let article = articles?[safe: index.row] else { return nil }
        
        let newsTableCellViewModelDependencies = NewsTableCellViewModel.Dependencies(article: article)
        return NewsTableCellViewModel(dependencies: newsTableCellViewModelDependencies)
    }
    
    func newsDetailsViewModel(at index: IndexPath) -> NewsDetailsViewModel? {
        guard let article = articles?[safe: index.row] else { return nil }
        
        let newsDetailsViewModelDependencies = NewsDetailsViewModel.Dependencies(article: article)
        return NewsDetailsViewModel(dependencies: newsDetailsViewModelDependencies)
    }
    
    enum SortMode {
        case date, category, title, bookmarkedStatus
    }
    
    var currentSortMode = SortMode.date
    
    func sort(mode: SortMode) {
        currentSortMode = mode
        switch mode {
        case .category:
            articles?.sort(by: { a1, a2 in
                a1.type.rawValue < a2.type.rawValue
            })
        case .title:
            articles?.sort(by: { a1, a2 in
                a1.headline < a2.headline
            })
            
        case .bookmarkedStatus:
            articles = articles?.sorted(by: { a1, a2 in
                a1.id < a2.id // no date in this mini api, faking it
            }).sorted(by: { a1, a2 in
                UserDefaults.standard.bool(forKey: a1.id) > UserDefaults.standard.bool(forKey: a2.id)
            })
            
        case .date:
            articles?.sort(by: { a1, a2 in
                a1.id < a2.id // no date in this mini api, faking it
            })
        }
        
        updateUIBind?()
    }
    
    func resort() {
        sort(mode: currentSortMode)
    }
}

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        let lhsint = lhs ? 1 : 0
        let rhsint = rhs ? 1 : 0
        
        return lhsint <= rhsint
    }
}
