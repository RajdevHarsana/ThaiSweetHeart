//
//  BlockListVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
class BlockListVC: BaseViewSideMenuController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var BlockListTblView: UITableView!
    var dataArray = [Any]()
    var dataA = [String:Any]()
    var b_memberShip = String()
    var menuBarBtn = UIBarButtonItem()
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
        bar_title.text = "Details"
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kBlock_List : kThBlock_List
//        self.title = "Block List"
        
        let nibClass = UINib(nibName: "BlockListTableCell", bundle: nil)
        self.BlockListTblView.register(nibClass, forCellReuseIdentifier: "BlockListTableCell")
        self.BlockListTblView.rowHeight = UITableView.automaticDimension
        self.BlockListTblView.delegate = self
        self.BlockListTblView.dataSource = self

        self.getBlockListAPI()
    }
    func getBlockListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "blacklist"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["blacklist"]) as? [Any] ?? []
                let dict = DataManager.getVal(responseData?["blacklist"]) as? [Any] ?? []
                self.BlockListTblView.reloadData()
                self.BlockListTblView.backgroundView = nil
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.BlockListTblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @objc func UnBlockButtonAction(_ sender: UIButton){
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! [String: Any]
        let blacklist_id = DataManager.getVal(dict["receiver_id"]) as? String ?? ""

        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("UnBlock", backgroundColor: UIColor(displayP3Red: 238/255, green: 158/255, blue: 180/255, alpha: 1.0)){
            self.getUnBlockAPI(blacklist_id: blacklist_id)
        }
        alert.addButton("Cancel", backgroundColor: UIColor(displayP3Red: 146/255, green: 218/255, blue: 233/255, alpha: 1.0)){
            print("NO")
        }
        alert.showEdit("UnBlock", subTitle: "Are you sure you want to unblock?")
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockListTableCell" ,for: indexPath) as! BlockListTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.descLbl.text = DataManager.getVal(dict["about"]) as? String ?? ""
        cell.nameLbl.text = DataManager.getVal(dict["fullname"]) as? String ?? ""
        let membership = DataManager.getVal(dict["membership"]) as? String ?? ""
        if membership == "3" {
            cell.goldImg.isHidden = false
        }else{
            cell.goldImg.isHidden = true
        }
        Config().setimage(name: DataManager.getVal(dict["image"]) as? String ?? "", image: cell.imgView)
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        cell.unblockButton.setTitle(lang == "en" ? kunblockButton : kThunblockButton, for: .normal)
        cell.unblockButton.tag = indexPath.row
        cell.unblockButton.addTarget(self, action: #selector(self.UnBlockButtonAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String:Any]
        let userID = DataManager.getVal(Dict["user_id"]) as? String ?? ""
        let receiver_id = DataManager.getVal(Dict["receiver_id"]) as? String ?? ""
        let membership = DataManager.getVal(Dict["membership"]) as? String ?? ""
        print(Dict)
        print(userID)
        print(membership)
        let vc = SearchUserDetailVC(nibName: "SearchUserDetailVC", bundle: nil)
        vc.UserDetailID = receiver_id
        vc.MemberShipStatus = membership
        self.onlyPushViewController(vc)

    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func getUnBlockAPI(blacklist_id: String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(blacklist_id), forKey: "receiver_id")
        
        let methodName = "blacklist/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.getBlockListAPI()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
}
