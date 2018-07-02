//
//  ToDoListViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

    var items: Results<Item>?
    let realm = try! Realm() // swiftlint:disable:this force_try
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
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
            alertTextField.placeholder = "Create New Item"
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

}

// MARK: - SearchBar Delegate Methods

extension ToDoListViewController: UISearchBarDelegate {
    
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
