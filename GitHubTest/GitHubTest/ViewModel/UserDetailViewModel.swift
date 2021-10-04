//
//  UserDetailViewModel.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import Foundation

protocol UserDetailViewModelDelegate: AnyObject {
    
    func onDataFetched()
    func onReposFetched()
    func onDataFailed(error: String)
        
}
final class UserDetalViewModel{
    //MARK: - View Model Variables
    private weak var delegate: UserDetailViewModelDelegate?
    
    var userResponse = UserResponse()
    var userReposResponse = ReposResponse()
    
    var isLoading = false
    let apiClient = API()
    var currentRequest : String
    var currentReposRequest: String
    var pageNumber = 1
    
    var totalCount: Int {
        if let items = userReposResponse.items{
            return items.count
        }
        return 0
    }
    
    var items: [Repo]
    {
        if let items = userReposResponse.items {
            return items
        }
        return [Repo]()
    }
    //MARK: - View Model Init

    init(request: String, repoQuery: String, delegate: UserDetailViewModelDelegate) {
        self.currentRequest = request
        self.delegate = delegate
        self.currentReposRequest = repoQuery
    }
    //MARK: - View Model functions

    func fetchUser(){

        apiClient.getUser(with: self.currentRequest, completion: { (UserResponse, Error)in
            if let err = Error {
                self.delegate?.onDataFailed(error: err.localizedDescription)
                return
            }
                        
            self.userResponse = UserResponse!
            self.delegate?.onDataFetched()

        })
        
        
    }
    
    func fetchRepos(){
        apiClient.getReposSearch(with: self.currentReposRequest, page: self.pageNumber, user: self.currentRequest, completion: {(ReposResponse, Error)in
            if let err = Error {
                self.delegate?.onDataFailed(error: err.localizedDescription)
                return
            }
            
            if (self.pageNumber > 1)
            {
                
                if let items = ReposResponse?.items{
                    self.userReposResponse.items?.append(contentsOf: items)
                }
                
            }
            else
            {
                self.userReposResponse = ReposResponse!

            }
            self.pageNumber += 1
            self.delegate?.onReposFetched()

        })
    }
    
}
