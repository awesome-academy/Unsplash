//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 9/3/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import RealmSwift
protocol SearchViewControllerDelegate: class {
    func searchAction(searchKey: String)
    func viewDidDisappear(viewController: UIViewController)
}

class SearchViewController: UIViewController {
    
    @IBOutlet private weak var historySearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: SearchViewControllerDelegate?
    private var history: Results<SearchHistory>?
    private let realmManager = RealmManager.shared
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadHistory()
    }
    
    private func setupViews() {
        searchBar.delegate = self
        historySearchTableView.dataSource = self
        historySearchTableView.delegate = self
        historySearchTableView.allowsSelection = true
        historySearchTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear(viewController: self)
    }
    
    func loadHistory() {
        history = realmManager.fetchData()
        historySearchTableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKey = searchBar.text else {
            return
        }
        
        if searchKey.isEmpty {
            return
        }
        
        guard let isContaintKey = history?.contains(where: { searchHistory -> Bool in
            return searchHistory.searchKey == searchKey
        }) else {
            return
        }
        
        if !isContaintKey {
            let searchHistory = SearchHistory()
            searchHistory.searchKey = searchKey
            realmManager.addData(data: searchHistory)
            historySearchTableView.reloadData()
        }
        searchBar.text = ""
        delegate?.searchAction(searchKey: searchKey)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = history?[indexPath.row].searchKey ?? "no data"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.addSubview(headerLabel)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        return headerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if let searchKey = history?[indexPath.row] {
                realmManager.deleteData(data: searchKey)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchAction(searchKey: history?[indexPath.row].searchKey ?? " ")
    }
}
