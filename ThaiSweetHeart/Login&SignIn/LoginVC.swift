//
//  LoginVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 30/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import CountryList
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class LoginVC: UIViewController,GIDSignInDelegate,CountryListDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var PasswordLbl: UILabel!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var RememberMelbl: UILabel!
    @IBOutlet weak var RememberMeButton: ResponsiveButton!
    @IBOutlet weak var forgotBtn: ResponsiveButton!
    @IBOutlet weak var loginBtn: MyButton!
    @IBOutlet weak var orLoginWith: MyLabel!
    @IBOutlet weak var registerLbl: UILabel!
    @IBOutlet weak var registerBtn: ResponsiveButton!

    @IBOutlet weak var contryTxtWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var contryTxtTrailingConstrant: NSLayoutConstraint!
    @IBOutlet weak var contryCodeTxtField: UITextField!
    @IBOutlet weak var forgotLblWidthConstrant: NSLayoutConstraint!
    private let SignInbutton = ASAuthorizationAppleIDButton()
    //RatingView
    @IBOutlet var RatingView: UIView!
    var rememberMe: Bool = false
    
    var imgurll = ""
    var emaill = ""
    var name = ""
    var lastName = ""
    var facebookId = ""
    var googleId = ""
    var type = String()
    var countryList = CountryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(SignInbutton)
//        SignInbutton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        self.loginBtn.layer.cornerRadius = 6
        
        self.navigationController?.isNavigationBarHidden = true
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.EmailTxtField.background = UIImage(named: "input-transparent")
        self.PasswordTxtField.background = UIImage(named: "input-transparent")
        
        self.EmailTxtField.setLeftPaddingPoints(10)
        self.PasswordTxtField.setLeftPaddingPoints(10)
        
        let is_remember = DataManager.getVal(Config().AppUserDefaults.object(forKey: "isRemember")) as? String ?? ""
        
        if is_remember == "yes"{
            
            let user_email = DataManager.getVal(Config().AppUserDefaults.object(forKey: "user_email")) as? String ?? ""
            let user_password = DataManager.getVal(Config().AppUserDefaults.object(forKey: "user_password")) as? String ?? ""
            
            self.EmailTxtField.text = user_email
            self.PasswordTxtField.text = user_password
            self.RememberMeButton.setImage(UIImage(named: "check-box"), for: UIControl.State.normal)
            self.rememberMe = true
        }else{
            self.EmailTxtField.text = ""
            self.PasswordTxtField.text = ""
            self.RememberMeButton.setImage(UIImage(named: "uncheck-box"), for: UIControl.State.normal)
            self.rememberMe = true
        }
        self.countryList.delegate = self
        self.EmailTxtField.keyboardType = .emailAddress
        self.EmailTxtField.background = UIImage(named: "input-transparent")
        self.EmailTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.background = UIImage(named: "input-transparent")
        self.contryCodeTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.delegate = self
        self.EmailTxtField.delegate = self
        self.contryTxtWidthConstrant.constant = 0
        self.contryTxtTrailingConstrant.constant = 0
        self.EmailTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.isHidden = true
        
        if lang == "en"{
            self.forgotLblWidthConstrant.constant = 122
        }else{
            self.forgotLblWidthConstrant.constant = 75
        }
        self.type = "email"
    }
