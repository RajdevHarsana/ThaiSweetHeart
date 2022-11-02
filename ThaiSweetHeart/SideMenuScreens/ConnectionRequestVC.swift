//
//  ConnectionRequestVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 28/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class ConnectionRequestVC: BaseViewSideMenuController,UITableViewDelegate,UITableViewDataSource {
   
    //MARK:- IBOutlates
    @IBOutlet weak var ceonnectionTable: UITableView!
    
    //MARK:- Objects
    var dataArray = [Any]()
    var image = String()
    var userName = String()
    var memberShipe = String()
    var LikeType = String()
    var recieverId = String()
    var recieverName = String()
    var recieverImage = String()
    var recieverArray = [Any]()
    var room_id = String()
    var r_membership = String()
    var comeFromMember = String()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = nil
             self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "yellowbkImage.png"), for: .default)
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if membershiptype == "3"{
        }else{
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
        }
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.black
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Who likes & Superlike you"
        self.navigationItem.titleView = bar_title
        
//        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.title = "Connection Request"
//        self.title = lang == "en" ? kConnection_Request : kThConnection_Request
        let nibClass = UINib(nibName: "ConnectionRequestCell", bundle: nil)
        self.ceonnectionTable.register(nibClass, forCellReuseIdentifier: "ConnectionRequestCell")
        self.ceonnectionTable.rowHeight = UITableView.automaticDimension
        self.ceonnectionTable.delegate = self
        self.ceonnectionTable.dataSource = self
        
        if membershiptype == "3"{
            
        }else{
            let nextview = GoldMemberPopUp.intitiateFromNib()
            let model = BackModel()
            nextview.layer.cornerRadius = 8
            nextview.buttonbuyHandler = {
                let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                detailVC.comeFromConnectionRequest = "yes"
                self.onlyPushViewController(detailVC)
                
//                self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
               model.closewithAnimation()
            }
            nextview.buttonCancelHandler = {
                model.closewithAnimation()
                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                self.RootViewWithSideManu(vc)
            }
            model.show(view: nextview)
        }
