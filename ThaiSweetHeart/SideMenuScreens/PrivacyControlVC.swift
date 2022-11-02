//
//  PrivacyControlVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class PrivacyControlVC: BaseViewSideMenuController {
    
    @IBOutlet weak var everyOneBtn: UIButton!
    @IBOutlet weak var noneBtn: UIButton!
    @IBOutlet weak var onlyConnectionBtn: UIButton!
    @IBOutlet weak var everyOneLbl: UILabel!
    @IBOutlet weak var noneLbl: UILabel!
    @IBOutlet weak var onlyConnectionsLbl: UILabel!
    
    var every = String()
    var none = String()
    var connections = String()
    var memberShip = String()
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
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kPrivacy_Control : kThPrivacy_Control
//        self.title = "Privacy Control"
        self.everyOneLbl.text = lang == "en" ? keveryOneLbl : kTheveryOneLbl
        self.noneLbl.text = lang == "en" ? knoneLbl : kThnoneLbl
        self.onlyConnectionsLbl.text = lang == "en" ? konlyConnectionsLbl : kThonlyConnectionsLbl
        self.getSettingApi()
        
        if self.memberShip == "3"{
            
        }else{
            let nextview = GoldMemberPopUp.intitiateFromNib()
            let model = BackModel()
            nextview.layer.cornerRadius = 8
            nextview.buttonbuyHandler = {
                let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                
                self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
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
    }

    func getSettingApi(){
        self.pleaseWait()
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(self.user_id, forKey: "user_id")
        
        let methodName = "privacy/view"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1" {
                    if let privacy = DataManager.getVal(responseData?.object(forKey: "privacy")) as? NSDictionary{
                        self.every = DataManager.getVal(privacy["everyone"]) as? String ?? ""
                        self.none = DataManager.getVal(privacy["none"]) as? String ?? ""
                        self.connections = DataManager.getVal(privacy["connections"]) as? String ?? ""
                        if self.every == "1"{
                            self.everyOneBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                            self.noneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.onlyConnectionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }else{
                            self.everyOneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }
                        if self.none == "1"{
                            self.everyOneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.noneBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                            self.onlyConnectionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }else{
                            self.noneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }
                        if self.connections == "1"{
                            self.everyOneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.noneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.onlyConnectionBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        }else{
                            self.onlyConnectionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }
    @IBAction func everyOneAction(_ sender: UIButton) {
        self.every = "1"
        self.none = "0"
        self.connections = "0"
        self.everyOneBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.noneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.onlyConnectionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.privacySettingEditAPI(everyone: self.every,none: self.none,connections: self.connections)
    }
    @IBAction func noneAction(_ sender: UIButton) {
        self.every = "0"
        self.none = "1"
        self.connections = "0"
        self.everyOneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noneBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.onlyConnectionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.privacySettingEditAPI(everyone: self.every,none: self.none,connections: self.connections)
    }
    @IBAction func onlyConnectionAction(_ sender: UIButton) {
        self.every = "0"
        self.none = "0"
        self.connections = "1"
        self.everyOneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noneBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.onlyConnectionBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.privacySettingEditAPI(everyone: self.every,none: self.none,connections: self.connections)
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func privacySettingEditAPI(everyone: String,none: String,connections: String){
        self.pleaseWait()

        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(self.user_id, forKey: "user_id")
        parameterDictionary.setValue(everyone, forKey: "everyone")
        parameterDictionary.setValue(none, forKey: "none")
        parameterDictionary.setValue(connections, forKey: "connections")

        print(everyone)
        print(none)
        print(connections)
        let methodName = "privacy/edit"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1" {

                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }

}
