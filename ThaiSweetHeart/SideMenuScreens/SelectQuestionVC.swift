//
//  SelectQuestionVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 26/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SelectQuestionVC: BaseViewSideMenuController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var complationLbl: UILabel!
    @IBOutlet weak var QuestionTblView: UITableView!
    
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var doneBtn: MyButton!
    @IBOutlet weak var calulateLbl: UILabel!
    @IBOutlet weak var slidebart: UISlider!
    var data_array = [Any]()
    var answer_array = NSMutableArray()
    var option_array = [Any]()
    var AnsDict1 = [String: Any]()
    var AnsDict2 = [String: Any]()
    var section = Int()
    var index1 = Int()
    var index2 = Int()
    var page_count = String()
    var page = Int()
    var Starting = Int()
    var pageres = Int()
    var totalpage = Int()
    var totalqus = Int()
    var totalans = Int()
    var flag_comingfromLogin = Bool()
    var id_Array = NSMutableArray()
    var isFirst = Bool()
    
    var buttoncounter1 = NSMutableArray()
    var buttoncounter2 = NSMutableArray()
    var idarray = NSMutableArray()
    var ansArr1 = [Any]()
    var ansArr2 = [Any]()
    var answerSel:Int!
    var selectedIndexes = [[IndexPath.init(row: 0, section: 0)], [IndexPath.init(row: 0, section: 1)]]
    var isSelectSection0 = Bool()
    var isSelectSection1 = Bool()
    var possibleVal = String()
    var newArray = NSMutableArray()
    var answer1 = String()
    var globle_upload_array = [Any]()
    var menuBarBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        nextBtn.isHidden = false
        doneBtn.isHidden = false
        slidebart.isUserInteractionEnabled = false
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.title = "Preference Questionnaire"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        bar_title.text = lang == "en" ? kQuestionnaire : kThQuestionnaire
        self.complationLbl.text = lang == "en" ? kcomplationLbl : kThcomplationLbl
//        self.skipBtn.setTitle(lang == "en" ? kDone : kThSkipe , for: .normal)
        self.nextBtn.setTitle(lang == "en" ? knextBtn : kThnextBtn, for: .normal)
        self.doneBtn.setTitle(lang == "en" ? kdoneBtn : kThdoneBtn, for: .normal)
        let nibClass = UINib(nibName: "QuestionTableCell", bundle: nil)
        self.QuestionTblView.register(nibClass, forCellReuseIdentifier: "QuestionTableCell")
        self.QuestionTblView.rowHeight = UITableView.automaticDimension
        self.QuestionTblView.delegate = self
        self.QuestionTblView.dataSource = self
        self.page = 1
        self.Starting = 1
        if self.flag_comingfromLogin == true{
            self.navigationItem.leftBarButtonItem = nil
        }else{
            
        }
        self.QuestionListAPI()
    }
    
//    @IBAction func skipBtnAction(_ sender: UIButton) {
//        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//        vc.flag_comingfromLogin1 = flag_comingfromLogin
//        self.RootViewWithSideManu(vc)
//        
//    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
//        self.buttoncounter1.removeAllObjects()
//        self.buttoncounter2.removeAllObjects()
//        self.globle_upload_array.removeAll()
        
        print(self.ansArr1)//first section array
        print(self.AnsDict2)//single answer dict
//        var globle_upload_array = [Any]()
        
//        for i in 0..<self.ansArr1.count {
//            let dict = DataManager.getVal(self.ansArr1[i]) as! [String: Any]
//            globle_upload_array.append(dict)
//        }
//        globle_upload_array.append(self.AnsDict2)
        
//        let answer_str = self.JSONStringify(value: globle_upload_array as AnyObject)
        
        if self.ansArr1.count != 0{
//            self.id_Array.add(self.ansArr1)
            for i in 0..<self.ansArr1.count {
                let dict = DataManager.getVal(self.ansArr1[i]) as! [String: Any]
                globle_upload_array.append(dict)
            }
        }else{
//            self.id_Array.add(self.AnsDict1)
            globle_upload_array.append(self.AnsDict1)
        }
        if self.ansArr2.count != 0{
//            self.id_Array.add(self.ansArr2)
            for i in 0..<self.ansArr1.count {
                let dict = DataManager.getVal(self.ansArr1[i]) as! [String: Any]
                globle_upload_array.append(dict)
            }
        }else{
//            self.id_Array.add(self.AnsDict2)
            globle_upload_array.append(self.AnsDict2)
        }
        print(globle_upload_array)
        let answer_str = self.JSONStringify(value: globle_upload_array as AnyObject)
        //let answer : String = self.JSONStringify(value: self.id_Array as AnyObject)
        //print(answer)
