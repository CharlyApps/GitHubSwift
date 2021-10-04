//
//  API.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import Foundation
class API{
    ///Main url allows to use different endpoints
    let mainUrl = "https://api.github.com/"
    
    func getUsersSearch(with q: String, page: Int, completion: @escaping(UsersResponse?, Error?)->()){
        
        ///Escape string with host allowed characters to avoid crash like ? ' ...
     
        var queryString = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        queryString = "search/users?q=\(queryString!)&page=\(page)"
        
        let url = URL(string: "\(mainUrl)\(queryString!)")

        URLSession.shared.dataTask(with: url!){
            data, response, error in
            
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let response = try JSONDecoder().decode(UsersResponse.self, from:data)
                completion(response, nil)
            }
            catch
            {
                completion(nil, error)
            }
        }.resume()
    }
    func getReposSearch(with q: String, page: Int, user: String, completion: @escaping(ReposResponse?, Error?)->()){
        
        ///Escape string with host allowed characters to avoid crash like ? ' ...
     
        var queryString = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if (q == ""){
            queryString = "search/repositories?q=user:\(user),\(queryString!)&page=\(page)"

        }
        else{
            queryString = "search/repositories?q=\(queryString!),user:\(user)&page=\(page)"

        }
        
        let url = URL(string: "\(mainUrl)\(queryString!)")

        URLSession.shared.dataTask(with: url!){
            data, response, error in
            
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let response = try JSONDecoder().decode(ReposResponse.self, from:data)
                completion(response, nil)
            }
            catch
            {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getUser(with q: String, completion: @escaping(UserResponse?, Error?)->()){
        
        ///Escape string with host allowed characters to avoid crash like ? ' ...
     
        var queryString = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        queryString = "users/\(queryString!)"
        
        let url = URL(string: "\(mainUrl)\(queryString!)")

        URLSession.shared.dataTask(with: url!){
            data, response, error in
            
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else {
                
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Max request reached"])
                completion(nil, error)
                return
                
            }
            
            do{
                let response = try JSONDecoder().decode(UserResponse.self, from:data)
                completion(response, nil)
            }
            catch
            {
                completion(nil, error)
            }
        }.resume()
    }
}
