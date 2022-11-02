//
//  ManageConnectionsVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class ManageConnectionsVC: BaseViewSideMenuController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var ConnectionTblView: UITableView!
    //MARK:- Objects
    var dataArray = [Any]()
    var menuBarBtn = UIBarButtonItem()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kManage_Connections : kThManage_Connections
        
        let nibClass = UINib(nibName: "ManageConnectionTableCell", bundle: nil)
        self.ConnectionTblView.register(nibClass, forCellReuseIdentifier: "ManageConnectionTableCell")
        self.ConnectionTblView.rowHeight = UITableView.automaticDimension
        self.ConnectionTblView.delegate = self
        self.ConnectionTblView.dataSource = self
        
//        self.getFriendsListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getFriendsListAPI()
    }
    //MARK:- List API
    func getFriendsListAPI(){
        self.pleaseWait()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "friend/list"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["friend"]) as? [Any] ?? []
                self.ConnectionTblView.reloadData()
                self.ConnectionTblView.backgroundView = nil
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.ConnectionTblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    //MARK:- Chat Button Action
    @objc func chatButtonAction(_ sender: UIButton){
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! [String: Any]
        let roomID = DataManager.getVal(dict["room"]) as? String ?? ""
        let image = DataManager.getVal(dict["image"]) as? String ?? ""
        let userName = DataManager.getVal(dict["fullname"]) as? String ?? ""
        let user_id = DataManager.getVal(dict["user_id"]) as? String ?? ""
        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
        vc.room_id = roomID
        vc.imagestr = image
        vc.UserName = userName
        vc.receiverid = user_id
        self.onlyPushViewController(vc)
    }
    //MARK:- Remove Button Action
    @objc func removeButtonAction(_ sender: UIButton){
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! [String: Any]
        let friend_id = DataManager.getVal(dict["friend_id"]) as? String ?? ""
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("UnFriend", backgroundColor: UIColor.systemPink){
            self.removeFrndAPI(friendId: friend_id, Type: "1")
        }
        alert.addButton("Cancel", backgroundColor: UIColor.systemPink){
            print("NO")
        }
        alert.showEdit("Remove Friend", subTitle: "Are you sure you want to unfriend?")
    }
    
    func removeFrndAPI(friendId:String,Type:String){
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(friendId), forKey: "friend_id")
        dict.setValue(DataManager.getVal(Type), forKey: "type")
        
        let methodName = "friend/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.view.makeToast(message: message)
                self.getFriendsListAPI()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    //MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageConnectionTableCell" ,for: indexPath) as! ManageConnectionTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.aboutLbl.text = DataManager.getVal(dict["about"]) as? String ?? ""
        cell.nameLbl.text = DataManager.getVal(dict["fullname"]) as? String ?? ""

        let membership = DataManager.getVal(dict["membership"]) as? String ?? ""
        if membership == "3"{
            cell.goldMemberIcon.isHidden = false
        }else{
            cell.goldMemberIcon.isHidden = true
        }
        Config().setimage(name: DataManager.getVal(dict["image"]) as? String ?? "", image: cell.imgView)

        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        cell.chatButton.setTitle(lang == "en" ? kchatButton : kThchatButton, for: .normal)
        cell.chatButton.tag = indexPath.row
        cell.chatButton.addTarget(self, action: #selector(self.chatButtonAction), for: .touchUpInside)
        cell.removeButton.setTitle(lang == "en" ? kremoveButton : kThremoveButton, for: .normal)
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.removeButtonAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String:Any]
        let user_id = DataManager.getVal(Dict["user_id"]) as? String ?? ""
        let membership = DataManager.getVal(Dict["membership"]) as? String ?? ""
        let vc = SearchUserDetailVC(nibName: "SearchUserDetailVC", bundle: nil)
        vc.UserDetailID = user_id
        vc.MemberShipStatus = membership
        self.onlyPushViewController(vc)
    }
    
    
}
