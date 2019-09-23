//
//  FiltersViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 23.09.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: Any])
}

class FiltersViewController: UIViewController, SwitchCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String: String]]!
    var switchStates = [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        var filters = [String: Any]()
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    func yelpCategories() -> [[String: String]] {
        return [
            ["name": "Arabian", "code": "arabian"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "Beer Hall", "code": "beerhall"],
            ["name": "Chicken Wings", "code": "chicken_wings"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "Halal", "code": "halal"],
            ["name": "Latin American", "code": "latin"],
            ["name": "Meatballs", "code": "meatballs"],
            ["name": "Mexican", "code": "mexican"],
            ["name": "Turkish", "code": "turkish"],
            ["name": "Vegetarian", "code": "vegetarian"],
            ["name": "Wok", "code": "wok"],
            ["name": "Wraps", "code": "wraps"],
            ["name": "Yugoslav", "code": "yugoslav"]
        ]
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filtersTableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self

        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false

        return cell
    }

    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }
}
