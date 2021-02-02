//
//  FiltersViewController.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class FiltersViewController: UIViewController {
    
    typealias Completion = ((String) -> Void)?
    var complition: Completion = nil
    
    var drinkFilters = [DrinkFilter]() {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedFilter = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        customNavigationBar.delegate = self
    }
    
    func fetchData() {
        NetworkService.shared.loadFilters { response in
            switch response {
            case let .success(filters):
                self.drinkFilters = filters
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        complition?(selectedFilter)
        navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UITableViewDelegate{}
extension FiltersViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = tableView.cellForRow(at: indexPath) else { return }
        let filter = drinkFilters[indexPath.row]
        selectedFilter = filter.strCategory
        
        if selected.accessoryType == .checkmark {
            selected.accessoryType = .none
        } else {
            selected.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selected = tableView.cellForRow(at: indexPath) else { return }
        
        if selected.accessoryType == .checkmark {
            selected.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FiltersTableViewCell else { return UITableViewCell() }
        
        let filter = drinkFilters[indexPath.row]
        
        cell.customizeCell(filters: filter)
        return cell
    }
}

extension FiltersViewController: NavigationBarDelegate {
    func leftAction() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
}

