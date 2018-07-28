//
//  CategoryVC.swift
//  Check This
//
//  Created by Luis M Gonzalez on 6/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift
import ChameleonFramework

class CategoryVC: CustomTableVC {
    
    let realm = try! Realm() // swiftlint:disable:this force_try
    var categories: Results<Category>?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCategories()
        setTableViewAppearance()
        Utilities.setUpBlueNavBarFor(self)
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let category = categories?[indexPath.row] else { fatalError() }
        let categoryColor = UIColor(hexString: category.colorHexValue) ?? .white
        let contrastingCategoryColor = ContrastColorOf(categoryColor, returnFlat: true)
        cell.textLabel?.text = category.name
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = contrastingCategoryColor
        cell.accessoryView = matchChevronIconTo(contrastingCategoryColor)
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError() }
        guard let selectedCategory = categories?[indexPath.row] else { fatalError() }
        switch segue.identifier {
        case "goToItemsVC":
            let itemsVC = segue.destination as? ItemVC
            itemsVC?.selectedCategory = selectedCategory
        case "goToColorPickerVC":
            guard let navigationController = segue.destination as? UINavigationController else { fatalError() }
            guard let colorPickerVC = navigationController.viewControllers.first as? ColorPickerViewController else { fatalError() }
            colorPickerVC.delegate = self
            colorPickerVC.selectedCategory = selectedCategory
        default:
            fatalError("Error: No matching segue identifiers found.")
        }
    }

    // MARK: - Add New Categories Methods

    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        CategoryAlerts.presentAlertToAddNewCategory(from: self)
    }
    
    // MARK: - Category Cell Accesory Setup
    
    func matchChevronIconTo(_ contrastingCategoryColor: UIColor) -> UIImageView {
        let darkChevron = UIImageView(image: UIImage(named: "Dark_Chevron_Icon"))
        let lightChevron = UIImageView(image: UIImage(named: "Light_Chevron_Icon"))
        // The ContrastColorOf method from the ChameleonFramework returns a
        // color with a hexValue of either #EDF1F2 or #262626
        if contrastingCategoryColor.hexValue() == "#EDF1F2" {
            return lightChevron
        } else if contrastingCategoryColor.hexValue() == "#262626" {
            return darkChevron
        } else { fatalError() }
    }
    
    // MARK: - Set up Table View Appearance

    func setCategoryTableViewAppearance() {
        tableView.rowHeight = 80
        tableView.backgroundView = UIView(frame: UIScreen.main.bounds)
        if let numberOfCategories = categories?.count {
            if numberOfCategories == 0 {
                let instructions = "Add a new category\nusing the + button."
                let instructionsLabel = labelWith(instructions)
                tableView.backgroundView?.addSubview(instructionsLabel)
            }
        }
    }
    
    // MARK: - Random Color Method For New Categories
    
    /// Returns the hex value of a random color from the CategoryColorHex enum
    /// that differs from the previos category color
    func differentCategoryColorHex() -> String {
        var newColorHex = randomColorHexFromColorOptions()
        while categories?.last?.colorHexValue.lowercased() == newColorHex.lowercased() {
            newColorHex = randomColorHexFromColorOptions()
        }
        return newColorHex
    }
    
    func randomColorHexFromColorOptions() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(Utilities.colorOptions.count)))
        return Utilities.colorOptions[randomIndex]
    }
    
}
