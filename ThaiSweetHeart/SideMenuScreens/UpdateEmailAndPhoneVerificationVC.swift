//
//  UpdateEmailAndPhoneVerificationVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 06/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//


import UIKit

@available(iOS 13.0, *)
class UpdateEmailAndPhoneVerificationVC: BaseViewController,VPMOTPViewDelegate {

    @IBOutlet weak var OtpView: VPMOTPView!
    
    @IBOutlet weak var discribeLbl: UILabel!
    @IBOutlet weak var verifyBtn: MyButton!
    @IBOutlet weak var resendOtpBtn: ResponsiveButton!
    var OTP_Str = String()
    var GetComeOtp = String()
    var email = String()
    var typeComming = Bool()
    var userName = String()
    var phone = String()
    var value:String!
    var isemail:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyBtn.layer.cornerRadius = 6
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.title = "OTP Verification"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        bar_title.text = lang == "en" ? kOTPVerifyBackBtn : kThOTPVerifyBackBtn
        self.discribeLbl.text = lang == "en" ? kotptxtLbl : kThotptxtLbl
        self.verifyBtn.setTitle(lang == "en" ? kverifyBtn : kThverifyBtn, for: .normal)
        self.resendOtpBtn.setTitle(lang == "en" ? kresendOtpBtn : kThresendOtpBtn, for: .normal)
        self.GetComeOtp = "0000"
        self.OtpView.otpFieldsCount = 4
        self.OtpView.delegate = self
        self.OtpView.initalizeUI()
        self.view.layoutIfNeeded()
        self.view.updateConstraints()
//
//        if self.typeComming == true{
//            self.BackButton.isHidden = true
//        }
    }

    
        
    @IBAction func verifyBtnAction(_ sender: MyButton) {
    if self.OTP_Str == ""{
            self.view.makeToast(message: "Please enter OTP first.")
        }else{
            self.pleaseWait()
            let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.value), forKey: "value")
            dict.setValue(DataManager.getVal(self.isemail), forKey: "is_email")
            dict.setValue(DataManager.getVal(self.OTP_Str), forKey: "otp")

            let methodName = "profile/save-user"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
    }
    
    @IBAction func ResendBtnAction(_ sender: ResponsiveButton) {
        self.pleaseWait()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.value), forKey: "value")
        
        let methodName = "profile/resend-otp"
        
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

