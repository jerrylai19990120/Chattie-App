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
    }
    
    func closeConnection(){
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
    
}
