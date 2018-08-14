//
//  CategoryVC+DataManipulation.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/24/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift

extension CategoryVC {
    
    // MARK: - Create Data Methods
    
    /// Saves a new category to the database.
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
                if let categories = categories {
                    category.persistedIndexRow = categories.count - 1
                }
            }
        } catch {
            fatalError("Error saving category \(error)")
        }
    }
    
    // MARK: - Read Data Methods
    
    /// Loads all of the user's categories in the table view.
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "persistedIndexRow", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Update Data Methods
    
    /// Edit the provided category's name.
    func edit(category: Category, newName: String) {
        do {
            try realm.write {
                category.name = newName
            }
        } catch {
            fatalError("Error editing category name \(error)")
        }
    }
    
    /// Edits the provided category's colorHexValue.
    func edit(category: Category, newColorHex: String) {
        do {
            try realm.write {
                category.colorHexValue = newColorHex
            }
        } catch {
            fatalError("Error editing category colorHexValue \(error)")
        }
    }
    
    /// Moves a category from the sourceIndexPath to the destinationIndexPath.
    func moveCategory(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let categoryBeingMoved = categories?[sourceIndexPath.row]
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in (sourceIndexPath.row + 1)...destinationIndexPath.row {
                        categories?[index].persistedIndexRow -= 1
                    }
                } else if sourceIndexPath.row > destinationIndexPath.row {
                    for index in destinationIndexPath.row..<sourceIndexPath.row {
                        categories?[index].persistedIndexRow += 1
                    }
                }
                categoryBeingMoved?.persistedIndexRow = destinationIndexPath.row
            }
        } catch {
            fatalError("Error moving category to new indexPath \(error)")
        }
    }
    
    /// Resets the persistedIndexRow property of the categories to match the
    /// index in the table view.
    func resetCategoriesPersistedIndexRow() {
        if let categories = categories {
            var index = 0
            for category in categories {
                do {
                    try realm.write {
                        category.persistedIndexRow = index
                        
                    }
                } catch {
                    fatalError("Error resetting category persistedIndexRow \(error)")
                }
                index += 1
            }
        }
    }
    
    // MARK: - Delete Data Methods
    
    /// Deletes the category at the given indexPath.
    func deleteCategory(at indexPath: IndexPath) {
        if let categoryToBeDeleted = self.categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToBeDeleted.items)
                    realm.delete(categoryToBeDeleted)
                }
            } catch {
                fatalError("Error deleting category \(error)")
            }
        }
    }
    
}
