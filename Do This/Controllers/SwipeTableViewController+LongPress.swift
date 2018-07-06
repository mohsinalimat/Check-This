//
//  SwipeTableViewController+LongPress.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/6/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

// MARK: - Long Press Gesture
extension SwipeTableViewController: UIGestureRecognizerDelegate {
    
    func setupTableViewLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                presentEditAlert(for: indexPath)
            }
        }
    }
    
}
