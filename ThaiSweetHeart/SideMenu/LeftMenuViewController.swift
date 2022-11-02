//
//  LeftMenuViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//  

import Foundation
import UIKit
import SDWebImage
import CoreLocation
@available(iOS 13.0, *)

var latNew = String()
var longNew = String()

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var TableVw: UITableView!
    @IBOutlet weak var ProfileImgView: MyImageView!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var goldMemberIcon: UIImageView!
    @IBOutlet weak var chooseLangLbl: UILabel!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var lang = String()
    var Menu_Item_Array = [String]()
    var Menu_Item_ArrayThai = [String]()
    var Menu_Item_Image_Array = [String]()
    var user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
    var plantype = String()
    var AnsPercentage = String()
    var likeCount = String()
    var lat1 = String()
    var long1 = String()
//    var membershiptype = String()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.chooseLangLbl.text = lang == "en" ? kChooseLang : kThChooseLang
        self.languageLbl.text = lang == "en" ? "Eng" : "ไทย"
        self.Menu_Item_Image_Array = ["home","manageProfile","filter","preferenceQuestionnaire","manageConnections",
//                                      "connectionRequests",
                                      "privacyControl","membership","notificationSetting","accountSetting","icon1","blockList","informationalPages","logout"]
        
        
        if membershiptype == "3" {
            self.Menu_Item_Image_Array = ["home","manageProfile","filter","preferenceQuestionnaire","privacyControl",
    //                                      "connectionRequests",
                                          "managePayment","notificationSetting","accountSetting","icon1","blockList","informationalPages","logout"]
        }else{
            self.Menu_Item_Image_Array = ["home","manageProfile","filter","preferenceQuestionnaire","privacyControl",
    //                                      "connectionRequests",
                                          "membership","notificationSetting",
                                          "accountSetting","icon1","blockList",
//                                          "manageConnections",
                                          "informationalPages","logout"]
        }
        
        if membershiptype == "3"{//gold
            self.Menu_Item_Array =
                [kHome,kManage_Profile,kPreference,kQuestionnaire,
//                 kManage_Connections,
//                 kConnection_Request,
                 kPrivacy_Control,kManage_Payment,kNotification_Setting,kAccount_Settings,kRequest_Verification,kBlock_List,kInformationalTitle,kLogout]
        }else{
            self.Menu_Item_Array =
                [kHome,kManage_Profile,kPreference,kQuestionnaire,
//                 kManage_Connections,
//                 kConnection_Request,
                 kPrivacy_Control,kMembership_Plans,kNotification_Setting,kAccount_Settings,kRequest_Verification,kBlock_List,kInformationalTitle,kLogout]
        }
        if membershiptype == "3" {
            self.Menu_Item_ArrayThai = [kThHome,kThManage_Profile,kThPreference,kThQuestionnaire,
//                                        kThManage_Connections,
    //                                    kThConnection_Request,
                                        kThPrivacy_Control,kThManagePayments,kThNotification_Setting,kThAccount_Settings,kThRequest_Verification,kThBlock_List,kThInformationalTitle,kThLogout]
        }else{
        
        self.Menu_Item_ArrayThai = [kThHome,kThManage_Profile,kThPreference,kThQuestionnaire,
//                                    kThManage_Connections,
//                                    kThConnection_Request,
                                    kThPrivacy_Control,kThMembership_Plans,kThNotification_Setting,kThAccount_Settings,kThRequest_Verification,kThBlock_List,kThInformationalTitle,kThLogout]
        }
        
        self.getProfileDataAPI()
        
    }
        
        //MARK:- viewDidLoad()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let nibClass = UINib(nibName: "LeftMenuViewCell", bundle: nil)
            self.TableVw.register(nibClass, forCellReuseIdentifier: "LeftMenuViewCell")
            self.TableVw.tableFooterView = UIView(frame: .zero)
            self.TableVw.delegate = self
            self.TableVw.dataSource = self
            self.langView.layer.cornerRadius = 6
        }
    
    @IBAction func languageBtnAction(_ sender: UIButton) {
            let detailVC = LanguageVC(nibName: "LanguageVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }
    
    func getProfileDataAPI(){
        //self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
       // let methodName = "profile"
        let methodName = "profile/sidebar"
        
        DataManager.WithOutPrintgetAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            goldSwipeCountLimit = DataManager.getVal(responseData?["goldSwipeCountLimit"]) as? String ?? ""
            matchSwipeCountLimit = DataManager.getVal(responseData?["matchSwipeCountLimit"]) as? String ?? ""
            newSwipeCountLimit = DataManager.getVal(responseData?["newSwipeCountLimit"]) as? String ?? ""
            suggestionSwipeCountLimit = DataManager.getVal(responseData?["suggestionSwipeCountLimit"]) as? String ?? ""
            self.likeCount = DataManager.getVal(responseData?["likeCount"]) as? String ?? ""
            
            if status == "1"{
                DispatchQueue.main.async( execute: {
                    print(responseData!)
                    if let profile = DataManager.getVal(responseData?["user"]) as? NSDictionary{
                        print(profile)
                        self.UserNameLbl.text = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        self.EmailLbl.text = DataManager.getVal(profile["city"]) as? String ?? ""
                        self.plantype = DataManager.getVal(profile["has_gold_membership"]) as? String ?? ""
                        membershiptype = DataManager.getVal(profile["membership"]) as? String ?? ""
                        print(membershiptype)
                        trial_limit = DataManager.getVal(profile["trial_limit"]) as? String ?? ""
                        membership_limit = DataManager.getVal(profile["membership_limit"]) as? String ?? ""
                        let percentageStr = DataManager.getVal(profile["answer_percentage"]) as? String ?? ""
                        print(percentageStr)
//                        if let distanceDb = Double(percentageStr) {
//                            self.AnsPercentage = "\(distanceDb.round(to:2)) %"
//                        }
                        self.AnsPercentage = "\(percentageStr) %"
                        if membershiptype == "3" {
                            self.goldMemberIcon.isHidden = false
                        }else{
                            self.goldMemberIcon.isHidden = true
                        }
                        
                        self.TableVw.reloadData()
                        Config().setimage(name: DataManager.getVal(profile["image"]) as? String ?? "", image: self.ProfileImgView)
                        Config().AppUserDefaults.set(DataManager.getVal(profile["image"]) as? String ?? "", forKey: "User_Img")
                        Config().AppUserDefaults.set(DataManager.getVal(profile["fullname"]) as? String ?? "", forKey: "User_Name")
                    }
                    
                    if let coordinate = DataManager.getVal(responseData?["coordinate"]) as? NSDictionary{
                        self.lat1 =  DataManager.getVal(coordinate["lat"]) as? String ?? ""
                        self.long1 = DataManager.getVal(coordinate["long"]) as? String ?? ""
                        
                        let lats = Double(self.lat1)
                        let longs = Double(self.long1)
                        lat = lats ?? 0
                        Long = longs ?? 0
                        print(self.lat1)
                        print(self.long1)
                    }
                    
                })
            }else{
                self.view.makeToast(message: message)
            }
            //self.clearAllNotice()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lang == "en" ? self.Menu_Item_Array.count : self.Menu_Item_ArrayThai.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuViewCell" ,for: indexPath) as! LeftMenuViewCell
        cell.ImgVw.image = UIImage(named: self.Menu_Item_Image_Array[indexPath.row])
        cell.titleLable.text = self.lang == "en" ? self.Menu_Item_Array[indexPath.row] : Menu_Item_ArrayThai[indexPath.row]
        let textVal = Menu_Item_Array[indexPath.row]
        if indexPath.row == 3{
            cell.CountLbl.text = self.AnsPercentage
            cell.CountLbl.isHidden = false
        }
//        else if indexPath.row == 5{
//            cell.CountLbl.text = self.likeCount
//            cell.CountLbl.isHidden = false
//        }
        else{
            cell.CountLbl.isHidden = true
        }
        if textVal == "Questionnaire" {
            cell.titleLable.text = textVal
        }else{
            
        }
        if textVal == "Who like & Superlike You"{
            cell.titleLable.text = textVal
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let textVal = Menu_Item_Array[indexPath.row]
        
        if textVal == "Home"{
            let detailVC = HomeVC(nibName: "HomeVC", bundle: nil)
            
//            detailVC.MemberShipStatus = membershiptype
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }else if textVal == "Preference"{
            let detailVC = PreferenceVC(nibName: "PreferenceVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }else if textVal == "Questionnaire"{
            let detailVC = SelectQuestionVC(nibName: "SelectQuestionVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }else if textVal == "Manage Profile"{
            let detailVC = ManageProfileVC(nibName: "ManageProfileVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }
        
        else if textVal == "Manage Connections"{
            let detailVC = ManageConnectionsVC(nibName: "ManageConnectionsVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }
//        else if textVal == "Who likes & Superlike You"{
//            let detailVC = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
//            detailVC.memberShipe = membershiptype
//            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
//        }
        else if textVal == "Privacy Control"{
        let detailVC = PrivacyControlVC(nibName: "PrivacyControlVC", bundle: nil)
        detailVC.memberShip = membershiptype
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }
        else if textVal == "Manage Payment"{
        let detailVC = ActiveMembershipPlanVC(nibName: "ActiveMembershipPlanVC", bundle: nil)
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }
        else if textVal == "Membership Plans"{
            let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }
    else if textVal == "Notification Settings"{
        let detailVC = NotificationSettingVC(nibName: "NotificationSettingVC", bundle: nil)
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }else if textVal == "Account Settings"{
        let detailVC = AccountSettingVC(nibName: "AccountSettingVC", bundle: nil)
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }else if textVal == "Request verification"{
        let detailVC = RequestVerificationVC(nibName: "RequestVerificationVC", bundle: nil)
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }else if textVal == "Block List"{
        let detailVC = BlockListVC(nibName: "BlockListVC", bundle: nil)
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
    }
        else if textVal == "Informational Pages"{
            let detailVC = InformationalPagesVC(nibName: "InformationalPagesVC", bundle: nil)
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
        }else if textVal == "Logout"{
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("YES", backgroundColor: UIColor(displayP3Red: 238/255, green: 158/255, blue: 180/255, alpha: 1.0)){
                self.logOut()
            }
            alert.addButton("NO", backgroundColor: UIColor(displayP3Red: 146/255, green: 218/255, blue: 233/255, alpha: 1.0)){
                print("NO")
            }
            alert.showEdit("Logout", subTitle: "Are you sure you want to logout?")
        }
    }
    func latLong(lat: Double,long: Double)  {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            print("Response GeoLocation : \(String(describing: placemarks))")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Country
            if placeMark != nil{
                if let country = placeMark.addressDictionary!["Country"] as? String {
                    print("Country :- \(country)")
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String {
                        print("City :- \(city)")
                        // State
                        if let state = placeMark.addressDictionary!["State"] as? String{
                            print("State :- \(state)")
                            // Street
                            if let street = placeMark.addressDictionary!["Street"] as? String{
                                print("Street :- \(street)")
                                let str = street
                                let streetNumber = str.components(
                                    separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                                print("streetNumber :- \(streetNumber)" as Any)
                                
                                // ZIP
                                if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                    print("ZIP :- \(zip)")
                                    // Location name
                                    if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                        print("Location Name :- \(locationName)")
                                        // Street address
                                        if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                            print("Thoroughfare :- \(thoroughfare)")
                                            
                                            var properAddress = String()
                                            self.EmailLbl.text = "\(city),\(state),\(streetNumber),\(zip),\(locationName)"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                self.EmailLbl.text = "No address available."
            }
        })
    }
    func logOut(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "logout"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            //let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                Config().AppUserDefaults.set("no", forKey: "login")
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                self.RootViewControllerWithNav(vc)
            }else{
                Config().AppUserDefaults.set("no", forKey: "login")
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                self.RootViewControllerWithNav(vc)
            }
            self.clearAllNotice()
        }
    }
}
