//
//  ItemVC+CustomTable.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/23/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation

extension ItemVC: CustomTableDelegate {

    func moveElement(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Moves element only if user is not performing a search.
        if presentedViewController == nil {
            moveItem(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    func deleteElement(at indexPath: IndexPath) {
        deleteItem(at: indexPath)
    }
    
    func resetIndexes() {
        resetItemsPersistedIndexRow()
    }
    
    func setTableViewAppearance() {
        setItemTableViewAppearance()
    }
    
}
