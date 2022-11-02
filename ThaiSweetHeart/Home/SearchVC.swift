//
//  SearchVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SearchVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,FilterSendingDelegate {
    
    
    @IBOutlet weak var SearchTblView: UITableView!
    
    var SearchText = String()
    var SearchDataArray = [Any]()
    var dict_Data = [String:Any]()
    var apiFlag = String()
    var AgeMinRange = String()
    var AgeMaxRange = String()
    var Smoking = String()
    var Drinking = String()
    var Like_pets = String()
    var Like_parties = String()
    var OnlineUser = String()
    var LocationRadius = String()
    var sport_id_str = String()
    var cuisines_id_str = String()
    var MinHeightFeet = String()
    var MinHeightInch = String()
    var MaxHeightFeet = String()
    var MaxHeightInch = String()
    var Fav_Sports_id_array = NSMutableArray()
    var Fav_Cuisines_id_array = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        bar_title.text = lang == "en" ? kExplore : kThexplore
        
        let FilterImage : UIImage? = UIImage(named:"Filter")!.withRenderingMode(.alwaysOriginal)
        let FilterButton = UIBarButtonItem(image: FilterImage, style: .plain, target: self, action: #selector(self.FilterButton_Action))
        self.navigationItem.rightBarButtonItem = FilterButton
        
        
        let nibClass = UINib(nibName: "SearchTableCell", bundle: nil)
        self.SearchTblView.register(nibClass, forCellReuseIdentifier: "SearchTableCell")
        self.SearchTblView.rowHeight = UITableView.automaticDimension
        self.SearchTblView.delegate = self
        self.SearchTblView.dataSource = self
//        self.SearchListApi(min_age: "",max_age: "",smoking: "",drinking: "",like_pet: "",like_party: "",is_online: "",radius: "",fvt_sport: "",fvt_cuisines: "",min_feet: "",min_inch: "",max_feet: "",max_inch: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.apiFlag != "true"{
            self.SearchListApi(min_age: self.AgeMinRange,max_age: self.AgeMaxRange,smoking: self.Smoking,drinking: self.Drinking,like_pet: self.Like_pets,like_party: self.Like_parties,is_online: self.OnlineUser,radius: self.LocationRadius,fvt_sport: self.sport_id_str,fvt_cuisines: self.cuisines_id_str,min_feet: self.MinHeightFeet,min_inch: self.MinHeightInch,max_feet: self.MaxHeightFeet,max_inch: self.MaxHeightInch)
        }else{
            self.SearchListApi(min_age: self.AgeMinRange,max_age: self.AgeMaxRange,smoking: self.Smoking,drinking: self.Drinking,like_pet: self.Like_pets,like_party: self.Like_parties,is_online: self.OnlineUser,radius: self.LocationRadius,fvt_sport: self.sport_id_str,fvt_cuisines: self.cuisines_id_str,min_feet: self.MinHeightFeet,min_inch: self.MinHeightInch,max_feet: self.MaxHeightFeet,max_inch: self.MaxHeightInch)
        }
    }
    
    func sendDataToSearchController(dict: [String: Any]) {
        self.dict_Data = dict
        self.AgeMinRange = DataManager.getVal(self.dict_Data["AgeMinRange"]) as? String ?? ""
        self.AgeMaxRange = DataManager.getVal(self.dict_Data["AgeMaxRange"]) as? String ?? ""
        self.MinHeightFeet = DataManager.getVal(self.dict_Data["MinHeightFeet"]) as? String ?? ""
        self.MinHeightInch = DataManager.getVal(self.dict_Data["MinHeightInch"]) as? String ?? ""
        self.MaxHeightFeet = DataManager.getVal(self.dict_Data["MaxHeightFeet"]) as? String ?? ""
        self.MaxHeightInch = DataManager.getVal(self.dict_Data["MaxHeightInch"]) as? String ?? ""
        self.OnlineUser = DataManager.getVal(self.dict_Data["OnlineUser"]) as? String ?? ""
        self.LocationRadius = DataManager.getVal(self.dict_Data["LocationRadius"]) as? String ?? ""
        self.Smoking = DataManager.getVal(self.dict_Data["Smoking"]) as? String ?? ""
        self.Drinking = DataManager.getVal(self.dict_Data["Drinking"]) as? String ?? ""
        self.Like_pets = DataManager.getVal(self.dict_Data["Like_pets"]) as? String ?? ""
        self.Like_parties = DataManager.getVal(self.dict_Data["Like_parties"]) as? String ?? ""
        self.Fav_Sports_id_array = DataManager.getVal(self.dict_Data["Fav_Sports_id_array"]) as? NSMutableArray ?? []
        self.Fav_Cuisines_id_array = DataManager.getVal(self.dict_Data["Fav_Cuisines_id_array"]) as? NSMutableArray ?? []
        self.apiFlag = DataManager.getVal(self.dict_Data["flag"]) as? String ?? ""
        
        let sport_id_str = Fav_Sports_id_array.componentsJoined(by: ",")
        print(sport_id_str)
        let cuisines_id_str = Fav_Cuisines_id_array.componentsJoined(by: ",")
        print(cuisines_id_str)
        
        self.SearchListApi(min_age: AgeMinRange,max_age: AgeMaxRange,smoking: Smoking,drinking: Drinking,like_pet: Like_pets,like_party: Like_parties,is_online: OnlineUser,radius: LocationRadius,fvt_sport: sport_id_str,fvt_cuisines: cuisines_id_str,min_feet: MinHeightFeet,min_inch: MinHeightInch,max_feet: MaxHeightFeet,max_inch: MaxHeightInch)
    }
    
    @objc func FilterButton_Action(_ sender: UIBarButtonItem){
//        print(dict)
        let vc = FilterVC(nibName: "FilterVC", bundle: nil)
        vc.delegate = self
        vc.dataDict = self.dict_Data
        
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        }else{
            // Fallback on earlier versions
        }
        self.presentViewController(vc)
    }
    
    func SearchListApi(min_age: String,max_age: String,smoking: String,drinking: String,like_pet: String,like_party: String,is_online: String,radius: String,fvt_sport: String,fvt_cuisines: String,min_feet: String,min_inch: String,max_feet: String,max_inch: String){
        
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.SearchText), forKey: "key_city")
        dict.setValue(DataManager.getVal(lat), forKey: "lat")
        dict.setValue(DataManager.getVal(Long), forKey: "long")
        dict.setValue(DataManager.getVal(min_age), forKey: "min_age")
        dict.setValue(DataManager.getVal(max_age), forKey: "max_age")
        dict.setValue(DataManager.getVal(smoking), forKey: "smoking")
        dict.setValue(DataManager.getVal(drinking), forKey: "drinking")
        dict.setValue(DataManager.getVal(like_pet), forKey: "like_pet")
        dict.setValue(DataManager.getVal(like_party), forKey: "like_party")
        dict.setValue(DataManager.getVal(is_online), forKey: "is_online")
        dict.setValue(DataManager.getVal(radius), forKey: "radius")
        dict.setValue(DataManager.getVal(fvt_sport), forKey: "fvt_sport")
        dict.setValue(DataManager.getVal(fvt_cuisines), forKey: "fvt_cuisines")
        dict.setValue(DataManager.getVal(min_feet), forKey: "min_feet")
        dict.setValue(DataManager.getVal(min_inch), forKey: "min_inch")
        dict.setValue(DataManager.getVal(max_feet), forKey: "max_feet")
        dict.setValue(DataManager.getVal(max_inch), forKey: "max_inch")
        
        let methodName = "profile/search-connection"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.SearchDataArray.removeAll()
                self.SearchDataArray = DataManager.getVal(responseData?["profile"]) as? [Any] ?? []
                self.SearchTblView.reloadData()
            }else{
                self.SearchDataArray.removeAll()
//                self.SearchTblView.reloadData()
//                self.view.makeToast(message: message)
                Config().TblViewbackgroundLbl(array: self.SearchDataArray, tblName: self.SearchTblView, message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell" ,for: indexPath) as! SearchTableCell
        var Dict = [String:Any]()
        Dict = DataManager.getVal(self.SearchDataArray[indexPath.row]) as! [String:Any]
        cell.usernameLbl.text = DataManager.getVal(Dict["fullname"]) as? String ?? ""
        cell.deslbl.text = DataManager.getVal(Dict["about"]) as? String ?? ""
        var age = String()
        age = DataManager.getVal(Dict["age"]) as? String ?? ""
        cell.ageLbl.text = "Age - " + age
        Config().setimage(name: DataManager.getVal(Dict["image"]) as? String ?? "", image: cell.userimage)
        cell.viewdetailBtn.tag = indexPath.row
        cell.viewdetailBtn.addTarget(self, action: #selector(viewDetailAction(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func viewDetailAction(_ sender: UIButton){
        let Dict = DataManager.getVal(self.SearchDataArray[sender.tag]) as! [String:Any]
        let userID = DataManager.getVal(Dict["user_id"]) as? String ?? ""
        let membership = DataManager.getVal(Dict["membership"]) as? String ?? ""
        let vc = SearchUserDetailVC(nibName: "SearchUserDetailVC", bundle: nil)
        vc.UserDetailID = userID
        vc.MemberShipStatus = membership
        self.onlyPushViewController(vc)
    }
    
}
