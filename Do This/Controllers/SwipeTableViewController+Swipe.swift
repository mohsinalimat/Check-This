//
//  SwipeTableViewController+Swipe.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/9/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import SwipeCellKit

// MARK: - SwipeTableViewCell Delegate Methods

extension CustomTableVC: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        var actions = [SwipeAction]()
        let swipeToEditDescription: String? = self is CategoryViewController ? "Edit" : nil
        let swipeToDeleteDescription: String? = self is CategoryViewController ? "Delete" : nil
        
        let editAction = SwipeAction(style: .default, title: swipeToEditDescription) { _, indexPath in
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.presentEditAlertController(at: indexPath)
        }
        let deleteAction = SwipeAction(style: .destructive, title: swipeToDeleteDescription) { _, indexPath in
            self.deleteFromModel(at: indexPath)
            self.setTableViewBackground()
        }

        deleteAction.image = UIImage(named: "Delete_Icon")
        editAction.image = UIImage(named: "More_Icon")
        actions.append(deleteAction)
        actions.append(editAction)

        return actions
    }

    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        options.expansionStyle = .destructive
        return options
    }
    
}