//    override func viewDidLayoutSubviews() {
//            super.viewDidLayoutSubviews()
//            SignInbutton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
//            SignInbutton.center = view.center
//    }
    func selectedCountry(country: Country) {
        self.contryCodeTxtField.text = "+\(country.phoneExtension)"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.contryCodeTxtField {
            let navController = UINavigationController(rootViewController: countryList)
            self.present(navController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    @IBAction func RatingViewBackButton(_ sender: UIButton) {
        self.removeAnimate(YourHiddenView: self.RatingView, ishidden: true)
    }
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.RatingView, ishidden: true)
    }
    @IBAction func RateButtonAction(_ sender: MyButton) {
        self.removeAnimate(YourHiddenView: self.RatingView, ishidden: true)
    }
    @IBAction func LoginButtonAction(_ sender: MyButton) {
        
        if ValidationClass().ValidateLoginForm(self){
            self.pleaseWait()
            
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.EmailTxtField.text!), forKey: "username")
            dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
            dict.setValue(DataManager.getVal(lat), forKey: "lat")
            dict.setValue(DataManager.getVal(Long), forKey: "long")
            
            let methodName = "login"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let user = DataManager.getVal(responseData?["user"]) as! [String: Any]
                    let profile_setup = DataManager.getVal(user["profile_setup"]) as? String ?? ""
                    let interest_setup = DataManager.getVal(user["interest_setup"]) as? String ?? ""
//                    let question_setup = DataManager.getVal(user["question_setup"]) as? String ?? ""
                    DataManager.saveinDefaults(user)
                    
                    if self.rememberMe == true{
                        Config().AppUserDefaults.set("yes", forKey: "isRemember")
                        Config().AppUserDefaults.set(DataManager.getVal(self.EmailTxtField.text!), forKey: "user_email")
                        Config().AppUserDefaults.set(DataManager.getVal(self.PasswordTxtField.text!), forKey: "user_password")
                    }else{
                        Config().AppUserDefaults.set("no", forKey: "isRemember")
                    }
                    if profile_setup == "1" && interest_setup == "0"{//For Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                        
                    }else if profile_setup == "0" && interest_setup == "0"{//For Profile and Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                    }else{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        
                        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        slideMenuController.delegate = initialViewController
                        self.view.window?.rootViewController = slideMenuController
                    }
                    
                }else if status == "2"{
                    let user = DataManager.getVal(responseData?["user"]) as! NSDictionary
                    let email = DataManager.getVal(user["email"]) as? String ?? ""
                    let phone = DataManager.getVal(user["phone"]) as? String ?? ""
                    
                    let vc = AllVerificationVC(nibName: "AllVerificationVC", bundle: nil)
                    vc.email = email
                    vc.phone = phone
                    self.onlyPushViewController(vc)
                    UIApplication.topViewController()?.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
        
    }
    @IBAction func RememberMeButtonAction(_ sender: ResponsiveButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.rememberMe = true
            self.RememberMeButton.setImage(UIImage(named: "check-box"), for: UIControl.State.selected)
        }else{
            self.rememberMe = false
            self.RememberMeButton.setImage(UIImage(named: "uncheck-box") , for: UIControl.State.normal)
        }
    }
    @IBAction func ForgotPasswordButtonAction(_ sender: ResponsiveButton) {
        let vc = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
        self.onlyPushViewController(vc)
        
    }
    @IBAction func SignUpButtonAction(_ sender: ResponsiveButton) {
        let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
        let defaults = UserDefaults.standard
        defaults.setValue("SignUp", forKey: "SOCIALLOGIN")
        defaults.synchronize()
        self.onlyPushViewController(vc)
    }
    @IBAction func GoogleLoginButton(_ sender: MyButton) {
        //GIDSignIn.sharedInstance()?.signIn()
        let signin = GIDSignIn.sharedInstance()
        signin?.presentingViewController = self
        signin?.shouldFetchBasicProfile = true
        signin?.delegate = self
        signin?.signIn()
        
    }
    
    
    @IBAction func FaceBookLoginButton(_ sender: MyButton) {
        let login:LoginManager = LoginManager()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if(error != nil){
                LoginManager().logOut()
            }else if(result!.isCancelled){
                LoginManager().logOut()
            }else{
                self.fetchUserData()
            }
        }
    }
    @IBAction func AppleLoginButtonAction(_ sender: MyButton) {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//
//        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        handleAppleIdRequest()
    }

    @objc func handleAppleIdRequest() {
        
        
        if #available(iOS 13.0, *) {
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    authorizationController.delegate = self
                    authorizationController.presentationContextProvider = self
                    authorizationController.performRequests()
                    
                }else{
                    self.view.makeToast(message: "Please update your apple version to use apple signin.")
                }
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
//    private func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
//
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
    
    
    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
    
    
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
    //MARK:- FaceBook Login Api Integration
    func facebookLogin(name:String,facbookID:String,email:String,imgUrll:String) {
        
        self.pleaseWait()
        
        let facebookProfileUrl = "http://graph.facebook.com/\(facbookID)/picture?type=large"
        let device_token = DataManager.getVal(Config().AppUserDefaults.value(forKey: "deviceToken")) as? String ?? ""
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(name), forKey: "fullname")
        //dict.setValue(DataManager.getVal(email), forKey: "email")
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
            } else if status == "5" {
                let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
                let defaults = UserDefaults.standard
                defaults.setValue("Facebook", forKey: "SOCIALLOGIN")
                defaults.synchronize()
                self.onlyPushViewController(vc)
            }else if status == "2" {
                let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                DataManager.saveinDefaults(data)
                let profile_setup = DataManager.getVal(data["profile_setup"]) as? String ?? ""
                let interest_setup = DataManager.getVal(data["interest_setup"]) as? String ?? ""
                
                // Config().AppUserDefaults.set("yes", forKey: "login")
                if profile_setup == "1" && interest_setup == "0"{//For Intres and habbits fill page
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    let flag_comingfromLogin = true
                    let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                    vc.delegate = initialViewController
                    initialViewController.flag_comingfromLogin = flag_comingfromLogin
                    self.view.window?.rootViewController = vc
                    
                }else if profile_setup == "0" && interest_setup == "0"{//For Profile and Intres and habbits fill page
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    let flag_comingfromLogin = true
                    let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                    vc.delegate = initialViewController
                    initialViewController.flag_comingfromLogin = flag_comingfromLogin
                    self.view.window?.rootViewController = vc
                }else{
                    Config().AppUserDefaults.set("yes", forKey: "login")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
                    let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                    
                    let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                    slideMenuController.delegate = initialViewController
                    self.view.window?.rootViewController = slideMenuController
                }
            }
            else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn?) throws {
        
    }
    
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        if let aController = viewController {
            present(aController, animated: true)
        }
    }
    
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        dismiss(animated: true)
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
        // dict.setValue(DataManager.getVal(self.name), forKey: "fullname")
        // dict.setValue(DataManager.getVal(email), forKey: "email")
        dict.setValue(DataManager.getVal(social_id), forKey: "google_token")
        dict.setValue(DataManager.getVal("2"), forKey: "device")
        dict.setValue(DataManager.getVal(device_token), forKey: "device_token")
        // dict.setValue(DataManager.getVal(image), forKey: "dp_image")
        
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
                    
                }else if status == "5"{
                    let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
                    let defaults = UserDefaults.standard
                    defaults.setValue("Google", forKey: "SOCIALLOGIN")
                    defaults.synchronize()
                    self.onlyPushViewController(vc)
                }else if status == "2" {
                    let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                    DataManager.saveinDefaults(data)
                    let profile_setup = DataManager.getVal(data["profile_setup"]) as? String ?? ""
                    let interest_setup = DataManager.getVal(data["interest_setup"]) as? String ?? ""
                    
                    // Config().AppUserDefaults.set("yes", forKey: "login")
                    if profile_setup == "1" && interest_setup == "0"{//For Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                        
                    }else if profile_setup == "0" && interest_setup == "0"{//For Profile and Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                    }else{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        
                        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        slideMenuController.delegate = initialViewController
                        self.view.window?.rootViewController = slideMenuController
                    }
                }
                else{
                    self.view.makeToast(message: message)
                    print(message)
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
    
    func ChangeLanguage(language:String){
        self.PasswordLbl.text = language == "en" ? kPasswordLbl : kThpassordLbl
        self.PasswordTxtField.placeholder = language == "en" ? kPasswordTxtField : kThPasswordTxtField
        self.RememberMelbl.text = language == "en" ? kRememberMelbl : kThRememberMelbl
        self.forgotBtn.setTitle(language == "en" ? kforgotBtn : kThforgotBtn, for: .normal)
        self.loginBtn.setTitle(language == "en" ? kloginBtn : kThloginBtn, for: .normal)
        self.orLoginWith.text = language == "en" ? korLoginWith : kThorLoginWith
        self.registerLbl.text = language == "en" ? kregisterLbl : kThregisterLbl
        self.registerBtn.setTitle(language == "en" ? kregisterBtn : kThregisterBtn, for: .normal)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        if Int(text) != nil {
            print("int")
            self.EmailTxtField.keyboardType = .asciiCapableNumberPad
            self.contryTxtWidthConstrant.constant = 60
            self.contryTxtTrailingConstrant.constant = 8
            self.contryCodeTxtField.isHidden = false
            self.EmailLbl.text = lang == "en" ? kPhone_Number : kThPhone_Number
            self.EmailTxtField.placeholder = lang == "en" ? kPhoneTxtField : kThPhoneTxtField
            self.type = "phone"

        } else {
            print("string...")
            self.EmailTxtField.keyboardType = .emailAddress
            self.contryTxtWidthConstrant.constant = 0
            self.contryTxtTrailingConstrant.constant = 0
            self.EmailTxtField.setLeftPaddingPoints(10)
            self.contryCodeTxtField.isHidden = true
            self.EmailLbl.text = lang == "en" ? kemailIdLbl : kThemailIdLbl
            self.EmailTxtField.placeholder = lang == "en" ? kEmailTxtField : kThEmailTxtField
            self.type = "email"

        }
        return true
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func AppleLogin_API(){
        
        let AppleUserEmail = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserEmail")) as? String ?? ""
        let AppleUserFirstName = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserFirstName")) as? String ?? ""
        let AppleUserLastName = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleUserLastName")) as? String ?? ""
        let device_token = DataManager.getVal(Config().AppUserDefaults.value(forKey: "deviceToken")) as? String ?? ""
        let apple_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "AppleToken")) as? String ?? ""
        
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(AppleUserFirstName + AppleUserLastName), forKey: "fullname")
        dict.setValue(DataManager.getVal(AppleUserEmail), forKey: "email")
