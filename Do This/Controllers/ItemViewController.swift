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
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var categoryColor: UIColor {
        return UIColor(hexString: selectedCategory!.colorHexValue) ?? FlatSkyBlue()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        searchBar.barTintColor = categoryColor
        let contrastingColor = ContrastColorOf(categoryColor, returnFlat: true)
        let contrastingColorAttribute = [NSAttributedStringKey.foregroundColor: contrastingColor]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = categoryColor
            navBar.tintColor = contrastingColor
            navBar.largeTitleTextAttributes = contrastingColorAttribute
            navBar.titleTextAttributes = contrastingColorAttribute
        }
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let item = items?[indexPath.row] else { fatalError() }
        let cellTitle = NSMutableAttributedString(string: item.title)
        if item.done {
            cellTitle.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: item.title.count))
            cell.imageView?.image = UIImage(named: "Checked_Checkbox_Icon")
        } else {
            cell.imageView?.image = UIImage(named: "Unchecked_Checkbox_Icon")
        }
        cell.backgroundColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
        cell.textLabel?.attributedText = cellTitle
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
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
                print("Error changing item done property \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To List", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { _ in
            if textField.text! != "" {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.timeCreated = Date()
                self.save(item: newItem)
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
    
    // MARK: - Data Manipulation Methods
    
    func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
                selectedCategory?.items.append(item)
            }
        } catch {
            print("Error saving item \(error)")
        }

    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "timeCreated", ascending: true)
        tableView.reloadData()
    }
    
    func edit(item: Item, newName: String? = nil) {
        do {
            try realm.write {
                if let newName = newName {
                    item.title = newName
                }
                realm.add(item)
            }
        } catch {
            print("Error editing item \(error)")
        }
    }
    
    override func deleteFromModel(at indexPath: IndexPath) {
        if let item = selectedCategory?.items[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
    // MARK: - Editing Item Methods
    
    override func editName(at indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item Name:", message: nil, preferredStyle: .alert)
        let editItemNameAction = UIAlertAction(title: "Save", style: .default) { _ in
            if textField.text! != "" {
                guard let item = self.items?[indexPath.row] else { fatalError() }
                self.edit(item: item, newName: textField.text!)
                let cell = self.tableView.cellForRow(at: indexPath) as! SwipeTableViewCell // swiftlint:disable:this force_cast
                cell.hideSwipe(animated: true)
                // Wait to reload tableView so hiding swipe is visible
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(editItemNameAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "New Name"
        }
        present(alert, animated: true)
    }

}

// MARK: - SearchBar Delegate Methods

extension ItemViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Hide keyboard if user clicks on the searchBar "x"
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
    
}
