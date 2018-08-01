//
//  ItemVC+CustomTable.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/23/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation

extension ItemVC: CustomTableDelegate {

    /// Moves element only if user is not performing a search.
    func moveElement(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if presentedViewController == nil {
            moveItem(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    func deleteElement(at indexPath: IndexPath) {
//        print("\nDELETEELEMENT indexPath: \(indexPath)")
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        var persistedIndexRow = Int()
//        print("items?.count: \(String(describing: items?.count))")
//        for item in items! {
//            if item.name == selectedCell?.textLabel?.text { // swiftlint:disable:this for_where superfluous_disable_command
//                persistedIndexRow = item.persistedIndexRow
//                print("DELETEELEMENT IF IF IF persistedIndexRow: \(persistedIndexRow)")
//                return
//            }
////            else {
////                persistedIndexRow = selectedCategory!.items[indexPath.row].persistedIndexRow
////                print("DELETEELEMENT ELSE persistedIndexRow: \(persistedIndexRow)")
////            }
//        }
//
//        let persistedIndex = IndexPath(row: persistedIndexRow, section: 0)
//        deleteItem(at: persistedIndex)
        deleteItem(at: indexPath)
    }
    
    /// Resets Indexes only if user is not performing a search.
    func resetIndexes() {
        if presentedViewController == nil {
            resetItemsPersistedIndexRow()
        }
    }
    
    func setTableViewAppearance() {
        setItemTableViewAppearance()
    }
    
}
