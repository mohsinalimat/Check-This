//
//  CustomTableVC.swift
//  Check This
//
//  Created by Luis M Gonzalez on 6/29/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import SwipeCellKit

protocol CustomTableDelegate: class {
    func moveElement(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func deleteElement(at indexPath: IndexPath)
    func resetIndexes()
    func setTableViewAppearance()
}

class CustomTableVC: UITableViewController {

    weak var delegate: CustomTableDelegate!
    
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
        cell.selectionStyle = .none
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate.moveElement(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - Alert Methods
    
    /// Presents alert to edit item or category.
    func presentEditAlertController(at indexPath: IndexPath) {
        if let categoryVC = self as? CategoryVC {
            presentAlertController(CategoryAlerts.editCategoryAlertController(from: categoryVC, at: indexPath))
        } else if let itemVC = self as? ItemVC {
            presentAlertController(ItemAlerts.editItemAlertController(from: itemVC, at: indexPath))
        }
    }
    
    /// Presents alert controller from either self or from the presented view
    /// controller, if user is using search bar.
    func presentAlertController(_ alertController: UIAlertController) {
        if let presentedVC = self.presentedViewController {
            presentedVC.present(alertController, animated: true)
        } else {
            present(alertController, animated: true)
        }
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
    
    /// Returns the number of lines there are in the given string.
    func numberOfLines(in string: String) -> Int {
        var numberOfLinesCount = 0
        string.enumerateLines { (_, _) in
            numberOfLinesCount += 1
        }
        return numberOfLinesCount
    }
    
}
