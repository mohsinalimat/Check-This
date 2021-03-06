//
//  ItemVC.swift
//  Check This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift
import ChameleonFramework

class ItemVC: CustomTableVC {
    
    /// Realm database instance.
    let realm = try! Realm() // swiftlint:disable:this force_try
    
    /// Realm container of the user created items in the selected category.
    var items: Results<Item>?
    
    /// Category the user selected to navigate to the Item screen.
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    /// Color of the selectedCategory.
    var categoryColor: UIColor {
        return UIColor(hexString: selectedCategory!.colorHexValue)!
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setTableViewAppearance()
        setUpSearchBar()
        setUpSwipeToNavigateBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationController()
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let item = items?[indexPath.row] else { fatalError() }
        let cellTitle = NSMutableAttributedString(string: item.name)
        if item.done {
            cellTitle.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: cellTitle.length))
            cell.imageView?.image = UIImage(named: "Checked_Checkbox_Icon")
        } else {
            cell.imageView?.image = UIImage(named: "Unchecked_Checkbox_Icon")
        }
        let percentageToDarkenCellBackground = CGFloat(indexPath.row) / CGFloat(items!.count + 5)
        cell.backgroundColor = categoryColor.darken(byPercentage: percentageToDarkenCellBackground)
        cell.textLabel?.attributedText = cellTitle
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator.impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                fatalError("Error changing item done property \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - @IBActions
    
    /// Called when user touches the + button to add a new item. Presents alert
    /// for user to provide new item name.
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        ItemAlerts.presentAlertToAddNewItem(from: self)
    }
    
    /// Called when user touches the back button in the navigation bar.
    /// Pops the Item screen.
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Controller Setup
    
    /// Sets up the navigation controller properties.
    func setUpNavigationController() {
        title = selectedCategory?.name
        let contrastingColor = ContrastColorOf(categoryColor, returnFlat: true)
        let contrastingColorAttribute = [NSAttributedString.Key.foregroundColor: contrastingColor]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = categoryColor
            navBar.tintColor = contrastingColor
            navBar.largeTitleTextAttributes = contrastingColorAttribute
            navBar.titleTextAttributes = contrastingColorAttribute
        }
    }
    
    // MARK: - Set up Table View Appearance
    
    /// Sets a background displaying instructions on how to add items if the
    /// tableView is empty.
    func setItemTableViewAppearance() {
        // If user is searching, the background instructions will not display.
        if presentedViewController == nil {
            tableView.backgroundView = UIView(frame: UIScreen.main.bounds)
            tableView.backgroundView?.backgroundColor = categoryColor.withAlphaComponent(0.1)
            if let numberOfItems = items?.count {
                if numberOfItems == 0 {
                    let instructions = "Add a new item to\nyour to-do list using\nthe + button."
                    let instructionsLabel = labelWith(instructions)
                    tableView.backgroundView?.addSubview(instructionsLabel)
                }
            }
        }
    }
    
    // MARK: - Set Up Search Bar
    
    /// Sets up the search bar properties.
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        // Set cursor color in search bar to gray
        UITextField.appearanceWhenContained(within: [type(of: searchController.searchBar)]).tintColor = .gray
        searchBar.placeholder = "Search"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
            }
        }
    }
    
}
