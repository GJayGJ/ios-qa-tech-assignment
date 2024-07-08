//
//  NewsTableCell.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import UIKit

class NewsTableCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet private var articleImageView: UIImageView!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var articleTypeLabel: UILabel!
    @IBOutlet private var toggleBookmarkButton: UIButton!
    
    // MARK: - Private Properties

    private var viewModel: NewsTableCellViewModel!
    
    // MARK: - Init / Deinit

    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        self.toggleBookmarkButton.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.toggleBookmark()
            self?.configureBookmark()
        }), for: .touchUpInside)
    }
    
    // MARK: - Public Methods

    func inject(viewModel: NewsTableCellViewModel) {
        self.viewModel = viewModel
        
        self.articleTypeLabel.setupLabelSettings(viewModel.articleTypeLabelSettings)
        self.articleTypeLabel.text = viewModel.articleType
        
        self.headlineLabel.setupLabelSettings(viewModel.headlineLabelSettings)
        self.headlineLabel.text = viewModel.headline
        
        self.setupTableCellSettings(viewModel.cellSettings)
        
        self.articleImageView.setupImageViewSettings(viewModel.articleImageViewSettings)
        
        self.configureBookmark()
        
        self.setupBindings()
        self.viewModel?.getLeadMedia()
    }
    
    func configureBookmark() {
        let name = self.viewModel.isBookmarked ? "bookmark.fill" : "bookmark"
        self.toggleBookmarkButton.accessibilityIdentifier = self.viewModel.isBookmarked ? "removeBookmarkButton" : "addBookmarkButton"
        self.toggleBookmarkButton.configuration?.image = UIImage(systemName: name)?.applyingSymbolConfiguration(.init(scale: .small))
    }
    
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.leadMediaBind = { [weak self] imageData in
            
            DispatchQueue.main.async {
                self?.articleImageView.image = imageData.toImage()
            }
        }
    }
}
