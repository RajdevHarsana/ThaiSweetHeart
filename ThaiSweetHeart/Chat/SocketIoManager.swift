//
//  SocketIoManager.swift
//  HowLit
//
//  Created by Tarun Nagar on 04/09/18.
//  Copyright © 2018 Tarun Nagar. All rights reserved.
//

import UIKit
import SocketIO


class SocketIoManager: NSObject {
    
    static let sharedInstance = SocketIoManager()
    
    let live_url = "https://thaisweetheart.com:8443/"
    let local_url = "http://192.168.1.48:8443/"
    let manager : SocketManager
    var socket: SocketIOClient
    
    override init() {
        
        self.manager = SocketManager(socketURL: URL(string: self.live_url)!, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
    }
    
    func establishConnection() {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }

            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                self.socket.emit("update", ["amount": cur + 2.50])
            }
            ack.with("Got your currentAmount", "dude")
        }
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func removeAllHandlers(){
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }
    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false
    }
    func connectToServerWithRoom(nickname: [Any]) {
        socket.emit("joinRoom", with: nickname)
        self.getChatMessage()
    }
    func getChatMessage() {
        socket.on("messages") { ( dataArray, ack) -> Void in
            let dict = DataManager.getVal(dataArray[0]) as! NSDictionary
            print(dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new_message_coming"), object: dict, userInfo: nil)
        }
    }

    func sendMessage(sender_id: String, reciever_id: String, message: String, withRoom room: String,is_file: String) {
        var dict = [String: Any]()
        dict = ["sender": sender_id,"message": message,"is_file": is_file,"room": room,"receiver": reciever_id]
        socket.emit("newMessage",with: [dict])
    }
    
}
