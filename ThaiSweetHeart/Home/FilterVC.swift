//
//  FilterVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

protocol FilterSendingDelegate {
    func sendDataToSearchController(dict: [String: Any])
}

class FilterVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate {
    
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var ageRangeLbl: UILabel!
    @IBOutlet weak var heightRange: UILabel!
    @IBOutlet weak var minHeightLbl: UILabel!
    @IBOutlet weak var maxHeightLbl: UILabel!
    @IBOutlet weak var onlineUserslbl: UILabel!
    @IBOutlet weak var locationRadiusLbl: UILabel!
    @IBOutlet weak var smokingLbl: UILabel!
    @IBOutlet weak var drinkingLbl: UILabel!
    @IBOutlet weak var likePetsLbl: UILabel!
    @IBOutlet weak var favoriteSportLbl: UILabel!
    @IBOutlet weak var clearBtn: MyButton!
    @IBOutlet weak var applyBtn: MyButton!
    
    @IBOutlet weak var minage: MyTextField!
    @IBOutlet weak var maxage: MyTextField!
    @IBOutlet weak var minfeet: MyTextField!
    @IBOutlet weak var mininches: MyTextField!
    @IBOutlet weak var maxfeet: MyTextField!
    @IBOutlet weak var maxinches: MyTextField!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var locationSlider: UISlider!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var nonSmokerBtn: UIButton!
    @IBOutlet weak var occasionalSmokerBtn: UIButton!
    @IBOutlet weak var smokerBtn: UIButton!
    @IBOutlet weak var tryToQuitSmokeBtn: UIButton!
    @IBOutlet weak var neverSmokeBtn: UIButton!
    
    @IBOutlet weak var drinkingOnSpecialOccasionBtn: UIButton!
    @IBOutlet weak var drinkingOnceWeekBtn: UIButton!
    @IBOutlet weak var drinkingFewTimeWeekButton: UIButton!
    @IBOutlet weak var drinkingDailyBtn: UIButton!
    @IBOutlet weak var drinkingAnyBtn: UIButton!
    
    @IBOutlet weak var CatBtb: UIButton!
    @IBOutlet weak var DogBtn: UIButton!
    @IBOutlet weak var BirdBtn: UIButton!
    @IBOutlet weak var FishBtn: UIButton!
    @IBOutlet weak var NoPetBtn: UIButton!
    
    
    @IBOutlet weak var favsportTxt: MyTextField!
    @IBOutlet weak var favcusionTxt: MyTextField!
    
    @IBOutlet var SelectMultipleView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SelectTblView: UITableView!
    
    var delegate: FilterSendingDelegate? = nil
    
    var smoking = "Non-smoker"
    var drinking = "On special occasion"
    var like_pet = "1"
    var like_party = "1"
    var flag = String()
    
    var sports_id_array = NSMutableArray()
    var cuisines_id_array = NSMutableArray()
    
    var sports_name_Array = NSMutableArray()
    var cuisines_name_Array = NSMutableArray()
    
    var dataArray = [Any]()
    var type_select = String()
    var online_status = "1"
    var dataDict = [String:Any]()
    
