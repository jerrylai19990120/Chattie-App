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
                //Not using SwiftyJson
                /*if let json = response.value as? Dictionary<String, Any> {
                    if let email = json["user"] as? String {
                        self.userEmail = email
                    }
                    if let token = json["token"] as? String {
                        self.authToken = token
                    }
                    
                    self.isLoggedIn = true
                }*/
                //Using SwiftyJson
                do {
                    guard let data = response.data else {return}
                    let json = try JSON(data: data)
                    self.authToken = json["token"].stringValue
                    self.userEmail = json["user"].stringValue
                    
                    self.isLoggedIn = true
                    completion(true)

                } catch  {
                    completion(false)
                    debugPrint(error)
                }
                
                
            } else {
                completion(false)
                debugPrint(response)
            }
        }
    }
    
    
    func createUser(name:String, email:String, avatarColor:String, avatarName:String, completion:@escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-type": "application/json; charset=utf-8"
        ]
        
        AF.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).validate().responseJSON{
            
            response in
            
            if response.value != nil {
                guard let data = response.data else {return}
                
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let name = json["name"].stringValue
                    let email = json["email"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    
                    completion(true)
                } catch {
                    completion(false)
                    debugPrint(error)
                }
                
                
                
            } else {
                completion(false)
            }
            
        }
    }
    
    
    func findUserByEmail(completion: @escaping CompletionHandler){
        
        AF.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate().responseJSON { (response) in
            
            if response.value != nil {
                guard let data = response.data else {return}
                
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let name = json["name"].stringValue
                    let email = json["email"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    
                    completion(true)
                } catch {
                    completion(false)
                    debugPrint(error)
                }
                
                
            } else {
                completion(false)
            }
        }
    }
    
}
