//
//  ItemViewController+SearchBar.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/9/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

// MARK: - Search Bar Delegate Methods

extension ItemViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
        } else {
            items = selectedCategory?.items.filter("name CONTAINS[cd] %@", searchBar.text!)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        print("\nsearchBarSearchButtonClicked called")
    }
    
}
