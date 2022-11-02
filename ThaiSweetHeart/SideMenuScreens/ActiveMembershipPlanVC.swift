//
//  ActiveMembershipPlanVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 28/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ActiveMembershipPlanVC: BaseViewSideMenuController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var goldMemberIcon: UIImageView!
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var planImage: UIImageView!
    @IBOutlet weak var membTypeLbl: UILabel!
    @IBOutlet weak var destableview: UITableView!
    @IBOutlet weak var membershipTypeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var strDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var upgradeBtn: MyButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var desArray = [Any]()
    var membership = String()
    var goldTitle = String()
    var menuBarBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
//        self.title = "Active Membership Plan"
        FindTrasancation()
        let nibClass = UINib(nibName: "PLanListTableCell", bundle: nil)
        self.destableview.register(nibClass, forCellReuseIdentifier: "PLanListTableCell")
        self.destableview.rowHeight = UITableView.automaticDimension
        self.destableview.delegate = self
        self.destableview.dataSource = self
        self.upgradeBtn.layer.cornerRadius = 6
        self.planView.layer.cornerRadius = 6
        self.planImage.layer.cornerRadius = 6
        
        // Do any additional setup after loading the view.
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title

        bar_title.text = language == "en" ? kManage_Connections_Title : kThManage_Connections_Title
        self.membershipTypeLbl.text = language == "en" ? kmembershipTypeLbl : kThmembershipTypeLbl
        self.priceLbl.text = language == "en" ? kpriceLbl : kThpriceLbl
        self.strDate.text = language == "en" ? kstrDate : kThstrDate
        self.endDate.text = language == "en" ? kendDate : kThendDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PLanListTableCell" ,for: indexPath) as! PLanListTableCell
        let dict = desArray[indexPath.row] as? [String: Any] ?? [:]
        
        let title = dict["txt"] as? String ?? ""
        let img = dict["img"] as? String ?? ""
        
        Config().setimage(name: img, image: cell.imgView)
        
        cell.titleLbl.text = title
        return cell
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func FindTrasancation(){
        self.pleaseWait()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
        let methodName = "find-subscription"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if let dict = DataManager.getVal(responseData?["subscription"]) as? NSDictionary{
                    self.membTypeLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
                    self.strDate.text = DataManager.getVal(dict["start_date"]) as? String ?? ""
                    self.endDate.text = DataManager.getVal(dict["end_date"]) as? String ?? ""
                    self.priceLbl.text = "$\(DataManager.getVal(dict["price"]) as? String ?? "")"
                    let period = DataManager.getVal(dict["period"]) as? String ?? ""
                    if period == "1" {
                        self.membershipTypeLbl.text = "Monthly"
                    }else if period == "2"{
                        self.membershipTypeLbl.text = "Quartly"
                    }else if period == "3"{
                        self.membershipTypeLbl.text = "Yearly"
                    }
                    self.membership = DataManager.getVal(dict["membership"]) as? String ?? ""
                    self.desArray = dict.value(forKey: "description") as? [Any] ?? []
                    print(desArray)
                    print(dict)
                }
                
                if self.membership == "3" {
                    self.goldMemberIcon.isHidden = false
                    self.upgradeBtn.isHidden = true
                }else{
                    self.goldMemberIcon.isHidden = true
                    self.upgradeBtn.isHidden = false
                }
                self.destableview.reloadData()
                self.destableview.needsUpdateConstraints()
                self.destableview.layoutIfNeeded()
                self.tableHeightConstraint.constant = self.destableview.contentSize.height - 80
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @IBAction func upgradeBtnAction(_ sender: Any) {
        
        let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
        onlyPushViewController(detailVC)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
