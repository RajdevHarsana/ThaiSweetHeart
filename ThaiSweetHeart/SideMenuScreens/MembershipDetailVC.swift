//
//  MembershipDetailVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 06/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: String)
}
@available(iOS 13.0, *)
class MembershipDetailVC: BaseViewController {
    
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var hotBtn: UIButton!
    @IBOutlet weak var checkoutBtn: MyButton!
   
    @IBOutlet weak var prifileImage: MyImageView!
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var useraddressLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var priceMLbl: UILabel!
    @IBOutlet weak var quaterlyLbl: UILabel!
    @IBOutlet weak var pricesmlbl: UILabel!
    @IBOutlet weak var priceQLbl: UILabel!
    @IBOutlet weak var pricesqLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var priceYlbl: UILabel!
    @IBOutlet weak var pricesylbl: UILabel!
    var member_id:String!
    @IBOutlet weak var firstplanImg: UIImageView!
    @IBOutlet weak var secondplanImg: UIImageView!
    @IBOutlet weak var thirdplanImg: UIImageView!
    var peri:String!
    var firstS:String!
    var secondS:String!
    var thirdS:String!
    var fullname:String!
    var makeTost:String!
    var comeFromHome = String()
    var comeFromConnectionRequest = String()
    var backToConnectionRequest = String()
    var delegate: MyDataSendingDelegateProtocol?
    var menuBarBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backToConnectionRequest = "comeFromMemberShip"
        self.delegate?.sendDataToFirstViewController(myData: self.backToConnectionRequest)
        if self.comeFromHome == "yes" {
            self.navigationItem.leftBarButtonItem = nil
            let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
            self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
            self.navigationItem.leftBarButtonItem = self.menuBarBtn
        }
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backAction))
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar.png"), for: .default)
        prifileImage.layer.cornerRadius = prifileImage.frame.height/2
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.title = "Membership Plan"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        bar_title.text = lang == "en" ? kMembership_Plans : kThMembership_Plans
        self.memberLbl.text = lang == "en" ? kmemberLbl : kThmemberLbl
        self.hotBtn.setTitle(lang == "en" ? khotBtn : kThhotBtn, for: .normal)
        self.checkoutBtn.setTitle(lang == "en" ? kcheckoutBtn : kThcheckoutBtn, for: .normal)
        UpdateProfileAPI()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func UpdateProfileAPI(){
        self.pleaseWait()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal("3"), forKey: "membership_id")
        print(member_id as Any)
        let methodName = "membership/view"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
               var dict = NSDictionary()
               dict = (DataManager.getVal(responseData?["profile"]) as? NSDictionary)!
               self.usernamelbl.text  = DataManager.getVal(dict["name"]) as? String ?? ""
                print(self.usernamelbl.text)
                Config().setimage(name: DataManager.getVal(dict["image"]) as? String ?? "", image: self.prifileImage)
                var membership = NSDictionary()
                membership = (DataManager.getVal(responseData?["membership"]) as? NSDictionary)!
                
                var membershipM = NSDictionary()
                membershipM = (DataManager.getVal(membership["monthly"]) as? NSDictionary)!
                
                var price:String!
                var saleprice:String!
                price = DataManager.getVal(membershipM["total"]) as? String ?? ""
                saleprice = DataManager.getVal(membershipM["sale"]) as? String ?? ""
                self.firstS = saleprice
                self.pricesmlbl.text = "price" + "$" + price
                self.priceMLbl.text = "$" + saleprice
                var membershipQ = NSDictionary()
                membershipQ = (DataManager.getVal(membership["quarterly"]) as? NSDictionary)!
                
                var price1:String!
                var saleprice1:String!
                price1 = DataManager.getVal(membershipQ["total"]) as? String ?? ""
                saleprice1 = DataManager.getVal(membershipQ["sale"]) as? String ?? ""
                self.secondS = saleprice1
                self.pricesqLbl.text = "price" + "$" + price1
                self.priceQLbl.text = "$" + saleprice1
                    
                
                var membershipY = NSDictionary()
                membershipY = (DataManager.getVal(membership["yearly"]) as? NSDictionary)!
                
                var price2:String!
                var saleprice2:String!
                price2 = DataManager.getVal(membershipY["total"]) as? String ?? ""
                saleprice2 = DataManager.getVal(membershipY["sale"]) as? String ?? ""
                self.thirdS = saleprice2
                self.pricesylbl.text =  "price" + "$" + price2
                self.priceYlbl.text = "$" + saleprice2
                   
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @IBAction func monthAction(_ sender: Any) {
        self.firstplanImg.layer.borderWidth = 3
        self.firstplanImg.layer.borderColor = UIColor(red: 247/255, green: 131/255, blue: 159/255, alpha: 1).cgColor
        self.firstplanImg.layer.cornerRadius = 8
        
        self.secondplanImg.layer.borderWidth = 0
        self.secondplanImg.layer.borderColor = UIColor.clear.cgColor
        
        self.thirdplanImg.layer.borderWidth = 0
        self.thirdplanImg.layer.borderColor = UIColor.clear.cgColor
        
        self.peri = "1"
    
        
    }
    
    @IBAction func quterAction(_ sender: Any) {
        self.firstplanImg.layer.borderWidth = 0
        self.firstplanImg.layer.borderColor = UIColor.clear.cgColor
        
        self.secondplanImg.layer.borderWidth = 3
        self.secondplanImg.layer.borderColor = UIColor(red: 247/255, green: 131/255, blue: 159/255, alpha: 1).cgColor
        self.secondplanImg.layer.cornerRadius = 8
        
        self.thirdplanImg.layer.borderWidth = 0
        self.thirdplanImg.layer.borderColor = UIColor.clear.cgColor
       
        self.peri = "2"
    }
    
    @IBAction func yearAction(_ sender: Any) {
        self.firstplanImg.layer.borderWidth = 0
        self.firstplanImg.layer.borderColor = UIColor.clear.cgColor
        
        self.secondplanImg.layer.borderWidth = 0
        self.secondplanImg.layer.borderColor = UIColor.clear.cgColor
        
        self.thirdplanImg.layer.borderWidth = 3
        self.thirdplanImg.layer.borderColor = UIColor(red: 247/255, green: 131/255, blue: 159/255, alpha: 1).cgColor
        self.thirdplanImg.layer.cornerRadius = 8
        
        self.peri = "3"
    }
    
    @IBAction func chcekBtnAction(_ sender: Any) {
        
        if self.peri == "1" || self.peri == "2" || self.peri == "3" {
            let nextview = buyMemberShipPop.intitiateFromNib()
            let model = BackModel2()
            nextview.layer.cornerRadius = 8
            nextview.buttonYesHandler = {
            self.AddTrasancation()
            model.closewithAnimation()
            }
            nextview.buttonNoHandler = {
                model.closewithAnimation()
            }
            model.show(view: nextview)
        }else{
        self.view.makeToast(message: "Please select membership period")
        }
    }
    
    func AddTrasancation(){
        self.pleaseWait()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal("3"), forKey: "membership_id")
        dict.setValue(DataManager.getVal(peri), forKey: "period")
        
        dict.setValue(DataManager.getVal(usernamelbl.text), forKey: "pay_subscription")
        dict.setValue(DataManager.getVal("Text"), forKey: "pay_txn")
        
        print(dict)
        
        let methodName = "transaction/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                Config().AppUserDefaults.removeObject(forKey: "SwipeCount")
                if self.comeFromConnectionRequest == "yes" {
//                    let vc = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
                    self.navigationController?.popViewController(animated: true)
                }else if self.comeFromHome == "yes"{
                    let vc = ChatVC(nibName: "ChatVC", bundle: nil)
                    self.onlyPushViewController(vc)
                }else{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.makeTost = "1"
                    vc.makeTost = self.makeTost
                    self.RootViewWithSideManu(vc)
                }
                
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
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
