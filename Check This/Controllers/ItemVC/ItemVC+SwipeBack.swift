//
//  ItemVC+SwipeBack.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/24/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

extension ItemVC {
    
    func setUpSwipeToNavigateBack() {
        let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePanGesture))
        screenEdgePanGesture.edges = .left
        view.addGestureRecognizer(screenEdgePanGesture)
    }

    /// Pops view controller if user swipes from the left edge of the view
    /// only if user is not using the search bar. (swiping a table view cell
    /// handled by CustomTableVC+Swipe.swift)
    @objc func handleScreenEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized && presentedViewController == nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
