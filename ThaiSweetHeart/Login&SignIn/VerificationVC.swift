//
//  VerificationVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class VerificationVC: UIViewController,VPMOTPViewDelegate {

    @IBOutlet weak var OtpView: VPMOTPView!
    @IBOutlet weak var OTPVerifyBackBtn: UIButton!
    @IBOutlet weak var otptxtLbl: UILabel!
    @IBOutlet weak var verifyBtn: MyButton!
    @IBOutlet weak var resendOtpLbl: UILabel!
    @IBOutlet weak var resendOtpBtn: ResponsiveButton!
    
    var OTP_Str = String()
    var language = String()
//    var GetComeOtp = String()
    var email = String()
    var typeComming = Bool()
    var userName = String()
    var phone = String()
    var countryCode = String()
    var userId = String()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verifyBtn.layer.cornerRadius = 6
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
//        self.GetComeOtp = "0000"
        self.OtpView.otpFieldsCount = 4
        self.OtpView.delegate = self
        self.OtpView.initalizeUI()
        self.OtpView.otpFieldSize = 65
        self.view.layoutIfNeeded()
        self.view.updateConstraints()

        if self.typeComming == true{
            self.OTPVerifyBackBtn.isHidden = true
        }
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.OTPVerifyBackBtn.setTitle(language == "en" ? kOTPVerifyBackBtn : kThOTPVerifyBackBtn, for: .normal)
        self.otptxtLbl.text = language == "en" ? kotptxtLbl : kThotptxtLbl
        self.resendOtpLbl.text = language == "en" ? kresendOtpLbl : kThresendOtpLbl
        self.resendOtpBtn.setTitle(language == "en" ? kresendOtpBtn : kThresendOtpBtn, for: .normal)
        self.verifyBtn.setTitle(language == "en" ? kverifyBtn : kThverifyBtn, for: .normal)
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func VerifyButtonAction(_ sender: MyButton) {
        if self.OTP_Str == ""{
            self.view.makeToast(message: "Please enter OTP first.")
        }else{
            self.pleaseWait()

            let dict = NSMutableDictionary()
//            dict.setValue(DataManager.getVal(self.phone), forKey: "username")
            dict.setValue(DataManager.getVal(self.userId), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.OTP_Str), forKey: "otp")
            let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
            print(lang)
            dict.setValue(DataManager.getVal(lang), forKey: "lang")

            let methodName = "checkOtp"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let vc = ResetPasswordVC(nibName: "ResetPasswordVC", bundle: nil)
                    vc.otp = self.OTP_Str
                    vc.phone = self.phone
                    vc.userId = self.userId
                    vc.language = self.language
                    vc.countryCode = self.countryCode
                    self.onlyPushViewController(vc)
                    UIApplication.topViewController()?.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
    }
    @IBAction func ResendButtonAction(_ sender: ResponsiveButton) {
        self.pleaseWait()

        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.email), forKey: "email")
        dict.setValue(DataManager.getVal(self.phone), forKey: "phone")
        
        let countryCode = Config().AppUserDefaults.value(forKey: "CountryCode") as? String ?? ""
        print(countryCode)
        
        dict.setValue(DataManager.getVal(countryCode), forKey: "country_code")
        let methodName = "forgetPassword"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    //MARK:- OTP TextView Delegate ---- Start
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
    }
    
    func enteredOTP(otpString: String) {
        self.OTP_Str = otpString
        print("OTPString: \(otpString)")
    }
   
}
