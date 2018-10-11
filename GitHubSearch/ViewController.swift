//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/9/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let networkManager = NetworkManager()
    var sort: Sort?
    var repositories: Repositories?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        tableview.delegate = self
        searchTextField.delegate = self
        setStyle()
    }
    
    private func setStyle() {
        view.backgroundColor = Colors.darkBackground
        searchTextField.returnKeyType = UIReturnKeyType.search
        searchTextField.backgroundColor = Colors.grayBackground
        searchTextField.font = Fonts.smallFont
        searchTextField.textColor = UIColor.white
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [NSAttributedString.Key.font: Fonts.smallFont,
                                                                                NSAttributedString.Key.foregroundColor: Colors.gray])
        sortSegmentControl.setSegmentStyle()
    }
    
    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            sort = Sort.stars
        case 2:
            sort = Sort.forks
        default:
            sort = nil
        }
        searchParametersChanged()
    }
    
    private func searchParametersChanged() {
        guard let qualifiers = searchTextField.text, qualifiers != "" else { return }
        
        let searchParameters = SearchParameters(qualifiers: qualifiers,
                                                sort: sort,
                                                page: Page(currentPage: 1, perPage: 10))
        let parameters = searchParameters.make()
        activityIndicator.startAnimating()
        networkManager.getRepositories(parameters: parameters) { [weak self] (repositories, error) in
            if let repositories = repositories {
                self?.repositories = repositories
                self?.tableview.reloadData()
            }
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showAboutSegue",
            let repo = sender as? Repository,
            let dvc = segue.destination as? AboutTableViewController
            else { return }
        
        dvc.repo = repo
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchParametersChanged()
        return true
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let repo = repositories?.items[indexPath.row] else { return }
        self.performSegue(withIdentifier: "showAboutSegue", sender: repo)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repositories = self.repositories?.items else { return 0 }
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let repositories = self.repositories else { return cell }
        let repo = repositories.items[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = starString(repo.stargazers_count)
        return cell
    }
    
    func starString(_ value: Int?) -> String {
        let value = value ?? 0
        switch value {
        case 0:
            return ""
        
        case 0..<1000:
            return "★ \(value)"
        
        case 1000..<10000:
            let kValue = Double(value / 100) / 10
            return "★ \(kValue)k"
        
        default:
            let kValue = value / 1000
            return "★ \(kValue)k"
        }
    }
    
}