//        let newAns = answer.replacingOccurrences(of: "[", with: "")
//        let AnsNew = newAns.replacingOccurrences(of: "]", with: "")
//        print(AnsNew)
//
//
//        self.newArray.add(AnsNew)
//        print(newArray)
//
//        self.answer1 = self.JSONStringify(value: self.newArray as AnyObject)
//        print(answer1)
//        let newArray1 = answer1.replacingOccurrences(of: "\"", with: "")
//        print(newArray1)
        
        self.AnswerSendAPI(answer: answer_str)
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        if self.flag_comingfromLogin == true {
            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
            self.RootViewWithSideManu(vc)
        }else {
            if self.ansArr1.count != 0{
                for i in 0..<self.ansArr1.count {
                    let dict = DataManager.getVal(self.ansArr1[i]) as! [String: Any]
                    globle_upload_array.append(dict)
                }
            }else{
                globle_upload_array.append(self.AnsDict1)
            }
            if self.ansArr2.count != 0{
                for i in 0..<self.ansArr1.count {
                    let dict = DataManager.getVal(self.ansArr1[i]) as! [String: Any]
                    globle_upload_array.append(dict)
                }
            }else{
                globle_upload_array.append(self.AnsDict2)
            }
            print(globle_upload_array)
            let answer_str = self.JSONStringify(value: globle_upload_array as AnyObject)
//            let ans = UserDefaults.standard.value(forKey: "ANSWER") as? String
            self.AnswerSendAPI1(answer: answer_str)
        }
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
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
                self.page = self.pageres+1
                self.buttoncounter1.removeAllObjects()
                self.buttoncounter2.removeAllObjects()
                self.globle_upload_array.removeAll()
                self.ansArr1.removeAll()
                self.ansArr2.removeAll()
                self.QuestionListAPI()
                self.clearAllNotice()
            }else{
                self.view.makeToast(message: message)
                self.clearAllNotice()
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
                self.clearAllNotice()
            }else{
                self.view.makeToast(message: message)
                self.clearAllNotice()
            }
            self.clearAllNotice()
        }
    }
    
    func QuestionListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        dict.setValue(String(self.page), forKey: "page")
//        dict.setValue(String(self.Starting), forKey: "starting")

        if page == 1 {
            
            dict.setValue("1", forKey: "starting")
        }else{
            dict.setValue("0", forKey: "starting")
        }
    
        let methodName = "question/preference"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let pager = DataManager.getVal(responseData?["page"]) as? String ?? ""
            let totalPages = DataManager.getVal(responseData?["totalPages"]) as? String ?? ""
            let totalQuestion = DataManager.getVal(responseData?["totalQuestion"]) as? String ?? ""
            let totalAnswer = DataManager.getVal(responseData?["totalAnswer"]) as? String ?? ""
            let startingPage = DataManager.getVal(responseData?["starting"]) as? String ?? ""
            
            if status == "1"{
                self.Starting = Int(startingPage) ?? 0
                self.totalpage = Int(totalPages) ?? 0
                self.pageres =  Int(pager) ?? 0
                self.totalqus = Int(totalQuestion) ?? 0
                self.totalans = Int(totalAnswer) ?? 0
                let value = self.calculatePercentage(value: Double(self.totalqus),percentageVal: Double(self.totalans))
                 print(value)
                let x = Int(value)
                let value1 = x
    //            let y = Double(round(x))
    //            print(y)
    //            let int1 = Int(y)
                print(x)
                var slidervalue:Float!
                slidervalue = Float(x)
                print(slidervalue as Any)
                self.slidebart.minimumValue = 0
                self.slidebart.maximumValue = 100
                self.slidebart.value = slidervalue
                print(self.slidebart.value)
                self.calulateLbl.text = String(value1) + "%"
                
                self.data_array = DataManager.getVal(responseData?["question"]) as? [Any] ?? []
                self.isFirst = true
                self.isSelectSection0 = false
                self.isSelectSection1 = false
//                if self.pageres == self.totalpage {
//                    self.doneBtn.isHidden  = false
//                    self.skipBtn.isHidden = true
//                    self.nextBtn.isHidden = true
//                }else {
//                    if self.flag_comingfromLogin == true{
//                        self.skipBtn.isHidden = false
//                    }else{
//                        self.skipBtn.isHidden = true
//                    }
//                    self.doneBtn.isHidden  = true
//                    self.nextBtn.isHidden = false
//                }
                self.QuestionTblView.reloadData()
                self.clearAllNotice()
            }else{
                let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                self.RootViewWithSideManu(vc)
                self.view.makeToast(message: message)
                self.clearAllNotice()
            }
            self.clearAllNotice()
        }
    }
    
    func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = percentageVal / value
        return val * 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data_array.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = DataManager.getVal(self.data_array[section]) as! NSDictionary
        //let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
        
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 90)
        header.backgroundColor = Config().AppWhiteColor
