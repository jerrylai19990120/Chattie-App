//
//  SocketService.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-30.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketManager(socketURL: URL(string: BASE_URL)!).defaultSocket
    
    func establishConnection(){
        socket.connect()
        print(socket.status)
    }
    
    func closeConnection(){
        print(socket.status)
        socket.disconnect()
    }
    
    func addChannel(name: String, desc: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", name, desc)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        
        socket.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else {return}
            guard let desc = dataArray[1] as? String else {return}
            guard let id = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: name, channelDescription: desc, id: id)
            MessageService.instance.channels.append(newChannel)
            completion(true)
            
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
        
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message)->Void){
        
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn{
                let newMsg = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                
                MessageService.instance.messages.append(newMsg)
                completion(newMsg)
            } else {
                completion(Message())
            }
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUser: [String:String])-> Void){
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String:String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    
}
