//
//  QuestionaryNewCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 28/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class QuestionaryNewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var newview: UIView!
    var optionarray:NSMutableArray!
    var buttoncounter = NSMutableArray()
    var idarray = NSMutableArray()
    var answerSel:Int!
    var index:Int!
    var questId:Int!
    var ansArr = [Any]()
    var questionar = NSMutableArray()
    var itemArr = [[String: Any]]()
    var dict1 = [String:Any]()
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibClass = UINib(nibName: "Expandcell", bundle: nil)
        self.answerTableView.register(nibClass, forCellReuseIdentifier: "Expandcell")
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
        
        self.newview.layer.cornerRadius = 8
        self.newview.layer.borderWidth = 1
        self.newview.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Expandcell", for: indexPath) as! Expandcell
        var dict = NSDictionary()
        dict = optionarray.object(at: indexPath.row) as! NSDictionary
        cell.optionlabel.text = dict.value(forKey: "value") as? String
        cell.checkBtn.tag  = indexPath.row
        if answerSel == 1 {
            if indexPath.row  == index {
                cell.checkBtn.setBackgroundImage(UIImage(named: "roundRedFill"), for: .normal)
            }else{
                cell.checkBtn.setBackgroundImage(UIImage(named: "roundBlack"), for: .normal)
            }
            
        }else {
            if self.buttoncounter.contains(indexPath.row){
                cell.checkBtn.setBackgroundImage(UIImage(named: "roundRedFill"), for: .normal)
            }else{
                cell.checkBtn.setBackgroundImage(UIImage(named: "roundBlack"), for: .normal)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = NSDictionary()
        dict = optionarray.object(at: indexPath.row) as! NSDictionary
        var option_id:Int!
        option_id = dict.value(forKey: "option_id") as? Int
        index = indexPath.row
        dict1 = ["option_id":option_id!,"question_id": questId!] as [String:Any]
        
        if buttoncounter.contains(indexPath.row) {
            buttoncounter.remove(indexPath.row)
            idarray.add(option_id!)
        }else{
            buttoncounter.add(indexPath.row)
            self.ansArr.append(dict1)
            print(self.ansArr)
            idarray.remove(option_id!)
        }
        self.answerTableView.reloadData()
        
        var answer:String!
        answer = self.JSONStringify(value: ansArr as AnyObject)
        print(answer!)
        self.itemArr.append(dict1)
        let defaults = UserDefaults.standard
        defaults.setValue(answer, forKey: "ANSWER")
        defaults.setValue("Answer", forKey: "callAns")
        defaults.synchronize()
    }
    
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
