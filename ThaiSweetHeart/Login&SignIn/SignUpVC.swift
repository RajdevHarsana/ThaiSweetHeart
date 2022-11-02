//
//  SignUpVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import CountryList
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SignUpVC: UIViewController,CountryListDelegate,UITextFieldDelegate,GIDSignInDelegate,MyDataSendingDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var FullNameTxtField: UITextField!
    @IBOutlet weak var emailIdLbl: UILabel!
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var CountryCodeTxtField: UITextField!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var PhoneNumberTxtField: UITextField!
    @IBOutlet weak var GenderTxtFeild: MyTextField!
    
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var MaleButton: UIButton!
    @IBOutlet weak var FeMaleButton: UIButton!
    @IBOutlet weak var TranssexualButton: UIButton!
    
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var DOBTxtField: MyTextField!
    
    @IBOutlet weak var doneBtn: MyButton!
    @IBOutlet var SelectMultipleView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SelectTblView: UITableView!
    var gender_name_Array = NSMutableArray()
    var type_select = String()
    var gender_Array = NSMutableArray()
    var dataArray = [Any]()
    var gender_str = String()
    
    @IBOutlet weak var passordLbl: UILabel!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var ConfirmPasswordTxtField: UITextField!
    @IBOutlet weak var submitBtn: MyButton!
    
    @IBOutlet weak var passlblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var passTxtHeightConst: NSLayoutConstraint!
    @IBOutlet weak var confirmPassLblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var confirmtxtHeightConsts: NSLayoutConstraint!
    @IBOutlet weak var buttontopConst: NSLayoutConstraint!
    var gender = "Male"
    let formatter = DateFormatter()
    var countryList = CountryList()
    
    var imgurll = ""
    var emaill = ""
    var name = ""
    var lastName = ""
    var facebookId = ""
    var googleId = ""
    var socialLogin:String!
    var gender_id  = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.submitBtn.layer.cornerRadius = 6
        self.SelectMultipleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.SelectTblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.SelectTblView.rowHeight = UITableView.automaticDimension
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        
        
        socialLogin = UserDefaults.standard.value(forKey: "SOCIALLOGIN") as? String
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.countryList.delegate = self
        self.GenderTxtFeild.delegate = self
        self.formatter.dateFormat = "yyyy-MM-dd"
        PhoneNumberTxtField.keyboardType = .asciiCapableNumberPad
        self.FullNameTxtField.background = UIImage(named: "input-transparent")
        self.EmailTxtField.background = UIImage(named: "input-transparent")
        self.CountryCodeTxtField.background = UIImage(named: "input-transparent")
        self.PhoneNumberTxtField.background = UIImage(named: "input-transparent")
        self.GenderTxtFeild.background = UIImage(named: "input-transparent")
        self.DOBTxtField.background = UIImage(named: "input-transparent")
        self.PasswordTxtField.background = UIImage(named: "input-transparent")
        self.ConfirmPasswordTxtField.background = UIImage(named: "input-transparent")
        
        self.FullNameTxtField.setLeftPaddingPoints(10)
        self.EmailTxtField.setLeftPaddingPoints(10)
        self.CountryCodeTxtField.setLeftPaddingPoints(10)
        self.PhoneNumberTxtField.setLeftPaddingPoints(10)
        self.GenderTxtFeild.setLeftPaddingPoints(10)
        self.DOBTxtField.setLeftPaddingPoints(10)
        self.PasswordTxtField.setLeftPaddingPoints(10)
        self.ConfirmPasswordTxtField.setLeftPaddingPoints(10)
        
        if socialLogin == "Facebook" {
            let email = UserDefaults.standard.value(forKey: "emailId") as? String
            let first = UserDefaults.standard.value(forKey: "first") as? String
            let last = UserDefaults.standard.value(forKey: "last") as? String
            
            if email != nil{
                EmailTxtField.text = email
                EmailTxtField.isUserInteractionEnabled  = false
            }else{
                EmailTxtField.text = ""
                EmailTxtField.isUserInteractionEnabled  = true
            }
            
            if first != nil || first != "" || last != nil || last != "" {
                FullNameTxtField.text = first! + " " + last!
            }else {
                FullNameTxtField.text = ""
            }
            self.passlblHeightConst.constant = 0
            self.passTxtHeightConst.constant  = 0
            self.confirmPassLblHeightConst.constant  = 0
            self.confirmtxtHeightConsts.constant = 0
            buttontopConst.constant = -30
        }else if socialLogin == "Google" {
            let email = UserDefaults.standard.value(forKey: "social_email_id") as? String
            let first = UserDefaults.standard.value(forKey: "social_first_name") as? String
            let last = UserDefaults.standard.value(forKey: "social_last_name") as? String
            
            if email != nil || email != "" {
                EmailTxtField.text = email
                EmailTxtField.isUserInteractionEnabled  = false
            }else {
                EmailTxtField.text = ""
                EmailTxtField.isUserInteractionEnabled  = true
            }
            
            if first != nil || first != "" || last != nil || last != "" {
                FullNameTxtField.text = first! + " " + last!
            }else {
                FullNameTxtField.text = ""
            }
            self.passlblHeightConst.constant = 0
            self.passTxtHeightConst.constant  = 0
            self.confirmPassLblHeightConst.constant  = 0
            self.confirmtxtHeightConsts.constant = 0
            buttontopConst.constant = -30
        }else if socialLogin == "Apple" {
            let email = UserDefaults.standard.value(forKey: "AppleUserEmail") as? String
            let first = UserDefaults.standard.value(forKey: "AppleUserFirstName") as? String
            let last = UserDefaults.standard.value(forKey: "AppleUserLastName") as? String
            
            if email != nil {
                EmailTxtField.text = email
                EmailTxtField.isUserInteractionEnabled  = false
            }else {
                EmailTxtField.text = ""
                EmailTxtField.isUserInteractionEnabled  = true
            }
            
            if first != nil || last != nil{
                FullNameTxtField.text = first! + " " + last!
            }else {
                FullNameTxtField.text = ""
            }
            self.passlblHeightConst.constant = 0
            self.passTxtHeightConst.constant  = 0
            self.confirmPassLblHeightConst.constant  = 0
            self.confirmtxtHeightConsts.constant = 0
            buttontopConst.constant = -30
        }else {
            self.passlblHeightConst.constant = 22
            self.passTxtHeightConst.constant  = 45
            self.confirmPassLblHeightConst.constant  = 22
            self.confirmtxtHeightConsts.constant = 45
            buttontopConst.constant = 30
        }
        
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func MaleButtonAction(_ sender: UIButton) {
        self.gender = "Male"
        self.MaleButton.setImage(UIImage(named: "white-check-radio"), for: .normal)
        self.FeMaleButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
        self.TranssexualButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
    }
    @IBAction func FeMaleButtonAction(_ sender: UIButton) {
        self.gender = "Female"
        self.MaleButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
        self.FeMaleButton.setImage(UIImage(named: "white-check-radio"), for: .normal)
        self.TranssexualButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
    }
    @IBAction func TranssexualButtonAction(_ sender: UIButton) {
        self.gender = "Transsexual"
        self.MaleButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
        self.FeMaleButton.setImage(UIImage(named: "uncheck-radio"), for: .normal)
        self.TranssexualButton.setImage(UIImage(named: "white-check-radio"), for: .normal)
    }
    
    
    //MARK:- Facebook Login Functionality
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Cancelled")
        }  else if result.isCancelled {
            print("Cancelled")
        } else {
            print(result!)
            self.fetchUserData()
        }
    }
    //MARK:- get option data of Gender
    func getOptionsData(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        let methodName = "option/gender"
        dict.setValue(DataManager.getVal(self.gender_id), forKey: "gender_id")
        print(gender_id)
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.type_select == "gender"{
                    self.dataArray = DataManager.getVal(responseData?["gender"]) as? [Any] ?? []
//                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "gender")) as? [Any] ?? []
                }
//                else if self.type_select == "orientation"  {
//                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "orientation")) as? [Any] ?? []
//                }
                self.SelectTblView.reloadData()
                self.showAnimate(YourHiddenView: self.SelectMultipleView, ishidden: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.type_select == "gender"{
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            print(id)
            if self.gender_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        let name = DataManager.getVal(dict["name"]) as? String ?? ""
        if self.type_select == "gender"{
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            print(id)
            if gender_Array.count <= 3 {
            if self.gender_Array.contains(id){
                self.gender_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.gender_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.gender_name_Array.contains(name){
                self.gender_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.gender_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
            }else{
                if gender_Array.count <= 4 {
                    self.gender_Array.remove(id)
                    self.SelectTblView.reloadData()
                    self.gender_name_Array.remove(name)
                    self.SelectTblView.reloadData()
                }else{
                }
                if gender_Array.count == 3 {
                }else{
                    self.SelectMultipleView.makeToast(message: "Maximum selection is four.")
                }
            }
        }
    }
    
    
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if self.type_select == "gender"{
            let select_name = self.gender_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.GenderTxtFeild.text = gender_str
            }else{
                self.GenderTxtFeild.text = select_name
            }
        }
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    //MARK:-Facebook login data
    private func fetchUserData() {
        self.pleaseWait()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name, last_name, picture.type(large)"])
        graphRequest.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error",error!.localizedDescription)
            }else{
                print(result!)
                let field = result! as? [String:Any]
                self.name = field!["first_name"] as? String ?? ""
                print(self.lastName)
                Config().AppUserDefaults.set(DataManager.getVal(self.name), forKey: "first")
                self.lastName = field!["last_name"] as? String ?? ""
                print(self.lastName)
                //var idd = ""
                Config().AppUserDefaults.set(DataManager.getVal(self.lastName), forKey: "last")
                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    
                    self.imgurll = imageURL
                } else {
                    self.imgurll = ""
                }
                
                if let iddd = field!["id"] as? NSNumber {
                    self.facebookId = iddd.stringValue
                    
                }else{
                    self.facebookId = field!["id"] as! String
                    Config().AppUserDefaults.set(DataManager.getVal(self.facebookId), forKey: "facebookid")
                }
                if let email = field!["email"] {
                    self.emaill = email as! String
                    Config().AppUserDefaults.set(DataManager.getVal(self.emaill), forKey: "emailId")
                }else {
                    self.emaill = ""
                }
                //self.name = field!["name"] as! String
                //print(self.name)
                self.clearAllNotice()
               
                self.facebookLogin(name: "\(self.name) \(self.lastName)", facbookID: self.facebookId, email: self.emaill, imgUrll: self.imgurll)
            }
        })
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func SignUpButtonAction(_ sender: MyButton) {
        if socialLogin == "Facebook" {
            if ValidationClass().ValidateUserSignUpFormSocialLogin(self) {
                self.fetchUserData()
            }
        }else if socialLogin == "Google" {
            if ValidationClass().ValidateUserSignUpFormSocialLogin(self) {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            }
        }else if socialLogin == "Apple" {
            if ValidationClass().ValidateUserSignUpFormSocialLogin(self) {
                self.AppleLogin_API()
            }
        }else {
            if ValidationClass().ValidateUserSignUpForm(self){
                self.pleaseWait()
                
                let dict = NSMutableDictionary()
                dict.setValue(DataManager.getVal(self.EmailTxtField.text!), forKey: "email")
                dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "phone")
                dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
                dict.setValue(DataManager.getVal(self.FullNameTxtField.text!), forKey: "fullname")
                dict.setValue(DataManager.getVal(self.DOBTxtField.text!), forKey: "dob")
                dict.setValue(DataManager.getVal(self.CountryCodeTxtField.text!), forKey: "country_code")
                let genderstr = gender_Array.componentsJoined(by: ",")
                dict.setValue(DataManager.getVal(genderstr), forKey: "gender_id")
                dict.setValue(DataManager.getVal(self.GenderTxtFeild.text!), forKey: "gender")
                
                print(genderstr)
                print(GenderTxtFeild.text!)
                print(gender_Array)
                
                let methodName = "register"
                
                DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                    
                    let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                    let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                    
                    if status == "1"{
                        let user = DataManager.getVal(responseData?["user"]) as! NSDictionary
                        let email = DataManager.getVal(user["email"]) as? String ?? ""
                        let phone = DataManager.getVal(user["phone"]) as? String ?? ""

                        let typeComming = true
                        let vc = AllVerificationVC(nibName: "AllVerificationVC", bundle: nil)
                        vc.typeComming = typeComming
                        vc.email = email
                        vc.phone = phone
                        self.onlyPushViewController(vc)
                    }else{
                        self.view.makeToast(message: message)
                    }
                    self.clearAllNotice()
                }
            }
        }
      
    }
    
    
    //MARK:- FaceBook Login Api Integration
    func facebookLogin(name:String,facbookID:String,email:String,imgUrll:String) {
        
        self.pleaseWait()
        
        let facebookProfileUrl = "http://graph.facebook.com/\(facbookID)/picture?type=large"
        let device_token = DataManager.getVal(Config().AppUserDefaults.value(forKey: "deviceToken")) as? String ?? ""
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.EmailTxtField.text!), forKey: "email")
        dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "phone")
        dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
        dict.setValue(DataManager.getVal(self.FullNameTxtField.text!), forKey: "fullname")
        dict.setValue(DataManager.getVal(self.GenderTxtFeild.text!), forKey: "gender")
        dict.setValue(DataManager.getVal(self.DOBTxtField.text!), forKey: "dob")
        dict.setValue(DataManager.getVal(self.CountryCodeTxtField.text!), forKey: "country_code")
        dict.setValue(DataManager.getVal(facbookID), forKey: "facebook_token")
        dict.setValue(DataManager.getVal(""), forKey: "google_token")
        dict.setValue(DataManager.getVal("2"), forKey: "device")
        dict.setValue(DataManager.getVal(device_token), forKey: "device_token")
        dict.setValue(DataManager.getVal(facebookProfileUrl), forKey: "dp_image")
        
        let methodName = "socialLoginRegister"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                DataManager.saveinDefaults(data)
                let phone = DataManager.getVal(data["phone"]) as? String ?? ""
                let vc = AllVerificationVC(nibName: "AllVerificationVC", bundle: nil)
                vc.phone = phone
                self.onlyPushViewController(vc)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    //MARK:-Google Sign in Data
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            return
        }
        let fullName = user.profile.name
        self.name = user.profile.givenName
        self.lastName = user.profile.familyName
        self.emaill = user.profile.email
        
        self.googleId = DataManager.getVal(user.userID) as? String ?? ""
        let email_id = DataManager.getVal(user.profile.email) as? String ?? ""
        let first_name = DataManager.getVal(user.profile.givenName) as? String ?? ""
        let last_name = DataManager.getVal(user.profile.familyName) as? String ?? ""
        
        guard let emailv = user.profile.email else { return }
        guard let imageUrl = user.profile.imageURL(withDimension: 400) else { return }
        print(imageUrl)
        //emailIdTxtFld.text = emailv
        
        var socialInfo : [String:String] = [:]
        socialInfo["email"] = emailv
        socialInfo["social_id"] = user.userID
        socialInfo["social_type"] = "google"
        socialInfo["first_name"] = user.profile.givenName
        socialInfo["last_name"] = user.profile.familyName
        socialInfo["mobile_number"] = ""
        socialInfo["image"] = imageUrl.path
        print(imageUrl.path)
        
        Config().AppUserDefaults.set(imageUrl, forKey: "social_profile_image")
        Config().AppUserDefaults.set(self.googleId, forKey: "social_id")
        Config().AppUserDefaults.set(email_id, forKey: "social_email_id")
        Config().AppUserDefaults.set(first_name, forKey: "social_first_name")
        Config().AppUserDefaults.set(last_name, forKey: "social_last_name")
        
        
        Config().AppUserDefaults.set(DataManager.getVal(email_id), forKey: "emailId")
        Config().AppUserDefaults.set(DataManager.getVal(first_name), forKey: "first")
        Config().AppUserDefaults.set(DataManager.getVal(last_name), forKey: "last")
        Config().AppUserDefaults.set(DataManager.getVal(self.googleId), forKey: "googleid")
        
        self.checkSocialExist(social_id:self.googleId,email:emailv,first_name:user.profile.givenName,last_name:user.profile.familyName,business_name:user.profile.givenName+user.profile.familyName)
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,withError error: Error!) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),object: nil,userInfo: ["statusText": "User has disconnected."])
    }
    //MARK:- Google login api
    func checkSocialExist(social_id:String,email:String,first_name:String,last_name:String,business_name:String){
        
        let image = Config().AppUserDefaults.object(forKey: "image") as? String ?? ""
        print(image)
        let device_token = DataManager.getVal(Config().AppUserDefaults.value(forKey: "deviceToken")) as? String ?? ""
        
        Config().AppUserDefaults.set(social_id, forKey: "social_id")
        Config().AppUserDefaults.set(email, forKey: "social_email_id")
        Config().AppUserDefaults.set(first_name, forKey: "social_first_name")
        Config().AppUserDefaults.set(last_name, forKey: "social_last_name")
        
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.EmailTxtField.text!), forKey: "email")
        dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "phone")
        dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
        dict.setValue(DataManager.getVal(self.FullNameTxtField.text!), forKey: "fullname")
        dict.setValue(DataManager.getVal(self.gender), forKey: "gender")
        dict.setValue(DataManager.getVal(self.DOBTxtField.text!), forKey: "dob")
        dict.setValue(DataManager.getVal(self.CountryCodeTxtField.text!), forKey: "country_code")
        dict.setValue(DataManager.getVal(""), forKey: "facebook_token")
        dict.setValue(DataManager.getVal(social_id), forKey: "google_token")
        dict.setValue(DataManager.getVal("2"), forKey: "device")
        dict.setValue(DataManager.getVal(device_token), forKey: "device_token")
        dict.setValue(DataManager.getVal(image), forKey: "dp_image")
        
        let methodName = "socialLoginRegister"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1"{
                    let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                    DataManager.saveinDefaults(data)
                    let phone = DataManager.getVal(data["phone"]) as? String ?? ""
                    let vc = AllVerificationVC(nibName: "AllVerificationVC", bundle: nil)
                    vc.phone = phone
                    self.onlyPushViewController(vc)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }
    func removeAnimate(YourHiddenView: UIView,ishidden: Bool){
        UIView.animate(withDuration: 0.25, animations: {
            YourHiddenView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            YourHiddenView.alpha = 0.0
            
        }, completion: {(finished : Bool) in
            if(finished)
            {
                YourHiddenView.isHidden = ishidden
                self.willMove(toParent: nil)
                YourHiddenView.removeFromSuperview()
                //self.removeFromParent()
            }
        })
    }
    func showAnimate(YourHiddenView: UIView,ishidden: Bool){
        self.view.window?.addSubview(YourHiddenView)
        YourHiddenView.isHidden = ishidden
        YourHiddenView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        YourHiddenView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            YourHiddenView.alpha = 1.0
            YourHiddenView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    func selectedCountry(country: Country) {
        self.CountryCodeTxtField.text = "+\(country.phoneExtension)"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.DOBTxtField{
            // Date Picker
            self.view.endEditing(true)
            let max = Date()
            
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            comps.year = -99
            let minDate = calendar.date(byAdding: comps, to: Date())
            var comps1 = DateComponents()
            comps1.year = -13
            let maxDate = calendar.date(byAdding: comps1, to: Date())
            
            DPPickerManager.shared.showPicker(title: "Date Of Birth", selected: max, min: minDate, max: maxDate) { (date, cancel) in
                if !cancel {
                    // TODO: you code here
                    let date = self.formatter.string(from: date!)
                    self.DOBTxtField.text = date
                    debugPrint(date as Any)
                }
            }
            return false
        }else if textField == self.GenderTxtFeild{
            self.view.endEditing(true)
            self.type_select = "gender"
            self.TitleLbl.text = "Select Gender"
            self.getOptionsData()
            return false
        }else if textField == self.CountryCodeTxtField{
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    func ChangeLanguage(language:String){
        self.backBtn.setTitle(language == "en" ? kbackBtnSignUp : kThbackBtnSignUp, for: .normal) 
        self.fullNameLbl.text = language == "en" ? kfullNameLbl : kThfullNameLbl
        self.FullNameTxtField.placeholder = language == "en" ? kFullNameTxtField : kThFullNameTxtField
        self.emailIdLbl.text = language == "en" ? kSigneUpmailIdLbl : kThemailIdLbl
        self.EmailTxtField.placeholder = language == "en" ? kSigneUpmailIdLbl : kThemailIdLbl
        self.phoneNumberLbl.text = language == "en" ? kphoneNumberLbl : kThphoneNumberLbl
        self.PhoneNumberTxtField.placeholder = language == "en" ? kPhoneNumberTxtField : kThPhoneNumberTxtField
        self.genderLbl.text = language == "en" ? kSignUpgenderLbl : kThgenderLbl
        self.GenderTxtFeild.placeholder = language == "en" ? kSignUpgenderLbl : kThgenderLbl
//        self.MaleButton.setTitle(language == "en" ? kMaleButton : kThMaleButton, for: .normal)
//        self.FeMaleButton.setTitle(language == "en" ? kFeMaleButton : kThFeMaleButton, for: .normal)
//        self.TranssexualButton.setTitle(language == "en" ? kTranssexualButton : kThTranssexualButton, for: .normal)
        self.dobLbl.text = language == "en" ? kdobLbl : kThdobLbl
        self.DOBTxtField.placeholder = language == "en" ? kDOBTxtField : kThDOBTxtField
        self.passordLbl.text = language == "en" ? kpassordLbl : kThpassordLbl
        self.confirmPasswordLbl.text = language == "en" ? kconfirmPasswordLbl : kThconfirmPasswordLbl
        self.submitBtn.setTitle(language == "en" ? ksubmitBtn : kThsubmitBtn, for: .normal)
    }
    
    //MARK:- Protocol Delegate Function
    func sendDataToFirstViewController(id: String,name: String,type: String) {
        if type == "gender"{
            self.gender_id = id
            self.GenderTxtFeild.text = name
        }
    }
}
@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func AppleLogin_API(){
//        let AppleUserEmail = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserEmail")) as? String ?? ""
//        let AppleUserFirstName = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserFirstName")) as? String ?? ""
//        let AppleUserLastName = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserLastName")) as? String ?? ""
        let device_token = DataManager.getVal(Config().AppUserDefaults.value(forKey: "deviceToken")) as? String ?? ""
        let apple_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleToken")) as? String ?? ""
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.EmailTxtField.text!), forKey: "email")
        dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "phone")
        dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
        dict.setValue(DataManager.getVal(self.FullNameTxtField.text!), forKey: "fullname")
        dict.setValue(DataManager.getVal(self.gender), forKey: "gender")
        dict.setValue(DataManager.getVal(self.DOBTxtField.text!), forKey: "dob")
        dict.setValue(DataManager.getVal(self.CountryCodeTxtField.text!), forKey: "country_code")
