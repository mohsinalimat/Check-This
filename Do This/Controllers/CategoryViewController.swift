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

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() // swiftlint:disable:this force_try
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        swipeToDeleteTextDescription = "Delete"
        swipeToEditTextDescription = "Edit"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = UIColor(hexString: "0096FF")!
            navBar.tintColor = UIColor.white
            navBar.largeTitleTextAttributes = whiteAttribute
            navBar.titleTextAttributes = whiteAttribute
        }
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
        cell.accessoryView = chevronIconMatching(contrastingCategoryColor)
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToToDoListViewController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add New Items

    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addCategoryAction = UIAlertAction(title: "Add", style: .default) { _ in
            if textField.text! != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colorHexValue = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
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
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteFromModel(at indexPath: IndexPath) {
        if let categoryToBeDeleted = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToBeDeleted.items)
                    self.realm.delete(categoryToBeDeleted)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    func chevronIconMatching(_ contrastingCategoryColor: UIColor) -> UIImageView {
        let darkChevron = UIImageView(image: UIImage(named: "Dark_Chevron"))
        let lightChevron = UIImageView(image: UIImage(named: "Light_Chevron"))
        // The ContrastColorOf method from the ChameleonFramework returns a
        // color with a hexValue of either #EDF1F2 or #262626
        if contrastingCategoryColor.hexValue() == "#EDF1F2" {
            return lightChevron
        } else if contrastingCategoryColor.hexValue() == "#262626" {
            return darkChevron
        } else { fatalError() }
    }
    
}
