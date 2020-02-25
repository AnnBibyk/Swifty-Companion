//
//  APIController.swift
//  Swifty Companion
//
//  Created by Anna Bibyk on 22.02.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Alamofire

class APIController {
    
    static private var token: String?
    static private let auth_config = [
        "grant_type": "client_credentials",
        "client_id": "d543bcca9a7b87986a680ca833c64600d5592f7b32fab8bbc53ab34884926445",
        "client_secret": "f1886b976f255047c836560c04f5a92b6d06f4b3a3028b898bdddc02463b6339"
    ]
   
    static public func getToken() {
        
        guard let url = URL(string: "https://api.intra.42.fr/v2/oauth/token") else { return }
        let receivedToken = UserDefaults.standard.object(forKey: "token")
        
        if receivedToken == nil {
            request(url, method: .post, parameters: auth_config).validate().responseJSON { response in
                switch response.result {
                case .success(_):
                    if response.value == nil { print("Value doesn't exist")}
                    let value = response.value as! NSDictionary
                    self.token = value.value(forKey: "access_token") as? String
                    print("Token received")
                    UserDefaults.standard.set(self.token, forKey: "token")
                    self.checkToken()
                    
                case .failure(let error):
                    print("Error getting token : \(error)")
                }
            }
            
        } else {
            self.token = receivedToken as! String?
            print("Token has not changed\n\(self.token!)")
            checkToken()
        }
    }
    
    static public func checkToken() {
        
        guard let url = URL.init(string: "https://api.intra.42.fr/oauth/token/info") else { return }
        guard let accessToken = self.token else { print("Token is nil"); return }
        
        let params: HTTPHeaders = ["Authorization" : "Bearer " + accessToken ]
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: params)
            .validate()
            .responseJSON { response in
            switch response.result {
            case .failure(_):
                if response.response?.statusCode == 401 {
                    print("Token has been expired. Getting a new one...")
                    UserDefaults.standard.removeObject(forKey: "token")
                    self.getToken()
                } else {
                    print(response.error.debugDescription)
                }
            case .success(_):
                guard let data = response.result.value as! NSDictionary? else { return }
                let timeLeft = data.value(forKey: "expires_in_seconds") as! Int?
                if timeLeft == 0 {
                    UserDefaults.standard.removeObject(forKey: "token")
                    self.getToken()
                }
            }
        }
    }
    
    static public func getUser(login: String, completion: @escaping (User?) -> Void) {
       
        let url = URL.init(string: "https://api.intra.42.fr/v2/users/" + login.trimmingCharacters(in: .whitespacesAndNewlines))!
        print(url)
        guard let accessToken = self.token else { print("Token is nil"); return }
        
        let params: HTTPHeaders = [ "Authorization" : "Bearer " + accessToken ]
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: params)
            .validate()
            .responseJSON { response in
                print(response.result.description)
            switch response.result {
            case .success(_):
                guard let jsonData = response.data else { return }
                print(jsonData)
                let decObject: User? = try? JSONDecoder().decode(User.self, from: jsonData)
                print(decObject)
                completion(decObject)
            case .failure(_):
                print("There is no user with such login! \(response.result.error.debugDescription)")
                completion(nil)
            }
        }
    }
    
}

