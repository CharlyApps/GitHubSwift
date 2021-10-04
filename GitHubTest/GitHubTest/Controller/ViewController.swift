//
//  ViewController.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel : UsersViewModel?
    @IBOutlet weak var usersTable: UITableView!
    var lastRequestString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsersData(with: "")
        self.navigationItem.title = "GitHub Searcher"
    }
    
    @objc func loadUsersData(with q: String){
        if (viewModel == nil){
            viewModel = UsersViewModel(request: "charly", delegate: self)
        }
        else{
            viewModel?.currentRequest = q
        }
        viewModel?.pageNumber = 1
        viewModel?.fetchUsersList()
    }
    
    func genericAlert(text: String) {
        
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UsersViewModelDelegate {
    func onDataFailed(error: String) {
        self.genericAlert(text: error)
    }
    
    func onDataViewedFetched() {
        //TODO: View Data
        
    }
    
    func onDataFetched() {
        DispatchQueue.main.async {
            self.usersTable.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailVC") as! Detail_ViewController
        vc.user = self.viewModel?.items[indexPath.row].login
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:User_TableViewCell = tableView.dequeueReusableCell(withIdentifier: "User_Identifier",
                                                           for: indexPath) as! User_TableViewCell
        
        let model = self.viewModel?.items[indexPath.row]
        
        cell.configureCell(with: model!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemsCount = self.viewModel?.items.count else {return 0}
        
        return itemsCount
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.00
        
    }
    
}
extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths
        {
            if (indexPath.row == viewModel!.totalCount - 5)
            {
                viewModel?.fetchUsersList()
            }
        }
    }
    
}
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.loadUsersData(with:)),
        object: lastRequestString)
        
        lastRequestString = searchBar.text!

        
        perform(#selector(self.loadUsersData(with:)), with: searchBar.text!, afterDelay: 0.75)
    }
    
    
}
