//
//  CustomTableVC+Swipe.swift
//  Check This
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
        
        switch orientation {
        case .right:
            
            // If the user is searching for an item, they can cross it out, but
            // can't open the swipe menu to edit or delete. Deleting while
            // searching deletes the wrong item.
            if presentedViewController != nil { return nil }
            
            var actions = [SwipeAction]()
            let swipeToEditDescription: String? = self is CategoryVC ? "Edit" : nil
            let swipeToDeleteDescription: String? = self is CategoryVC ? "Delete" : nil
            
            let editAction = SwipeAction(style: .default, title: swipeToEditDescription) { _, indexPath in
                tableView.cellForRow(at: indexPath)?.selectionStyle = .none
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                self.presentEditAlertController(at: indexPath)
            }
            
            let deleteAction = SwipeAction(style: .destructive, title: swipeToDeleteDescription) { _, indexPath in
                self.delegate.deleteElement(at: indexPath)
                self.delegate.resetIndexes()
                self.delegate.setTableViewAppearance()
            }
            
            deleteAction.image = UIImage(named: "Delete_Icon")
            editAction.image = UIImage(named: "More_Icon")
            actions.append(deleteAction)
            actions.append(editAction)
            return actions
            
        case .left:
            // Pops view controller if user swipes from the left edge of the
            // cell only if user is not using the search bar.
            if presentedViewController == nil {
                navigationController?.popViewController(animated: true)
            }
            return nil
        }
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
