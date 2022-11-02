//
//  PreferenceVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 30/06/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import CoreLocation

@available(iOS 13.0, *)
class PreferenceVC: BaseViewSideMenuController, UITableViewDataSource, UITableViewDelegate, SlideMenuControllerDelegate {
    
    @IBOutlet weak var genderTxtFeild: UITextField!
    @IBOutlet weak var orientationTxtFeild: UITextField!
    @IBOutlet weak var AgeRangeSlider: RangeSlider!
    @IBOutlet weak var HeightRangeSlider: RangeSlider!
    @IBOutlet weak var maritalTxtFeild: UITextField!
    @IBOutlet weak var haveChildTxtFeild: UITextField!
    @IBOutlet weak var wantChildTxtFeild: UITextField!
    @IBOutlet weak var ethnicityTxtFeild: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var buildTxtFeild: UITextField!
    @IBOutlet weak var lookingTxtFeild: UITextField!
    @IBOutlet weak var smokingTxtFeild: UITextField!
    @IBOutlet weak var drinkingTxtFeild: UITextField!
    @IBOutlet weak var backBtn: MyButton!
    @IBOutlet weak var saveBtm: MyButton!
    @IBOutlet weak var doneBtn: MyButton!
    @IBOutlet var SelectMultipleView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SelectTblView: UITableView!
    @IBOutlet weak var MinAgeLbl: UILabel!
    @IBOutlet weak var MaxAgeLbl: UILabel!
    @IBOutlet weak var MinHeightLbl: UILabel!
    @IBOutlet weak var MaxHeightLbl: UILabel!
    @IBOutlet weak var DistanceLbl: UILabel!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var wishLocationTxtField: UITextField!
    @IBOutlet weak var wishLocationTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var wishLocationHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var wishTxtFieldTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var wishTxtFieldHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var wishTxtFieldBottomConstrant: NSLayoutConstraint!
    
    
    var gender_Array = NSMutableArray()
    var orientation_Array = NSMutableArray()
    var marital_Array = NSMutableArray()
    var haveChild_Array = NSMutableArray()
    var wantChild_Array = NSMutableArray()
    var ethnicity_Array = NSMutableArray()
    var build_Array = NSMutableArray()
    var looking_Array = NSMutableArray()
    var smoking_Array = NSMutableArray()
    var drinking_Array = NSMutableArray()
    
    var gender_name_Array = NSMutableArray()
    var orientation_name_Array = NSMutableArray()
    var marital_name_Array = NSMutableArray()
    var haveChild_name_Array = NSMutableArray()
    var wantChild_name_Array = NSMutableArray()
    var ethnicity_name_Array = NSMutableArray()
    var build_name_Array = NSMutableArray()
    var looking_name_Array = NSMutableArray()
    var smoking_name_Array = NSMutableArray()
    var drinking_name_Array = NSMutableArray()
    
    var gender_str = String()
    var orientation_str = String()
    var marital_str = String()
    var haveChild_str = String()
    var wantChild_str = String()
    var ethnicity_str = String()
    var build_str = String()
    var looking_str = String()
    var smoking_str = String()
    var drinking_str = String()
    var cityName = String()
    var dataArray = [Any]()
    var type_select = String()
    var api_type = String()
    var havechildStr = String()
    var AgeSlideminValue = String()
    var AgeSlidemaxValue = String()
    var HeightSlideminValue = String()
    var HeightSlidemaxValue = String()
    var DistanceValue = String()
    
