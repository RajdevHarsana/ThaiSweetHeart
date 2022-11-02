//
//  AddCardVC.swift
//  PartyPlan
//
//  Created by mac-15 on 19/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AddCardVC: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var choosePayemtMethodLbl: UILabel!
    @IBOutlet weak var nameOfCardLbl: UILabel!
    @IBOutlet weak var carNumberLbl: UILabel!
    @IBOutlet weak var nameonCardtextField: UITextField!
    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var CvvLbl: UILabel!
    @IBOutlet weak var cardNumnerTxt: UITextField!
    @IBOutlet weak var monthTxt: MyTextField!
    @IBOutlet weak var yearTxt: MyTextField!
    @IBOutlet weak var CVVTxt: UITextField!
    @IBOutlet weak var addCardBtn: MyButton!
    var defaults:UserDefaults!
    var cardadd:String!
    var Month = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var year = ["2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031"]
    var monthpickerview: UIPickerView = UIPickerView()
    var yearpickerview:UIPickerView = UIPickerView()
    var cardid:Int!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        cardadd = defaults.value(forKey: "CardADD") as? String
        
        monthpickerview.delegate = self
        monthpickerview.dataSource = self
        monthTxt.inputView = monthpickerview
        
        yearpickerview.delegate = self
        yearpickerview.dataSource = self
        yearTxt.inputView = yearpickerview
        
        if cardadd == "Add" {
            
            let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            bar_title.textColor = UIColor.white
            bar_title.numberOfLines = 0
            bar_title.center = CGPoint(x: 0, y: 0)
            bar_title.textAlignment = .left
            bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
            self.navigationItem.titleView = bar_title
            bar_title.text = "Add Card"
        }else {
            let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            bar_title.textColor = UIColor.white
            bar_title.numberOfLines = 0
            bar_title.center = CGPoint(x: 0, y: 0)
            bar_title.textAlignment = .left
            bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
            self.navigationItem.titleView = bar_title
            bar_title.text = "Add Card"
            self.CardViewAPI()
        }
       
    }
    
    func CardViewAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.cardid, forKey: "card_id")
        
        let methodName = "card/view"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                var response = NSDictionary()
                response = responseData?.value(forKey: "card") as! NSDictionary
                var cardno:Int!
                cardno = response.value(forKey: "number") as? Int
                self.cardNumnerTxt.text = String(cardno)
                self.nameonCardtextField.text = response.value(forKey: "name") as? String
                var cardmo:Int!
                cardmo = response.value(forKey: "exp_month") as? Int
                var cardyear:Int!
                cardyear = response.value(forKey: "exp_year") as? Int
                var cardcvv:Int!
                cardcvv = response.value(forKey: "cvv") as? Int
                self.CVVTxt.text = String(cardcvv)
                self.monthTxt.text = String(cardmo)
                self.yearTxt.text = String(cardyear)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if monthTxt.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }else if yearTxt.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // PickerView Delegate.....
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == monthpickerview {
            return Month.count
        }else {
            return year.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthpickerview {
            return Month[row] as? String
        }else {
            return year[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == monthpickerview {
            monthTxt.text = Month[row] as? String
        }else{
            yearTxt.text = year[row] as? String
            
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumnerTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 16
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }else if textField == CVVTxt {
            if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                guard range.location == 0 else {
                    return true
                }
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString = currentString.replacingCharacters(in: range, with: string)
                return  validate(string: newString)
            }else {
                
                let maxLength = 3
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
        }
        else {
            return true
        }
    }
    
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    func validate(whiteSpaceString: String) -> Bool {
        return whiteSpaceString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }

    @IBAction func addCardBtnAction(_ sender: Any) {
        if cardadd == "Add" {
            if ValidationClass().ValidateAddCardForm(self){
                self.AddcardAPI()
            }
        }else {
            if ValidationClass().ValidateEditCardForm(self){
                self.EditcardAPI()
            }
        }
        
    }
    
    func EditcardAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.nameonCardtextField.text!), forKey: "name")
        dict.setValue(DataManager.getVal(self.cardNumnerTxt.text!), forKey: "number")
        dict.setValue(DataManager.getVal(self.monthTxt.text!), forKey: "exp_month")
        dict.setValue(DataManager.getVal(self.yearTxt.text!), forKey: "exp_year")
        dict.setValue(DataManager.getVal(self.CVVTxt.text!), forKey: "cvv")
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue(self.cardid, forKey: "card_id")
        dict.setValue("1", forKey: "status")
        
        let methodName = "card/edit"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
                UIApplication.topViewController()?.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func AddcardAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.nameonCardtextField.text!), forKey: "name")
        dict.setValue(DataManager.getVal(self.cardNumnerTxt.text!), forKey: "number")
        dict.setValue(DataManager.getVal(self.monthTxt.text!), forKey: "exp_month")
        dict.setValue(DataManager.getVal(self.yearTxt.text!), forKey: "exp_year")
        dict.setValue(DataManager.getVal(self.CVVTxt.text!), forKey: "cvv")
        dict.setValue(self.user_id, forKey: "user_id")
        
        let methodName = "card/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
                UIApplication.topViewController()?.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    
    
}