//        dict.setValue(DataManager.getVal(""), forKey: "facebook_token")
//        dict.setValue(DataManager.getVal(""), forKey: "google_token")
        dict.setValue(DataManager.getVal(apple_id), forKey: "apple_token")
        dict.setValue(DataManager.getVal("2"), forKey: "device")
        dict.setValue(DataManager.getVal(device_token), forKey: "device_token")
//        dict.setValue(DataManager.getVal(""), forKey: "dp_image")
        
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
                    
                }else if status == "5"{
                    let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
                    let defaults = UserDefaults.standard
                    defaults.setValue("Apple", forKey: "SOCIALLOGIN")
                    defaults.synchronize()
                    self.onlyPushViewController(vc)
                }else if status == "2" {
                    let data = DataManager.getVal(responseData?["user"]) as! [String: Any]
                    DataManager.saveinDefaults(data)
                    let profile_setup = DataManager.getVal(data["profile_setup"]) as? String ?? ""
                    let interest_setup = DataManager.getVal(data["interest_setup"]) as? String ?? ""
                    
                    // Config().AppUserDefaults.set("yes", forKey: "login")
                    if profile_setup == "1" && interest_setup == "0"{//For Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                    }else if profile_setup == "0" && interest_setup == "0"{//For Profile and Intres and habbits fill page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let flag_comingfromLogin = true
                        let vc = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        vc.delegate = initialViewController
                        initialViewController.flag_comingfromLogin = flag_comingfromLogin
                        self.view.window?.rootViewController = vc
                    }else{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
                        let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                        let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                        slideMenuController.delegate = initialViewController
                        self.view.window?.rootViewController = slideMenuController
                    }
                }
                else{
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
//            Config().AppUserDefaults.setValue(appleId, forKey: "apple_id")
//            let appleUserFirstName = appleIDCredential.fullName?.givenName
//            let appleUsernme = appleIDCredential.fullName?.familyName
//            let appleUserEmail = appleIDCredential.email
//
//
//            if appleId != nil {
//                                   Config().AppUserDefaults.setValue(appleId, forKey: "AppleToken")
//                               }
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
//                Config().AppUserDefaults.setValue(appleUserFirstName, forKey: "AppleUserFirstName")
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
////                        let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
////                        self.onlyPushViewController(vc)
//        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//
//            let appleUsername = passwordCredential.user
//            print(appleUsername as Any)
//            let applePassword = passwordCredential.password
//            print(applePassword as Any)
//            //Write your code
//        }
//    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
            
            let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
          
          switch authorization.credential {
              case let credentials as ASAuthorizationAppleIDCredential:
                  DispatchQueue.main.async {

                      let appleId = credentials.user
                      print(appleId)
                      let appleUserFirstName = credentials.fullName?.givenName
                      let appleUsernme = credentials.fullName?.familyName
                      let appleUserEmail = credentials.email
//                      let appleToken = credentials.identityToken
                      
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
    }
    


@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


