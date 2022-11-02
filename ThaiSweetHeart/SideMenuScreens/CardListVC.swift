//
//  CardListVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class CardListVC: BaseViewSideMenuController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var CardTblView: UITableView!
    var cardArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Manage Payment"
        self.navigationItem.titleView = bar_title
        
        let nibClass = UINib(nibName: "CardTableCell", bundle: nil)
        self.CardTblView.register(nibClass, forCellReuseIdentifier: "CardTableCell")
        self.CardTblView.rowHeight = UITableView.automaticDimension
        self.CardTblView.delegate = self
        self.CardTblView.dataSource = self
        
      

    }
    
    override func  viewWillAppear(_ animated: Bool) {
        self.CardListAPI()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
        footer.backgroundColor = UIColor.white
        
        let addCardButton = MyButton()
        addCardButton.frame = CGRect(x: 10, y: 5, width: screenWidth-20, height: 50)
        addCardButton.backgroundColor = UIColor.systemPink
        addCardButton.setTitle("Add Card", for: .normal)
        addCardButton.layer.cornerRadius = 6
        addCardButton.setBackgroundImage(UIImage(named: "NavigationBarImage"), for: .normal)
        addCardButton.clipsToBounds = true
        addCardButton.addTarget(self, action: #selector(addCardButton_Action), for: UIControl.Event.touchUpInside)
        addCardButton.showsTouchWhenHighlighted = true

        footer.addSubview(addCardButton)
        
        return footer
    }
    @objc func addCardButton_Action(_ sender: UIButton){
        let vc = AddCardVC(nibName: "AddCardVC", bundle: nil)
        let defaults = UserDefaults.standard
        defaults.setValue("Add", forKey: "CardADD")
        defaults.synchronize()
        self.onlyPushViewController(vc)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableCell" ,for: indexPath) as! CardTableCell
        var dict = NSDictionary()
        dict = self.cardArray.object(at: indexPath.row) as! NSDictionary
        var Cardnumber:Int!
        Cardnumber = dict.value(forKey: "number") as? Int
        var card:String!
        card = String(Cardnumber)
        
        var str4:String!
        str4 =  card.separate(every: 4, with: " ")
        
        cell.cardNumber.text = str4
        
        cell.nameLbl.text = dict.value(forKey: "name") as? String
        
        var month:Int!
        month = dict.value(forKey: "exp_month") as? Int
        
        var year:Int!
        year = dict.value(forKey: "exp_year") as? Int
        
        cell.expireLbl.text = String(month) + "/" + String(year)
        cell.BackView.backgroundColor = .random()
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(EditBtn(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(DeleteBtn(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    @objc func EditBtn(_ sender:UIButton){
        var dict = NSDictionary()
        dict = self.cardArray.object(at: sender.tag) as! NSDictionary
        var cardid:Int!
        cardid = dict.value(forKey: "card_id") as? Int
        let vc = AddCardVC(nibName: "AddCardVC", bundle: nil)
        vc.cardid = cardid
        let defaults = UserDefaults.standard
        defaults.setValue("Edit", forKey: "CardADD")
        defaults.synchronize()
        self.onlyPushViewController(vc)
        
    }
    
    @objc func DeleteBtn(_ sender:UIButton){
        var dict = NSDictionary()
        dict = self.cardArray.object(at: sender.tag) as! NSDictionary
        var cardid:Int!
        cardid = dict.value(forKey: "card_id") as? Int
        
        self.DeleteCardAPI(CardId: cardid)
    }
    
    func CardListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        
        let methodName = "card/list"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.cardArray = responseData?.value(forKey: "card") as! NSMutableArray
                self.CardTblView.reloadData()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func DeleteCardAPI(CardId:Int!){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(CardId, forKey: "card_id")
        
        let methodName = "card/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.CardListAPI()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    


}

extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
