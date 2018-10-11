//
//  AboutTableViewController.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/11/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import UIKit

enum CellID: String {
    case title = "titleCell"
    case basic = "basicCell"
    case detail = "detailCell"
}

struct AboutItem {
    let identifier: String
    let text: String?
    let detail: String?
}

class AboutTableViewController: UITableViewController {
    
    var repo: Repository!
    var aboutItems = [AboutItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = repo.name
        
        newItem(cellID: .title, text: repo.full_name, detail: repo.description)
        newItem(cellID: .detail, text: "Language:", detail: repo.language)
        
        if let license = repo.license {
            newItem(cellID: .detail, text: "License:", detail: license.name)
        }
        
        newItem(cellID: .detail, text: "Stars:", value: repo.stargazers_count)
        newItem(cellID: .detail, text: "Forks:", value: repo.forks)
        newItem(cellID: .detail, text: "Updated:", date: repo.updated_at)
    }
    
    private func newItem(cellID: CellID, text: String?, detail: String?) {
        let item = AboutItem(identifier: cellID.rawValue, text: text, detail: detail)
        aboutItems.append(item)
    }
    
    private func newItem(cellID: CellID, text: String?, value: Int?) {
        guard let value = value else { return }
        newItem(cellID: cellID, text: text, detail: String(value))
    }
    
    private func newItem(cellID: CellID, text: String?, date: String?) {
        guard let dateString = dateStringFrom(date) else { return }
        newItem(cellID: cellID, text: text, detail: dateString)
    }
    
    private func dateStringFrom(_ text: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard
            let dateString = text,
            let date = dateFormatter.date(from: dateString)
            else { return nil}
        
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Today at \(dateFormatter.string(from: date))"
        
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Yesterday at \(dateFormatter.string(from: date))"
        
        } else {
            dateFormatter.dateFormat = "dd/MM/YY"
            return dateFormatter.string(from: date)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aboutItem = aboutItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: aboutItem.identifier, for: indexPath)
        cell.textLabel?.text = aboutItem.text
        cell.detailTextLabel?.text = aboutItem.detail
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