    var use_GPS = String()
    var gps_Address = String()
    var lat = String()
    var long = String()
    var menuBarBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Preference"
        self.navigationItem.titleView = bar_title
        
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        self.genderTxtFeild.delegate = self
        self.orientationTxtFeild.delegate = self
        self.maritalTxtFeild.delegate = self
        self.haveChildTxtFeild.delegate = self
        self.wantChildTxtFeild.delegate = self
        self.ethnicityTxtFeild.delegate = self
        self.buildTxtFeild.delegate = self
        self.lookingTxtFeild.delegate = self
        self.smokingTxtFeild.delegate = self
        self.drinkingTxtFeild.delegate = self
        self.wishLocationTxtField.delegate = self
  
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyChosen1(_:)), name: NSNotification.Name("USERUPDATE"), object: nil)
        self.AgeRangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        
        
        self.HeightRangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        self.SelectMultipleView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.SelectTblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.SelectTblView.rowHeight = UITableView.automaticDimension
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        
        self.getPreferenceData()
        //        self.getOptionsData()
        // Do any additional setup after loading the view.
    }
    //MARK:- Notification Fire
    @objc func currencyChosen1(_ pNotification: Notification?) {
        let defaults = UserDefaults.standard
        var address = String()
        address = defaults.value(forKey: "ADDRESS") as? String ?? ""
        print(address)
        self.wishLocationTxtField.text = address
        self.lat = Config().AppUserDefaults.value(forKey: "LAT") as? String ?? ""
        self.long = Config().AppUserDefaults.value(forKey: "LONG") as? String ?? ""
        print(self.lat)
        print(self.long)
        getAddressFromLatLon(pdblLatitude: self.lat, withLongitude: self.long)
        view.endEditing(true)
    }
    //MARK:- Location Switch Action
    @IBAction func CurrentLocationSwitchAction(_ sender: UISwitch) {
        if sender.isOn == true{
            self.use_GPS = "1"
            self.currentLocationSwitch.setOn(true, animated:true)
            self.wishLocationTopConstrant.constant = 0
            self.wishLocationHeightConstrant.constant = 0
            self.wishTxtFieldTopConstrant.constant = 0
            self.wishTxtFieldHeightConstrant.constant = 0
            self.wishTxtFieldBottomConstrant.constant = 15
        }else{
            self.use_GPS = "0"
            self.currentLocationSwitch.setOn(false, animated:true)
            self.wishLocationTopConstrant.constant = 15
            self.wishLocationHeightConstrant.constant = 21
            self.wishTxtFieldTopConstrant.constant = 8
            self.wishTxtFieldHeightConstrant.constant = 40
            self.wishTxtFieldBottomConstrant.constant = 15
        }
    }
    //MARK:- Slider Action
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        if rangeSlider == AgeRangeSlider {
            Config().AppUserDefaults.set("true", forKey: "AgeChange")
            let MinValue = rangeSlider.lowerValue
            let valueMin = round(MinValue)
            let NewValueMin: String = String(format: "%.f", valueMin)
            self.AgeSlideminValue = NewValueMin
            self.MinAgeLbl.text = self.AgeSlideminValue
            
            
            
            let MaxValue = rangeSlider.upperValue
            let valueMax = round(MaxValue)
            let NewValueMax: String = String(format: "%.f", valueMax)
            self.AgeSlidemaxValue = NewValueMax
            self.MaxAgeLbl.text = self.AgeSlidemaxValue
            Config().AppUserDefaults.set(NewValueMin, forKey: "AGEMINVALUE")
            Config().AppUserDefaults.set(NewValueMax, forKey: "AGEMAXVALUE")
            print("Range slider value changed: (\(self.AgeSlideminValue) , \(self.AgeSlidemaxValue))")
        }else{
            Config().AppUserDefaults.set("true", forKey: "HeightChange")
            let MinValue = rangeSlider.lowerValue
            let valueMin = Int(MinValue)
            
            let division = valueMin/12
            let modulus = valueMin % 12
            let divisionStr = String(division)
            let modulusStr = String(modulus)
            let getVal = divisionStr + "." + modulusStr
//            let NewMinVal = 36
            
//            let foot = NewMinVal/12
//            let inch = NewMinVal%12
            
//            print(foot)
//            print(inch)
            
            let NewValueMin: String = String(format: "%.f", getVal)
            self.HeightSlideminValue = getVal
            self.MinHeightLbl.text = self.HeightSlideminValue
            
            let MaxValue = rangeSlider.upperValue
            let valueMax = Int(MaxValue)
            
            let division1 = valueMax/12
            let modulus1 = valueMax % 12
            let divisionStr1 = String(division1)
            let modulusStr1 = String(modulus1)
            let getVal1 = divisionStr1 + "." + modulusStr1
            
            let NewValueMax: String = String(format: "%.f", getVal1)
            self.HeightSlidemaxValue = getVal1
            self.MaxHeightLbl.text = self.HeightSlidemaxValue
            Config().AppUserDefaults.set(NewValueMin, forKey: "HIGMINVALUE")
            Config().AppUserDefaults.set(NewValueMax, forKey: "HIGMAXVALUE")
            print("Range slider value changed: (\(self.HeightSlideminValue) , \(self.HeightSlidemaxValue))")
        }
    }
    @IBAction func distanceValueChanged(_ sender: UISlider) {
        let Value = sender.value
        let distance = round(Value)
        self.DistanceValue = String(format: "%.f", distance)
        self.DistanceLbl.text = self.DistanceValue + " mi"
    }
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    //MARK:- GetAddressFromLatLong
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country as Any)
                        print(pm.locality as Any)
                        self.cityName = pm.locality!
                        print(self.cityName)
                        print(pm.subLocality as Any)
                        print(pm.thoroughfare as Any)
                        print(pm.postalCode as Any)
                        print(pm.subThoroughfare as Any)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print(addressString)
                  }
            })
        }
    //MARK:- Preference API Calling
    func getPreferenceData(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        let methodName = "preference"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.api_type = "edit"
                if let preference = DataManager.getVal(responseData?["preference"]) as? NSDictionary{
                    self.AgeSlidemaxValue = DataManager.getVal(preference["age_max"]) as? String ?? ""
                    self.AgeSlideminValue = DataManager.getVal(preference["age_min"]) as? String ?? ""
                    self.DistanceValue = DataManager.getVal(preference["distance"]) as? String ?? ""
                    self.HeightSlidemaxValue = DataManager.getVal(preference["height_max"]) as? String ?? ""
                    self.HeightSlideminValue = DataManager.getVal(preference["height_min"]) as? String ?? ""
                    self.build_str = DataManager.getVal(preference["build_str"]) as? String ?? ""
                    self.drinking_str = DataManager.getVal(preference["drinking_str"]) as? String ?? ""
                    self.ethnicity_str = DataManager.getVal(preference["ethnicity_str"]) as? String ?? ""
                    self.gender_str = DataManager.getVal(preference["genders_str"]) as? String ?? ""
                    self.looking_str = DataManager.getVal(preference["looking_str"]) as? String ?? ""
                    self.marital_str = DataManager.getVal(preference["maritals_str"]) as? String ?? ""
                    self.orientation_str = DataManager.getVal(preference["orientation_str"]) as? String ?? ""
                    self.smoking_str = DataManager.getVal(preference["smoking_str"]) as? String ?? ""
                    self.wantChild_str = DataManager.getVal(preference["wantkid_str"]) as? String ?? ""
                    self.haveChild_str = DataManager.getVal(preference["have_kid_str"]) as? String ?? ""
                    self.use_GPS = DataManager.getVal(preference["use_gps"]) as? String ?? ""
                    let address = DataManager.getVal(preference["gps_landmark"]) as? String ?? ""
                    
                    if self.use_GPS == "1"{
                        self.currentLocationSwitch.isOn = true
                        self.wishLocationTopConstrant.constant = 0
                        self.wishLocationHeightConstrant.constant = 0
                        self.wishTxtFieldTopConstrant.constant = 0
                        self.wishTxtFieldHeightConstrant.constant = 0
                        self.wishTxtFieldBottomConstrant.constant = 15
                        self.wishLocationTxtField.text = ""
                    }else if self.use_GPS == "0"{
                        self.currentLocationSwitch.isOn = false
                        self.wishLocationTopConstrant.constant = 15
                        self.wishLocationHeightConstrant.constant = 21
                        self.wishTxtFieldTopConstrant.constant = 8
                        self.wishTxtFieldHeightConstrant.constant = 40
                        self.wishTxtFieldBottomConstrant.constant = 15
                        self.wishLocationTxtField.text = address
                    }
                    self.AgeRangeSlider.maximumValue = 100.0
                    self.AgeRangeSlider.minimumValue = 18.0
                    self.AgeRangeSlider.lowerValue = Double(self.StringToFloat(str: self.AgeSlideminValue))
                    self.AgeRangeSlider.upperValue = Double(self.StringToFloat(str: self.AgeSlidemaxValue))
                    self.MinAgeLbl.text = self.AgeSlideminValue
                    self.MaxAgeLbl.text = self.AgeSlidemaxValue
                    self.HeightRangeSlider.maximumValue = 95.0
                    self.HeightRangeSlider.minimumValue = 36.0
                    if self.HeightSlideminValue == "" {
                        self.HeightSlideminValue = "4.5"
                        self.HeightSlidemaxValue = "5.6"
                    }
                    let parsed = self.HeightSlideminValue.replacingOccurrences(of: ".", with: "")
                    let parsed1 = self.HeightSlidemaxValue.replacingOccurrences(of: ".", with: "")
                    var parseStr = String()
                    var parse1Str = String()
                    var showHeight = String()
                    var showInch = String()
                    var showHeight1 = String()
                    var showInch1 = String()
                    if parsed.count == 3 {
                        showHeight = String(parsed.prefix(1))
                        showInch = String(parsed.suffix(2))
                        let val_hei = Int(showHeight)
                        let val_in = Int(showInch)
                        let LowerVal = Double((val_hei ?? 0)*12) + Double(val_in ?? 0)
                        parseStr = String(LowerVal)
                    }else{
                        showHeight = String(parsed.prefix(1))
                        showInch = String(parsed.suffix(1))
                        let val_hei = Int(showHeight)
                        let val_in = Int(showInch)
                        let LowerVal = Double((val_hei ?? 0)*12) + Double(val_in ?? 0)
                        parseStr = String(LowerVal)
                    }
                    if parsed1.count == 3 {
                        showHeight1 = String(parsed1.prefix(1))
                        showInch1 = String(parsed1.suffix(2))
                        let val_hei1 = Int(showHeight1)
                        let val_in1 = Int(showInch1)
                        let LowerVal1 = Double((val_hei1 ?? 0)*12) + Double(val_in1 ?? 0)
                        parse1Str = String(LowerVal1)
                    }else{
                        showHeight1 = String(parsed1.prefix(1))
                        showInch1 = String(parsed1.suffix(1))
                        let val_hei1 = Int(showHeight1)
                        let val_in1 = Int(showInch1)
                        let LowerVal1 = Double((val_hei1 ?? 0)*12) + Double(val_in1 ?? 0)
                        parse1Str = String(LowerVal1)
                    }
                    self.HeightRangeSlider.lowerValue = Double(self.StringToFloat(str: parseStr))
                    self.HeightRangeSlider.upperValue = Double(self.StringToFloat(str: parse1Str))
                    self.MinHeightLbl.text = showHeight + "." + showInch
                    self.MaxHeightLbl.text = showHeight1 + "." + showInch1
                    self.distanceSlider.value = Float(self.StringToFloat(str: self.DistanceValue))
                    self.DistanceLbl.text = self.DistanceValue
//                    if self.haveChild_str == "1"{
//                        self.haveChildTxtFeild.text = "Yes, they sometimes live with me"
//                    }else if self.haveChild_str == "2"{
//                        self.haveChildTxtFeild.text = "Yes, they live with me"
//                    }else if self.haveChild_str == "3"{
//                        self.haveChildTxtFeild.text = "No"
//                    }
                    self.genderTxtFeild.text = self.gender_str
                    self.orientationTxtFeild.text = self.orientation_str
                    self.maritalTxtFeild.text = self.marital_str
                    //                    self.haveChildTxtFeild.text = self.haveChild_str
                    self.wantChildTxtFeild.text = self.wantChild_str
                    self.ethnicityTxtFeild.text = self.ethnicity_str
                    self.buildTxtFeild.text = self.build_str
                    self.lookingTxtFeild.text = self.looking_str
                    self.smokingTxtFeild.text = self.smoking_str
                    self.drinkingTxtFeild.text = self.drinking_str
                    self.haveChildTxtFeild.text = self.haveChild_str
                    
                    let build_array = DataManager.getVal(preference["build"]) as? [Any] ?? []
                    let drinking_array = DataManager.getVal(preference["drinking"]) as? [Any] ?? []
                    let ethnicity_array = DataManager.getVal(preference["ethnicity"]) as? [Any] ?? []
                    let genders_array = DataManager.getVal(preference["genders"]) as? [Any] ?? []
                    let looking_array = DataManager.getVal(preference["looking"]) as? [Any] ?? []
                    let maritals_array = DataManager.getVal(preference["maritals"]) as? [Any] ?? []
                    let orientation_array = DataManager.getVal(preference["orientation"]) as? [Any] ?? []
                    let smoking_array = DataManager.getVal(preference["smoking"]) as? [Any] ?? []
                    let wantkid_array = DataManager.getVal(preference["wantkid"]) as? [Any] ?? []
                    let haveChild_Array = DataManager.getVal(preference["have_kid"]) as? [Any] ?? []
                    print(haveChild_Array)
                    for ilike_id in 0..<build_array.count{
                        let dict = DataManager.getVal(build_array[ilike_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.build_Array.add(id)
                    }
                    for sports_id in 0..<drinking_array.count{
                        let dict = DataManager.getVal(drinking_array[sports_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.drinking_Array.add(id)
                    }
                    for music_id in 0..<ethnicity_array.count{
                        let dict = DataManager.getVal(ethnicity_array[music_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.ethnicity_Array.add(id)
                    }
                    for spendTime_id in 0..<genders_array.count{
                        let dict = DataManager.getVal(genders_array[spendTime_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.gender_Array.add(id)
                    }
                    for vacation_id in 0..<looking_array.count{
                        let dict = DataManager.getVal(looking_array[vacation_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.looking_Array.add(id)
                    }
                    for looking_id in 0..<maritals_array.count{
                        let dict = DataManager.getVal(maritals_array[looking_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.marital_Array.add(id)
                    }
                    for looking_id in 0..<orientation_array.count{
                        let dict = DataManager.getVal(orientation_array[looking_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.orientation_Array.add(id)
                    }
                    for looking_id in 0..<smoking_array.count{
                        let dict = DataManager.getVal(smoking_array[looking_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.smoking_Array.add(id)
                    }
                    for looking_id in 0..<wantkid_array.count{
                        let dict = DataManager.getVal(wantkid_array[looking_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.wantChild_Array.add(id)
                    }
                    for haveChild_id in 0..<haveChild_Array.count{
                        let dict = DataManager.getVal(haveChild_Array[haveChild_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.haveChild_Array.add(id)
                    }
                }
            }else{
                self.api_type = "add"
                self.AgeRangeSlider.maximumValue = 100.0
                self.AgeRangeSlider.minimumValue = 18.0
                self.AgeRangeSlider.lowerValue = 18.0
                self.AgeRangeSlider.upperValue = 30.0
                self.AgeSlideminValue = "18"
                self.MinAgeLbl.text = self.AgeSlideminValue
                self.AgeSlidemaxValue = "30"
                self.MaxAgeLbl.text = self.AgeSlidemaxValue
                
                self.HeightRangeSlider.maximumValue = 95.0
                self.HeightRangeSlider.minimumValue = 36.0
                self.HeightRangeSlider.lowerValue = 50.0
                self.HeightRangeSlider.upperValue = 70.0
                self.HeightSlideminValue = "4.2"
                self.MinHeightLbl.text = self.HeightSlideminValue
                self.HeightSlidemaxValue = "5.10"
                self.MaxHeightLbl.text = self.HeightSlidemaxValue
                self.distanceSlider.value = 5
                self.DistanceLbl.text = "5"
                self.DistanceValue = self.DistanceLbl.text!
                //                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Options API Calling
    func getOptionsData(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "option/preference"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.type_select == "gender"{
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "gender")) as? [Any] ?? []
                }else if self.type_select == "orientation"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "orientation")) as? [Any] ?? []
                }else if self.type_select == "marital"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "marital")) as? [Any] ?? []
                }else if self.type_select == "haveChild"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "have_kid")) as? [Any] ?? []
                }else if self.type_select == "wantChild"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "wantkid")) as? [Any] ?? []
                }else if self.type_select == "ethnicity"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "ethnicity")) as? [Any] ?? []
                }else if self.type_select == "build"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "build")) as? [Any] ?? []
                }else if self.type_select == "looking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "looking")) as? [Any] ?? []
                }else if self.type_select == "smoking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "smoking")) as? [Any] ?? []
                }else if self.type_select == "drinking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "drinking")) as? [Any] ?? []
                }
                self.SelectTblView.reloadData()
                self.showAnimate(YourHiddenView: self.SelectMultipleView, ishidden: false)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    //MARK:- Text Feild Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.genderTxtFeild{
            self.view.endEditing(true)
            self.type_select = "gender"
            self.TitleLbl.text = "Select Gender"
            self.getOptionsData()
            return false
        }else if textField == self.orientationTxtFeild{
            self.view.endEditing(true)
            self.type_select = "orientation"
            self.TitleLbl.text = "Select Orientation"
            self.getOptionsData()
            return false
        }else if textField == self.wishLocationTxtField{
            self.TitleLbl.text = "Search Your Location"
            self.view.endEditing(true)
            let vc = SelectAddressViewController(nibName: "SelectAddressViewController", bundle: nil)
            self.onlyPushViewController(vc)
            self.wishLocationTxtField.resignFirstResponder()
            return false
        }else if textField == self.maritalTxtFeild{
            self.view.endEditing(true)
            self.type_select = "marital"
            self.TitleLbl.text = "Select Marital"
            self.getOptionsData()
            return false
        }else if textField == self.haveChildTxtFeild{
            self.view.endEditing(true)
            self.type_select = "haveChild"
            self.TitleLbl.text = "Select HaveChild"
            self.getOptionsData()
            return false
        }else if textField == self.wantChildTxtFeild{
            self.view.endEditing(true)
            self.type_select = "wantChild"
            self.TitleLbl.text = "Select WantChild"
            self.getOptionsData()
            return false
        }else if textField == self.ethnicityTxtFeild{
            self.view.endEditing(true)
            self.type_select = "ethnicity"
            self.TitleLbl.text = "Select Ethnicity"
            self.getOptionsData()
            return false
        }else if textField == self.buildTxtFeild{
            self.view.endEditing(true)
            self.type_select = "build"
            self.TitleLbl.text = "Select Build"
            self.getOptionsData()
            return false
        }else if textField == self.lookingTxtFeild{
            self.view.endEditing(true)
            self.type_select = "looking"
            self.TitleLbl.text = "Select Looking"
            self.getOptionsData()
            return false
        }else if textField == self.smokingTxtFeild{
            self.view.endEditing(true)
            self.type_select = "smoking"
            self.TitleLbl.text = "Select Smoking"
            self.getOptionsData()
            return false
        }else if textField == self.drinkingTxtFeild{
            self.view.endEditing(true)
            self.type_select = "drinking"
            self.TitleLbl.text = "Select Gender"
            self.getOptionsData()
            return false
        }else{
            return true
        }
    }
    //MARK:- View Button Actions
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if self.type_select == "gender"{
            let select_name = self.gender_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.genderTxtFeild.text = gender_str
            }else{
                self.genderTxtFeild.text = select_name
            }
        }else if self.type_select == "orientation"{
            let select_name = self.orientation_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.orientationTxtFeild.text = orientation_str
            }else{
                self.orientationTxtFeild.text = select_name
            }
        }else if self.type_select == "marital"{
            let select_name = self.marital_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.maritalTxtFeild.text = self.marital_str
            }else{
                self.maritalTxtFeild.text = select_name
            }
        }else if self.type_select == "haveChild"{
            let select_name = self.haveChild_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.haveChildTxtFeild.text = self.haveChild_str
            }else{
                self.haveChildTxtFeild.text = select_name
            }
        }else if self.type_select == "wantChild" {
            let select_name = self.wantChild_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.wantChildTxtFeild.text = self.wantChild_str
            }else{
                self.wantChildTxtFeild.text = select_name
            }
        }else if self.type_select == "ethnicity" {
            let select_name = self.ethnicity_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.ethnicityTxtFeild.text = self.ethnicity_str
            }else{
                self.ethnicityTxtFeild.text = select_name
            }
        }else if self.type_select == "build" {
            let select_name = self.build_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.buildTxtFeild.text = self.build_str
            }else{
                self.buildTxtFeild.text = select_name
            }
        }else if self.type_select == "looking" {
            let select_name = self.looking_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.lookingTxtFeild.text = self.looking_str
            }else{
                self.lookingTxtFeild.text = select_name
            }
        }else if self.type_select == "smoking" {
            let select_name = self.smoking_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.smokingTxtFeild.text = self.smoking_str
            }else{
                self.smokingTxtFeild.text = select_name
            }
        }else if self.type_select == "drinking" {
            let select_name = self.drinking_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.drinkingTxtFeild.text = self.drinking_str
            }else{
                self.drinkingTxtFeild.text = select_name
            }
        }
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    //MARK:- TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.type_select == "gender"{
            let id = DataManager.getVal(dict["gender_id"]) as? String ?? ""
            if self.gender_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "orientation" {
            let id = DataManager.getVal(dict["orientation_id"]) as? String ?? ""
            if self.orientation_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "marital" {
            let id = DataManager.getVal(dict["marital_id"]) as? String ?? ""
            if self.marital_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "haveChild" {
            print(dict)
            let id = DataManager.getVal(dict["have_kid_id"]) as? String ?? ""
            if self.haveChild_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "wantChild" {
            let id = DataManager.getVal(dict["wantkid_id"]) as? String ?? ""
            if self.wantChild_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "ethnicity" {
            let id = DataManager.getVal(dict["ethnicity_id"]) as? String ?? ""
            if self.ethnicity_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "build" {
            let id = DataManager.getVal(dict["build_id"]) as? String ?? ""
            if self.build_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "looking" {
            let id = DataManager.getVal(dict["looking_id"]) as? String ?? ""
            if self.looking_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "smoking" {
            let id = DataManager.getVal(dict["smoking_id"]) as? String ?? ""
            if self.smoking_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "drinking" {
            let id = DataManager.getVal(dict["drinking_id"]) as? String ?? ""
            if self.drinking_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        let name = DataManager.getVal(dict["name"]) as? String ?? ""
        if self.type_select == "gender"{
            let id = DataManager.getVal(dict["gender_id"]) as? String ?? ""
            if gender_Array.count <= 3 {
                if self.gender_Array.contains(id){
                    self.gender_Array.remove(id)
                    self.SelectTblView.reloadData()
                }else{
                    self.gender_Array.add(id)
                    self.SelectTblView.reloadData()
                }
                if self.gender_name_Array.contains(name){
                    self.gender_name_Array.remove(name)
                    self.SelectTblView.reloadData()
                }else{
                    self.gender_name_Array.add(name)
                    self.SelectTblView.reloadData()
                }
            }else{
            }
            
        }else if self.type_select == "orientation" {
            let id = DataManager.getVal(dict["orientation_id"]) as? String ?? ""
            if orientation_Array.count <= 3 {
                if self.orientation_Array.contains(id){
                    self.orientation_Array.remove(id)
                    self.SelectTblView.reloadData()
                }else{
                    self.orientation_Array.add(id)
                    self.SelectTblView.reloadData()
                }
                if self.orientation_name_Array.contains(name){
                    self.orientation_name_Array.remove(name)
                    self.SelectTblView.reloadData()
                }else{
                    self.orientation_name_Array.add(name)
                    self.SelectTblView.reloadData()
                }
            }else{
                
            }
            
        }else if self.type_select == "marital" {
            let id = DataManager.getVal(dict["marital_id"]) as? String ?? ""
            if self.marital_Array.contains(id){
                self.marital_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.marital_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.marital_name_Array.contains(name){
                self.marital_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.marital_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "haveChild" {
            let id = DataManager.getVal(dict["have_kid_id"]) as? String ?? ""
                        if self.haveChild_Array.contains(id){
            self.haveChild_Array.removeAllObjects()
                            self.SelectTblView.reloadData()
                        }else{
            self.haveChild_Array.add(id)
            self.SelectTblView.reloadData()
                        }
                        if self.haveChild_name_Array.contains(name){
            self.haveChild_name_Array.removeAllObjects()
            self.SelectTblView.reloadData()
                        }else{
            self.haveChild_name_Array.add(name)
            self.SelectTblView.reloadData()
                        }
        }else if self.type_select == "wantChild" {
            let id = DataManager.getVal(dict["wantkid_id"]) as? String ?? ""
                        if self.wantChild_Array.contains(id){
            self.wantChild_Array.removeAllObjects()
                            self.SelectTblView.reloadData()
                        }else{
            self.wantChild_Array.add(id)
            self.SelectTblView.reloadData()
                        }
                        if self.wantChild_name_Array.contains(name){
            self.wantChild_name_Array.removeAllObjects()
                            self.SelectTblView.reloadData()
                        }else{
            self.wantChild_name_Array.add(name)
            self.SelectTblView.reloadData()
                        }
        }else if self.type_select == "ethnicity" {
            let id = DataManager.getVal(dict["ethnicity_id"]) as? String ?? ""
            if self.ethnicity_Array.contains(id){
                self.ethnicity_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.ethnicity_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.ethnicity_name_Array.contains(name){
                self.ethnicity_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.ethnicity_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "build" {
            let id = DataManager.getVal(dict["build_id"]) as? String ?? ""
            if self.build_Array.contains(id){
                self.build_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.build_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.build_name_Array.contains(name){
                self.build_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.build_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "looking" {
            let id = DataManager.getVal(dict["looking_id"]) as? String ?? ""
            if self.looking_Array.contains(id){
                self.looking_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.looking_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.looking_name_Array.contains(name){
                self.looking_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.looking_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "smoking" {
            let id = DataManager.getVal(dict["smoking_id"]) as? String ?? ""
            if self.smoking_Array.contains(id){
                self.smoking_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.smoking_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.smoking_name_Array.contains(name){
                self.smoking_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.smoking_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "drinking" {
            let id = DataManager.getVal(dict["drinking_id"]) as? String ?? ""
            if self.drinking_Array.contains(id){
                self.drinking_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.drinking_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.drinking_name_Array.contains(name){
                self.drinking_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.drinking_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }
        
    }
    //MARK:- Save Button Action
    @IBAction func saveBtnAction(_ sender: MyButton) {
        if self.api_type == "add"{
            self.pleaseWait()
            
            let gender = self.gender_Array.componentsJoined(by: ",")
            let orientation = self.orientation_Array.componentsJoined(by: ",")
            let marital = self.marital_Array.componentsJoined(by: ",")
            //            let haveChild = self.haveChild_Array.componentsJoined(by: ",")
            let wantChild = self.wantChild_Array.componentsJoined(by: ",")
            let ethnicity = self.ethnicity_Array.componentsJoined(by: ",")
            let build = self.build_Array.componentsJoined(by: ",")
            let looking = self.looking_Array.componentsJoined(by: ",")
            let smoking = self.smoking_Array.componentsJoined(by: ",")
            let drinking = self.drinking_Array.componentsJoined(by: ",")
            let haveChild = self.haveChild_Array.componentsJoined(by: ",")
            print(haveChild)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.AgeSlideminValue), forKey: "age_min")
            dict.setValue(DataManager.getVal(self.AgeSlidemaxValue), forKey: "age_max")
            dict.setValue(DataManager.getVal(self.HeightSlideminValue), forKey: "height_min")
            dict.setValue(DataManager.getVal(self.HeightSlidemaxValue), forKey: "height_max")
            dict.setValue(DataManager.getVal(haveChild), forKey: "have_kid")
            dict.setValue(DataManager.getVal(self.DistanceValue), forKey: "distance")
            dict.setValue(DataManager.getVal(gender), forKey: "genders")
            dict.setValue(DataManager.getVal(marital), forKey: "maritals")
            dict.setValue(DataManager.getVal(orientation), forKey: "orientation")
            dict.setValue(DataManager.getVal(wantChild), forKey: "wantkid")
            dict.setValue(DataManager.getVal(build), forKey: "build")
            dict.setValue(DataManager.getVal(ethnicity), forKey: "ethnicity")
            dict.setValue(DataManager.getVal(looking), forKey: "looking")
            dict.setValue(DataManager.getVal(smoking), forKey: "smoking")
            dict.setValue(DataManager.getVal(drinking), forKey: "drinking")
            dict.setValue(DataManager.getVal(self.cityName), forKey: "city")
            if self.use_GPS == "0"{
//                dict.setValue(DataManager.getVal(self.use_GPS), forKey: "use_gps")
//                dict.setValue(DataManager.getVal(self.cityName), forKey: "gps_landmark")
//                dict.setValue(DataManager.getVal(self.lat), forKey: "lat")
//                dict.setValue(DataManager.getVal(self.long), forKey: "long")
            }else{
                dict.setValue(DataManager.getVal(self.use_GPS), forKey: "use_gps")
                dict.setValue(DataManager.getVal(self.cityName), forKey: "gps_landmark")
                dict.setValue(DataManager.getVal(self.lat), forKey: "lat")
                dict.setValue(DataManager.getVal(self.long), forKey: "long")
                dict.setValue(DataManager.getVal(self.use_GPS), forKey: "use_gps")
                print(self.use_GPS)
            }
            print(dict)
            let methodName = "preference/add"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }else if self.api_type == "edit"{
            self.pleaseWait()
            
            let gender = self.gender_Array.componentsJoined(by: ",")
            let orientation = self.orientation_Array.componentsJoined(by: ",")
            let marital = self.marital_Array.componentsJoined(by: ",")
            //            let haveChild = self.haveChild_Array.componentsJoined(by: ",")
            let wantChild = self.wantChild_Array.componentsJoined(by: ",")
            let ethnicity = self.ethnicity_Array.componentsJoined(by: ",")
            let build = self.build_Array.componentsJoined(by: ",")
            let looking = self.looking_Array.componentsJoined(by: ",")
            let smoking = self.smoking_Array.componentsJoined(by: ",")
            let drinking = self.drinking_Array.componentsJoined(by: ",")
            let havechild = self.haveChild_Array.componentsJoined(by: ",")
            print(havechild)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.AgeSlideminValue), forKey: "age_min")
            dict.setValue(DataManager.getVal(self.AgeSlidemaxValue), forKey: "age_max")
            dict.setValue(DataManager.getVal(self.HeightSlideminValue), forKey: "height_min")
            dict.setValue(DataManager.getVal(self.HeightSlidemaxValue), forKey: "height_max")
            dict.setValue(DataManager.getVal(havechild), forKey: "have_kid")
            dict.setValue(DataManager.getVal(self.DistanceValue), forKey: "distance")
            dict.setValue(DataManager.getVal(gender), forKey: "genders")
            dict.setValue(DataManager.getVal(marital), forKey: "maritals")
            dict.setValue(DataManager.getVal(orientation), forKey: "orientation")
            dict.setValue(DataManager.getVal(wantChild), forKey: "wantkid")
            dict.setValue(DataManager.getVal(build), forKey: "build")
            dict.setValue(DataManager.getVal(ethnicity), forKey: "ethnicity")
            dict.setValue(DataManager.getVal(looking), forKey: "looking")
            dict.setValue(DataManager.getVal(smoking), forKey: "smoking")
            dict.setValue(DataManager.getVal(drinking), forKey: "drinking")
            dict.setValue(DataManager.getVal(self.cityName), forKey: "city")
            print(dict)
            print(self.haveChild_str)
            if self.use_GPS == "0"{
                dict.setValue(DataManager.getVal(self.use_GPS), forKey: "use_gps")
                dict.setValue(DataManager.getVal(self.cityName), forKey: "gps_landmark")
                dict.setValue(DataManager.getVal(self.lat), forKey: "lat")
                dict.setValue(DataManager.getVal(self.long), forKey: "long")
            }else{
                dict.setValue(DataManager.getVal(self.use_GPS), forKey: "use_gps")
            }
            let methodName = "preference/edit"
            print(dict)
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                    self.view.makeToast(message: message)
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }else{
            
        }
    }
    //MARK:- Back Button Action
    @IBAction func backBtnAction(_ sender: MyButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Animations
    func removeAnimate(YourHiddenView: UIView,ishidden: Bool){
        UIView.animate(withDuration: 0.25, animations: {
            YourHiddenView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            YourHiddenView.alpha = 0.0
            
        }, completion: {(finished : Bool) in
            if(finished)
            {
                YourHiddenView.isHidden = ishidden
                self.willMove(toParent: nil)
                YourHiddenView.removeFromSuperview()
                //self.removeFromParent()
            }
        })
    }
    func showAnimate(YourHiddenView: UIView,ishidden: Bool){
        self.view.window?.addSubview(YourHiddenView)
        YourHiddenView.isHidden = ishidden
        YourHiddenView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        YourHiddenView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            YourHiddenView.alpha = 1.0
            YourHiddenView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
