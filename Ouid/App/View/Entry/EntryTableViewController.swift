//
//  EntryTableViewController.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import UIKit
import Combine
import SwiftUI

class EntryTableViewController: UITableViewController {
    private let viewModel = EntryViewModel()
    private var delegate = AddEntryViewDelegate()
    private var changePublisher: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Entries"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground

        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: EntryTableViewCell.REUSE_IDENTIFIER)
        
        observeDelegate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count == 0 ? setEmptyView() : restore()
        return viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.REUSE_IDENTIFIER) as! EntryTableViewCell
        
        cell.entry = viewModel.entries[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEntry = viewModel.entries[indexPath.row]
        
        let vc = UIHostingController(rootView: AddEntryView(delegate: delegate, dismissAction: {
            self.dismiss(animated: true, completion: nil)
        }, oldEntry: selectedEntry))
        self.present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.save(viewModel.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Methods
    func setEmptyView() {
        self.tableView.backgroundView = UIHostingController(rootView: EmptyEntriesView()).view
        self.tableView.separatorStyle = .none
        self.tableView.alwaysBounceVertical = false
    }

    func restore() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.alwaysBounceVertical = true
    }
    
    private func observeDelegate() {
        changePublisher = delegate.didChange.sink(receiveValue: { [weak self] delegate in
            guard let self = self else { return }
            self.viewModel.save(delegate.newEntry)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @objc private func addTapped(_ sender: UIBarButtonItem) {
        let vc = UIHostingController(rootView: AddEntryView(delegate: delegate, dismissAction: {
            self.dismiss(animated: true, completion: nil)
        }, oldEntry: nil))
        self.present(vc, animated: true, completion: nil)
    }
}
 