//        getFriendListAPI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = UIColor.black
   self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "yellowbkImage.png"), for: .default)
        getFriendListAPI()
    }
    //MARK:- List API
    func getFriendListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")

        let methodName = "like/view"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["user"]) as? [Any] ?? []
                let dict = DataManager.getVal(self.dataArray[0]) as? [String: Any]
                self.recieverId = DataManager.getVal(dict?["user_id"]) as? String ?? ""
                print(self.recieverId)
                print(dict)
                self.recieverName = DataManager.getVal(dict?["fullname"]) as? String ?? ""
                self.recieverImage = DataManager.getVal(dict?["image"]) as? String ?? ""
                self.r_membership = DataManager.getVal(dict?["membership"]) as? String ?? ""
                self.ceonnectionTable.reloadData()
                self.ceonnectionTable.backgroundView = nil
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.ceonnectionTable, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionRequestCell" ,for: indexPath) as! ConnectionRequestCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        let age = DataManager.getVal(dict["age"]) as? String ?? ""
        cell.userdes.text = DataManager.getVal(dict["about"]) as? String ?? ""
        cell.username.text = DataManager.getVal(dict["fullname"]) as? String ?? ""
        let liketype = DataManager.getVal(dict["type"]) as? String ?? ""
        if liketype == "1" {
            cell.SuperlikeImg.isHidden = false
        }else{
            cell.SuperlikeImg.isHidden = true
        }
        Config().setimage(name: DataManager.getVal(dict["image"]) as? String ?? "", image: cell.userimage)

        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        cell.agelbl.text = lang == "en" ? kage + " " + age : kThage + " " + age
        
        cell.likeBtn.setTitle(lang == "en" ? klikeBtn : kThlikeBtn, for: .normal)
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(self.chatButtonAction), for: .touchUpInside)
        cell.dislikebtn.setTitle(lang == "en" ? kdislikebtn : kThdislikebtn, for: .normal)
        cell.dislikebtn.tag = indexPath.row
        cell.dislikebtn.addTarget(self, action: #selector(self.removeButtonAction), for: .touchUpInside)
        
        let membership = DataManager.getVal(dict["membership"]) as? String ?? ""
        
        if membership == "3"{
            cell.Goldimage.isHidden = false
        }else{
            cell.Goldimage.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String:Any]
        let userID = DataManager.getVal(Dict["user_id"]) as? String ?? ""
        let membership = DataManager.getVal(Dict["membership"]) as? String ?? ""
        let vc = SearchUserDetailVC(nibName: "SearchUserDetailVC", bundle: nil)
        vc.UserDetailID = userID
        vc.MemberShipStatus = membership
        vc.isCommingSuperlike = "superlike"
        self.onlyPushViewController(vc)
    }
    //MARK:- Like Button Action
    @objc func chatButtonAction(_ sender: UIButton){
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! [String: Any]
        let receiver_id = DataManager.getVal(dict["user_id"]) as? String ?? ""
        let type = DataManager.getVal(dict["type"]) as? String ?? ""
        self.image = DataManager.getVal(dict["image"]) as? String ?? ""
        self.userName = DataManager.getVal(dict["fullname"]) as? String ?? ""
        self.memberShipe = DataManager.getVal(dict["membership"]) as? String ?? ""
//        self.LikeAPI(Receiver_id: receiver_id, Super_user_id: receiver_id,Type: type)
        let Rid = Int(self.recieverId) ?? 0
        let Uid = Int(self.user_id) ?? 0
        if Rid < Uid {
            self.room_id = receiver_id + "-" + user_id
            print(self.room_id)
        }else{
            self.room_id = user_id + "-" + receiver_id
            print(self.room_id)
        }
        SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: receiver_id, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: type, Room_id: room_id)
            let vc = ChatVC(nibName: "ChatVC", bundle: nil)
            vc.room_id = room_id
            vc.UserName = self.userName
            vc.imagestr = self.image
            vc.member = self.memberShipe
            vc.m_recieverId = receiver_id
            vc.isCommingFromlikeToChat = "likeToChat"
            print(vc.m_recieverId)
            print(vc.UserName)
            self.onlyPushViewController(vc)
            self.getFriendListAPI()
    }
    //MARK:- DisLike Button Action
    @objc func removeButtonAction(_ sender: UIButton){
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! [String: Any]
        let receiver_id = DataManager.getVal(dict["user_id"]) as? String ?? ""
        self.DislikeAPI(Receiver_id: receiver_id, Super_user_id: receiver_id)
//        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
//        let alert = SCLAlertView(appearance: appearance)
//        alert.addButton("UnFriend", backgroundColor: UIColor.systemPink){
//
//        }
//        alert.addButton("Cancel", backgroundColor: UIColor.systemPink){
//            print("NO")
//        }
//        alert.showEdit("Remove Friend", subTitle: "Are you sure you want to unfriend?")
    }
    //MARK:- Like API
    func LikeAPI(Receiver_id:String,Super_user_id:String,Type: String){
        let Rid = Int(self.recieverId) ?? 0
        let Uid = Int(self.user_id) ?? 0
        if Rid < Uid {
            self.room_id = recieverId + "-" + user_id
            print(self.room_id)
        }else{
            self.room_id = user_id + "-" + recieverId
            print(self.room_id)
        }
        self.LikeType = "2"
//        let methodName = "like/add"

//        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
//
//            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
//            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
//            let isfriend = DataManager.getVal(responseData?["is_friend"]) as? String ?? ""
//            if status == "1"{
//                if isfriend == "1"{
//                    if let dict = DataManager.getVal(responseData?["user"]) as? NSDictionary{
//                        self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
//                        self.recieverName = DataManager.getVal(dict["name"]) as? String ?? ""
//                        self.recieverImage = DataManager.getVal(dict["image"]) as? String ?? ""
//                        print(self.recieverId)
//                        print(self.recieverName)
//                        print(self.recieverImage)
//                    }
//                    let room = DataManager.getVal(responseData?["room"]) as? String ?? ""
//                    let vc = ChatVC(nibName: "ChatVC", bundle: nil)
//                    vc.room_id = room
//                    vc.UserName = self.userName
//                    vc.imagestr = self.image
//                    self.onlyPushViewController(vc)
//                    self.getFriendListAPI()
//                }else{
//                    self.getFriendListAPI()
//                }
//                self.view.makeToast(message: message)
//
//            }else{
//                self.view.makeToast(message: message)
//            }
//            self.clearAllNotice()
//        }
    }
    //MARK:- DisLike API
    func DislikeAPI(Receiver_id:String,Super_user_id:String){
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(Receiver_id), forKey: "receiver_id")
        dict.setValue(DataManager.getVal(Super_user_id), forKey: "super_user_id")
        
        let methodName = "like/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.view.makeToast(message: message)
                self.getFriendListAPI()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
}
