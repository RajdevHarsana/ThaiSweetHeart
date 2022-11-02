//
//  ForgotPasswordVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import CountryList

class ForgotPasswordVC: UIViewController,UITextFieldDelegate,CountryListDelegate {

    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var PhoneNumberTxtField: UITextField!
    @IBOutlet weak var contryCodeTxtField: UITextField!
    
    @IBOutlet weak var contryTxtWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var DiscriptionLbl: UILabel!
    @IBOutlet weak var emailPhoneLbl: UILabel!
    @IBOutlet weak var sendBtn: MyButton!
    
    var countryList = CountryList()
    var type = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendBtn.layer.cornerRadius = 6
        
        contryCodeTxtField.isHidden = false
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        self.countryList.delegate = self
        self.PhoneNumberTxtField.keyboardType = .emailAddress
        self.PhoneNumberTxtField.background = UIImage(named: "input-transparent")
        self.PhoneNumberTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.background = UIImage(named: "input-transparent")
        self.contryCodeTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.delegate = self
        self.PhoneNumberTxtField.delegate = self
        self.contryTxtWidthConstrant.constant = 0
        self.PhoneNumberTxtField.setLeftPaddingPoints(10)
        self.contryCodeTxtField.isHidden = true

        self.type = "email"
        self.emailPhoneLbl.text = "Email ID/Phone number"
        if self.type == "email"{
            self.emailPhoneLbl.text = lang == "en" ? kEmail : kThEmail
            self.PhoneNumberTxtField.placeholder = lang == "en" ? kEmail : kThEmail
            self.PhoneNumberTxtField.keyboardType = .emailAddress
        }else{
            self.emailPhoneLbl.text = lang == "en" ? kPhone_Number : kThPhone_Number
            self.PhoneNumberTxtField.placeholder = lang == "en" ? kPhoneNumberTxtField : kThPhoneNumberTxtField
            self.PhoneNumberTxtField.keyboardType = .phonePad
        }
        
    }
    
    func ChangeLanguage(language:String){
        self.forgotPasswordBtn.setTitle(language == "en" ? kforgotPasswordbtn : kThforgotPasswordbtn, for: .normal)
        self.sendBtn.setTitle(language == "en" ? kSendBtn : kThSendBtn, for: .normal)
        if self.type == "email"{
            self.emailPhoneLbl.text = language == "en" ? kemailIdLbl : kThemailIdLbl
            self.PhoneNumberTxtField.placeholder = language == "en" ? kEmailTxtField : kThEmailTxtField
            self.DiscriptionLbl.text = language == "en" ? kDiscriotion1 : kThDiscriotion1
        }else{
            self.emailPhoneLbl.text = language == "en" ? kPhone_Number : kThPhone_Number
            self.PhoneNumberTxtField.placeholder = language == "en" ? kPhoneTxtField : kThPhoneNumberTxtField
            self.DiscriptionLbl.text = language == "en" ? kDiscriotion2 : kThDiscriotion2
        }
    }

    func selectedCountry(country: Country) {
        self.contryCodeTxtField.text = "+\(country.phoneExtension)"
        Config().AppUserDefaults.setValue(self.contryCodeTxtField.text, forKey: "CountryCode")
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
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendButtonAction(_ sender: MyButton) {
        if self.PhoneNumberTxtField.text == ""{
            if type == "email"{
                self.view.makeToast(message: "Please enter Email/Mobile.")
            }else{
                self.view.makeToast(message: "Please enter Email/Mobile.")
            }
        }else{
            self.pleaseWait()
            
            let dict = NSMutableDictionary()
            if type == "email"{
                dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "email")
            }else{
                dict.setValue(DataManager.getVal(self.PhoneNumberTxtField.text!), forKey: "phone")
                dict.setValue(DataManager.getVal(self.contryCodeTxtField.text!), forKey: "country_code")
                dict.setValue(DataManager.getVal(""), forKey: "email")
            }
            
            let methodName = "forgetPassword"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                let user_Id = DataManager.getVal(responseData?["user_id"]) as? String ?? ""
                if status == "1"{
                    if #available(iOS 13.0, *) {
                        let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
                        if self.type == "email"{
                            vc.email = self.PhoneNumberTxtField.text!
                        }else{
                            vc.phone = self.PhoneNumberTxtField.text!
                        }
                        vc.userId = user_Id
                        vc.type = self.type
                        self.onlyPushViewController(vc)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    UIApplication.topViewController()?.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.PhoneNumberTxtField{
            if self.type != "email"{
                let maxLength = 16
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }else{
                return true
            }
        }else{
            return true
        }
    }*/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        if Int(text) != nil {
            print("int")
            self.PhoneNumberTxtField.keyboardType = .phonePad
            self.contryTxtWidthConstrant.constant = 60
            self.contryCodeTxtField.isHidden = false
            self.emailPhoneLbl.text = lang == "en" ? kPhone_Number : kThPhone_Number
            self.PhoneNumberTxtField.placeholder = lang == "en" ? kPhoneTxtField : kThPhoneNumberTxtField
            self.DiscriptionLbl.text = lang == "en" ? kDiscriotion2 : kThDiscriotion2
            self.type = "phone"
            let maxLength = 16
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength

        }else{
            print("string...")
            self.PhoneNumberTxtField.keyboardType = .emailAddress
            self.contryTxtWidthConstrant.constant = 0
            self.PhoneNumberTxtField.setLeftPaddingPoints(10)
            self.contryCodeTxtField.isHidden = true
            self.emailPhoneLbl.text = lang == "en" ? kemailIdLbl : kThemailIdLbl
            self.PhoneNumberTxtField.placeholder = lang == "en" ? kEmailTxtField : kThEmailTxtField
            self.DiscriptionLbl.text = lang == "en" ? kDiscriotion1 : kThDiscriotion1
            self.type = "email"

        }
        return true
    }

    
    
}
