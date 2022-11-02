//
//  ChangePasswordVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var oldPasswordLbl: UILabel!
    @IBOutlet weak var OldPasswordTxtField: UITextField!
    @IBOutlet weak var newPasswordLbl: UILabel!
    @IBOutlet weak var NewPasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var ConfirmPasswordTxtField: UITextField!
    @IBOutlet weak var submitBtn: MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
//        self.title = "Change Password"
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
        
        bar_title.text = language == "en" ? kchangePasswordBtn : kThchangePasswordBtn
        self.oldPasswordLbl.text = language == "en" ? koldPasswordLbl : kTholdPasswordLbl
        self.OldPasswordTxtField.placeholder = language == "en" ? koldPasswordLbl : kTholdPasswordLbl
        self.newPasswordLbl.text = language == "en" ? knewPasswordLbl : kThnewPasswordLbl
        self.NewPasswordTxtField.placeholder = language == "en" ? knewPasswordLbl : kThnewPasswordLbl
        self.confirmPasswordLbl.text = language == "en" ? kconfirmPasswordLbl : kThconfirmPasswordLbl
        self.ConfirmPasswordTxtField.placeholder = language == "en" ? kconfirmPasswordLbl : kThconfirmPasswordLbl
        self.submitBtn.setTitle(language == "en" ? ksubmitBtn : kThsubmitBtn, for: .normal)
    }
    
    @IBAction func SubmitButtonAction(_ sender: MyButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateChangePasswordForm(self){
            
            self.pleaseWait()
            
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setValue(self.user_id, forKey: "user_id")
            parameterDictionary.setValue(DataManager.getVal(self.NewPasswordTxtField.text!), forKey: "password")
            
            let methodName = "profile/changePwd"
            
            DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                    let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                    
                    if status == "1" {
                        self.OldPasswordTxtField.text = ""
                        self.NewPasswordTxtField.text = ""
                        self.ConfirmPasswordTxtField.text = ""
                        self.navigationController?.popViewController(animated: true)
                        UIApplication.topViewController()?.view.makeToast(message: message)
                    }else{
                        self.view.makeToast(message: message)
                    }
                    self.clearAllNotice()
                })
            }
        }
    }
    

}
