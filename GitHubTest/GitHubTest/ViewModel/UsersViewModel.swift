//
//  UsersViewModel.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import Foundation

protocol UsersViewModelDelegate: AnyObject {
    
    func onDataFetched()
    
    func onDataFailed(error: String)
    
    func onDataViewedFetched()
    
}
final class UsersViewModel{
    //MARK: - View Model Variables
    private weak var delegate: UsersViewModelDelegate?
    private var usersResponse = UsersResponse()
    var isLoading = false
    var pageNumber = 1
    
    let apiClient = API()
    var currentRequest : String
    
    var totalCount: Int {
        if let items = usersResponse.items {
            return items.count
        }
        return 0
    }
    
    var items: [Item]
    {
        if let items = usersResponse.items {
            return items
        }
        return [Item]()
    }
    //MARK: - View Model Init

    init(request: String, delegate: UsersViewModelDelegate) {
        self.currentRequest = request
        self.delegate = delegate
    }
    //MARK: - View Model functions

    func fetchUsersList(){

        apiClient.getUsersSearch(with: self.currentRequest, page: self.pageNumber, completion: {[weak self] (UsersResponse, Error)in
            if let err = Error {
                self!.delegate?.onDataFailed(error: err.localizedDescription)
                return
            }
            
            if (self!.pageNumber > 1)
            {
                if let items = UsersResponse?.items{
                    self?.usersResponse.items?.append(contentsOf: items)
                }
            }
            else
            {
                self!.usersResponse = UsersResponse!

            }
            self!.pageNumber += 1
            print(self!.pageNumber)
            self!.delegate?.onDataFetched()

        })
        
        
    }
    
}

