//
//  LoadingViewViewModel.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 01/10/2022.
//

import CoreGraphics
import Foundation

class LoadingViewViewModel {
    // MARK: - Private Properties

    private let dependencies: LoadingViewViewModel.Dependencies
    
    // MARK: - Public Properties

    var loadingFrame: CGRect {
        return self.dependencies.frame
    }
    
    var loadingText: String {
        return self.dependencies.loadingText ?? Localized("loadingView_text")
    }
    
    // MARK: - Dependencies

    struct Dependencies {
        let frame: CGRect
        let loadingText: String? = nil
    }
    
    // MARK: - Init / Deinit

    init(dependencies: LoadingViewViewModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
}
