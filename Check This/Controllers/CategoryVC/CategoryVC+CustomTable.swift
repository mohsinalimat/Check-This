//
//  CategoryVC+CustomTable.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/23/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation

extension CategoryVC: CustomTableDelegate {
    
    func moveElement(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveCategory(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    func deleteElement(at indexPath: IndexPath) {
        deleteCategory(at: indexPath)
    }
    
    func resetIndexes() {
        resetCategoriesPersistedIndexRow()
    }
    
    func setTableViewAppearance() {
        setCategoryTableViewAppearance()
    }
    
}
