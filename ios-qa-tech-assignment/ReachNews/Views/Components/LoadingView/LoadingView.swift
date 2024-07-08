//
//  LoadingView.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 01/10/2022.
//

import UIKit

class LoadingView: UIView {
    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var loadingLabel: UILabel!
    
    // MARK: - Private Properties

    private let viewModel: LoadingViewViewModel
    
    // MARK: - Init / Deinit

    init(viewModel: LoadingViewViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: viewModel.loadingFrame)
        self.setupXib()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Life Cycle

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupXib()
    }
    
    // MARK: - Public Methods

    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isHidden = true
        }
    }
    
    // MARK: - Private Methods

    private func loadViewFromXib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupXib() {
        if self.contentView == nil {
            guard let contentView = loadViewFromXib() else {
                fatalError("Can't load the view from \(String(describing: type(of: self))).xib")
            }
            
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(contentView)
            self.contentView = contentView
            
            self.loadingLabel.text = self.viewModel.loadingText
            
            self.stopLoading()
            
            self.layoutIfNeeded()
        }
    }
}
