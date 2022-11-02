//
//  NotificationVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 18/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
class NotificationVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var NotificationTblView: UITableView!
    var dataArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Notifications"
        self.navigationItem.titleView = bar_title
        
        let nibClass = UINib(nibName: "NotificationTableCell", bundle: nil)
        self.NotificationTblView.register(nibClass, forCellReuseIdentifier: "NotificationTableCell")
        self.NotificationTblView.rowHeight = UITableView.automaticDimension
        self.NotificationTblView.delegate = self
        self.NotificationTblView.dataSource = self
        
        self.getNotificationsAPI()
    }
    func getNotificationsAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "notification"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["notification"]) as? [Any] ?? []
                self.NotificationTblView.reloadData()
                self.NotificationTblView.backgroundView = nil
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.NotificationTblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell" ,for: indexPath) as! NotificationTableCell
        if let dict = DataManager.getVal(self.dataArray[indexPath.row]) as? [String: Any]{
            cell.descLbl.text = DataManager.getVal(dict["message"]) as? String ?? ""
            if let senderdict = DataManager.getVal(dict["sender"]) as? [String: Any]{
                cell.titleLbl.text = DataManager.getVal(senderdict["fullname"]) as? String ?? ""

                Config().setimage(name: DataManager.getVal(senderdict["image"]) as? String ?? "", image: cell.imgView)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
