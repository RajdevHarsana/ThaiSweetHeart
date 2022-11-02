//
//  MessageListVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class MessageListVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var matchCollectionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var matchLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var MatchCollectionViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var matchLblTopConstant: NSLayoutConstraint!
    @IBOutlet weak var lineLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lineLblTopConstant: NSLayoutConstraint!
    @IBOutlet weak var MatchCollectionView: UICollectionView!
    @IBOutlet weak var MessageListTblView: UITableView!
    var dataArray = [Any]()
    var matchArray = [Any]()
    var matchDict = [String: Any]()
    var isSelect = Bool()
    var is_online = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar.png"), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 300))
//        imageView.contentMode = .bottomRight
//            let image = UIImage(named: "NavigationBarImage")
//            imageView.image = image
//        let image1: UIImage = imageView.image!
//        navigationItem.titleView = imageView
//        self.navigationController?.navigationBar.setBackgroundImage(image1, for: .default)
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Chats"
        self.navigationItem.titleView = bar_title

        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let nib = UINib(nibName: "ChatCollectionCell", bundle: nil)
        self.MatchCollectionView.register(nib, forCellWithReuseIdentifier: "ChatCollectionCell")
        self.MatchCollectionView.collectionViewLayout = layout
        
        let nibClass = UINib(nibName: "MessageTableCell", bundle: nil)
        self.MessageListTblView.register(nibClass, forCellReuseIdentifier: "MessageTableCell")
        self.MessageListTblView.rowHeight = UITableView.automaticDimension
        self.MessageListTblView.delegate = self
        self.MessageListTblView.dataSource = self
        
        self.getMessageListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.is_online = "0"
        self.getUserChatStatusAPI()
        self.getMessageListAPI()
    }
    
    //MARK:- User chat status API
    func getUserChatStatusAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.is_online), forKey: "is_online")
        
        let methodName = "chat/is-online"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)        
    }
    
    //MARK:- Get Message List API
    func getMessageListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "chat/thread"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["thread"]) as? [Any] ?? []
                print(self.dataArray)
                self.matchArray = DataManager.getVal(responseData?["friends"]) as? [Any] ?? []
                print(self.matchArray)
                print(self.matchArray.count)
                if self.matchArray.count == 0 {
                    matchLblTopConstant.constant = 0
                    MatchCollectionViewTopCons.constant = 0
                    matchCollectionHeightConstant.constant = 0
                    matchLblHeightConstant.constant = 0
                    lineLblHeightConstant.constant = 0
                }else{
                    matchLblTopConstant.constant = 10
                    MatchCollectionViewTopCons.constant = 0
                    lineLblTopConstant.constant = 2
                    matchCollectionHeightConstant.constant = 95
                    matchLblHeightConstant.constant = 18
                    lineLblHeightConstant.constant = 0.33
                }
                self.MatchCollectionView.reloadData()
                self.MessageListTblView.reloadData()
                self.MessageListTblView.backgroundView = nil
            }else if status == "0"{
                matchLblTopConstant.constant = 0
                matchCollectionHeightConstant.constant = 0
                matchLblHeightConstant.constant = 0
                lineLblHeightConstant.constant = 0
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.MessageListTblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell" ,for: indexPath) as! MessageTableCell
        var dict = NSDictionary()
        dict = self.dataArray[indexPath.row] as! NSDictionary
        cell.username.text = dict.value(forKey: "r_fullname") as? String
        
        cell.userimage.sd_setImage(with: URL(string: (dict.value(forKey: "r_image") as? String)!), placeholderImage: UIImage(named: "No image available"))
        
        let membership = DataManager.getVal(dict["membership"]) as? String ?? ""
        let is_file = DataManager.getVal(dict["is_file"]) as? String ?? ""
        if is_file == "2"{
            cell.messageTxt.text = "GIF"
        }else{
            cell.messageTxt.text = dict.value(forKey: "message") as? String
        }
        if membership == "3"{
            cell.goldMemberIcon.isHidden = false
        }else{
            cell.goldMemberIcon.isHidden = false
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(DeleteChat(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func DeleteChat(_ sender:UIButton){
        var Datadict = NSDictionary()
        Datadict = self.dataArray[sender.tag] as! NSDictionary
        print(Datadict)
        let roomId = DataManager.getVal(Datadict["room_id"]) as? String ?? ""
        let userId = DataManager.getVal(Datadict["sender_id"]) as? String ?? ""
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("YES", backgroundColor: UIColor(displayP3Red: 238/255, green: 158/255, blue: 180/255, alpha: 1.0)){
            self.pleaseWait()
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(roomId), forKey: "room_id")
            dict.setValue(DataManager.getVal(userId), forKey: "user_id")
            let methodName = "chat/thread-delete"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    self.view.makeToast(message: message)
                    self.getMessageListAPI()
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
        alert.addButton("NO", backgroundColor: UIColor(displayP3Red: 146/255, green: 218/255, blue: 233/255, alpha: 1.0)){
            print("NO")
        }
        alert.showEdit("Delete", subTitle: "Are you sure you want to delete this Chat?")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isSelect = true
        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
        var dict = NSDictionary()
        dict = self.dataArray[indexPath.row] as! NSDictionary
        let roomid = DataManager.getVal(dict["room_id"]) as? String ?? ""
        let receiverid = DataManager.getVal(dict["r_id"]) as? String ?? ""
        let r_fullname = DataManager.getVal(dict["r_fullname"]) as? String ?? ""
        let r_image = DataManager.getVal(dict["r_image"]) as? String ?? ""
        let r_memberShip = DataManager.getVal(dict["membership"]) as? String ?? ""
        print(dict)
        vc.room_id = roomid
        vc.m_recieverId = receiverid
        vc.UserName = r_fullname
        vc.imagestr = r_image
        vc.member = r_memberShip
        self.onlyPushViewController(vc)
    }
}
extension MessageListVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matchArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionCell", for: indexPath) as! ChatCollectionCell
        let dict = DataManager.getVal(self.matchArray[indexPath.row]) as? [String: Any] ?? [:]
        cell.titleLbl.text = DataManager.getVal(dict["fullname"]) as? String ?? ""
        Config().setimage(name: DataManager.getVal(dict["image"]) as? String ?? "", image: cell.imgView)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
        let dict = DataManager.getVal(self.matchArray[indexPath.row]) as? [String: Any] ?? [:]
        print(dict)
        vc.menuPopUpFriendId = DataManager.getVal(dict["friend_id"]) as? String ?? ""
        vc.m_recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
        vc.UserName = DataManager.getVal(dict["fullname"]) as? String ?? ""
        vc.imagestr = DataManager.getVal(dict["image"]) as? String ?? ""
        vc.room_id = DataManager.getVal(dict["room"]) as? String ?? ""
        vc.member = DataManager.getVal(dict["membership"]) as? String ?? ""
        print(dict)
        self.onlyPushViewController(vc)
    }
}
