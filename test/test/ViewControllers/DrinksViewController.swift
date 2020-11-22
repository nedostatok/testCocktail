//
//  DrinksViewController.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class DrinksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var drinksArray = [DrinkModel]()
    var sectionName = "Ordinary_Drink"  {
        didSet {
            fetchData(param: sectionName)
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        fetchData(param: sectionName)
        createLabel()
    }
    
    func fetchData(param: String) {
        GetData.shared.loadDrinks(param: param) { response in
            switch response {
            
            case let .Value(valueOrError):
                self.drinksArray = valueOrError
                
            case let .Error(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func createLabel() {
        let label = UILabel()
        label.text = "Drinks"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @IBAction func toFiltersVC(_ sender: UIBarButtonItem) {
        guard let filtersVC = storyboard?.instantiateViewController(identifier: "FiltersViewController") as? FiltersViewController else { return }
        
        filtersVC.complition =  { [weak self] filter in
            self?.sectionName = filter
        }
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(filtersVC, animated: true)
    }
}

extension DrinksViewController: UITableViewDelegate{}
extension DrinksViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 8, width: 150, height: 20)
        myLabel.font = UIFont(name: "System", size: 15)
        myLabel.textColor = .gray
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName.replacingOccurrences(of: "_", with: " ")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DrinksTableViewCell else { return UITableViewCell() }
        
        let array = drinksArray[indexPath.row]
        
        cell.customizeCell(drinks: array)
        
        return cell
    }
}

extension DrinksViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
