//
//  SwipeTableViewController+Swipe.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/9/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation
import SwipeCellKit

// MARK: - SwipeTableViewCell Delegate Methods

extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        var actions = [SwipeAction]()
        
        let deleteAction = SwipeAction(style: .destructive, title: swipeToDeleteTextDescription) { _, indexPath in
            self.deleteFromModel(at: indexPath)
            self.setTableViewBackground()
        }
        let editAction = SwipeAction(style: .default, title: swipeToEditTextDescription) { _, indexPath in
            self.present(self.editAlertController(for: indexPath), animated: true)
        }
        
        deleteAction.image = UIImage(named: "Delete_Icon")
        editAction.image = UIImage(named: "More_Icon")
        actions.append(deleteAction)
        actions.append(editAction)
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions { // swiftlint:disable:this line_length
        var options = SwipeOptions()
        options.transitionStyle = .border
        options.expansionStyle = .destructive
        return options
    }
    
}
