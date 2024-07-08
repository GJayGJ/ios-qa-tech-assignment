//
//  NewsListViewController.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import UIKit

class NewsListViewController: BaseViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties

    private var viewModel: NewsListViewModel
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init / Deinit

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: Self.classString(), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
        
        self.setupPullToRefresh()
        self.viewModel.start()
        self.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.resort()
        self.tableView.reloadData()
    }
    
    // MARK: - Overrides

    override func setupUI() {
        self.title = self.viewModel.title
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: NewsTableCell.classString(), bundle: nil), forCellReuseIdentifier: NewsTableCell.classString())
        
        let menu = UIMenu(children: [
            UIAction(title: "Ascending By Date", handler: { [unowned self] _ in
                self.viewModel.sort(mode: .date)
            }),
            UIAction(title: "Alphabetically By Category", handler: { [unowned self] _ in
                self.viewModel.sort(mode: .category)
            }),
            UIAction(title: "Alphabetically By Title", handler: { [unowned self] _ in
                self.viewModel.sort(mode: .title)
            }),
            UIAction(title: "By Bookmarks", handler: { [unowned self] _ in
                self.viewModel.sort(mode: .bookmarkedStatus)
            }),
        ])
        
        let rightItem = UIBarButtonItem(title: "Sort", image: UIImage(systemName: "list.number"), menu: menu)
        
        navigationItem.rightBarButtonItem = rightItem
        
        self.tableView.accessibilityIdentifier = "newsListTable"
    }
    
    override func setupBindings() {
        self.viewModel.setupUIBinding = {
            // Do more stuff after setupUIBinding
        }
        
        self.viewModel.updateUIBind = { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopLoading()
                self.refreshControl.endRefreshing()
            }
        }
        
        self.viewModel.newsErrorBind = { [unowned self] errorMessage in
            
            DispatchQueue.main.async {
                self.displayDefaultAlert(message: errorMessage) { [unowned self] _ in
                    self.getNews()
                }
            }
        }
    }
    
    // MARK: - Private Methods

    private func setupPullToRefresh() {
        self.refreshControl.attributedTitle = NSAttributedString(string: self.viewModel.pullToRefreshTitle)
        self.refreshControl.addTarget(self, action: #selector(self.getNews), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc private func getNews() {
        self.startLoading()
        self.viewModel.getNews()
    }
}

// MARK: - Table View Methods

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.classString()) as? NewsTableCell,
              let newsCellViewModel = self.viewModel.cellViewModel(at: indexPath) else { return UITableViewCell() }
        
        newsCell.accessibilityIdentifier = "article\(indexPath.row)"
        newsCell.inject(viewModel: newsCellViewModel)
        
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let newsDetailsVieWModel = self.viewModel.newsDetailsViewModel(at: indexPath) else { return }
        
        let newsDetailsViewController = NewsDetailsViewController(viewModel: newsDetailsVieWModel)
        
        self.navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
}
