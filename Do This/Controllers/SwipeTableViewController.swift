//
//  SwipeTableViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/29/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {
    
    // Text descriptions for swipe options to be set by subclasses if needed
    var swipeToDeleteTextDescription: String?
    var swipeToEditTextDescription: String?

    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setUpTableViewLongPressGesture()
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell // swiftlint:disable:this force_cast
        cell.delegate = self
        return cell
    }
    
    // MARK: - Alert Methods for Editing
    
    func editAlertController(for indexPath: IndexPath) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editNameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            self.present(self.editNameAlertController(at: indexPath), animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(editNameAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    // MARK: - Methods to be overwritten by sublasses
    
    func deleteFromModel(at indexPath: IndexPath) {
        fatalError("Subclass must override this method")
    }
    
    func editNameAlertController(at indexPath: IndexPath) -> UIAlertController {
        fatalError("Subclass must override this method")
    }
    
    func setTableViewBackground() {
        fatalError("Subclass must override this method")
    }
    
}
