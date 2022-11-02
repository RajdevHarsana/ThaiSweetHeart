//
//  MembershipVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 03/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MembershipVC: BaseViewSideMenuController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var PlanTblView: UITableView!
    var listArray = [Any]()
    var dataArray = [Any]()
    var imgArray = [String]()
    var iconArray = [String]()
    var menuBarBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.title = "Membership Plans"
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kMembership_Plans : kThMembership_Plans
        
        self.imgArray = ["banner1","banner3"]
        self.iconArray = ["card-icon-per","crown","crowncrown-1"]
        let nibClass = UINib(nibName: "MembershipTableCell", bundle: nil)
        self.PlanTblView.register(nibClass, forCellReuseIdentifier: "MembershipTableCell")
        self.PlanTblView.rowHeight = UITableView.automaticDimension
        self.PlanTblView.delegate = self
        self.PlanTblView.dataSource = self
        
        self.membershipAPI()
        
    }
    func membershipAPI(){
        self.pleaseWait()
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        let methodName = "membership"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
            let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
            
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?.object(forKey: "membership")) as? [Any] ?? []
                self.PlanTblView.reloadData()
                self.PlanTblView.backgroundView = nil
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.PlanTblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.PlanTblView{
            return self.dataArray.count
        }else{
            return self.listArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.PlanTblView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipTableCell" ,for: indexPath) as! MembershipTableCell
            let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! NSDictionary
            cell.NameLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
            if indexPath.row == 0 {
                cell.PriceLbl.text = "Free"
            }else{
                cell.PriceLbl.text = "$\(DataManager.getVal(dict["price"]) as? String ?? "")/Per Month"
            }
            
            if indexPath.row == 0 {
                cell.buybtnHeightConstraint.constant = 0
            }else{
                cell.buybtnHeightConstraint.constant = 40
            }
            
            self.listArray = DataManager.getVal(dict["description"]) as? [Any] ?? []
//            cell.BackView.backgroundColor = .random()
            let image = imgArray[indexPath.row]
            cell.backImage.image = UIImage(named: image)
            let iconImg = iconArray[indexPath.row]
            cell.iconImage.image = UIImage(named: iconImg)
            let MembershipId = DataManager.getVal(dict["membership_id"]) as? String ?? ""
            if MembershipId == "3"{
                cell.iconImage.isHidden = false
                cell.buyBtn.isHidden = false
                cell.buyBtn.layer.cornerRadius = 8
            }else if MembershipId == "2"{
                cell.iconImage.isHidden = false
                cell.buyBtn.isHidden = true
                cell.buyBtn.layer.cornerRadius = 8
            }else{
                cell.iconImage.isHidden = true
                cell.buyBtn.isHidden = true
            }
            cell.layer.cornerRadius = 10
            let nib = UINib(nibName: "PLanListTableCell", bundle: nil)
            cell.PlanListTblView.register(nib, forCellReuseIdentifier: "PLanListTableCell")
            cell.PlanListTblView.rowHeight = UITableView.automaticDimension
            cell.PlanListTblView.delegate = self
            cell.PlanListTblView.dataSource = self
            cell.PlanListTblView.reloadData()
            cell.PlanListTblViewHeightConstraint.constant = CGFloat(self.listArray.count*35)
//            cell.PlanListTblViewHeightConstraint.constant = CGFloat(6*44)
            let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
            cell.buyBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
            cell.buyBtn.tag  = indexPath.row
            cell.buyBtn.addTarget(self, action: #selector(Handletap(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PLanListTableCell" ,for: indexPath) as! PLanListTableCell
            cell.backgroundColor = UIColor.clear
            let dict = self.listArray[indexPath.row] as? [String:Any] ?? [:]
            cell.titleLbl.text = DataManager.getVal(dict["txt"]) as? String ?? ""
            Config().setimage(name: DataManager.getVal(dict["img"]) as? String ?? "", image: cell.imgView)
            return cell
        }
    }

    @objc func Handletap(_ sender:UIButton) {
        let dict = DataManager.getVal(self.dataArray[sender.tag]) as! NSDictionary
        let memid = DataManager.getVal(dict["membership_id"]) as? String ?? ""
        let vc = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
        vc.member_id = memid
        self.onlyPushViewController(vc)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
}
