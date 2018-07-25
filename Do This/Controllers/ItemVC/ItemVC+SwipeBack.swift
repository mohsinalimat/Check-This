//
//  ItemVC+SwipeBack.swift
//  Do This
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

    @objc func handleScreenEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
