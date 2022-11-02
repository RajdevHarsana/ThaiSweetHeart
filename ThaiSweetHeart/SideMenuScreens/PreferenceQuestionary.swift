//
//  PreferenceQuestionary.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 10/12/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class PreferenceQuestionary: BaseViewSideMenuController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var questionaryTableView: UITableView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var doneBtn: MyButton!
    @IBOutlet weak var calulateLbl: UILabel!
    @IBOutlet weak var slidebart: UISlider!
    
    var questionArray = NSMutableArray()
    var expanarray = NSMutableArray()
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    let kHeaderSectionTag: Int = 6900;
    var sectionItems: Array<Any> = []
    var sectionNames = [String]()
    var isExpended: Bool = false
    var ansArr = NSMutableArray()
    var buttoncounter = NSMutableArray()
    var idarray = NSMutableArray()
    var sectionItems1: Array<Any> = []
    var page:Int!
    var pageres:Int!
    var totalpage:Int!
    var totalqus:Int!
    var totalans:Int!
    var flag_comingfromLogin = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        bar_title.text = "Preference Questionnaire"
        
        let nibClass = UINib(nibName: "QuestionaryNewCell", bundle: nil)
        self.questionaryTableView.register(nibClass, forCellReuseIdentifier: "QuestionaryNewCell")
        self.doneBtn.isHidden  = true
        self.page = 1
        
        if self.flag_comingfromLogin == true{
            self.skipBtn.isHidden = false
        }else{
            self.skipBtn.isHidden = true
        }
        self.QuestionListAPI()

    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        vc.flag_comingfromLogin1 = flag_comingfromLogin 
        self.RootViewWithSideManu(vc)
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        self.page = self.pageres+1
        self.QuestionListAPI()
       
        let ansn = UserDefaults.standard.value(forKey: "callAns") as? String
        if ansn == "Answer" {
            let ans = UserDefaults.standard.value(forKey: "ANSWER") as? String
            self.AnswerSendAPI(answer: ans)
        }else {
           print("Ashish")
        }
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if self.flag_comingfromLogin == true {
            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
            self.RootViewWithSideManu(vc)
        }else {
            let ans = UserDefaults.standard.value(forKey: "ANSWER") as? String
            self.AnswerSendAPI1(answer: ans)
        }
    }
    
    func AnswerSendAPI(answer:String!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue("1", forKey: "type")
        dict.setValue(answer, forKey: "answer")
        
        let methodName = "question/answer"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                UserDefaults.standard.removeObject(forKey: "callAns")
//                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//                self.RootViewWithSideManu(vc)
               // self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func AnswerSendAPI1(answer:String!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue("1", forKey: "type")
        dict.setValue(answer, forKey: "answer")
        
        let methodName = "question/answer"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                UserDefaults.standard.removeObject(forKey: "callAns")
                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                self.RootViewWithSideManu(vc)
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    // MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionaryNewCell", for: indexPath) as! QuestionaryNewCell
        //let section = self.sectionItems[indexPath.section] as! NSArray
        var dict = NSDictionary()
        dict = questionArray.object(at: indexPath.row) as! NSDictionary
       // cell.textLabel?.textColor = UIColor.black
       // cell.questionLbl?.text = section[indexPath.row] as? String
        var answerselction:Int!
        answerselction = dict.value(forKey: "possible_answer") as? Int
        var questionId:Int!
        questionId = dict.value(forKey: "question_id") as? Int
        var value:String!
        value = dict.value(forKey: "value") as? String
        cell.questionLbl?.text = "Q. " + value
        var optionArra:NSArray!
        optionArra = (dict.value(forKey: "options") as? NSMutableArray)!
        cell.optionarray = optionArra as? NSMutableArray
        cell.answerSel = answerselction
        cell.questId = questionId
        cell.questionar = self.questionArray
        cell.answerTableView.reloadData()
        return cell
    }
    func QuestionListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue(String(self.page), forKey: "page")
        
        let methodName = "question/preference"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let pager = DataManager.getVal(responseData?["page"]) as? String ?? ""
            let totalPages = DataManager.getVal(responseData?["totalPages"]) as? String ?? ""
            let totalQuestion = DataManager.getVal(responseData?["totalQuestion"]) as? String ?? ""
            let totalAnswer = DataManager.getVal(responseData?["totalAnswer"]) as? String ?? ""
            self.totalpage = Int(totalPages)
            self.pageres =  Int(pager)
            self.totalqus = Int(totalQuestion)
            self.totalans = Int(totalAnswer)
            var finalAns:Int!
            finalAns = self.totalans*100/self.totalqus
            print(finalAns!)
            var slidervalue:Float!
            slidervalue = Float(finalAns)
            self.slidebart.value = slidervalue
            self.slidebart.minimumValue = slidervalue
            self.slidebart.maximumValue = 100.0
            self.calulateLbl.text = String(finalAns) + "%"
            
            if status == "1"{
                self.questionArray = responseData?.value(forKey: "question") as! NSMutableArray
                if self.pageres == self.totalpage {
                    self.doneBtn.isHidden  = false
                    self.skipBtn.isHidden = true
                    self.nextBtn.isHidden = true
                }else {
                    if self.flag_comingfromLogin == true{
                        self.skipBtn.isHidden = false
                    }else{
                        self.skipBtn.isHidden = true
                    }
                    self.doneBtn.isHidden  = true
                    self.nextBtn.isHidden = false
                }
                for i in 0..<self.questionArray.count{
                    var dict = NSDictionary()
                    dict = self.questionArray.object(at: i) as! NSDictionary
                    var valuenew:String!
                    valuenew = dict.value(forKey: "value") as? String
                    self.sectionNames.append(valuenew!)
                }
                for i in 0..<self.questionArray.count{
                    var dict = NSDictionary()
                    dict = self.questionArray.object(at: i) as! NSDictionary
                    var optionArra:NSArray!
                    optionArra = (dict.value(forKey: "options") as? NSMutableArray)!
                    var neewar:NSArray!
                    neewar = optionArra.value(forKey: "value") as? NSArray
                    print(neewar!)
                    self.sectionItems.append(neewar!)
                }
                print(self.sectionNames)
                print(self.sectionItems)
                self.questionaryTableView.reloadData()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }

}
