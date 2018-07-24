//
//  ItemVC+SearchBar.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/9/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

// MARK: - Search Bar Delegate Methods

extension ItemVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
        } else {
            items = selectedCategory?.items.filter("name CONTAINS[cd] %@", searchText)
            tableView.reloadData()
        }
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
    }
    
}
