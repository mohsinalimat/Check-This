//
//  CategoryViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() // swiftlint:disable:this force_try
    var categories: Results<Category>?
    let defaultRandomColorOptions = [FlatRed(), FlatOrange(), FlatYellow(), FlatSand(), FlatMagenta(), FlatSkyBlue(), FlatGreen(), FlatMint(), FlatPurple(), FlatWatermelon(), FlatLime(), FlatPink()] // swiftlint:disable:this line_length
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCategories()
        setUpNavigationController()
        setUpTableViewAppearance()
        setUpTableViewLongPressGesture()
        setSwipeButtonsTextDescription()
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let category = categories?[indexPath.row] else { fatalError() }
        guard let categoryColor = UIColor(hexString: category.colorHexValue) else { fatalError() }
        let contrastingCategoryColor = ContrastColorOf(categoryColor, returnFlat: true)
        cell.textLabel?.text = category.name
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = contrastingCategoryColor
        cell.accessoryView = matchChevronIconTo(contrastingCategoryColor)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveCategory(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsViewController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add New Categories Methods

    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addCategoryAction = UIAlertAction(title: "Add", style: .default) { _ in
            if textField.text! != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colorHexValue = self.differentColorHexFromDefaultColors()
                self.save(category: newCategory)
                self.setTableViewBackground()
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addCategoryAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField .placeholder = "Category Name"
        }
        present(alert, animated: true)
    }
    
    // MARK: - Editing Category Methods
    
    override func editAlertController(for indexPath: IndexPath) -> UIAlertController {
        let alertController = super.editAlertController(for: indexPath)
        let actionToEditColor = UIAlertAction(title: "Change Color", style: .default) { _ in
            // What happens when user presses edit color in this editAlertController
        }
        alertController.addAction(actionToEditColor)
        return alertController
    }
    
    override func editNameAlertController(at indexPath: IndexPath) -> UIAlertController {
        var textField = UITextField()
        let alertController = UIAlertController(title: "New Category Name:", message: nil, preferredStyle: .alert)
        let editCategoryNameAction = UIAlertAction(title: "Save", style: .default) { _ in
            if textField.text! != "" {
                guard let category = self.categories?[indexPath.row] else { fatalError() }
                self.edit(category: category, newName: textField.text!)
                let cell = self.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell
                cell?.hideSwipe(animated: true)
                // Wait to reload tableView so hiding swipe is visible
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(editCategoryNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = self.categories?[indexPath.row].name
        }
        return alertController
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
                if let categories = categories {
                    category.indexForSorting = categories.count - 1
                }
            }
        } catch {
            fatalError("Error saving category \(error)")
        }
    }
    
    func moveCategory(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let categoryBeingMoved = categories?[sourceIndexPath.row]
                if sourceIndexPath.row < destinationIndexPath.row { // If category is moving down in the tableView
                    for index in (sourceIndexPath.row + 1)...destinationIndexPath.row {
                        let category = categories?[index]
                        category?.indexForSorting -= 1
                    }
                } else if sourceIndexPath.row > destinationIndexPath.row { // If category is moving up in the tableView
                    for index in destinationIndexPath.row..<sourceIndexPath.row {
                        categories?[index].indexForSorting += 1
                    }
                }
                categoryBeingMoved?.indexForSorting = destinationIndexPath.row
            }
        } catch {
            fatalError("Error moving category to new indexPath \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "indexForSorting", ascending: true)
        tableView.reloadData()
    }
    
    func edit(category: Category, newName: String? = nil, newColor: UIColor? = nil) {
        do {
            try realm.write {
                if let newName = newName {
                    category.name = newName
                }
                if let newColor = newColor {
                    category.colorHexValue = newColor.hexValue()
                }
                realm.add(category)
            }
        } catch {
            fatalError("Error editing category \(error)")
        }
    }
    
    override func deleteFromModel(at indexPath: IndexPath) {
        if let categoryToBeDeleted = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToBeDeleted.items)
                    self.realm.delete(categoryToBeDeleted)
                }
            } catch {
                fatalError("Error deleting category \(error)")
            }
        }
        resetCategoriesIndexForSorting()
    }
    
    func resetCategoriesIndexForSorting() {
        if let categories = categories {
            var indexForSorting = 0
            for category in categories {
                do {
                    try realm.write {
                        category.indexForSorting = indexForSorting
                        
                    }
                } catch {
                    fatalError("Error resetting category indexForSorting \(error)")
                }
                indexForSorting += 1
            }
        }
    }
    
    // MARK: - Navigation Controller Setup
    
    func setUpNavigationController() {
        let whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = UIColor(hexString: "0096FF")!
            navBar.tintColor = UIColor.white
            navBar.largeTitleTextAttributes = whiteAttribute
            navBar.titleTextAttributes = whiteAttribute
        }
    }
    
    // MARK: - Category Cell Accesory Setup
    
    func matchChevronIconTo(_ contrastingCategoryColor: UIColor) -> UIImageView {
        let darkChevron = UIImageView(image: UIImage(named: "Dark_Chevron_Icon"))
        let lightChevron = UIImageView(image: UIImage(named: "Light_Chevron_Icon"))
        // The ContrastColorOf method from the ChameleonFramework returns a
        // color with a hexValue of either #EDF1F2 or #262626
        if contrastingCategoryColor.hexValue() == "#EDF1F2" {
            return lightChevron
        } else if contrastingCategoryColor.hexValue() == "#262626" {
            return darkChevron
        } else { fatalError() }
    }
    
    func setSwipeButtonsTextDescription() {
        swipeToDeleteTextDescription = "Delete"
        swipeToEditTextDescription = "Edit"
    }
    
    // MARK: - Set up Table View Appearance
    
    func setUpTableViewAppearance() {
        tableView.rowHeight = 80
        setTableViewBackground()
    }
    
    override func setTableViewBackground() {
        if let numberOfCategories = categories?.count {
            if numberOfCategories == 0 {
                tableView.backgroundView = UIImageView(image: UIImage(named: "Default_Category_Background"))
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    
    // MARK: - Random Color Method For New Categories
    
    /// Returns the hex value of a random color from the defaultColors array
    /// that differs from the previos category color
    func differentColorHexFromDefaultColors() -> String {
        guard let numberOfCategories = categories?.count else { fatalError() }
        var randomHex = defaultRandomColorOptions[Int(arc4random_uniform(UInt32(self.defaultRandomColorOptions.count)))].hexValue()
        if numberOfCategories == 0 {
            return randomHex
        } else {
            while categories?.last?.colorHexValue == randomHex {
                randomHex = defaultRandomColorOptions[Int(arc4random_uniform(UInt32(self.defaultRandomColorOptions.count)))].hexValue()
            }
            return randomHex
        }
    }
    
}
