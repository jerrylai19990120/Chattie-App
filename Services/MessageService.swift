//
//  MessageService.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-29.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    func findAllChannel(completion: @escaping CompletionHandler){
        
        AF.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate().responseJSON { (response) in
            
            if response.value != nil {
                guard let data = response.data else {return}
                do {
                    if let json = try JSON(data: data).array {
                        for item in json{
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            
                            let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                            
                            self.channels.append(channel)
                        }
                        
                    }
                } catch {
                    completion(false)
                    debugPrint(error)
                }
               
            } else {
                completion(false)
                debugPrint(response.error as Any)
            }
        }
        
    }
}
