//
//  ItemViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class ItemViewController: SwipeTableViewController {

    var items: Results<Item>?
    let realm = try! Realm() // swiftlint:disable:this force_try
    var searchController: UISearchController?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var categoryColor: UIColor {
        return UIColor(hexString: selectedCategory!.colorHexValue) ?? FlatSkyBlue()
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewBackground()
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationController()
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let item = items?[indexPath.row] else { fatalError() }
        let cellTitle = NSMutableAttributedString(string: item.name)
        if item.done {
            cellTitle.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSRange(location: 0, length: cellTitle.length))
            cell.imageView?.image = UIImage(named: "Checked_Checkbox_Icon")
        } else {
            cell.imageView?.image = UIImage(named: "Unchecked_Checkbox_Icon")
        }
        cell.backgroundColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
        cell.textLabel?.attributedText = cellTitle
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        move(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                fatalError("Error changing item done property \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { _ in
            if textField.text! != "" {
                let newItem = Item()
                newItem.name = textField.text!
                newItem.timeCreated = Date()
                self.save(item: newItem)
                self.setTableViewBackground()
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "New Item"
        }
        present(alert, animated: true)
    }
    
    // MARK: - Edit Item Methods
    
    override func editNameAlertController(at indexPath: IndexPath) -> UIAlertController {
        guard let itemAtIndexPath = self.items?[indexPath.row] else { fatalError() }
        var textField = UITextField()
        let alertController = UIAlertController(title: "Edit Item Name:", message: nil, preferredStyle: .alert)
        let editItemNameAction = UIAlertAction(title: "Save", style: .default) { _ in
            self.edit(item: itemAtIndexPath, newName: textField.text!)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
            cell.hideSwipe(animated: true)
            // Wait to reload tableView so hiding swipe is visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(editItemNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = itemAtIndexPath.name
        }
        return alertController
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
                if let items = items {
                    item.indexForSorting = items.count
                }
                selectedCategory?.items.append(item)
            }
        } catch {
            fatalError("Error saving item \(error)")
        }

    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "indexForSorting", ascending: true)
        tableView.reloadData()
    }
    
    override func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let itemBeingMoved = items?[sourceIndexPath.row]
                if sourceIndexPath.row < destinationIndexPath.row { // If item is moving down in the tableView
                    for index in (sourceIndexPath.row + 1)...destinationIndexPath.row {
                        let item = items?[index]
                        item?.indexForSorting -= 1
                    }
                } else if sourceIndexPath.row > destinationIndexPath.row { // If item is moving up in the tableView
                    for index in destinationIndexPath.row..<sourceIndexPath.row {
                        items?[index].indexForSorting += 1
                    }
                }
                itemBeingMoved?.indexForSorting = destinationIndexPath.row
            }
        } catch {
            fatalError("Error moving item to new indexPath \(error)")
        }
    }
    
    func edit(item: Item, newName: String? = nil) {
        do {
            try realm.write {
                if let newName = newName {
                    item.name = newName
                }
                realm.add(item)
            }
        } catch {
            fatalError("Error editing item \(error)")
        }
    }
    
    override func deleteFromModel(at indexPath: IndexPath) {
        if let item = selectedCategory?.items[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                fatalError("Error deleting item \(error)")
            }
        }
        resetItemsIndexForSorting()
    }
    
    func resetItemsIndexForSorting() {
        if let items = items {
            var indexForSorting = 0
            for item in items {
                do {
                    try realm.write {
                        item.indexForSorting = indexForSorting
                    }
                } catch {
                    fatalError("Error resetting item indexForSorting \(error)")
                }
                indexForSorting += 1
            }
        }
    }
    
    // MARK: - Navigation Controller Setup
    
    func setUpNavigationController() {
        title = selectedCategory?.name
        let contrastingColor = ContrastColorOf(categoryColor, returnFlat: true)
        let contrastingColorAttribute = [NSAttributedStringKey.foregroundColor: contrastingColor]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = categoryColor
            navBar.tintColor = contrastingColor
            navBar.largeTitleTextAttributes = contrastingColorAttribute
            navBar.titleTextAttributes = contrastingColorAttribute
        }
    }
    
    // MARK: - Set Up Table View Appearance
    
    override func setTableViewBackground() {
        tableView.backgroundView = UIView(frame: UIScreen.main.bounds)
        tableView.backgroundView?.backgroundColor = categoryColor.withAlphaComponent(0.1)
        if let numberOfItems = items?.count {
            if numberOfItems == 0 {
                let instructions = "Add a new item to\nyour to-do list using\nthe + button."
                let instructionsLabel = labelWith(instructions)
                tableView.backgroundView?.addSubview(instructionsLabel)
            }
        }
    }
    
    // MARK: - Set Up Search Bar
    
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
        searchBar.placeholder = "Search"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
            }
        }
    }

}
