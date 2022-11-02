//
//  ResetPasswordVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var CreateNewPassbackBtn: UIButton!
    @IBOutlet weak var newPasswordLbl: UILabel!
    @IBOutlet weak var PasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var ConfirmPasswordTxtField: UITextField!
    @IBOutlet weak var submitBtn: MyButton!
    var otp = String()
    var language = String()
    var countryCode = String()
    var phone = String()
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        // Do any additional setup after loading the view.
        self.PasswordTxtField.background = UIImage(named: "input-transparent")
        self.ConfirmPasswordTxtField.background = UIImage(named: "input-transparent")
        self.PasswordTxtField.setLeftPaddingPoints(10)
        self.ConfirmPasswordTxtField.setLeftPaddingPoints(10)
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.CreateNewPassbackBtn.setTitle(language == "en" ? kCreateNewPassbackBtn : kThCreateNewPassbackBtn, for: .normal)
        self.newPasswordLbl.text = language == "en" ? knewPasswordLbl : kThnewPasswordLbl
        self.PasswordTxtField.placeholder = language == "en" ? knewPasswordLbl : kThnewPasswordLbl
        self.confirmPasswordLbl.text = language == "en" ? kconfirmPasswordLbl : kThconfirmPasswordLbl
        self.ConfirmPasswordTxtField.placeholder = language == "en" ? kconfirmPasswordLbl : kThconfirmPasswordLbl
        self.submitBtn.setTitle(language == "en" ? ksubmitBtn : kThsubmitBtn, for: .normal)
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @available(iOS 13.0, *)
    @IBAction func SubmitButtonAction(_ sender: MyButton) {
        
        if ValidationClass().ReSet_Password_Form(self){
            self.pleaseWait()

            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.PasswordTxtField.text!), forKey: "password")
            dict.setValue(DataManager.getVal(self.userId), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.otp), forKey: "otp")
            dict.setValue(DataManager.getVal(self.language), forKey: "lang")
            dict.setValue(DataManager.getVal(self.countryCode), forKey: "country_code")
            let methodName = "resetPassword"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
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
}
