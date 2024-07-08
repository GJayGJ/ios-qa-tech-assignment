//
//  NewsDetailsViewController.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Combine
import UIKit

class NewsDetailsViewController: BaseViewController {
    // MARK: - Outlets

    @IBOutlet private var headlineImageView: UIImageView!
    @IBOutlet private var imageCreditLabel: UILabel!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var fullDescriptionLabel: UILabel!
    @IBOutlet private var tagButton: UIButton!
    
    @IBOutlet var toggleBookmarkButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - Private Properties

    private var viewModel: NewsDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var bookmarkImage: UIImage? {
        UIImage(systemName: self.viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
    }
    
    // MARK: - Init / Deinit

    init(viewModel: NewsDetailsViewModel) {
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
        
        setupBindings()
        viewModel.start()
    }
    
    // MARK: - Overrides

    override func setupUI() {
        title = viewModel.title
        
        headlineImageView.setupImageViewSettings(viewModel.articleImageViewSettings)
        headlineImageView.accessibilityIdentifier = "headlineImageView"
        headlineImageView.isAccessibilityElement = true
        
        imageCreditLabel.setupLabelSettings(viewModel.imageCreditLabelSettings)
        imageCreditLabel.text = viewModel.imageCredit
        imageCreditLabel.accessibilityIdentifier = "imageCreditLabel"
        imageCreditLabel.isAccessibilityElement = true
        
        headlineLabel.setupLabelSettings(viewModel.headlineLabelSettings)
        headlineLabel.text = viewModel.headline
        headlineLabel.accessibilityIdentifier = "headlineLabel"
        headlineLabel.isAccessibilityElement = true
        
        if viewModel.headline.contains("supermassive") {
            imageCreditLabel.isHidden = true
        }
        
        fullDescriptionLabel.setupLabelSettings(viewModel.fullDescriptionLabelSettings)
        fullDescriptionLabel.text = viewModel.fullDescription
        fullDescriptionLabel.accessibilityIdentifier = "bodyLabel"
        fullDescriptionLabel.isAccessibilityElement = true
        
        tagButton.configuration?.title = viewModel.tagName
        tagButton.accessibilityIdentifier = "tagButton"
        tagButton.isAccessibilityElement = true
        
        toggleBookmarkButton.configuration?.title = viewModel.isBookmarked ? "Remove From Bookmarks" : "Add To Bookmarks"
        
        toggleBookmarkButton.addAction(.init(handler: { [unowned self] _ in
            self.viewModel.toggleBookmark()
        }), for: .touchUpInside)
        
        toggleBookmarkButton.accessibilityIdentifier = "toggleBookmarkButton"
        
        scrollView.isAccessibilityElement = true
        scrollView.accessibilityIdentifier = "articleDetailScrollView"
        
        let item = UIBarButtonItem(title: "Save", image: bookmarkImage, primaryAction: UIAction(handler: { [weak self] _ in
            self?.viewModel.toggleBookmark()
        }))
        
        navigationItem.rightBarButtonItem = item
    }
    
    override func setupBindings() {
        viewModel.setupUIBinding = {
            // Do more stuff after setupUIBinding
        }
        
        viewModel.leadMediaBind = { [unowned self] imageData in
            
            DispatchQueue.main.async {
                self.headlineImageView.image = imageData?.toImage()
            }
        }
        
        viewModel.onBookmarkToggled.sink { [unowned self] _ in
            self.toggleBookmarkButton.configuration?.title = self.viewModel.isBookmarked ? "Remove From Bookmarks" : "Add To Bookmarks"
            self.navigationItem.rightBarButtonItem?.image = bookmarkImage
        }
        .store(in: &cancellables)
    }
}
