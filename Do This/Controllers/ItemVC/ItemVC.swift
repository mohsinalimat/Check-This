//
//  ItemVC.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/12/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift
import ChameleonFramework

class ItemVC: CustomTableVC {

    var items: Results<Item>?
    let realm = try! Realm() // swiftlint:disable:this force_try
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
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
            cellTitle.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSRange(location: 0, length: cellTitle.length))
            cell.imageView?.image = UIImage(named: "Checked_Checkbox_Icon")
        } else {
            cell.imageView?.image = UIImage(named: "Unchecked_Checkbox_Icon")
        }
        cell.backgroundColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
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
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        ItemAlerts.presentAlertToAddNewItem(from: self)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Controller Setup
    
    func setUpNavigationController() {
        title = selectedCategory?.name
        let contrastingColor = ContrastColorOf(categoryColor, returnFlat: true)
        let contrastingColorAttribute = [NSAttributedStringKey.foregroundColor: contrastingColor]
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = categoryColor
            navBar.tintColor = contrastingColor
            navBar.largeTitleTextAttributes = contrastingColorAttribute
            navBar.titleTextAttributes = contrastingColorAttribute
        }
    }
    
    // MARK: - Set up Table View Appearance
    
    func setItemTableViewAppearance() {
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
    
    // MARK: - Set Up Search Bar
    
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
        searchBar.placeholder = "Search"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
            }
        }
    }

}
