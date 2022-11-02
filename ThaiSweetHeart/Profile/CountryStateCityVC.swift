//
//  CountryStateCityVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 11/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
protocol MyDataSendingDelegate {
    func sendDataToFirstViewController(id: String,name: String,type: String)
}

class CountryStateCityVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var ListtblView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var delegate: MyDataSendingDelegate? = nil
    var dataArray = [Any]()
    var country_id = String()
    var state_id = String()
    var gender_id = String()
    var orientation_id = String()
    var ethnicity_id = String()
    var religion_id = String()
    var degree_id = String()
    var type = String()
    var search_Array = [Any]()
    var isPresent = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.tintColor = UIColor.systemPink
        let OTPToolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: screenWidth,height: 35))
        OTPToolbar.barStyle = UIBarStyle.default
        
        var OTPItems = [IQBarButtonItem]()
        
        let OTPFlexSpace: IQBarButtonItem
        OTPFlexSpace = IQBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        OTPItems.append(OTPFlexSpace)
        
        let OTPDoneButton = IQBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.BarButtonDonePressed(_:)))
        OTPDoneButton.tintColor = UIColor.systemPink
        OTPItems.append(OTPDoneButton)
        OTPToolbar.setItems(OTPItems, animated: true)
        
        self.SearchBar.delegate = self
        self.SearchBar.backgroundColor = Config().AppBlackColor
        self.SearchBar.sizeToFit()
        self.SearchBar.inputAccessoryView = OTPToolbar
        self.SearchBar.showsCancelButton = false
        self.SearchBar.returnKeyType = .search
        self.SearchBar.enablesReturnKeyAutomatically = false
        
        
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.ListtblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.ListtblView.rowHeight = UITableView.automaticDimension
        self.ListtblView.delegate = self
        self.ListtblView.dataSource = self
        
        self.countryStateCityAPI()
    }
    func countryStateCityAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        var methodName = String()
        
        if self.title == "Select Country"{
            methodName = "option/country"
            self.type = "country"
        }else if self.title == "Select State"{
            methodName = "option/state"
            dict.setValue(DataManager.getVal(self.country_id), forKey: "country_id")
            self.type = "state"
        }else  if self.title == "Select City"{
            methodName = "option/city"
            dict.setValue(DataManager.getVal(self.state_id), forKey: "state_id")
            self.type = "city"
        }else  if self.title == "Select Ethnicity"{
            methodName = "option/ethnicity"
            dict.setValue(DataManager.getVal(self.ethnicity_id), forKey: "ethnicity_id")
            self.type = "ethnicity"
        }else  if self.title == "Select Religion"{
            methodName = "option/religions"
            dict.setValue(DataManager.getVal(self.religion_id), forKey: "religion_id")
            self.type = "religion"
        }else  if self.title == "Select Degree"{
            methodName = "option/degree"
            dict.setValue(DataManager.getVal(self.degree_id), forKey: "degree_id")
            self.type = "degree"
        }else if title == "Select Build" {
            methodName = "option/build"
            self.type = "build"
        }else if title == "Select Gender" {
            methodName = "option/gender"
            dict.setValue(DataManager.getVal(self.gender_id), forKey: "gender_id")
            self.type = "gender"
        }else if title == "Select Orientation" {
            methodName = "option/orientation"
            dict.setValue(DataManager.getVal(self.orientation_id), forKey: "orientation_id")
            self.type = "orientation"
        }
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.title == "Select Country"{
                    self.dataArray = DataManager.getVal(responseData?["country"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select State"{
                    self.dataArray = DataManager.getVal(responseData?["state"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select City"{
                    self.dataArray = DataManager.getVal(responseData?["city"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select Gender"{
                    self.dataArray = DataManager.getVal(responseData?["gender"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select Orientation"{
                    self.dataArray = DataManager.getVal(responseData?["orientation"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select Ethnicity"{
                    self.dataArray = DataManager.getVal(responseData?["ethnicity"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select Religion"{
                    self.dataArray = DataManager.getVal(responseData?["religion"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else  if self.title == "Select Degree"{
                    self.dataArray = DataManager.getVal(responseData?["degree"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }else if self.title == "Select Build"{
                    self.dataArray = DataManager.getVal(responseData?["build"]) as? [Any] ?? []
                    self.search_Array = self.dataArray
                }
                self.ListtblView.reloadData()
            }else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.ListtblView, message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.search_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.search_Array[indexPath.row]) as! [String: Any]
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.search_Array[indexPath.row]) as! [String: Any]
        var id = String()
        if self.title == "Select Country"{
            id = DataManager.getVal(dict["country_id"]) as? String ?? ""
        }else if self.title == "Select State"{
            id = DataManager.getVal(dict["state_id"]) as? String ?? ""
        }else if self.title == "Select City"{
            id = DataManager.getVal(dict["city_id"]) as? String ?? ""
        }else if self.title == "Select Gender"{
            id = DataManager.getVal(dict["id"]) as? String ?? ""
        }else if self.title == "Select Orientation"{
            id = DataManager.getVal(dict["id"]) as? String ?? ""
        }else if self.title == "Select Ethnicity"{
            id = DataManager.getVal(dict["ethnicity_id"]) as? String ?? ""
        }else if self.title == "Select Religion"{
            id = DataManager.getVal(dict["religion_id"]) as? String ?? ""
        }else if self.title == "Select Degree"{
            id = DataManager.getVal(dict["degree_id"]) as? String ?? ""
        }else if self.title == "Select Build"{
            id = DataManager.getVal(dict["build_id"]) as? String ?? ""
        }
        
        let name = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.delegate != nil{
            let data_id = id
            let data_name = name
            self.delegate?.sendDataToFirstViewController(id: data_id,name: data_name,type: self.type)
            if isPresent == true{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK:- UISEARCH BAR DELEGATE FUNCTIONS
    @objc func BarButtonDonePressed(_ sender: UIBarButtonItem) {
        SearchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.SearchBar.setShowsCancelButton(false, animated: true)
        self.SearchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var keyword = searchBar.text
        keyword = keyword?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        self.search_Array = [Any]()
        if (keyword == ""){
            self.search_Array = self.dataArray
        }else{
            for dict in self.dataArray  {
                let attachmentListDict = dict as! [String: Any]
                
                var message = DataManager.getVal(attachmentListDict["name"]) as! String
                message = message.lowercased()
                
                if message.range(of: keyword!.lowercased()) != nil {
                    print("exists")
                    self.search_Array.append(attachmentListDict)
                    print(self.search_Array)
                }else{
                    print("Does not exist")
                }
            }
        }
        self.ListtblView.reloadData()
        if self.search_Array.count == 0 {
            let NoDataFountLbl = UILabel()
            NoDataFountLbl.frame = CGRect(x: 0, y: self.ListtblView.frame.size.height/2 - 30, width: self.ListtblView.frame.size.width, height: 60)
            NoDataFountLbl.textAlignment = NSTextAlignment.center
            NoDataFountLbl.text = "No Record Found"
            NoDataFountLbl.textColor = UIColor.black
            NoDataFountLbl.numberOfLines = 0
            self.ListtblView.backgroundView = NoDataFountLbl
        }else{
            self.ListtblView.backgroundView = nil
        }
    }
}
