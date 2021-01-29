//
//  AuthService.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-28.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).validate().responseString{
            response in
            
            if response.value != nil{
                completion(true)
            } else {
                completion(false)
                debugPrint(response)
            }
        }
        
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).validate().responseJSON{
            response in
            
            if response.value != nil {
                
                /*if let json = response.value as? Dictionary<String, Any> {
                    if let email = json["user"] as? String {
                        self.userEmail = email
                    }
                    if let token = json["token"] as? String {
                        self.authToken = token
                    }
                    
                    self.isLoggedIn = true
                }*/
                do {
                    guard let data = response.data else {return}
                    let json = try JSON(data: data)
                    self.authToken = json["token"].stringValue
                    self.userEmail = json["user"].stringValue
                    
                    self.isLoggedIn = true
                    completion(true)

                } catch  {
                    
                }
                
                
            } else {
                completion(false)
                debugPrint(response)
            }
        }
    }
    
    
}
