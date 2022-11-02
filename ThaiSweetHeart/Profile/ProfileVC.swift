//
//  ProfileVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//
// d
//change

import UIKit
import MobileCoreServices
import YangMingShan
import AVKit
import SDWebImage
import AVFoundation
import AVKit
import AutoCompletion
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

@available(iOS 13.0, *)
class ProfileVC: BaseViewSideMenuController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YMSPhotoPickerViewControllerDelegate,MyDataSendingDelegate,SlideMenuControllerDelegate,UITableViewDataSource,UITableViewDelegate{

    
    
    //MARK:- IBoutlates
    @IBOutlet weak var ProfileImgView: MyImageView!
    @IBOutlet weak var FullNameLbl: UILabel!
    @IBOutlet weak var FullNameTxtField: UITextField!
    @IBOutlet weak var DOBLbl: UILabel!
    @IBOutlet weak var DOBtxtField: UITextField!
    @IBOutlet weak var GenderLbl: UILabel!
    @IBOutlet weak var OrientationLbl: UILabel!
    
    @IBOutlet weak var CountryTxtField: MyTextField!
    @IBOutlet weak var StateTxtField: MyTextField!
    @IBOutlet weak var CityTxtField: MyTextField!
    
    
//    @IBOutlet weak var CollegeButton: UIButton!
    @IBOutlet weak var EducationSearchTxtField: MyTextField!
    
    @IBOutlet weak var GenderTxtFeild: MyTextField!
    @IBOutlet weak var OrientationTxtFeild: MyTextField!
    @IBOutlet weak var EthnicityTxtField: MyTextField!
    @IBOutlet weak var ReligionTxtField: MyTextField!
    
    @IBOutlet weak var YesButton: UIButton!
    @IBOutlet weak var YesLiveButton: UIButton!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var showGenderYesBtn: UIButton!
    @IBOutlet weak var showGenderNOBtn: UIButton!
    
    @IBOutlet weak var MatrialStatusTxtField: MyTextField!
    
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    @IBOutlet weak var minHeightTxt: MyTextField!
    @IBOutlet weak var maxHeightTxt: MyTextField!
    //    @IBOutlet weak var HeightLbl: UILabel!
    //    @IBOutlet weak var HeightSlider: UISlider!
    
    @IBOutlet weak var rolepostTxt: MyTextField!
    
    @IBOutlet weak var BuildTxtField: MyTextField!
    @IBOutlet weak var AboutTxtView: UITextView!
    
    @IBOutlet weak var HabitButton: MyButton!
    @IBOutlet weak var HabitButtonTopConstraint: NSLayoutConstraint!//30
    @IBOutlet weak var HabitheightConstraint: NSLayoutConstraint!//50
    
    @IBOutlet weak var userRoundView: UIView!
    @IBOutlet weak var personalInfoLbl: UILabel!
    @IBOutlet weak var uploadVideoLbl: UILabel!
    @IBOutlet weak var uploadPictureLbl: UILabel!
    @IBOutlet weak var chooseFileLbl: UILabel!
    @IBOutlet weak var choseFileBtn: MyButton!
    @IBOutlet weak var chooseFileLbl2: UILabel!
    @IBOutlet weak var choseFileBtn2: MyButton!
    @IBOutlet weak var ethnicityLbl: UILabel!
    @IBOutlet weak var religionLbl: UILabel!
    @IBOutlet weak var educationDetailsLbl: UILabel!
    @IBOutlet weak var workDetailsLbl: UILabel!
    @IBOutlet weak var physicalAppearanceLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var setBuildLbl: UILabel!
    @IBOutlet weak var maritalStatusLbl: UILabel!
    @IBOutlet weak var haveChildrenLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var ProfileBackBtn: MyButton!
    @IBOutlet weak var nextBtn: MyButton!
    
    @IBOutlet weak var doneBtn: MyButton!
    @IBOutlet var SelectMultipleView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SelectTblView: UITableView!
    var orientation_Array = NSMutableArray()
    var orientation_name_Array = NSMutableArray()
    var orientation_str = String()
    //MARK:- Objects
    var have_children = "1"
    var marital_status = [String]()
    var gender_name_Array = NSMutableArray()
    var type_select = String()
    // var videoArray = NSMutableArray()
    var singleImageArr = NSMutableArray()
    
    var UploadimageArray = NSMutableArray()
    var UploadvideoArray = NSMutableArray()
    
    let imagePickerController = UIImagePickerController()
    
    var videoURL: NSURL?
    var imageAndVideoFlag = Bool()
    let formatter = DateFormatter()
    
    var gender_Array = NSMutableArray()
    var dataArray = [Any]()
    var gender_str = String()
    var country_id = String()
    var state_id = String()
    var city_id = String()
    var gender_id = String()
    var orientation_id = String()
    var ethnicity_id = String()
    var educationDetails = String()
    var religion_id = String()
    var degree_id = String()
    var marital_id = String()
    var build_id = String()
    var gender = String()
    var height_value = String()
    var flag_comingfromLogin = Bool()
    var minpickerview: UIPickerView = UIPickerView()
    var maxpickerview:UIPickerView = UIPickerView()
    var maritalName = String()
    var bar_title = UILabel()
    var count = Int()
    var menuBarBtn = UIBarButtonItem()
    
