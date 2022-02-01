//
//  UsersListViewController.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import UIKit
import CoreData

protocol UsersListViewControllerDelegate: AnyObject {
    func userListViewControllerDidSelectUser(_ user: User)
}

final class UsersListViewController: UIViewController {
    
    weak var delegate: UsersListViewControllerDelegate?
    
    private let viewModel = UsersListViewModel()
    
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.tableFooterView = loadingIndicator
        return tableView
    }()
    
    private lazy var loadingIndicator: LoadingIndicatorView = {
        var frame = view.bounds
        frame.size.height = 60
        return LoadingIndicatorView(frame: frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.delegate = self
        viewModel.fetchedRC.delegate = self
        viewModel.performFetch()
    }

}

//MARK: - View Setup
private extension UsersListViewController {
    private func setupView() {

        navigationItem.titleView = searchBar
        view.backgroundColor = tableView.backgroundColor
        view.addSubview(tableView)
        layoutView()
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCellIdentifier)
        tableView.register(UserNoteTableViewCell.self, forCellReuseIdentifier: UserNoteTableViewCellIdentifier)
        tableView.register(UserInvertedImageTableViewCell.self, forCellReuseIdentifier: UserInvertedImageTableViewCellIdentifier)
        tableView.register(UserNoteInvertedImageTableViewCell.self, forCellReuseIdentifier: UserNoteInvertedImageTableViewCellIdentifier)
    }
    
    private func layoutView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK: - TableView Delegate & Data Source

extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifierForRowAtIndexPath(indexPath)) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = viewModel.fetchedRC.object(at: indexPath)
        if user.avatar == nil {
            viewModel.downloadUserAvatar(user)
        }
        cell.configureWithUser(user: user)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchedRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedRC.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfRequiredAtIndex(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.userListViewControllerDidSelectUser(viewModel.fetchedRC.object(at: indexPath))
    }
}

//MARK: - UISearchBarDelegate
extension UsersListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.searchText(nil)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText(searchText)
        tableView.reloadData()

    }
}

//MARK: - UsersListViewModelDelegate

extension UsersListViewController: UsersListViewModelDelegate {
    func networkConnectivityFailed() {
        self.alert(title: "Connection Error", message: "You're not connected to the internet. Please connect to the internet and try again later.")
    }
    

    func startedLoadingPageSince(_ userID: Int64) {
        if let lastUserId = viewModel.fetchedRC.fetchedObjects?.last?.id, lastUserId == userID {
            loadingIndicator.view.startAnimating()
        } else  {
            let count = viewModel.fetchedRC.fetchedObjects?.count ?? 0
            if count == 0 && userID == 0 {
                loadingIndicator.view.startAnimating()
            }
        }
    }
    
    func finishedLoadingPageSince(_ userID: Int64) {
        if let lastUserId = viewModel.fetchedRC.fetchedObjects?.last?.id, lastUserId == userID {
            loadingIndicator.view.stopAnimating()
        }
    }
    
    func failedToFetchNewUsersSince( _ userID: Int64, error: String) {
        if let lastUserId = viewModel.fetchedRC.fetchedObjects?.last?.id, lastUserId == userID {
            loadingIndicator.view.stopAnimating()
        }
    }
    
}

//MARK: - Core Data NSFetchedResultsControllerDelegate
extension UsersListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        switch type {
            
        case .insert:
            if let path = newIndexPath {
                tableView.insertRows(at: [path], with: .fade)
            }
            
        case .delete:
            if let path = indexPath {
                tableView.deleteRows(at: [path], with: .fade)
            }
            
        case .update:
            if let path = indexPath {
                tableView.reloadRows(at: [path], with: .fade)
            }
            
        case .move:
            if let old = indexPath, let newPath = newIndexPath {
                tableView.insertRows(at: [newPath], with: .fade)
                tableView.deleteRows(at: [old], with: .fade)
            }
            
        default:
            break
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
