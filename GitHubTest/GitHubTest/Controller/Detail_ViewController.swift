//
//  Detail_ViewController.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import UIKit
import SDWebImage

class Detail_ViewController: UIViewController {
    public var user : String?
    private var viewModel : UserDetalViewModel?
    var lastRequestString = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var reposTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserData()
        // Do any additional setup after loading the view.
    }
    
    func getUserData(){
        if (viewModel == nil){
            self.viewModel = UserDetalViewModel(request: self.user!, repoQuery: "",delegate: self)
        }
        else {
            self.viewModel?.currentRequest = self.user!
        }
        self.viewModel?.fetchUser()
        self.getUserRepos(with: "")

    }
    
    @objc func getUserRepos(with q: String){
        self.viewModel?.pageNumber = 1
        self.viewModel?.currentReposRequest = "\(q)"
        self.viewModel?.fetchRepos()
    }
    
    func genericAlert(text: String) {
        
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        //self.present(alert, animated: true, completion: nil)
    }

}
extension Detail_ViewController: UserDetailViewModelDelegate{
    func onReposFetched() {
        DispatchQueue.main.async {
            self.reposTable.reloadData()
        }
    }
    
    
    func onDataFailed(error: String) {
        self.genericAlert(text: error)
    }
    
    func onDataFetched() {
        
        DispatchQueue.main.async {

            self.nameLabel.text = "\(self.viewModel?.userResponse.login ?? "Unknown")"
            self.mailLabel.text = "\(self.viewModel?.userResponse.email ?? "No Email")"
            self.locationLabel.text = "\(self.viewModel?.userResponse.location ?? "No Location")"
            self.followersLabel.text = "\(self.viewModel?.userResponse.followers ?? 0) Followers"
            self.followingLabel.text = "Following \(self.viewModel?.userResponse.following ?? 0)"
            self.descriptionLabel.text = "\(self.viewModel?.userResponse.bio ?? "Not much to say...")"
            self.profileImage.sd_setImage(with: URL(string: (self.viewModel?.userResponse.avatar_url)!))
            self.setFormatedDates()
        }

    }
    
    func setFormatedDates(){
        
        let dateFormatterGet = DateFormatter()
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterPrint.dateFormat = "MMM d, yyyy"
        
        let dateTaken = dateFormatterPrint.string(from: dateFormatterGet.date(from: (self.viewModel?.userResponse.created_at!)!)!)
        
        self.joinDateLabel.text = "\(dateTaken)"
        
    }
    
    
}
extension Detail_ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stringURL = self.viewModel?.items[indexPath.row].html_url
        
        UIApplication.shared.open(URL (string: stringURL!)!)

    }
}

extension Detail_ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Repo_TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repo_Identifier",
                                                           for: indexPath) as! Repo_TableViewCell
        
        
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
extension Detail_ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths
        {
            if (indexPath.row == viewModel!.totalCount - 5)
            {
                viewModel?.fetchRepos()
            }
        }
    }
    
}

extension Detail_ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.getUserRepos(with:)),
        object: lastRequestString)
        
        lastRequestString = searchBar.text!
        
        perform(#selector(self.getUserRepos(with:)), with: searchBar.text!, afterDelay: 0.75)
    }
    
    
}