    var FeetsArray = ["3","4","5","6","7"]
    var InchesArray = ["1","2","3","4","5","6","7","8","9","10","11"]
    var MinAgeArray = ["14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40"]
    var MaxAgeArray = ["40","39","38","37","36","35","34","33","32","31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Filter"
        self.navigationItem.titleView = bar_title
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.SelectMultipleView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.SelectTblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.SelectTblView.rowHeight = UITableView.automaticDimension
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        
        self.locationSlider.minimumValue = 0
        self.locationSlider.maximumValue = 30
        self.locationSlider.value = 0
        
        self.minage.text = DataManager.getVal(dataDict["AgeMinRange"]) as? String ?? ""
        self.maxage.text = DataManager.getVal(dataDict["AgeMaxRange"]) as? String ?? ""
        self.minfeet.text = DataManager.getVal(dataDict["MinHeightFeet"]) as? String ?? ""
        self.mininches.text = DataManager.getVal(dataDict["MinHeightInch"]) as? String ?? ""
        self.maxfeet.text = DataManager.getVal(dataDict["MaxHeightFeet"]) as? String ?? ""
        self.maxinches.text = DataManager.getVal(dataDict["MaxHeightInch"]) as? String ?? ""
        self.online_status = DataManager.getVal(dataDict["OnlineUser"]) as? String ?? ""
        self.smoking = DataManager.getVal(dataDict["Smoking"]) as? String ?? ""
        self.drinking = DataManager.getVal(dataDict["Drinking"]) as? String ?? ""
        self.like_pet = DataManager.getVal(dataDict["Like_pets"]) as? String ?? ""
        self.like_party = DataManager.getVal(dataDict["Like_parties"]) as? String ?? ""
        self.locationLbl.text = DataManager.getVal(dataDict["LocationRadius"]) as? String ?? ""
        self.sports_name_Array = DataManager.getVal(dataDict["sport_name_array"]) as? NSMutableArray ?? []
        self.cuisines_name_Array = DataManager.getVal(dataDict["cuisines_name_array"]) as? NSMutableArray ?? []
        let select_sports = self.sports_name_Array.componentsJoined(by: ",")
        self.favsportTxt.text = select_sports
        
//        let select_cuisines = self.cuisines_name_Array.componentsJoined(by: ",")
//        self.favcusionTxt.text = select_cuisines
        
        self.sports_id_array = DataManager.getVal(dataDict["Fav_Sports_id_array"]) as? NSMutableArray ?? []
        self.cuisines_id_array = DataManager.getVal(dataDict["Fav_Cuisines_id_array"]) as? NSMutableArray ?? []
        let value = Int(self.locationLbl.text!) ?? 0
        self.locationSlider.value = Float(value)
        
        if locationLbl.text == ""{
            locationLbl.text = "0"
        }
        if online_status == "2"{
            self.online_status = "2"
            self.yesBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.noBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        }else if online_status == "1"{
            self.online_status = "1"
            self.yesBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.noBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else{
            self.online_status = ""
            self.yesBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.noBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }
        if self.smoking == "Non-smoker"{
            self.nonSmokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.smoking == "Occasional smoker"{
            self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.smoking == "Smoker"{
            self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.smoking == "Trying to quit"{
            self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.smoking == "Any"{
            self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        }else{
            self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }
        if self.drinking == "On special occasion"{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.drinking == "Once a week"{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.drinking == "Few times a week"{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.drinking == "Daily"{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if self.drinking == "Any"{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        }else{
            self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }
        if like_pet == "Cat"{
            self.like_pet = "Cat"
            self.CatBtb.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if like_pet == "Dog"{
            self.like_pet = "Dog"
            self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if like_pet == "Bird"{
            self.like_pet = "Bird"
            self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if like_pet == "Fish"{
            self.like_pet = "Fish"
            self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }else if like_pet == "No Pet"{
            self.like_pet = "No Pet"
            self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        }else{
            self.like_pet = ""
            self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
            self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        }
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.filterLbl.text = language == "en" ? kfilterLbl : kThfilterLbl
        self.ageRangeLbl.text = language == "en" ? kageRangeLbl : kThageRangeLbl
        self.minage.placeholder = language == "en" ? kMin : kThMin
        self.maxage.placeholder = language == "en" ? kMax : kThMax
        self.heightRange.text = language == "en" ? kheightRange : kThheightRange
        self.minHeightLbl.text = language == "en" ? kminHeightLbl : kThminHeightLbl
        self.minfeet.placeholder = language == "en" ? kFeet : kThFeet
        self.mininches.placeholder = language == "en" ? kInches : kThInches
        self.maxHeightLbl.text = language == "en" ? kmaxHeightLbl : kThmaxHeightLbl
        self.maxfeet.placeholder = language == "en" ? kFeet : kThFeet
        self.maxinches.placeholder = language == "en" ? kInches : kThInches
        self.onlineUserslbl.text = language == "en" ? konlineUserslbl : kThonlineUserslbl
        self.yesBtn.setTitle(language == "en" ? kyesBtn : kThyesBtn, for: .normal)
        self.noBtn.setTitle(language == "en" ? knoBtn : kThnoBtn, for: .normal)
        self.locationRadiusLbl.text = language == "en" ? klocationRadiusLbl : kThlocationRadiusLbl
        self.smokingLbl.text = language == "en" ? ksmokingLbl : kThsmokingLbl
        self.nonSmokerBtn.setTitle(language == "en" ? knonSmokerBtn : kThnonSmokerBtn, for: .normal)
        self.occasionalSmokerBtn.setTitle(language == "en" ? koccasionalSmokerBtn : kThoccasionalSmokerBtn, for: .normal)
        self.smokerBtn.setTitle(language == "en" ? ksmokerBtn : kThsmokerBtn, for: .normal)
        self.tryToQuitSmokeBtn.setTitle(language == "en" ? ktryToQuitSmokeBtn : kThtryToQuitSmokeBtn, for: .normal)
        self.neverSmokeBtn.setTitle(language == "en" ? kneverSmokeBtn : kThneverSmokeBtn, for: .normal)
        self.drinkingLbl.text = language == "en" ? kdrinkingLbl : kThdrinkingLbl
        self.drinkingOnSpecialOccasionBtn.setTitle(language == "en" ? kdrinkingOnSpecialOccasionBtn : kThdrinkingOnSpecialOccasionBtn, for: .normal)
        self.drinkingOnceWeekBtn.setTitle(language == "en" ? kdrinkingOnceWeekBtn : kThdrinkingOnceWeekBtn, for: .normal)
        self.drinkingFewTimeWeekButton.setTitle(language == "en" ? kdrinkingFewTimeWeekButton : kThdrinkingFewTimeWeekButton, for: .normal)
        self.drinkingDailyBtn.setTitle(language == "en" ? kdrinkingDailyBtn : kThdrinkingDailyBtn, for: .normal)
        self.drinkingAnyBtn.setTitle(language == "en" ? kdrinkingAnyBtn : kThdrinkingAnyBtn, for: .normal)
        self.likePetsLbl.text = language == "en" ? klikePetsLbl : kThlikePetsLbl
        self.CatBtb.setTitle(language == "en" ? kCatBtb : kThCatBtb, for: .normal)
        self.DogBtn.setTitle(language == "en" ? kDogBtn : kThDogBtn, for: .normal)
        self.BirdBtn.setTitle(language == "en" ? kBirdBtn : kThBirdBtn, for: .normal)
        self.FishBtn.setTitle(language == "en" ? kFishBtn : kThFishBtn, for: .normal)
        self.NoPetBtn.setTitle(language == "en" ? kNoPetBtn : kThNoPetBtn, for: .normal)
        self.favoriteSportLbl.text = language == "en" ? kfavoriteSportLbl : kThfavoriteSportLbl
        self.clearBtn.setTitle(language == "en" ? kclearBtn : kThclearBtn, for: .normal)
        self.applyBtn.setTitle(language == "en" ? kapplyBtn : kThapplyBtn, for: .normal)
    }
    
    @IBAction func yesBtnAction(_ sender: MyButton) {
        self.online_status = "1"
        self.yesBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.noBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func noBtnAction(_ sender: MyButton) {
        self.online_status = "2"
        self.yesBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- Like Smoking
    @IBAction func nonSmokerBtnAction(_ sender: UIButton) {
        self.smoking = "Non-smoker"
        self.nonSmokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func occasionalSmokerBtnAction(_ sender: UIButton) {
        self.smoking = "Occasional smoker"
        self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.occasionalSmokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func smokerBtnAction(_ sender: UIButton) {
        self.smoking = "Smoker"
        self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.smokerBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func tryToQuitSmokeBtnAction(_ sender: UIButton) {
        self.smoking = "Trying to quit"
        self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.neverSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func neverSmokeBtnAction(_ sender: UIButton) {
        self.smoking = "Any"
        self.nonSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.occasionalSmokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.smokerBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.tryToQuitSmokeBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.neverSmokeBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    
    
    //MARK:- Like Drinking
    @IBAction func drinkingOnSpecialOccasionBtnAction(_ sender: UIButton) {
        self.drinking = "On special occasion"
        self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func drinkingOnceWeekBtnAction(_ sender: UIButton) {
        self.drinking = "Once a week"
        self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func drinkingFewTimeWeekButtonAction(_ sender: UIButton) {
        self.drinking = "Few times a week"
        self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func drinkingDailyBtnAction(_ sender: UIButton) {
        self.drinking = "Daily"
        self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingDailyBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.drinkingAnyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func drinkingAnyBtnAction(_ sender: UIButton) {
        self.drinking = "Any"
        self.drinkingOnSpecialOccasionBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingOnceWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingFewTimeWeekButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingDailyBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.drinkingAnyBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    
    //MARK:- Like Pets
    @IBAction func catBtnAction(_ sender: UIButton) {
        self.like_pet = "Cat"
        self.CatBtb.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func dogBtnAction(_ sender: UIButton) {
        self.like_pet = "Dog"
        self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func birdBtnAction(_ sender: UIButton) {
        self.like_pet = "Bird"
        self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func fishBtnAction(_ sender: UIButton) {
        self.like_pet = "Fish"
        self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.NoPetBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func noPetAction(_ sender: UIButton) {
        self.like_pet = "No Pet"
        self.CatBtb.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- UISlider Action
    @IBAction func rangeSliderAction(_ sender: UISlider) {
        let value: Int = Int(roundf(Float(sender.value)))
        self.locationLbl.text = String(value)
    }
    //MARK:- View Action Btn
    @IBAction func clearBtnAction(_ sender: Any) {
        if self.delegate != nil{
            let dict: [String: Any] = ["AgeMinRange": "",
                                       "AgeMaxRange": "",
                                       "MinHeightFeet": "",
                                       "MinHeightInch": "",
                                       "MaxHeightFeet": "",
                                       "MaxHeightInch": "",
                                       "OnlineUser": "",
                                       "LocationRadius": "",
                                       "Smoking": "",
                                       "Drinking": "",
                                       "Like_pets": "",
                                       "Like_parties": "",
                                       "Fav_Sports_id_array": "",
                                       "Fav_Cuisines_id_array": "",
                                       "sport_name_array": "",
                                       "cuisines_name_array": "",
                                       "flag": ""]
            print(dict)
            self.delegate?.sendDataToSearchController(dict: dict)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SubmitButtonAction(_ sender: MyButton) {
            if self.delegate != nil{
                self.flag = "true"
                let dict: [String: Any] = ["AgeMinRange": self.minage.text!,
                                           "AgeMaxRange": self.maxage.text!,
                                           "MinHeightFeet": self.minfeet.text!,
                                           "MinHeightInch": self.mininches.text!,
                                           "MaxHeightFeet": self.maxfeet.text!,
                                           "MaxHeightInch": self.maxinches.text!,
                                           "OnlineUser": self.online_status,
                                           "LocationRadius": self.locationLbl.text!,
                                           "Smoking": self.smoking,
                                           "Drinking": self.drinking,
                                           "Like_pets": self.like_pet,
                                           "Like_parties": self.like_party,
                                           "Fav_Sports_id_array": self.sports_id_array,
                                           "Fav_Cuisines_id_array": self.cuisines_id_array,
                                           "sport_name_array": self.sports_name_Array,
                                           "cuisines_name_array": self.cuisines_name_Array,
                                           "flag": self.flag]
                print(dict)
                self.delegate?.sendDataToSearchController(dict: dict)
                self.dismiss(animated: true, completion: nil)
            }
        
    }
    
    //MARK:- SrlrctMultiple View Action Btn
    @IBAction func CrossMultipleViewButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if self.type_select == "1"{
            let select_name = self.sports_name_Array.componentsJoined(by: ",")
            self.favsportTxt.text = select_name
        }else{
            let select_name = self.cuisines_name_Array.componentsJoined(by: ",")
            self.favcusionTxt.text = select_name
        }
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    //MARK:- SrlrctMultiple View TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.favsportTxt{
            self.view.endEditing(true)
            self.type_select = "1"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.favcusionTxt{
            self.view.endEditing(true)
            self.type_select = "2"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.minage{
            DPPickerManager.shared.showPicker(title: "Select Minimum Age", selected: "", strings: self.MinAgeArray) { (value, index, cancel) in
                if !cancel {
                    self.minage.text = value
                }
            }
            return false
        }else if textField == self.maxage{
            DPPickerManager.shared.showPicker(title: "Select Max Age", selected: "", strings: self.MaxAgeArray) { (value, index, cancel) in
                if !cancel {
                    self.maxage.text = value
                }
            }
            return false
        }else if textField == self.minfeet{
            DPPickerManager.shared.showPicker(title: "Select Minimum Height", selected: "", strings: self.FeetsArray) { (value, index, cancel) in
                if !cancel {
                    self.minfeet.text = value
                }
            }
            return false
        }else if textField == self.mininches{
            DPPickerManager.shared.showPicker(title: "Select Minimum Inches", selected: "", strings: self.InchesArray) { (value, index, cancel) in
                if !cancel {
                    self.mininches.text = value
                }
            }
            return false
        }else if textField == self.maxfeet{
            DPPickerManager.shared.showPicker(title: "Select Max Height", selected: "", strings: self.FeetsArray) { (value, index, cancel) in
                if !cancel {
                    self.maxfeet.text = value
                }
            }
            return false
        }else if textField == self.maxinches{
            DPPickerManager.shared.showPicker(title: "Select Max Inches", selected: "", strings: self.InchesArray) { (value, index, cancel) in
                if !cancel {
                    self.maxinches.text = value
                }
            }
            return false
        }else{
            return true
        }
    }
    //MARK:- SrlrctMultiple View API
    func getSportAndCuisinesAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        
        var methodName = String()
        
        if self.type_select == "1"{
            methodName = "option/sport"
        }else{
            methodName = "option/cuisine"
        }
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.type_select == "1"{
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "sport")) as? [Any] ?? []
                }else{
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "cuisine")) as? [Any] ?? []
                }
                self.SelectTblView.reloadData()
                self.showAnimate(YourHiddenView: self.SelectMultipleView, ishidden: false)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- SrlrctMultiple View TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.type_select == "1"{
            let id = DataManager.getVal(dict["sport_id"]) as? String ?? ""
            if self.sports_id_array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else{
            let id = DataManager.getVal(dict["cuisine_id"]) as? String ?? ""
            if self.cuisines_id_array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }
        return cell
    }
    //MARK:- SrlrctMultiple View TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        let name = DataManager.getVal(dict["name"]) as? String ?? ""
        if self.type_select == "1"{
            let id = DataManager.getVal(dict["sport_id"]) as? String ?? ""
            if self.sports_id_array.contains(id){
                self.sports_id_array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.sports_id_array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.sports_name_Array.contains(name){
                self.sports_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.sports_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else{
            let id = DataManager.getVal(dict["cuisine_id"]) as? String ?? ""
            if self.cuisines_id_array.contains(id){
                self.cuisines_id_array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.cuisines_id_array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.cuisines_name_Array.contains(name){
                self.cuisines_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.cuisines_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }
    }
    //MARK:- SrlrctMultiple View Animation
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
