//
//  SocketIoManagerNotification.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 07/07/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import SocketIO


class SocketIoManagerNotification: NSObject {
    
    static let sharedInstance = SocketIoManagerNotification()
    
    let manager : SocketManager
    var socket: SocketIOClient
    let live_url = "https://thaisweetheart.com:8443/"
    let local_url = "http://192.168.1.48:8443/"

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
        self.getNotification()
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
        socket.emit("like", with: nickname)
        self.getNotification()
    }
    func getNotification() {
        socket.on("notification") { ( dataArray, ack) -> Void in
            let dict = DataManager.getVal(dataArray[0]) as! NSDictionary
            print(dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new_message_coming"), object: dict, userInfo: nil)
        }
    }
    func sendLikeNoti(Sender_Id: String, Sender_Name: String, Sender_Image: String, Reciever_Id: String, Reciver_Name:String, Reciver_Image:String, Type: String, Room_id: String){
        var dict = [String: Any]()
        dict = ["sender_id": Sender_Id,"sender_name": Sender_Name,"sender_image": Sender_Image,"receiver_id": Reciever_Id, "receiver_name": Reciver_Name, "receiver_image": Reciver_Image, "type": Type, "room_id": Room_id]
        socket.emit("like",with: [dict])
    }
    
//    func sendMessage(sender_id: String, reciever_id: String, message: String, withRoom room: String,is_file: String) {
//        var dict = [String: Any]()
//        dict = ["sender": sender_id,"message": message,"is_file": is_file,"room": room,"receiver": reciever_id]
//        socket.emit("like",with: [dict])
//    }
    
}
