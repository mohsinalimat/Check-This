//
//  CategoryAlerts.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

struct CategoryAlerts {
    
    // MARK: - Alerts Methods For CategoryViewController
    
    static func editCategoryAlertController(from categoryVC: CategoryViewController, at indexPath: IndexPath) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editNameAction = CategoryAlerts.editCategoryNameAction(from: categoryVC, at: indexPath)
        let editColorAction = CategoryAlerts.editCategoryColorAction(from: categoryVC)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editNameAction)
        alertController.addAction(editColorAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    static func editCategoryNameAction(from categoryVC: CategoryViewController, at indexPath: IndexPath) -> UIAlertAction {
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { (_) in
            let editNameAlertController = CategoryAlerts.categoryEditNameAlertController(on: categoryVC, at: indexPath)
            categoryVC.present(editNameAlertController, animated: true)
        }
        return editNameAction
    }
    
    static func editCategoryColorAction(from categoryVC: CategoryViewController) -> UIAlertAction {
        let editColorAction = UIAlertAction(title: "Change Color", style: .default) { (_) in
            categoryVC.performSegue(withIdentifier: "goToColorPickerVC", sender: categoryVC)
        }
        return editColorAction
    }
    
    static func categoryEditNameAlertController(on categoryVC: CategoryViewController, at indexPath: IndexPath) -> UIAlertController {
        let categoryAtIndexPath = categoryVC.categories![indexPath.row]
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Edit Category Name:", message: nil, preferredStyle: .alert)
        
        let editCategoryNameAction = UIAlertAction(title: "Save", style: .default) { (_) in
            categoryVC.edit(category: categoryAtIndexPath, newName: textField.text!)
            guard let cell = categoryVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError()}
            cell.hideSwipe(animated: true)
            Utilities.waitForSwipeAnimationThenReloadTableViewFor(categoryVC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editCategoryNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = categoryAtIndexPath.name
        }
        
        return alertController
    }
    
}
