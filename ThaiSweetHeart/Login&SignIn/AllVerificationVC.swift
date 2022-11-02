//
//  AllVerificationVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 09/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AllVerificationVC: UIViewController,UITextFieldDelegate,VPMOTPViewDelegate,VPMOTPViewDelegate1 {
    
    @IBOutlet weak var backBtn: ResponsiveButton!
    @IBOutlet weak var enterOtpLbl: UILabel!
    @IBOutlet weak var PhoneNumberOTPTxtField: UITextField!
    @IBOutlet weak var EmailOTPTxtField: UITextField!
    @IBOutlet weak var phoneOtpView: VPMOTPView!
    @IBOutlet weak var EmailOtpView: VPMOTPView1!
    @IBOutlet weak var enterPhonrNumberOTPLbl: UILabel!
    @IBOutlet weak var notReciPhoneOtpLbl: UILabel!
    @IBOutlet weak var enterEmailOtpLbl: UILabel!
    @IBOutlet weak var notReciEmailOtpLbl: UILabel!
    @IBOutlet weak var resendBtn: MyButton!
    @IBOutlet weak var verifyBtn: MyButton!
    @IBOutlet weak var resendEmailOtpBtn: MyButton!
    
    var typeComming = Bool()
    var userName = String()
    var phone = String()
    var email = String()
    
    var GetEmailotpString = String()
    var GetMobileotpString = String()
    var GetComeOtp = String()
    var GetComeOtp1 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "OOtp"
        
        self.verifyBtn.layer.cornerRadius = 6
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        GetComeOtp = "0000"
        phoneOtpView.otpFieldsCount = 4
        phoneOtpView.delegate = self
        phoneOtpView.tag = 10
        // Create the UI
        phoneOtpView.initalizeUI()
        
        GetComeOtp1 = "0000"
        EmailOtpView.otpFieldsCount1 = 4
        EmailOtpView.delegate = self
        EmailOtpView.tag = 11
        
        // Create the UI
        EmailOtpView.initalizeUI1()
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.backBtn.setTitle(language == "en" ? kbackBtn : kThbackBtn, for: .normal)
        self.enterOtpLbl.text = language == "en" ? kenterOtpLbl : kThenterOtpLbl
        self.enterPhonrNumberOTPLbl.text = language == "en" ? kenterPhonrNumberOTPLbl : kThenterPhonrNumberOTPLbl
        self.notReciPhoneOtpLbl.text = language == "en" ? knotReciPhoneOtpLbl : kThEmailTxtField
        self.resendBtn.setTitle(language == "en" ? kresendBtn : kThresendBtn, for: .normal)
        self.enterEmailOtpLbl.text = language == "en" ? kenterEmailOtpLbl : kThenterEmailOtpLbl
        self.notReciEmailOtpLbl.text = language == "en" ? knotReciEmailOtpLbl : kThnotReciEmailOtpLbl
        self.resendEmailOtpBtn.setTitle(language == "en" ? kresendBtn : kThresendBtn, for: .normal)
        self.verifyBtn.setTitle(language == "en" ? kverifyBtn : kThverifyBtn, for: .normal)
    }
    //MARK:- OTP TextView Delegate  ---- Start
    func shouldBecomeFirstResponderForOTP1(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP1(otpString: String) {
        GetEmailotpString = otpString
        print("OTPString: \(otpString)")
    }
    func hasEnteredAllOTP1(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
    }
    
    func enteredOTP(otpString: String) {
        GetMobileotpString = otpString
        print("OTPString: \(otpString)")
    }
    
    
    @IBAction func BackButtonAction(_ sender: ResponsiveButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func PhoneResendButtonAction(_ sender: MyButton) {
        
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(""), forKey: "email")
        dict.setValue(DataManager.getVal(self.phone), forKey: "phone")
        
        let methodName = "newVerify"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.PhoneNumberOTPTxtField.text = ""
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @IBAction func EmailResendButtonAction(_ sender: MyButton) {
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.email), forKey: "email")
        dict.setValue(DataManager.getVal(""), forKey: "phone")
        
        let methodName = "newVerify"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.EmailOTPTxtField.text = ""
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if !GetMobileotpString.isEmpty && !GetEmailotpString.isEmpty {
            self.pleaseWait()
            
            let dict = NSMutableDictionary()
            if self.email == ""{
                dict.setValue(DataManager.getVal(self.phone), forKey: "username")
            }else{
                dict.setValue(DataManager.getVal(self.email), forKey: "username")
            }
            dict.setValue(DataManager.getVal(self.GetMobileotpString), forKey: "otp_phone")
            dict.setValue(DataManager.getVal(self.GetEmailotpString), forKey: "otp")
            
            let methodName = "verify"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    if self.typeComming == true{
                        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                        self.RootViewControllerWithNav(vc)
                        UIApplication.topViewController()?.view.makeToast(message: message)
                    }else{
                        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                        self.RootViewControllerWithNav(vc)
                        UIApplication.topViewController()?.view.makeToast(message: message)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }else if GetMobileotpString.isEmpty {
            self.view.makeToast(message: "Please enter phone number OTP.")
        }else if GetEmailotpString.isEmpty {
            self.view.makeToast(message: "Please enter email OTP.")
        }
        
        
//        if self.PhoneNumberOTPTxtField.text == ""{
//            self.view.makeToast(message: "Please enter phone number OTP.")
//        }else if self.EmailOTPTxtField.text == ""{
//            self.view.makeToast(message: "Please enter email OTP.")
//        }else{
//            self.pleaseWait()
//            
//            let dict = NSMutableDictionary()
//            if self.email == ""{
//                dict.setValue(DataManager.getVal(self.phone), forKey: "username")
//            }else{
//                dict.setValue(DataManager.getVal(self.email), forKey: "username")
//            }
//            dict.setValue(DataManager.getVal(self.PhoneNumberOTPTxtField.text!), forKey: "otp_phone")
//            dict.setValue(DataManager.getVal(self.EmailOTPTxtField.text!), forKey: "otp")
//            
//            let methodName = "verify"
//            
//            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
//                
//                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
//                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
//                
//                if status == "1"{
//                    if self.typeComming == true{
//                        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
//                        self.RootViewControllerWithNav(vc)
//                        UIApplication.topViewController()?.view.makeToast(message: message)
//                    }else{
//                        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
//                        self.RootViewControllerWithNav(vc)
//                        UIApplication.topViewController()?.view.makeToast(message: message)
//                    }
//                }else{
//                    self.view.makeToast(message: message)
//                }
//                self.clearAllNotice()
//            }
//        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
}
