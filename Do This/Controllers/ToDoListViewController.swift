//
//  ToDoListViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = itemArray[indexPath.row]
        selectedItem.done = !selectedItem.done
        saveItems()
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To List", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
//                let newItem = Item(context: self.context)
//                newItem.title = textField.text!
//                newItem.done = false
//                newItem.parentCategory = self.selectedCategory
//                self.itemArray.append(newItem)
                self.saveItems()
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
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems() {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = additionalPredicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar Delegate Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request, additionalPredicate: predicate)
        }
    }
    
}