//        dict.setValue(DataManager.getVal(AppleUserFirstName + AppleUserLastName), forKey: "fullname")
//        dict.setValue(DataManager.getVal(AppleUserEmail), forKey: "email")
//        dict.setValue(DataManager.getVal(""), forKey: "facebook_token")
        dict.setValue(DataManager.getVal(apple_id), forKey: "apple_token")
//        dict.setValue(DataManager.getVal(""), forKey: "google_token")
        dict.setValue(DataManager.getVal("2"), forKey: "device")
        
        dict.setValue(DataManager.getVal(device_token), forKey: "device_token")
        dict.setValue(DataManager.getVal(""), forKey: "dp_image")
        
        let methodName = "socialLoginRegister"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                if status == "1"{
                    let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                    DataManager.saveinDefaults(data)
                    let phone = DataManager.getVal(data["phone"]) as? String ?? ""
                    let vc = AllVerificationVC(nibName: "AllVerificationVC", bundle: nil)
                    vc.phone = phone
                    self.onlyPushViewController(vc)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }
    
    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//
//            let appleId = appleIDCredential.user
//            print(appleId)
//            let appleUserFirstName = appleIDCredential.fullName?.givenName
//            let appleUsernme = appleIDCredential.fullName?.familyName
//            let appleUserEmail = appleIDCredential.email
//
//            if appleUserEmail == nil {
//                Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
//                print(appleUserEmail as Any)
//            }else{
//                Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
//            }
//
//            if  appleUserFirstName == nil  {
//                Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
//                print(appleUserFirstName as Any)
//            }else{
//                Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "appleUserFirstName")
//            }
//
//            if appleUsernme == nil  {
//                Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
//                print(appleUsernme as Any)
//            }else{
//                Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
//            }
//
//            //api calling
//            self.AppleLogin_API()
//        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//
//            let appleUsername = passwordCredential.user
//            print(appleUsername as Any)
//            let applePassword = passwordCredential.password
//            print(applePassword as Any)
//            //Write your code
//        }
//    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                DispatchQueue.main.async {

                    let appleId = credentials.user
                    print(appleId)
                    let appleUserFirstName = credentials.fullName?.givenName
                    let appleUsernme = credentials.fullName?.familyName
                    let appleUserEmail = credentials.email
                    
                    if appleId != nil {
                        Config().AppUserDefaults.setValue(appleId, forKey: "AppleToken")
                    }
                    
                    
                    if appleUserEmail == nil {
                        Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
                        print(appleUserEmail as Any)
                    }else{
                        Config().AppUserDefaults.setValue(appleUserEmail, forKey: "AppleUserEmail")
                    }
                    
                    if  appleUserFirstName == nil  {
                        Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
                        print(appleUserFirstName as Any)
                    }else{
                        Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
                    }
                    
                    if appleUsernme == nil  {
                        Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
                        print(appleUsernme as Any)
                    }else{
                        Config().AppUserDefaults.setValue(appleUsernme, forKey: "AppleUserLastName")
                    }
                    
                    //api calling
                   self.AppleLogin_API()
  
                }

        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {

                let appleUsername = credentials.user
                print(appleUsername as Any)
                let applePassword = credentials.password
                print(applePassword as Any)
                //Write your code
                

            }

        default :
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.PhoneNumberTxtField{
            let maxLength = 16
            let minLength = 10
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength || newString.length >= minLength
        }else{
            return true
        }
    }
}

@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
