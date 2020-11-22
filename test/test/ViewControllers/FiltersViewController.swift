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
    
    var drinkFilters = [FilterModel]()
    var selectedFilter = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        customNavigationBar.delegate = self
    }
    
    func fetchData() {
        GetData.shared.loadFilters { response in
            switch response {
            case let .Value(valueOrError):
                self.drinkFilters = valueOrError
                
            case let .Error(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        complition?(selectedFilter.replacingOccurrences(of: " ", with: "_"))
        navigationController?.popViewController(animated: true)
    }
    
}

extension FiltersViewController: UITableViewDelegate{}
extension FiltersViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath)
        let filter = drinkFilters[indexPath.row]
        selectedFilter = filter.filterName
        
        if selected!.accessoryType == .checkmark {
            selected!.accessoryType = .none
        } else {
            selected!.accessoryType = .checkmark
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath)
        
        if selected?.accessoryType == .checkmark {
            selected!.accessoryType = .none
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

