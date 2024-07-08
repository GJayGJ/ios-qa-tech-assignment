//
//  BaseViewModel.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

protocol BaseViewModelProtocol {
    var title: String { get }
    
    var setupUIBinding: (() -> Void)? { get set }
    
    func start()
}

class BaseViewModel: BaseViewModelProtocol {
    // MARK: - Public Properties

    var title: String {
        return Localized("defaultNavTitle")
    }
    
    // MARK: - Bindings

    var setupUIBinding: (() -> Void)?
    
    // MARK: - Init / Deinit

    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Public Methods

    func start() {
        assertionFailure("Must be implemented in inherited classes")
    }
}
