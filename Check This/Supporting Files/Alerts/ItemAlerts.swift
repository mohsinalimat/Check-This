//
//  ItemAlerts.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

struct ItemAlerts {
    
    // MARK: - Alerts Methods For ItemVC
    
    static func presentAlertToAddNewItem(from itemVC: ItemVC) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { _ in
            if !textField.text!.isEmpty {
                let newItem = Item()
                newItem.name = textField.text!
                newItem.timeCreated = Date()
                itemVC.save(newItem)
                itemVC.setTableViewAppearance()
                itemVC.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "New Item"
            alertTextField.autocorrectionType = .yes
        }
        itemVC.present(alert, animated: true)
    }
    
    static func editItemAlertController(from itemVC: ItemVC, at indexPath: IndexPath) -> UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editNameAction = ItemAlerts.editItemNameAction(from: itemVC, at: indexPath)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            guard let cell = itemVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(itemVC)
        }
        
        alertController.addAction(editNameAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = itemVC.view
            popoverController.sourceRect = CGRect(x: itemVC.view.bounds.midX, y: itemVC.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        return alertController
    }
    
    static func editItemNameAction(from itemVC: ItemVC, at indexPath: IndexPath) -> UIAlertAction {
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { (_) in
            let editNameAlertController = ItemAlerts.itemEditNameAlertController(on: itemVC, at: indexPath)
            if let presentedVC = itemVC.presentedViewController {
                presentedVC.present(editNameAlertController, animated: true)
            } else {
                itemVC.present(editNameAlertController, animated: true)
            }
        }
        return editNameAction
    }

    static func itemEditNameAlertController(on itemVC: ItemVC, at indexPath: IndexPath) -> UIAlertController {
        let itemAtIndexPath = itemVC.items![indexPath.row]
        guard let cell = itemVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Edit Item Name:", message: nil, preferredStyle: .alert)
        
        let editItemNameAction = UIAlertAction(title: "Save", style: .default) { (_) in
            itemVC.edit(item: itemAtIndexPath, newName: textField.text!)
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(itemVC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            cell.hideSwipe(animated: true)
            Utilities.reloadTableViewWithDelayIn(itemVC)
        }
        
        alertController.addAction(editItemNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = itemAtIndexPath.name
            alertTextField.autocorrectionType = .yes
        }
        
        return alertController
    }
    
}
