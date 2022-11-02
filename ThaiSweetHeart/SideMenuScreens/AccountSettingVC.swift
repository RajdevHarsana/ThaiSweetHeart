//
//  AccountSettingVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import CountryList

@available(iOS 13.0, *)
class AccountSettingVC: BaseViewSideMenuController,CountryListDelegate {
    
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var FullNameTxtField: UITextField!
    @IBOutlet weak var emailIdLbl: UILabel!
    @IBOutlet weak var EmailIdTxtField: UITextField!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var CountryCodeTxtField: UITextField!
    @IBOutlet weak var PhoneNumberTxtField: UITextField!
    
    @IBOutlet weak var editEmailBtn: UIButton!
    @IBOutlet weak var editPhoneBtn: UIButton!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var GenderTxtField: UITextField!

    @IBOutlet weak var changePasswordBtn: MyButton!
    @IBOutlet weak var deleteAccountBtn: MyButton!
    @IBOutlet weak var deactiveAccountBtn: MyButton!
    
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var DOBTxtField: MyTextField!
    let formatter = DateFormatter()
    var countryList = CountryList()
    var CodeCountry = String()
    var menuBarBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
//        self.title = "Account Settings"
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.DOBTxtField.delegate = self
        self.CountryCodeTxtField.isUserInteractionEnabled = false
        self.EmailIdTxtField.isUserInteractionEnabled = false
        self.PhoneNumberTxtField.isUserInteractionEnabled = false
        self.FullNameTxtField.isUserInteractionEnabled = false
        self.DOBTxtField.isUserInteractionEnabled = false
        self.GenderTxtField.isUserInteractionEnabled = false
//        NotificationCenter.default.addObserver(self, selector: #selector(self.currentPlayedSong(_:)), name: NSNotification.Name("SHOW"), object: nil)
        self.countryList.delegate = self
        self.getProfileDataAPI()
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
        bar_title.text = language == "en" ? kAccount_Settings : kThAccount_Settings
        self.fullNameLbl.text = language == "en" ? kfullNameLbl : kThfullNameLbl
        self.FullNameTxtField.placeholder = language == "en" ? kFullNameTxtField : kThFullNameTxtField
        self.emailIdLbl.text = language == "en" ? kemailIdLblAcc : kThemailIdLbl
        self.EmailIdTxtField.placeholder = language == "en" ? kemailIdLbl : kThemailIdLbl
        self.editEmailBtn.setTitle(language == "en" ? keditEmailBtn : kTheditEmailBtn, for: .normal)
        self.phoneNumberLbl.text = language == "en" ? kPhone_Number : kThPhone_Number
        self.PhoneNumberTxtField.placeholder = language == "en" ? kPhone_Number : kThPhone_Number
        self.editPhoneBtn.setTitle(language == "en" ? keditPhoneBtn : kTheditPhoneBtn, for: .normal)
        self.genderLbl.text = language == "en" ? kSignUpgenderLbl : ThgenderLbl
        self.dobLbl.text = language == "en" ? kdobLbl : kThdobLbl
        self.DOBTxtField.placeholder = language == "en" ? kDOBTxtField : kThDOBTxtField
        self.changePasswordBtn.setTitle(language == "en" ? kchangePasswordBtn : kThchangePasswordBtn, for: .normal)
        self.deleteAccountBtn.setTitle(language == "en" ? kdeleteAccountBtn : kThdeleteAccountBtn, for: .normal)
        self.deactiveAccountBtn.setTitle(language == "en" ? kdeactiveAccountBtn : kThdeactiveAccountBtn, for: .normal)
    }
    func selectedCountry(country: Country) {
        self.CountryCodeTxtField.text = "+\(country.phoneExtension)"
        print(self.CountryCodeTxtField.text)
        self.CodeCountry = "+\(country.phoneExtension)"
        let defaults = UserDefaults.standard
        defaults.setValue("Edit Phone Number", forKey: "TitleLb")
        defaults.setValue("Please enter new phone number", forKey: "enteremail")
        defaults.setValue("Phone", forKey: "placeholder")
        defaults.synchronize()
        let nextview = EditEmailPhoneView.intitiateFromNib()
        let model = BackModel()
        nextview.countryTxt.text = self.CodeCountry
        nextview.buttonCountryHandler = { (code) in
            model.closewithAnimation()
            nextview.countryTxt.delegate = self
            let navController = UINavigationController(rootViewController: self.countryList)
            self.present(navController, animated: true, completion: nil)
        }
        nextview.buttonDoneNewHandler = { (Phone,CountryCode) in
          self.UpdateProfileMobileAPI(Phone: Phone, CountryCode: CountryCode)
          model.closewithAnimation()
        }
        nextview.buttonCancelHandler = {
           model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.DOBTxtField{
            self.view.endEditing(true)
            let max = Date()
            
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            comps.year = -50
            let minDate = calendar.date(byAdding: comps, to: Date())

            DPPickerManager.shared.showPicker(title: "Date Of Birth", selected: Date(), min: minDate, max: max) { (date, cancel) in
                if !cancel {
                    let date = self.formatter.string(from: date!)
                    self.DOBTxtField.text = date
                    debugPrint(date as Any)
                }
            }
            return false
        }else {
            return true
        }
        
    }
    func getProfileDataAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "profile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                DispatchQueue.main.async( execute: { [self] in
                    if let genderdict = DataManager.getVal(responseData?["gender_str"]) as? String{
                        print(genderdict)
                        self.GenderTxtField.text = genderdict
                    }

                    if let profile = DataManager.getVal(responseData?["profile"]) as? NSDictionary{
                        self.FullNameTxtField.text = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        self.DOBTxtField.text = DataManager.getVal(profile["dob"]) as? String ?? ""
                        let social_login = DataManager.getVal(profile["social_login"]) as? String ?? ""
                        if social_login == "1"{
                            self.editEmailBtn.isHidden = true
                            self.editPhoneBtn.isHidden = true
                        }else{
                            self.editEmailBtn.isHidden = false
                            self.editPhoneBtn.isHidden = false
                        }
                    }
                    if let user = DataManager.getVal(responseData?["user"]) as? NSDictionary{
                        self.EmailIdTxtField.text = DataManager.getVal(user["email"]) as? String ?? ""
                        self.PhoneNumberTxtField.text = DataManager.getVal(user["phone"]) as? String ?? ""
                        self.CountryCodeTxtField.text = DataManager.getVal(user["country_code"]) as? String ?? ""
                    }
                })
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    @IBAction func ChangePasswordButtonAction(_ sender: MyButton) {
        let vc = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        self.onlyPushViewController(vc)
    }
    @IBAction func editEmailBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("Edit Email", forKey: "TitleLb")
        defaults.setValue("Please enter new email", forKey: "enteremail")
        defaults.setValue("Email ID", forKey: "placeholder")
        defaults.synchronize()
        let nextview = EditEmailPhoneView.intitiateFromNib()
        let model = BackModel()

        nextview.buttonDoneHandler = { (Email) in
            self.UpdateProfileAPI(Email: Email)
            model.closewithAnimation()
        }
        nextview.buttonCancelHandler = {
           model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
    @IBAction func editPhoneBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("Edit Phone Number", forKey: "TitleLb")
        defaults.setValue("Please enter new phone number", forKey: "enteremail")
        defaults.setValue("Phone", forKey: "placeholder")
        defaults.synchronize()
        let nextview = EditEmailPhoneView.intitiateFromNib()
        let model = BackModel()
        nextview.buttonCountryHandler = { (code) in
            model.closewithAnimation()
            nextview.countryTxt.delegate = self
            nextview.countryList.delegate = self
            let navController = UINavigationController(rootViewController: self.countryList)
            self.present(navController, animated: true, completion: nil)
           
        }
        nextview.buttonDoneNewHandler = { (Phone,CountryCode) in
          self.UpdateProfileMobileAPI(Phone: Phone, CountryCode: CountryCode)
          model.closewithAnimation()
        }
        nextview.buttonCancelHandler = {
           model.closewithAnimation()
        }
        model.show(view: nextview)
    }
    
    @IBAction func DeleteAccountButtonAction(_ sender: MyButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("DELETE", backgroundColor: UIColor(displayP3Red: 238/255, green: 158/255, blue: 180/255, alpha: 1.0)){
            self.deleteAccountAPI()
        }
        alert.addButton("CANCEL", backgroundColor: UIColor(displayP3Red: 146/255, green: 218/255, blue: 233/255, alpha: 1.0)){
            print("NO")
        }
        alert.showEdit("Delete Account", subTitle: "Stay with us, dating takes time you are missing a chance.")
    }
    @IBAction func DeActivateAccountButtonAction(_ sender: MyButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("YES", backgroundColor: UIColor(displayP3Red: 238/255, green: 158/255, blue: 180/255, alpha: 1.0)){
            self.DeactivateAccountAPI()
        }
        alert.addButton("NO", backgroundColor: UIColor(displayP3Red: 146/255, green: 218/255, blue: 233/255, alpha: 1.0)){
            print("NO")
        }
        alert.showEdit("DeActivate Account", subTitle: "Are you sure you want to deactivate your account?")
    }
    func deleteAccountAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        let methodName = "profile/delete"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                Config().AppUserDefaults.set("no", forKey: "login")
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                self.RootViewControllerWithNav(vc)
                UIApplication.topViewController()?.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func UpdateProfileAPI(Email:String!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(Email), forKey: "email")
        
        let methodName = "profile/update-user"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let user = DataManager.getVal(responseData?["user"]) as? String ?? ""
            
            if status == "1"{
                let vc = UpdateEmailAndPhoneVerificationVC(nibName: "UpdateEmailAndPhoneVerificationVC", bundle: nil)
                vc.value = user
                vc.isemail = "1"
                self.onlyPushViewController(vc)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func UpdateProfileMobileAPI(Phone:String!,CountryCode:String!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(Phone), forKey: "phone")
        dict.setValue(DataManager.getVal(CountryCode), forKey: "country_code")
        
        let methodName = "profile/update-user"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let user = DataManager.getVal(responseData?["user"]) as? String ?? ""
            
            if status == "1"{
                let vc = UpdateEmailAndPhoneVerificationVC(nibName: "UpdateEmailAndPhoneVerificationVC", bundle: nil)
                vc.value = user
                vc.isemail = "0"
                self.onlyPushViewController(vc)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func DeactivateAccountAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "profile/deactivate"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                Config().AppUserDefaults.set("no", forKey: "login")
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                self.RootViewControllerWithNav(vc)
                UIApplication.topViewController()?.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
}
