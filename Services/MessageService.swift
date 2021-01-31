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
    var selectedChannel: Channel?
    var messages = [Message]()
    var unreadChannels = [String]()
    
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
                        
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        
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
    
    func clearChannels(){
        channels.removeAll()
    }
    
    func clearMessages(){
        messages.removeAll()
    }
    
    func findAllMessagesForChannel(channelId: String, completion:@escaping CompletionHandler){
        AF.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate().responseJSON { (response) in
            
            if response.value != nil {
                self.clearMessages()
                guard let data = response.data else {return}
                do {
                    if let json = try JSON(data: data).array {
                        for item in json{
                            let messageBody = item["messageBody"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let id = item["_id"].stringValue
                            let channelId = item["channelId"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            
                            self.messages.append(newMessage)
                        }
                         completion(true)
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
