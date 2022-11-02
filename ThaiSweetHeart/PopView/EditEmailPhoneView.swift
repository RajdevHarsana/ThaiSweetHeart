//
//  EditEmailPhoneView.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 06/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import CountryList

class EditEmailPhoneView: UIView , UITextFieldDelegate{
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var enterLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var countrtxtwithconsr: NSLayoutConstraint!
    @IBOutlet weak var emailtxtleadeingconst: NSLayoutConstraint!
    @IBOutlet weak var editBtn: MyButton!
    @IBOutlet weak var cancelEditBtn: MyButton!
    var defaults:UserDefaults!
    var buttonCancelHandler : (() -> Void)?
    var buttonDoneHandler : ((_ Email : String)-> Void)?
    var buttonDoneNewHandler : ((_ Phone : String, _ CountryCode:String)-> Void)?
    var buttonCountryHandler : ((_ code : String) -> Void)?
    
    var tllb:String!
    var entp:String!
    var plach:String!
    var countryList = CountryList()
    
    class func intitiateFromNib() -> EditEmailPhoneView {
        let View1 = UINib.init(nibName: "EditEmailPhoneView", bundle: nil).instantiate(withOwner: self, options: nil).first as! EditEmailPhoneView
        
        return View1
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//          NSBundle.mainBundle().loadNibNamed("SomeView", owner: self, options: nil)
//          self.addSubview(self.view);    // adding the top level view to the view hierarchy
        print("Rajesh")
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaults = UserDefaults.standard
        tllb = defaults.value(forKey: "TitleLb") as? String
        entp = defaults.value(forKey: "enteremail") as? String
        plach = defaults.value(forKey: "placeholder") as? String
        self.titleLbl.text  = tllb
        self.enterLbl.text = entp
        self.emailTxt.placeholder  = plach
        self.countryTxt.delegate = self
        if tllb == "Edit Email" {
            self.countrtxtwithconsr.constant = 0
            self.countryTxt.isHidden  = true
            self.emailtxtleadeingconst.constant = 0
            emailTxt.keyboardType = .asciiCapable
        }else {
            self.countrtxtwithconsr.constant = 48
            self.countryTxt.isHidden  = false
            self.emailtxtleadeingconst.constant = 10
            emailTxt.keyboardType = .numberPad
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.countryTxt{
            self.buttonCountryHandler?(textField.text!)
            self.endEditing(true)
            return false
        }else {
            return true
        }
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        self.endEditing(true)
        if tllb == "Edit Email" {
            if emailTxt.text == "" {
                self.makeToast(message: "Please enter your email id.")
            }else if isValidEmail(emailTxt.text!) {
                self.makeToast(message: "This is not correct email address")
            }else {
                self.buttonDoneHandler?(emailTxt.text!)
            }
        }else {
            if emailTxt.text == "" {
                self.makeToast(message: "Please enter your phone number.")
            }else if countryTxt.text == "" {
                self.makeToast(message: "Please select country code.")
            }else if self.emailTxt.text!.count < 7 || self.emailTxt.text!.count > 15 {
                self.makeToast(message: "Phone number should be 7-15 digits")
            }else {
                self.buttonDoneNewHandler?(emailTxt.text!, countryTxt.text!)
            }
        }
       
       
    }
    
    func isValidEmail(_ EmailStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = EmailStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        buttonCancelHandler?()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.emailTxt{
            if self.tllb != "Edit Email"{
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
    }
}
