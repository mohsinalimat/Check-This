//
//  CategoryVC+DataManipulation.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/24/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift

extension CategoryVC {
    
    // MARK: - Data Methods
    
    func save(_ category: Category) {
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
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "indexForSorting", ascending: true)
        tableView.reloadData()
    }
    
    func edit(category: Category, newName: String? = nil, newColorHex: String? = nil) {
        do {
            try realm.write {
                if let newName = newName {
                    category.name = newName
                }
                if let newColorHex = newColorHex {
                    category.colorHexValue = newColorHex
                }
                realm.add(category)
            }
        } catch {
            fatalError("Error editing category \(error)")
        }
    }
    
    func moveCategory(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let categoryBeingMoved = categories?[sourceIndexPath.row]
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in (sourceIndexPath.row + 1)...destinationIndexPath.row {
                        categories?[index].indexForSorting -= 1
                    }
                } else if sourceIndexPath.row > destinationIndexPath.row {
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
        resetCategoriesIndexForSorting()
    }
    
}
