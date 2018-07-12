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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SwipeTableViewCell else { fatalError() }
        cell.delegate = self
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
    
    // MARK: - Label With Instructions Methods
    
    /// Returns a UILabel with instructions in the center of the tableView to
    /// be used when user hasn't created a category nor an item.
    /// - Parameters:
    ///     - instructions: A string that includes the instructions to display.
    ///                     Make sure to use line breaks (\n) for formatting.
    func labelWith(_ instructions: String) -> UILabel {
        let instructionsLabel = UILabel(frame: UIScreen.main.bounds)
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = instructions
        instructionsLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        instructionsLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        instructionsLabel.numberOfLines = numberOfLines(in: instructions)
        return instructionsLabel
    }
    
    func numberOfLines(in string: String) -> Int {
        var numberOfLinesCount = 0
        string.enumerateLines { (_, _) in
            numberOfLinesCount += 1
        }
        return numberOfLinesCount
    }
    
    // MARK: - Methods to be overwritten by sublasses
    
    func deleteFromModel(at indexPath: IndexPath) {
        fatalError("Subclass must override this method")
    }
    
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fatalError("Subclass must override this method")
    }
    
    func editNameAlertController(at indexPath: IndexPath) -> UIAlertController {
        fatalError("Subclass must override this method")
    }
    
    func setTableViewBackground() {
        fatalError("Subclass must override this method")
    }
    
}