    var minHeightArray = ["3","4","5","6","7"]
    var maxHeightArray = ["0","1","2","3","4","5","6","7","8","9","10","11"]
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userRoundView.layer.cornerRadius = 60
        imagePickerController.videoExportPreset = AVAssetExportPresetPassthrough
        self.bar_title = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        self.SelectMultipleView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.SelectTblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.SelectTblView.rowHeight = UITableView.automaticDimension
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        if self.flag_comingfromLogin == true{
            let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
            self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: nil)
            self.navigationItem.leftBarButtonItem = self.menuBarBtn
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }
        self.marital_status = ["Single","Married","Divorced","Separated","Widowed","Open Relationship","Any"]
        
        self.formatter.dateFormat = "yyyy-MM-dd"

        let VideoLayOut = UICollectionViewFlowLayout()
        VideoLayOut.itemSize = CGSize(width: 70, height: 70)
        VideoLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        VideoLayOut.minimumInteritemSpacing = 0
        VideoLayOut.minimumLineSpacing = 0
        VideoLayOut.scrollDirection = .horizontal
        
        let Videonib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        self.VideoCollectionView.register(Videonib, forCellWithReuseIdentifier: "ImageCollectionCell")
        self.VideoCollectionView.layer.cornerRadius = 6
        self.VideoCollectionView.clipsToBounds = true
        self.VideoCollectionView.collectionViewLayout = VideoLayOut
        
        let ImageLayOut = UICollectionViewFlowLayout()
        ImageLayOut.itemSize = CGSize(width: 70, height: 70)
        ImageLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ImageLayOut.minimumInteritemSpacing = 0
        ImageLayOut.minimumLineSpacing = 0
        ImageLayOut.scrollDirection = .horizontal
        
        let Imagenib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        self.ImageCollectionView.register(Imagenib, forCellWithReuseIdentifier: "ImageCollectionCell")
        self.ImageCollectionView.layer.cornerRadius = 6
        self.ImageCollectionView.clipsToBounds = true
        self.ImageCollectionView.collectionViewLayout = ImageLayOut
        
        self.gender = "1"
        
        if gender == "1"{
            self.showGenderYesBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.showGenderNOBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else{
            self.showGenderYesBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.showGenderNOBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        }
        
        self.getProfileDataAPI()
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.personalInfoLbl.text = language == "en" ? kpersonalInfoLbl : kThpersonalInfoLbl
        self.uploadVideoLbl.text = language == "en" ? kuploadVideoLbl : kThuploadVideoLbl
        self.uploadPictureLbl.text = language == "en" ? kuploadPictureLbl : kThuploadPictureLbl
        self.choseFileBtn.setTitle(language == "en" ? kchoseFileBtn : kThchoseFileBtn, for: .normal)
        self.choseFileBtn2.setTitle(language == "en" ? kchoseFileBtn : kThchoseFileBtn, for: .normal)
        self.chooseFileLbl.text = language == "en" ? kchoseFileBtn : kchoseFileBtn
        self.chooseFileLbl2.text = language == "en" ? kchoseFileBtn : kchoseFileBtn
        self.FullNameLbl.text = language == "en" ? kfullNameLbl : kThfullNameLbl
        self.FullNameTxtField.placeholder = language == "en" ? kFullNameTxtField : kThFullNameTxtField
        self.DOBLbl.text = language == "en" ? kdobLbl : kThdobLbl
        self.DOBtxtField.placeholder = language == "en" ? kDOBTxtField : kThDOBTxtField
        self.GenderLbl.text = language == "en" ? kSignUpgenderLbl : kThgenderLbl
        self.OrientationLbl.text = language == "en" ? kOrientationplaceHoler : kThgenderLbl
//        self.MaleButton.setTitle(language == "en" ? kMaleButton : kThMaleButton, for: .normal)
//        self.FeMaleButton.setTitle(language == "en" ? kFeMaleButton : kThFeMaleButton, for: .normal)
//        self.TranssexualButton.setTitle(language == "en" ? kTranssexualButton : kThTranssexualButton, for: .normal)
        self.ethnicityLbl.text = language == "en" ? kethnicityLbl : kThethnicityLbl
        self.EthnicityTxtField.placeholder = language == "en" ? kEthnicityTxtField : kThEthnicityTxtField
        self.GenderTxtFeild.placeholder = language == "en" ? kSignUpgenderLbl : kThgenderLbl
        self.OrientationTxtFeild.placeholder = language == "en" ? kOrientationplaceHoler : kThgenderLbl
        self.religionLbl.text = language == "en" ? kreligionLbl : kThreligionLbl
        self.ReligionTxtField.placeholder = language == "en" ? kReligionTxtField : kThReligionTxtField
        self.educationDetailsLbl.text = language == "en" ? keducationDetailsLbl : kTheducationDetailsLbl
        self.EducationSearchTxtField.placeholder = language == "en" ? kEducationSearchTxtField : kThEducationSearchTxtField
        self.workDetailsLbl.text = language == "en" ? kworkDetailsLbl : kThworkDetailsLbl
        self.rolepostTxt.placeholder = language == "en" ? krolepostTxt : kThrolepostTxt
        self.physicalAppearanceLbl.text = language == "en" ? kphysicalAppearanceLbl : kThphysicalAppearanceLbl
        self.heightLbl.text = language == "en" ? kheightLbl : kThheightLbl
        self.minHeightTxt.placeholder = language == "en" ? kFeet : kThFeet
        self.maxHeightTxt.placeholder = language == "en" ? kInches : kThMax
        self.setBuildLbl.text = language == "en" ? ksetBuildLbl : kThsetBuildLbl
        self.BuildTxtField.placeholder = language == "en" ? kBuildTxtField : kThBuildTxtField
        self.maritalStatusLbl.text = language == "en" ? kmaritalStatusLbl : kThmaritalStatusLbl
        self.MatrialStatusTxtField.placeholder = language == "en" ? kMatrialStatusTxtField : kThMatrialStatusTxtField
        self.haveChildrenLbl.text = language == "en" ? khaveChildrenLbl : kThhaveChildrenLbl
        self.YesButton.setTitle(language == "en" ? kYesButton : kThYesButton, for: .normal)
        self.YesLiveButton.setTitle(language == "en" ? kYesLiveButton : kThYesLiveButton, for: .normal)
        self.NoButton.setTitle(language == "en" ? kNoButton : kThNoButton, for: .normal)
        self.locationLbl.text = language == "en" ? klocationLbl : kThlocationLbl
//        self.CountryTxtField.placeholder = language == "en" ?  kCountryTxtField : kThCountryTxtField
//        self.StateTxtField.placeholder = language == "en" ?  kStateTxtField : kThStateTxtField
//        self.CityTxtField.placeholder = language == "en" ? kCityTxtField : kThCityTxtField
        self.aboutLbl.text = language == "en" ?  kaboutLbl : kThaboutLbl
//        self.ProfileBackBtn.setTitle(language == "en" ? kbackBtn : kThbackBtn, for: .normal)
        self.nextBtn.setTitle(language == "en" ? knextBtn : kThnextBtn, for: .normal)
    }
    //MARK:- Gender Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.type_select == "gender"{
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            print(id)
            if self.gender_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }
        else if self.type_select == "orientation" {
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            if self.orientation_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "Marital status"{
            let id = DataManager.getVal(dict["marital_id"]) as? String ?? ""
            if marital_id == id {
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
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
            print(id)
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
                if gender_Array.count <= 4 {
                    self.gender_Array.remove(id)
                    self.SelectTblView.reloadData()
                    self.gender_name_Array.remove(name)
                    self.SelectTblView.reloadData()
                }else{
                }
                if gender_Array.count == 3 {
                }else{
                    self.SelectMultipleView.makeToast(message: "Maximum selection is four.")
                }
            }
        }
        if self.type_select == "orientation"{
            let id = DataManager.getVal(dict["id"]) as? String ?? ""
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
                if orientation_Array.count <= 4 {
                    self.orientation_Array.remove(id)
                    self.SelectTblView.reloadData()
                    self.orientation_name_Array.remove(name)
                    self.SelectTblView.reloadData()
                }else{
                }
                if orientation_Array.count == 3 {
                }else{
                    self.SelectMultipleView.makeToast(message: "Maximum selection is four.")
                }
            }
        }
        if self.type_select == "Marital status" {
            let id = DataManager.getVal(dict["marital_id"]) as? String ?? ""
            let name = DataManager.getVal(dict["name"]) as? String ?? ""
            marital_id = id
            maritalName = name
            self.SelectTblView.reloadData()
        }
        
    }
    
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if self.type_select == "gender"{
            let select_name = self.gender_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.GenderTxtFeild.text = gender_str
            }else{
                self.GenderTxtFeild.text = select_name
            }
        }
        else if self.type_select == "orientation"{
            let select_name = self.orientation_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.OrientationTxtFeild.text = orientation_str
            }else{
                self.OrientationTxtFeild.text = select_name
            }
        }
        else if self.type_select == "Marital status"{
            MatrialStatusTxtField.text = maritalName
        }
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    //MARK:- Profile Data API
    func getProfileDataAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "profile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                DispatchQueue.main.async( execute: { [self] in
                    self.UploadimageArray = DataManager.getVal(responseData?["picture"]) as? NSMutableArray ?? []
                    self.ImageCollectionView.isHidden = false
                    self.ImageCollectionView.reloadData()
                    self.UploadvideoArray = DataManager.getVal(responseData?["video"]) as? NSMutableArray ?? []
                    self.VideoCollectionView.isHidden = false
                    self.VideoCollectionView.reloadData()
                    
                    if let country = DataManager.getVal(responseData?["country"]) as? NSDictionary{
                        self.CountryTxtField.text = DataManager.getVal(country["name"]) as? String ?? ""
                        self.country_id = DataManager.getVal(country["country_id"]) as? String ?? ""
                    }
                    if let state = DataManager.getVal(responseData?["state"]) as? NSDictionary{
                        self.StateTxtField.text = DataManager.getVal(state["name"]) as? String ?? ""
                        self.state_id = DataManager.getVal(state["state_id"]) as? String ?? ""
                    }
                    if let city = DataManager.getVal(responseData?["city"]) as? NSDictionary{
                        self.CityTxtField.text = DataManager.getVal(city["name"]) as? String ?? ""
                        self.city_id = DataManager.getVal(city["city_id"]) as? String ?? ""
                    }
                    if let Degree = DataManager.getVal(responseData?["degree"]) as? NSDictionary{
                        self.EducationSearchTxtField.text = DataManager.getVal(Degree["name"]) as? String ?? ""
                        self.degree_id = DataManager.getVal(Degree["degree_id"]) as? String ?? ""
                            print("\(degree_id)")
                        print(EducationSearchTxtField.text)
                    }
                    self.GenderTxtFeild.text = DataManager.getVal(responseData?["gender_str"]) as? String ?? ""
                    print(GenderTxtFeild.text!)
                    
                    if let Gender = DataManager.getVal(responseData?["gender"]) as? [Any]{
                        for i in 0..<Gender.count {
                            let dict = Gender[i] as! [String:Any]
                            let id = DataManager.getVal(dict["gender_id"]) as? String
                            let name = DataManager.getVal(dict["name"]) as? String
                            self.gender_Array.add(id ?? "")
                            self.gender_name_Array.add(name ?? "")
                            print(id as Any)
                            print(gender_Array)
                            print(gender_name_Array)
                        }
                    }
                    
                    self.OrientationTxtFeild.text = DataManager.getVal(responseData?["orientation_str"]) as? String ?? ""
                    if let Orientation = DataManager.getVal(responseData?["orientation"]) as? [Any]{
                        for i in 0..<Orientation.count {
                            let dict = Orientation[i] as! [String: Any]
                            let id = DataManager.getVal(dict["orientation_id"]) as? String
                            let name = DataManager.getVal(dict["name"]) as? String
                            self.orientation_Array.add(id ?? "")
                            self.orientation_name_Array.add(name ?? "")
                            print(id as Any)
                            print(orientation_Array)
                        }
                    }

                    if let Ethnicity = DataManager.getVal(responseData?["ethnicity"]) as? NSDictionary{
                        self.EthnicityTxtField.text = DataManager.getVal(Ethnicity["name"]) as? String ?? ""
                        self.ethnicity_id = DataManager.getVal(Ethnicity["ethnicity_id"]) as? String ?? ""
                    }
                    if let Religion = DataManager.getVal(responseData?["religion"]) as? NSDictionary{
                        self.ReligionTxtField.text = DataManager.getVal(Religion["name"]) as? String ?? ""
                        self.religion_id = DataManager.getVal(Religion["religion_id"]) as? String ?? ""
                    }
                    if let build = DataManager.getVal(responseData?["build"]) as? NSDictionary{
                        self.BuildTxtField.text = DataManager.getVal(build["name"]) as? String ?? ""
                        self.build_id = DataManager.getVal(build["build_id"]) as? String ?? ""
                    }
                    
                    if let profile = DataManager.getVal(responseData?["profile"]) as? NSDictionary{
                        let titleName = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        bar_title.text = titleName
                        self.FullNameTxtField.text = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        
                        self.DOBtxtField.text = DataManager.getVal(profile["dob"]) as? String ?? ""
                        self.AboutTxtView.text = DataManager.getVal(profile["about"]) as? String ?? ""
                        let mygender = DataManager.getVal(profile["gender"]) as? String ?? ""
                        if mygender == ""{
                            self.gender = "1"
                        }else{
                            self.gender = mygender
                        }
                        self.height_value = DataManager.getVal(profile["height"]) as? String ?? ""
                        //self.PhysicalAppearanceTxtField.text = DataManager.getVal(profile["role"]) as? String ?? ""
                        self.have_children = DataManager.getVal(profile["have_children"]) as? String ?? ""
                        
                        if let profile = DataManager.getVal(responseData?["marital"]) as? NSDictionary{
                            self.MatrialStatusTxtField.text = DataManager.getVal(profile["name"]) as? String ?? ""
                            self.marital_id = DataManager.getVal(profile["marital_id"]) as? String ?? ""
                        }
                        if self.flag_comingfromLogin == true{
                            self.minHeightTxt.text = ""
                            self.maxHeightTxt.text = ""
                        }else{
                            self.minHeightTxt.text = DataManager.getVal(profile["height_feet"]) as? String ?? ""
                            self.maxHeightTxt.text = DataManager.getVal(profile["height_inch"]) as? String ?? ""
                        }
                        
                        self.rolepostTxt.text  = DataManager.getVal(profile["role"]) as? String ?? ""
                        if self.have_children == "1"{
                            self.YesButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
                            self.YesLiveButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.NoButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.have_children = "1"
                        }else if self.have_children == "2"{
                            self.YesButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.YesLiveButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
                            self.NoButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.have_children = "2"
                        }else if self.have_children == "3"{
                            self.YesButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.YesLiveButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.NoButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        }else{
                            self.YesButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.YesLiveButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                            self.NoButton.setImage(UIImage(named: "roundBlack"), for: .normal)
                        }
                        Config().setimage(name: DataManager.getVal(profile["image"]) as? String ?? "", image: self.ProfileImgView)
                    }
                })
             }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Profile Image Button Action
    @IBAction func ProfileImageButtonAction(_ sender: MyButton) {
        if (self.UploadimageArray.count < 8)  {
            self.imageAndVideoFlag = true
            let Picker = UIImagePickerController()
            Picker.delegate = self
            
            let actionSheet = UIAlertController(title: nil, message: "Choose your source", preferredStyle: UIAlertController.Style.actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
                
                Picker.sourceType = .camera
                self.present(Picker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
                
                Picker.sourceType = .photoLibrary
                self.present(Picker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            self.view.makeToast(message: "Upload maximum 8 photos only")
        }
    }
    //MARK:- Choose Video Button Action
    @IBAction func ChooseVideoButtonAction(_ sender: MyButton) {
        if (self.UploadvideoArray.count < 2){
            self.imageAndVideoFlag = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.imagePickerController.mediaTypes = ["public.movie"]
            
            self.present(self.imagePickerController, animated: true, completion: nil)
        }else{
            self.view.makeToast(message: "Upload maximum 2 videos only")
        }
        
    }
    //MARK:- Choose Image Button Action
    @IBAction func ChooseImageButtonAction(_ sender: MyButton) {
        let picker = YMSPhotoPickerViewController.init()
        if UploadimageArray.count == 0 {
            picker.numberOfPhotoToSelect = 8
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 1 {
            picker.numberOfPhotoToSelect = 7
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 2 {
            picker.numberOfPhotoToSelect = 6
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 3 {
            picker.numberOfPhotoToSelect = 5
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 4 {
            picker.numberOfPhotoToSelect = 4
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 5 {
            picker.numberOfPhotoToSelect = 3
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 6 {
            picker.numberOfPhotoToSelect = 2
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else if UploadimageArray.count == 7 {
            picker.numberOfPhotoToSelect = 1
            picker.theme.titleLabelTextColor = Config().AppNavTextColor
            picker.theme.tintColor = Config().AppNavTextColor
            picker.theme.orderLabelTextColor = Config().AppNavTextColor
            picker.theme.cameraIconColor = UIColor.white
            picker.theme.statusBarStyle = .default
            self.yms_presentCustomAlbumPhotoView(picker, delegate: self)
        }else{
            self.view.makeToast(message: "your upload limit is exceed please remove at least one image to uplaod.")
        }
        
    }
    //MARK:- Choose Have Children Button Action
    @IBAction func YesButtonAction(_ sender: UIButton) {
        self.have_children = "1"
        self.YesButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.YesLiveButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    
    @IBAction func YesliveButtonAction(_ sender: UIButton) {
        self.have_children = "2"
        self.YesButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.YesLiveButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.NoButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    
    @IBAction func NoButtonAction(_ sender: UIButton) {
        self.have_children = "3"
        self.YesButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.YesLiveButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- Show Gender Button Action
    @IBAction func ShowGenderYesButtonAction(_ sender: UIButton) {
        self.gender = "1"
        self.showGenderYesBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.showGenderNOBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func ShowGenderNoButtonAction(_ sender: UIButton) {
        self.gender = "0"
        self.showGenderYesBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.showGenderNOBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- Back Button Action
    @IBAction func backBtbAction(_ sender: Any) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Habites Button Action
    @IBAction func HabitsButtonAction(_ sender: MyButton) {
        let vc = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
        self.onlyPushViewController(vc)
    }
    //MARK:- Next Button Action
    @IBAction func NextButtonAction(_ sender: MyButton) {
        if ValidationClass().Profile_update_Form(self){
            self.pleaseWait()
            nextBtn.isUserInteractionEnabled = false
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.FullNameTxtField.text!), forKey: "fullname")
            let defaults = UserDefaults.standard
            defaults.setValue(self.FullNameTxtField.text, forKey: "NAME")
            defaults.synchronize()
            dict.setValue(DataManager.getVal(self.DOBtxtField.text!), forKey: "dob")
            dict.setValue(DataManager.getVal(lat), forKey: "lat")
            dict.setValue(DataManager.getVal(Long), forKey: "long")
            dict.setValue(DataManager.getVal(self.maxHeightTxt.text), forKey: "height_inch")
            dict.setValue(DataManager.getVal(self.minHeightTxt.text), forKey: "height_feet")
            dict.setValue(DataManager.getVal(self.build_id), forKey: "build_id")
            dict.setValue(DataManager.getVal(self.AboutTxtView.text!), forKey: "about")
            dict.setValue(DataManager.getVal(self.rolepostTxt.text!), forKey: "role")
            dict.setValue(DataManager.getVal(self.degree_id), forKey: "degree_id")
            dict.setValue(DataManager.getVal(self.EducationSearchTxtField.text), forKey: "name")
            dict.setValue(DataManager.getVal(self.have_children), forKey: "have_children")
            dict.setValue(DataManager.getVal(self.gender), forKey: "hide_gender")
            dict.setValue(DataManager.getVal(self.ethnicity_id), forKey: "ethnicity_id")
            let gender_id  = gender_Array.componentsJoined(by: ",")
            dict.setValue(DataManager.getVal(gender_id), forKey: "gender_id")
            dict.setValue(DataManager.getVal(self.GenderTxtFeild.text!), forKey: "gender")
            let orientationID = orientation_Array.componentsJoined(by: ",")
            dict.setValue(DataManager.getVal(orientationID), forKey: "orientation_id")
            dict.setValue(DataManager.getVal(self.religion_id), forKey: "religion_id")
            dict.setValue(DataManager.getVal(self.marital_id), forKey: "marital_id")

            print(dict)
                    
            let dataDict = NSMutableDictionary()
            dataDict.setObject("image", forKey: "image" as NSCopying)
            dataDict.setObject(resize(self.ProfileImgView.image!).pngData()!, forKey: "imageData" as NSCopying)
            dataDict.setObject("png", forKey: "ext" as NSCopying)
            self.singleImageArr.add(dataDict)
            
            //UploadImageArray
            let UploadImagedataArr = NSMutableArray()
            for index in 0..<self.UploadimageArray.count{
                let dict = DataManager.getVal(self.UploadimageArray[index]) as! [String:Any]
                let type = DataManager.getVal(dict["type"]) as? String ?? ""
                if type == "image"{
                    var imageData:Data!
                    var imgData:String!
                    imgData = dict["url"] as? String
                    if imgData == nil {
                        imageData = dict["imageData"] as? Data
                    }else {
                        let fileUrl = URL(string: imgData)
                        imageData = try! Data(contentsOf: fileUrl! as URL)
                    }
                    let dataDict = NSMutableDictionary()
                    dataDict.setObject("pictures", forKey: "image" as NSCopying)
                    dataDict.setObject(imageData!, forKey: "imageData" as NSCopying)
                    dataDict.setObject("png", forKey: "ext" as NSCopying)
                    UploadImagedataArr.add(dataDict)
                }
            }
            //UploadImageArray
            let UploadVideoDataArr = NSMutableArray()
            for index in 0..<self.UploadvideoArray.count{
                let dict = DataManager.getVal(self.UploadvideoArray[index]) as! [String:Any]
                let type = DataManager.getVal(dict["type"]) as? String ?? ""
                if type == "video"{
                    //print(dict)
                    var imageData:Data!
                    var imgData:String!
                    imgData = dict["url"] as? String
                    if imgData == nil {
                        imageData = dict["videoData"] as? Data
                    }else {
                        let fileUrl = URL(string: imgData)
                        imageData = try! Data(contentsOf: fileUrl! as URL)
                    }
                    let dataDict = NSMutableDictionary()
                    dataDict.setObject("videos", forKey: "video" as NSCopying)
                    dataDict.setObject(imageData!, forKey: "videoData" as NSCopying)
                    dataDict.setObject("mov", forKey: "Videoext" as NSCopying)
                    UploadVideoDataArr.add(dataDict)
                }
            }
            let methodName = "profile/edit"
            
            DataManager.UploadVideoAndImageArrayWithSingleImage(parameterDictionary: dict, methodName: methodName, multipleVideoArray: UploadVideoDataArr, multipleImageArray: UploadImagedataArr, singleImageArray: self.singleImageArr){ [self](responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    if self.flag_comingfromLogin == true{
                        let vc = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                        vc.flag_comingfromLogin = self.flag_comingfromLogin
                        self.onlyPushViewController(vc)
                    }else{
                        let vc = ProfileSecoundVC(nibName: "ProfileSecoundVC", bundle: nil)
                        self.onlyPushViewController(vc)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
                nextBtn.isUserInteractionEnabled = true
            }
        }
    }
    //MARK:- Video Delete Button Action
    @objc func VideoDeleteButton_Action(_ sender:UIButton){
        let dict = DataManager.getVal(self.UploadvideoArray[sender.tag]) as! NSDictionary
        let status = DataManager.getVal(dict["status"]) as? String ?? ""
        let id = DataManager.getVal(dict["id"]) as? String ?? ""

        if status == "new"{
            self.UploadvideoArray.removeObject(at: sender.tag)
            self.VideoCollectionView.reloadData()
        }else{
            self.DeleteImageAndVideo1(id: id)
        }
    }
    //MARK:- Image Delete Button Action
    @objc func ImageDeleteButton_Action(_ sender:UIButton){
        let dict = DataManager.getVal(self.UploadimageArray[sender.tag]) as! NSDictionary
        let status = DataManager.getVal(dict["status"]) as? String ?? ""
        let id = DataManager.getVal(dict["id"]) as? String ?? ""
        
        if status == "new"{
            self.UploadimageArray.removeObject(at: sender.tag)
            self.ImageCollectionView.reloadData()
        }else{
            self.DeleteImageAndVideo1(id: id)
        }
    }
    //MARK:- Delete Image and Video API
    func DeleteImageAndVideo1(id:String) {
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(id), forKey: "id")
        
        let methodName = "profile/delete-gallery"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.getProfileDataAPI()
                self.view.makeToast(message: message)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Collection View DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.ImageCollectionView {
            var numOfSections: Int = 0
            if UploadimageArray.count>0{
                numOfSections            = 1
                collectionView.backgroundView = nil
            }else{
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text = ""
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
            return numOfSections
        }else {
            var numOfSections: Int = 0
            if UploadvideoArray.count>0{
                numOfSections            = 1
                collectionView.backgroundView = nil
            }else{
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                noDataLabel.text = ""
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                collectionView.backgroundView = noDataLabel
            }
            return numOfSections
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.VideoCollectionView{
            return self.UploadvideoArray.count
        }else{
            return self.UploadimageArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.VideoCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.tag = indexPath.row
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            
            let dict = DataManager.getVal(self.UploadvideoArray[indexPath.row]) as! NSDictionary
            let status = DataManager.getVal(dict["status"]) as? String ?? ""
            if status == "new"{
                let image = DataManager.getVal(dict["image"]) as! UIImage
                cell.ImgView.image = image
            }else{
                let name = DataManager.getVal(dict["name"]) as? String ?? ""
                
                let url = URL(string: name)
                cell.player = AVPlayer(url: url!)
                
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                cell.player = AVPlayer(playerItem: playerItem)
                cell.avpController.player = cell.player
                cell.avpController.showsPlaybackControls = false
                cell.avpController.view.frame.size.height = cell.ImgView.frame.size.height
                cell.avpController.view.frame.size.width = cell.ImgView.frame.size.width
                cell.avpController.allowsPictureInPicturePlayback = true
                
                cell.ImgView.addSubview(cell.avpController.view)
                //cell.CrossButton.isHidden = true
            }
            cell.ImgView.contentMode = .scaleAspectFill
            cell.ImgView.layer.cornerRadius = 8
            cell.CrossButton.tag = indexPath.row
            cell.CrossButton.addTarget(self, action: #selector(self.VideoDeleteButton_Action), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.tag = indexPath.row
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            let dict = DataManager.getVal(self.UploadimageArray[indexPath.row]) as! NSDictionary
            let status = DataManager.getVal(dict["status"]) as? String ?? ""
            
            if status == "new"{
                let imageStr = UIImage(data: dict["imageData"] as! Data)
                cell.ImgView.image = imageStr
            }else{
                Config().setimage(name: DataManager.getVal(dict["name"]) as? String ?? "", image: cell.ImgView)
            }
            cell.ImgView.layer.cornerRadius = 8
            cell.CrossButton.tag = indexPath.row
            cell.CrossButton.addTarget(self, action: #selector(self.ImageDeleteButton_Action), for: .touchUpInside)
            return cell
        }
    }
    //MARK:- Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.VideoCollectionView{
            let dict = DataManager.getVal(self.UploadvideoArray [indexPath.row]) as! [String: Any]
            let video_url = DataManager.getVal(dict["name"]) as? String ?? ""
            
            let player = AVPlayer(url: URL(fileURLWithPath: video_url))
            let playerController = AVPlayerViewController()
            playerController.player = player
            playerController.showsPlaybackControls = true
            self.present(playerController, animated: true) {
                player.play()
            }
        }
    }
    //MARK:- Collection View Flowlayout Delegate
    
    //MARK:- Image and Video Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.imageAndVideoFlag == true{//image
            picker.dismiss(animated: true, completion: {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    self.ProfileImgView.image = image
                }else{
                    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                        self.ProfileImgView.image = image
                    }
                }
            })
        }else{//video
            self.videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
            print(self.videoURL!)
            let data = NSData(contentsOf: self.videoURL! as URL)
            do {
                let asset = AVURLAsset(url: self.videoURL! as URL , options: nil)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                print(durationTime)
                if durationTime <= 10.6{
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    
                    var dict = [String: Any]()
                    dict = ["image": thumbnail,"videoUrl": self.videoURL as Any,"videoData": data as Any,"status": "new","type": "video"]
                    self.UploadvideoArray.add(dict)
                    
                    self.VideoCollectionView.isHidden = false
                    self.VideoCollectionView.reloadData()
                }else{
                    self.view.makeToast(message: "Please upload video less than 10 seconds ")
                }
                
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: - YMSPhotoPickerViewControllerDelegate
    
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow photo album access?", message: "Need your permission to access photo albumbs", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        //self.UploadimageArray = [image ?? []]
       // self.ImageCollectionView.reloadData()
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            
            for asset: PHAsset in photoAssets{
                let scale = UIScreen.main.scale
                let targetSize = CGSize(width: (200) * scale, height: (200) * scale)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-YYYY hh:mm:ss"
                    let dateExtension = formatter.string(from: date)
                    let fileManager = FileManager.default
                    
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateExtension).appending(".png")
                    print(paths)
                    
                    var imgData = Data()
                    imgData = image!.jpegData(compressionQuality: 0.5)!
                    fileManager.createFile(atPath: paths as String, contents: imgData, attributes: nil)
                    
                     let img = UIImage(data: imgData)
                    let dict = ["imageData":self.resize(img!).pngData()!,"status": "new","type": "image"] as [String: Any]
                    self.UploadimageArray.add(dict)
//                    if self.UploadimageArray.count == 5 {
//                        self.UploadimageArray.removeAllObjects()
//                        self.UploadimageArray.add(dict)
//                    }else{
//                        self.UploadimageArray.add(dict)
//                    }
                    
                })
            }
            self.ImageCollectionView.isHidden = false
            self.ImageCollectionView.reloadData()
        }
    }
    //MARK:- Textfield Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.DOBtxtField{
            self.view.endEditing(true)
            let max = Date()
            
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            comps.year = -99
            let minDate = calendar.date(byAdding: comps, to: Date())
            var comps1 = DateComponents()
            comps1.year = -13
            let maxDate = calendar.date(byAdding: comps1, to: Date())
            
            DPPickerManager.shared.showPicker(title: "Date Of Birth", selected: max, min: minDate, max: maxDate) { (date, cancel) in
                if !cancel {
                    let date = self.formatter.string(from: date!)
                    self.DOBtxtField.text = date
                    debugPrint(date as Any)
                }
            }
            return false
        }else if textField == self.CountryTxtField{
            self.view.endEditing(true)
            let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
            vc.delegate = self
            vc.title = "Select Country"
            self.onlyPushViewController(vc)
            
            return false
        }else if textField == self.StateTxtField{
            self.view.endEditing(true)
            if self.CountryTxtField.text == ""{
                self.view.makeToast(message: "Please select country first.")
            }else{
                let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
                vc.delegate = self
                vc.title = "Select State"
                vc.country_id = self.country_id
                self.onlyPushViewController(vc)
            }
            return false
        }else if textField == self.CityTxtField{
            self.view.endEditing(true)
            if self.CountryTxtField.text == "" || self.StateTxtField.text == ""{
                self.view.makeToast(message: "Please select country and state first.")
            }else{
                let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
                vc.delegate = self
                vc.title = "Select City"
                vc.state_id = self.state_id
                self.onlyPushViewController(vc)
            }
            return false
        }else if textField == self.BuildTxtField{
            self.view.endEditing(true)
            let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
            vc.delegate = self
            vc.title = "Select Build"
            vc.state_id = self.state_id
            self.onlyPushViewController(vc)
            return false
        }else if textField == self.EducationSearchTxtField{
            self.view.endEditing(true)
                let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
                vc.delegate = self
                vc.title = "Select Degree"
                vc.degree_id = self.degree_id
                self.onlyPushViewController(vc)
            return false
        }
        else if textField == self.GenderTxtFeild{
            self.view.endEditing(true)
            self.type_select = "gender"
            self.TitleLbl.text = "Select Gender"
            self.getOptionsData()
            return false
        }
        else if textField == self.OrientationTxtFeild{
            self.view.endEditing(true)
            self.type_select = "orientation"
            self.TitleLbl.text = "Select Orientation"
            self.getOptionsData()
            return false
        }else if textField == self.EthnicityTxtField{
            self.view.endEditing(true)
                let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
                vc.delegate = self
                vc.title = "Select Ethnicity"
                vc.ethnicity_id = self.ethnicity_id
                self.onlyPushViewController(vc)
            return false
        }else if textField == self.ReligionTxtField{
            self.view.endEditing(true)
                let vc = CountryStateCityVC(nibName: "CountryStateCityVC", bundle: nil)
                vc.delegate = self
                vc.title = "Select Religion"
                vc.religion_id = self.religion_id
                self.onlyPushViewController(vc)
            return false
        }else if textField == self.MatrialStatusTxtField{
            self.view.endEditing(true)
            self.type_select = "Marital status"
            self.TitleLbl.text = "Select Marital status"
            self.getOptionsData()
            return false
        }else if textField == self.minHeightTxt{
            self.view.endEditing(true)
            DPPickerManager.shared.showPicker(title: "Height Feet", selected: "", strings: self.minHeightArray) { (value, index, cancel) in
                if !cancel {
                    self.minHeightTxt.text = value
                }
            }
            return false
        }else if textField == self.maxHeightTxt{
            self.view.endEditing(true)
            DPPickerManager.shared.showPicker(title: "Height Inch", selected: "", strings: self.maxHeightArray) { (value, index, cancel) in
                if !cancel {
                    self.maxHeightTxt.text = value
                }
            }
            return false
        }else{
            return true
        }
    }
    //MARK:- Option Data Api
    func getOptionsData(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        var methodName = String()
        
        if type_select == "gender" {
            methodName = "option/gender"
//            dict.setValue(DataManager.getVal(self.gender_id), forKey: "gender_id")
            
        }else if type_select == "orientation" {
            methodName = "option/orientation"
//            dict.setValue(DataManager.getVal(self.orientation_id), forKey: "orientation_id")
        }else if type_select == "Marital status"{
            methodName = "option/marital"
//            dict.setValue(DataManager.getVal(self.marital_id), forKey: "marital_id")
        }
        
//        dict.setValue(DataManager.getVal(self.gender_id), forKey: "gender_id")
//        print(gender_id)
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.type_select == "gender"{
                    self.dataArray = DataManager.getVal(responseData?["gender"]) as? [Any] ?? []
                    print(self.dataArray)
//                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "gender")) as? [Any] ?? []
                }
                else if self.type_select == "orientation"  {
                    self.dataArray = DataManager.getVal(responseData?["orientation"]) as? [Any] ?? []
                }else if self.type_select == "Marital status"{
                    self.dataArray = DataManager.getVal(responseData?["marital"]) as? [Any] ?? []
                }
                self.SelectTblView.reloadData()
                self.showAnimate(YourHiddenView: self.SelectMultipleView, ishidden: false)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    
    //MARK:- Protocol Delegate Function
    func sendDataToFirstViewController(id: String,name: String,type: String) {
        if type == "country"{
            self.country_id = id
            self.CountryTxtField.text = name
            self.StateTxtField.text = ""
            self.state_id = ""
            self.CityTxtField.text = ""
            self.city_id = ""
        }else if type == "state"{
            self.state_id = id
            self.StateTxtField.text = name
            self.CityTxtField.text = ""
            self.city_id = ""
        }else if type == "city"{
            self.city_id = id
            self.CityTxtField.text = name
        }else if type == "gender"{
            self.gender_id = id
            self.GenderTxtFeild.text = name
        }else if type == "orientation"{
            self.orientation_id = id
            self.OrientationTxtFeild.text = name
        }else if type == "ethnicity"{
            self.ethnicity_id = id
            self.EthnicityTxtField.text = name
        }else if type == "religion"{
            self.religion_id = id
            self.ReligionTxtField.text = name
        }else if type == "degree"{
            self.degree_id = id
            self.EducationSearchTxtField.text = name
        }else if type == "build"{
            self.build_id = id
            self.BuildTxtField.text = name
        }else if type == "marital status"{
            self.marital_id = id
            self.MatrialStatusTxtField.text = name
        }
    }
    
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
@available(iOS 13.0, *)
extension ProfileVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        self.locationTXt.text = place.formattedAddress
        let address =  place.formattedAddress
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            if placemarks != nil {
                let placemarks = placemarks
                let location = placemarks?.first?.location
                let long = location?.coordinate.longitude
                let lat = location?.coordinate.latitude
            }else{
                return
            }
        }
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
