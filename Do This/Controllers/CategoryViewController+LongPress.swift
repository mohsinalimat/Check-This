//
//  CategoryViewController+LongPress.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/10/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

extension CategoryViewController: UIGestureRecognizerDelegate {
    
    func setUpTableViewLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            tableView.isEditing = !tableView.isEditing
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("indexPath.row: ", indexPath.row)
            }
        }
    }
    
}
