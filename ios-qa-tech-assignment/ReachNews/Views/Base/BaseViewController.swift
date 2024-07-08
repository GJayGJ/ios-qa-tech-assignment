//
//  BaseViewController.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import UIKit

protocol BaseViewControllerProtocol {
    func setupUI()
    func setupBindings()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    // MARK: - Private Properties

    private var loadingView: LoadingView = {
        let loadingViewViewModelDependencies = LoadingViewViewModel.Dependencies(frame: UIScreen.main.bounds)
        let loadinViewViewModel = LoadingViewViewModel(dependencies: loadingViewViewModelDependencies)
        
        return LoadingView(viewModel: loadinViewViewModel)
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoadingView()
        self.setupUI()
    }
    
    // MARK: - Init / Deinit

    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Public Methods

    func setupUI() {
        assertionFailure("Must be implemented in inherited classes")
    }
    
    func setupBindings() {
        assertionFailure("Must be implemented in inherited classes")
    }
    
    func displayDefaultAlert(title: String = Localized("alert_title"), message: String = Localized("alert_message"), okAction: ((UIAlertAction) -> Void)? = nil, retryAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Localized("alert_okButton"), style: .default, handler: (okAction ?? { _ in
            self.stopLoading()
        }))
        alert.addAction(okAction)
        
        let retryAction = UIAlertAction(title: Localized("alert_retryButton"), style: .default, handler: retryAction)
        alert.addAction(retryAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        self.loadingView.startLoading()
    }
    
    func stopLoading() {
        self.loadingView.stopLoading()
    }
    
    // MARK: - Private Methods

    private func setupLoadingView() {
        self.view.addSubview(self.loadingView)
        self.view.bringSubviewToFront(self.loadingView)
    }
}
