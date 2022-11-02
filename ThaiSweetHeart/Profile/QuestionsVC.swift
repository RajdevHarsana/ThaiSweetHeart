//
//  QuestionsVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 10/12/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class QuestionsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var doneBtn: MyButton!
    var QuestionArray = NSMutableArray()
    var name:String!
    var defaults:UserDefaults!
    var answerArray = NSMutableArray()
    var dictquestion = [String:Any]()
    var AnswerAr:String!
    var textnei:Int!
    var AnswerArNew = String()
    var flag_comingfromLogin = Bool()
    var placeholder = " Enter Ans"
    override func viewDidLoad() {
            
        super.viewDidLoad()
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.doneBtn.setTitle(lang == "en" ? kProfiledoneBtn : kThdoneBtn, for: .normal)
        
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "NAME") as? String
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = name
        self.navigationItem.titleView = bar_title

        
        let nibClass = UINib(nibName: "QuestionCellNew", bundle: nil)
        self.questionTable.register(nibClass, forCellReuseIdentifier: "QuestionCellNew")
        self.questionTable.rowHeight = UITableView.automaticDimension
        
        self.QuestionListAPI()
        // Do any additional setup after loading the view.
    }
    
    func QuestionListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
    
        let methodName = "question/normal"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.QuestionArray = responseData?.value(forKey: "question") as! NSMutableArray
                self.questionTable.reloadData()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.QuestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCellNew", for: indexPath) as! QuestionCellNew
        var dict = NSDictionary()
        dict = QuestionArray.object(at: indexPath.row) as! NSDictionary
        cell.questionLbl.text = dict.value(forKey: "value") as? String
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        cell.ansTxt.placeholder = lang == "en" ? kansTxt : kThansTxt
//        if cell.andTextView.text == "" {
//            cell.andTextView.text = lang == "en" ? kansTxt : kThansTxt
//        }
        
        cell.andTextView.text = placeholder
        cell.andTextView.textColor = .black
        
        var textnew:String!
        textnew = dict.value(forKey: "answer") as? String
        
        if textnew == "" {
            cell.andTextView.textColor = .lightGray
        }else {
            cell.andTextView.text = textnew
        }
        cell.andTextView.delegate = self
        cell.andTextView.tag = indexPath.row
        self.answerArray.add(dict)
        return cell
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let myIP = IndexPath(row: textView.tag, section: 0)
        let cell1In = self.questionTable.cellForRow(at: myIP) as? QuestionCellNew
        
        if cell1In?.andTextView.textColor == .lightGray {
            cell1In?.andTextView.text = ""
            cell1In?.andTextView.textColor = .black
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        let myIP = IndexPath(row: textField.tag, section: 0)
//        let dict = DataManager.getVal(self.QuestionArray[textField.tag]) as! NSDictionary
//        let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
//        let cell1In = self.questionTable.cellForRow(at: myIP) as? QuestionCellNew
//        self.textnei = cell1In?.andTextView.tag
//        print(textnei)
//        self.AnswerArNew = cell1In?.andTextView.text ?? ""
//        print(AnswerArNew)
//        let dict1 = ["answer":cell1In?.andTextView.text as Any,"question_id": question_id] as NSMutableDictionary
//        print(dict1)
//        self.answerArray.add(dict1)
//        print(self.answerArray)
//
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let myIP = IndexPath(row: textView.tag, section: 0)
        let dict = DataManager.getVal(self.QuestionArray[textView.tag]) as! NSDictionary
        let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
        let cell1In = self.questionTable.cellForRow(at: myIP) as? QuestionCellNew
        self.textnei = cell1In?.andTextView.tag
        self.AnswerArNew = cell1In?.andTextView.text ?? ""
        print(AnswerArNew)
        let dict1 = ["answer":cell1In?.andTextView.text as Any,"question_id": question_id] as NSMutableDictionary
        print(dict1)
        self.answerArray.add(dict1)
        print(self.answerArray)
        if ((cell1In?.andTextView.text) != "") {
//            cell1In?.andTextView.text = " Enter Ans"
            placeholder = (cell1In?.andTextView.text)!
            cell1In?.andTextView.textColor = UIColor.black
            
        }else{
//            QuestionArray.removeObjects(at: self.QuestionArray[textView.tag] as! IndexSet)
            placeholder = " Enter Ans"
            cell1In?.andTextView.text = placeholder
            cell1In?.andTextView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let myIP = IndexPath(row: textView.tag, section: 0)
        let cell1In = self.questionTable.cellForRow(at: myIP) as? QuestionCellNew
        placeholder = (cell1In?.andTextView.text)!
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       
        return true
    }
    @IBAction func doneBtnAction(_ sender: UIButton) {
        var ans = NSArray()
        ans = self.answerArray.value(forKey: "value") as! NSArray
        var str:Int!
        for i in 0..<ans.count{
            str = i
        }
        if str == 0 {
            self.view.makeToast(message: "Please answer at least one question")
        }else {
            AnswerAr = self.JSONStringify(value: self.answerArray as AnyObject)
            print(AnswerAr!)
            self.AnswerSendAPI(answer: AnswerAr)
            str = 0
        }
//        for i in 0..<self.QuestionArray.count {
//            var dict = NSDictionary()
//            dict = self.QuestionArray.object(at: i) as! NSDictionary
//            var answe:String!
//            answe = dict.value(forKey: "answer") as? String
//            var quesid:Int!
//            quesid = dict.value(forKey: "question_id") as? Int
//            var dictquestion = [String:Any]()
//            dictquestion = ["question_id": quesid!,
//                            "answer": answe!]
//            self.answerArray.add(dictquestion)
//            var ansar:NSArray!
//            ansar = self.answerArray.value(forKey: "answer") as? NSArray
//
//            AnswerAr = self.JSONStringify(value: self.answerArray as AnyObject)
//            print(AnswerAr!)
//        }
        
//        if answe == "" {
//            self.view.makeToast(message: "Please answer at least one question")
//        }else {
//            self.AnswerSendAPI(answer: AnswerAr)
//        }
        
    }
    
    
    func AnswerSendAPI(answer:String!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue(AnswerAr, forKey: "answer")
        dict.setValue("2", forKey: "type")
        print(dict)
        let methodName = "question/answer"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.flag_comingfromLogin == true{
                    Config().AppUserDefaults.set("yes", forKey: "login")
                    let vc = SelectQuestionVC(nibName: "SelectQuestionVC", bundle: nil)
                    vc.flag_comingfromLogin = self.flag_comingfromLogin
                    self.onlyPushViewController(vc)
                    self.view.makeToast(message: message)
                }else{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                    self.view.makeToast(message: message)
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
   

}