//        header.layer.borderWidth = 0
//        header.layer.borderColor = UIColor.gray.cgColor
        header.layer.cornerRadius = 8
        let title_lbl = UILabel()
        title_lbl.numberOfLines = 3
        title_lbl.frame = CGRect(x: 17, y: 8, width: screenWidth-30, height: 44)
        title_lbl.text = "Q. " + "\(DataManager.getVal(dict["value"]) as? String ?? "")"
        
        title_lbl.textColor = UIColor.black
        header.addSubview(title_lbl)
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = DataManager.getVal(self.data_array[section]) as! NSDictionary
        self.option_array = DataManager.getVal(dict["options"]) as? [Any] ?? []
        
        return self.option_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableCell" ,for: indexPath) as! QuestionTableCell
        let dict = DataManager.getVal(self.data_array[indexPath.section]) as! NSDictionary
        let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
        self.option_array = DataManager.getVal(dict["options"]) as? [Any] ?? []
        self.answer_array = DataManager.getVal(dict["answer"]) as? NSMutableArray ?? []
        let dict1 = DataManager.getVal(self.option_array[indexPath.row]) as! NSDictionary
        let option_id = DataManager.getVal(dict1["option_id"]) as? String ?? ""
        cell.TitleLbl.text = DataManager.getVal(dict1["value"]) as? String ?? ""
        
        if self.isFirst == true{
            if answer_array.contains(option_id){
                let possibleValAns = DataManager.getVal(dict["possible_answer"]) as? String ?? ""
                if indexPath.section == 0{
                    if possibleValAns == "1"{
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        print(self.AnsDict1)
                    }else if possibleValAns == "2" {
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                        print(self.ansArr1)
                    }else if possibleValAns == "3" {
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                        print(self.ansArr1)
                    }
                }else if indexPath.section == 1{
                    if possibleValAns == "1"{
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        print(self.AnsDict1)
                    }else if possibleValAns == "2" {
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                        print(self.ansArr2)
                    }else if possibleValAns == "2" {
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                        print(self.ansArr2)
                    }
                }
                cell.CheckImg.image = UIImage(named: "roundRedFill")
            }else{
                cell.CheckImg.image = UIImage(named: "roundBlack")
            }
        }else{
            if indexPath.section == 0{
                if self.isSelectSection0 == true{
                    if self.possibleVal == "1" {
                        if indexPath.row  == index1 {
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    
                    }else if self.possibleVal == "2" {
                        if self.buttoncounter1.contains(indexPath.row){
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    }else if self.possibleVal == "3" {
                        if self.buttoncounter1.contains(indexPath.row){
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    }
                }else{
                    cell.CheckImg.image = UIImage(named: "roundBlack")
                }
            }else if indexPath.section == 1{
                if self.isSelectSection1 == true {
                    if self.possibleVal == "1" {
                        if indexPath.row  == index2 {
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    }else if self.possibleVal == "2" {
                        if self.buttoncounter2.contains(indexPath.row){
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    }else if self.possibleVal == "3" {
                        if self.buttoncounter2.contains(indexPath.row){
                            cell.CheckImg.image = UIImage(named: "roundRedFill")
                        }else{
                            cell.CheckImg.image = UIImage(named: "roundBlack")
                        }
                    }
                }else{
                    cell.CheckImg.image = UIImage(named: "roundBlack")
                }
            }
      }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = QuestionTblView.cellForRow(at: indexPath) as! QuestionTableCell
//
        if indexPath.section == 0{
            let dict = DataManager.getVal(self.data_array[indexPath.section]) as! NSDictionary
            self.section = indexPath.section
            let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
            self.option_array = DataManager.getVal(dict["options"]) as? [Any] ?? []
            let dict1 = DataManager.getVal(self.option_array[indexPath.row]) as! NSDictionary
            self.index1 = indexPath.row
            let option_id = DataManager.getVal(dict1["option_id"]) as? String ?? ""
            self.possibleVal = DataManager.getVal(dict["possible_answer"]) as? String ?? ""
            self.isSelectSection0 = true
            if self.possibleVal == "1"{
                self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                print(self.AnsDict1)
            }else if self.possibleVal == "2" {
                if buttoncounter1.contains(indexPath.row) {
                    buttoncounter1.remove(indexPath.row)
                    idarray.add(option_id)
                }else{
                    if buttoncounter1.count == 2{
                        buttoncounter1.removeObject(at: 0)
                        self.ansArr1.removeFirst()
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                    }else{
                        buttoncounter1.add(indexPath.row)
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                        print(self.ansArr1)
                        idarray.remove(option_id)
                    }
                }
            }else if self.possibleVal == "3" {
                if buttoncounter1.contains(indexPath.row) {
                    buttoncounter1.remove(indexPath.row)
                    idarray.add(option_id)
                }else{
                    if buttoncounter1.count == 3{
                        buttoncounter1.removeObject(at: 0)
                        self.ansArr1.removeFirst()
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                    }else{
                        buttoncounter1.add(indexPath.row)
                        self.AnsDict1 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr1.append(self.AnsDict1)
                        print(self.ansArr1)
                        idarray.remove(option_id)
                    }
                }
            }
            self.isFirst = false
            self.QuestionTblView.reloadSections(IndexSet(integer: 0), with: .none)
//            self.QuestionTblView.reloadData()
            
        }else if indexPath.section == 1 {
            let dict = DataManager.getVal(self.data_array[indexPath.section]) as! NSDictionary
            self.section = indexPath.section
            let question_id = DataManager.getVal(dict["question_id"]) as? String ?? ""
            self.option_array = DataManager.getVal(dict["options"]) as? [Any] ?? []
            let dict1 = DataManager.getVal(self.option_array[indexPath.row]) as! NSDictionary
            self.index2 = indexPath.row
            let option_id = DataManager.getVal(dict1["option_id"]) as? String ?? ""
            self.possibleVal = DataManager.getVal(dict["possible_answer"]) as? String ?? ""
            self.isSelectSection1 = true
            if possibleVal == "1"{
                self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                print(self.AnsDict2)
            }else if possibleVal == "2"{
                if buttoncounter2.contains(indexPath.row) {
                    buttoncounter2.remove(indexPath.row)
                    idarray.add(option_id)
                }else{
                    if buttoncounter2.count == 2{
                        buttoncounter2.removeObject(at: 0)
                        self.ansArr2.removeFirst()
                        print(self.ansArr2)
                        buttoncounter2.add(indexPath.row)
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                        print(self.ansArr2)
                    }else{
                        buttoncounter2.add(indexPath.row)
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                        print(self.ansArr2)
                        idarray.remove(option_id)
                    }
                    
                }
            }else if self.possibleVal == "3" {
                if buttoncounter2.contains(indexPath.row) {
                    buttoncounter2.remove(indexPath.row)
                    idarray.add(option_id)
                }else{
                    if buttoncounter2.count == 3{
                        buttoncounter2.removeObject(at: 0)
                        self.ansArr2.removeFirst()
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                    }else{
                        buttoncounter2.add(indexPath.row)
                        self.AnsDict2 = ["question_id": question_id,"answer": option_id] as [String: Any]
                        self.ansArr2.append(self.AnsDict2)
                        print(self.ansArr2)
                        idarray.remove(option_id)
                    }
                }
            }
            self.isFirst = false
            self.QuestionTblView.reloadSections(IndexSet(integer: 1), with: .none)
//            self.QuestionTblView.reloadData()
        }
    
        
//        if self.id_Array.contains(dict_add){
//            self.id_Array.remove(dict_add)
//            print(self.id_Array)
//            self.QuestionTblView.reloadData()
//        }else{
//            self.id_Array.add(dict_add)
//            print(self.id_Array)
//            self.QuestionTblView.reloadData()
//        }
    }
    
}

extension String {
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error")
            }
        }
        return ""
    }
}
