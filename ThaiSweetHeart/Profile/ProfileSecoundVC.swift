//
//  ProfileSecoundVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)

class ProfileSecoundVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate {
    
    @IBOutlet weak var habitsIntrestLbl: UILabel!
    @IBOutlet weak var doYouWOrkoutLbl: UILabel!
    @IBOutlet weak var haveChildrenLbl: UILabel!
    @IBOutlet weak var iLikeLbl: UILabel!
    @IBOutlet weak var spendTimeLbl: UILabel!
    @IBOutlet weak var musicLbl: UILabel!
    @IBOutlet weak var vacationLbl: UILabel!
    @IBOutlet weak var doneBtn: MyButton!
    
    @IBOutlet weak var SmokingTxtField: MyTextField!
    @IBOutlet weak var DrinkingTxtField: MyTextField!
    @IBOutlet weak var likePetTxtField: MyTextField!
    
    @IBOutlet weak var smokingLbl: UILabel!
    
    @IBOutlet weak var drinkingLbl: UILabel!
    
    @IBOutlet weak var likePetsLbl: UILabel!
    @IBOutlet weak var CatButton: UIButton!
    @IBOutlet weak var DogButton: UIButton!
    @IBOutlet weak var BirdButton: UIButton!
    @IBOutlet weak var FishButton: UIButton!
    @IBOutlet weak var NoPetButton: UIButton!
        
    
    @IBOutlet weak var WorkoutEveryDayBtn: UIButton!
    @IBOutlet weak var WorkoutAWeekBtn: UIButton!
    @IBOutlet weak var WorkoutAMonth: UIButton!
    @IBOutlet weak var WorkoutLessOftenBtn: UIButton!
    
    @IBOutlet weak var definitelyHaveChildBtn: UIButton!
    @IBOutlet weak var somedayHaveChildBtn: UIButton!
    @IBOutlet weak var noHaveChildBtn: UIButton!
    @IBOutlet weak var noAnswerHaveChildBtn: UIButton!
    
    
    @IBOutlet weak var favoriteSportLbl: UILabel!
    @IBOutlet weak var FavoriteSportTxtField: MyTextField!
    @IBOutlet weak var FavoriteMusicTxtField: MyTextField!
    @IBOutlet weak var ILikeTxtField: MyTextField!
    @IBOutlet weak var SpendTimeTxtFeild: MyTextField!
    @IBOutlet weak var VacationTxtFeild: MyTextField!
    @IBOutlet weak var LookingTxtField: MyTextField!
    
    
    @IBOutlet var SelectMultipleView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SelectTblView: UITableView!
    @IBOutlet weak var HabitsbackBtn: MyButton!
    @IBOutlet weak var nextBtn: MyButton!
    
    var flag_comingfromLogin = Bool()
    
    var like_pet = ""
    var workout = ""
    var haveChild = ""
    
    var sports_Array = NSMutableArray()
    var likes_Array = NSMutableArray()
    var spendTime_Array = NSMutableArray()
    var music_Array = NSMutableArray()
    var vacation_Array = NSMutableArray()
    var likePet_Array = NSMutableArray()
    var looking_Array = NSMutableArray()
    
    var sports_name_Array = NSMutableArray()
    var likes_name_Array = NSMutableArray()
    var spendTime_name_Array = NSMutableArray()
    var music_name_Array = NSMutableArray()
    var vacation_name_Array = NSMutableArray()
    var likePet_name_Array = NSMutableArray()
    var looking_name_Array = NSMutableArray()
    
    var sports_str = String()
    var iLikes_str = String()
    var music_str = String()
    var spendTime_str = String()
    var vacation_str = String()
    var looking_str = String()
    var likepet_str = String()
    var defaults:UserDefaults!
    var name:String!
    
    var dataArray = [Any]()
    var type_select = String()
    var smoking_id = String()
    var drinking_id = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        defaults = UserDefaults.standard
        name = defaults.value(forKey: "NAME") as? String
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont.boldSystemFont(ofSize: lbNavTitle.font.pointSize)
            lbNavTitle.text = name
            self.navigationItem.titleView = lbNavTitle
           

//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBarImage")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        self.SelectMultipleView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let nibClass = UINib(nibName: "CountryTableCell", bundle: nil)
        self.SelectTblView.register(nibClass, forCellReuseIdentifier: "CountryTableCell")
        self.SelectTblView.rowHeight = UITableView.automaticDimension
        self.SelectTblView.delegate = self
        self.SelectTblView.dataSource = self
        
        if self.flag_comingfromLogin == false{
            self.getProfileDataAPI()
        }
        
    }
    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        self.title = language == "en" ? name : kThhabitsIntrestLbl
        self.habitsIntrestLbl.text = language == "en" ? khabitsIntrestLbl : kThhabitsIntrestLbl
        self.smokingLbl.text = language == "en" ? ksmokingLbl : kThsmokingLbl
        self.drinkingLbl.text = language == "en" ? kdrinkingLbl : kThdrinkingLbl
        self.likePetsLbl.text = language == "en" ? klikePetsLbl : kThlikePetsLbl
//        self.CatButton.setTitle(language == "en" ? kCatBtb : kThCatBtb, for: .normal)
//        self.DogButton.setTitle(language == "en" ? kDogBtn : kThDogBtn, for: .normal)
//        self.BirdButton.setTitle(language == "en" ? kBirdBtn : kThBirdBtn, for: .normal)
//        self.FishButton.setTitle(language == "en" ? kFishBtn : kThFishBtn, for: .normal)
//        self.NoPetButton.setTitle(language == "en" ? kNoPetBtn : kThNoPetBtn, for: .normal)
        self.doYouWOrkoutLbl.text = language == "en" ? kdoYouWOrkoutLbl : kThdoYouWOrkoutLbl
        self.WorkoutEveryDayBtn.setTitle(language == "en" ? kWorkoutEveryDayBtn : kThWorkoutEveryDayBtn, for: .normal)
        self.WorkoutAWeekBtn.setTitle(language == "en" ? kWorkoutAWeekBtn : kThWorkoutAWeekBtn, for: .normal)
        self.WorkoutAMonth.setTitle(language == "en" ? kWorkoutAMonth : kThWorkoutAMonth, for: .normal)
        self.WorkoutLessOftenBtn.setTitle(language == "en" ? kWorkoutLessOftenBtn : kThWorkoutLessOftenBtn, for: .normal)
        self.haveChildrenLbl.text = language == "en" ? kDohaveChildrenLbl : kThDohaveChildrenLbl
        self.definitelyHaveChildBtn.setTitle(language == "en" ? kdefinitelyHaveChildBtn : kThdefinitelyHaveChildBtn, for: .normal)
        self.somedayHaveChildBtn.setTitle(language == "en" ? ksomedayHaveChildBtn : kThsomedayHaveChildBtn, for: .normal)
        self.noHaveChildBtn.setTitle(language == "en" ? knoHaveChildBtn : kThnoHaveChildBtn, for: .normal)
        self.noAnswerHaveChildBtn.setTitle(language == "en" ? knoAnswerHaveChildBtn : kThnoAnswerHaveChildBtn, for: .normal)
        self.iLikeLbl.text = language == "en" ?  kiLikeLbl : kThiLikeLbl
        self.ILikeTxtField.placeholder = language == "en" ? kILikeTxtField : kThILikeTxtField
        self.spendTimeLbl.text = language == "en" ? kspendTimeLbl : kThspendTimeLbl
        self.SpendTimeTxtFeild.placeholder = language == "en" ? kSpendTimeTxtFeild : kThSpendTimeTxtFeild
        self.favoriteSportLbl.text = language == "en" ? kfavoriteSportLbl : kThfavoriteSportLbl
        self.FavoriteSportTxtField.placeholder = language == "en" ?  kSportsTxtField : kThSportsTxtField
        self.musicLbl.text = language == "en" ? kmusicLbl : kThmusicLbl
        self.FavoriteMusicTxtField.placeholder = language == "en" ?  kFavoriteMusicTxtField : kThFavoriteMusicTxtField
        self.vacationLbl.text = language == "en" ? kvacationLbl : kThvacationLbl
        self.VacationTxtFeild.placeholder = language == "en" ? kVacationTxtFeild : kThVacationTxtFeild
        self.HabitsbackBtn.setTitle(language == "en" ? kprofileBackBtn : kThbackBtn, for: .normal)
        self.nextBtn.setTitle(language == "en" ? knextBtn : kThnextBtn, for: .normal)
        self.doneBtn.setTitle(language == "en" ? kProfiledoneBtn : kThdoneBtn, for: .normal)
    }
    func getProfileDataAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        
        let methodName = "interest"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if let drinking = DataManager.getVal(responseData?["drinking"]) as? NSDictionary{
                    self.drinking_id = DataManager.getVal(drinking["id"]) as? String ?? ""
                    self.DrinkingTxtField.text = DataManager.getVal(drinking["name"]) as? String ?? ""
                }
                if let smoking = DataManager.getVal(responseData?["smoking"]) as? NSDictionary{
                    self.smoking_id = DataManager.getVal(smoking["id"]) as? String ?? ""
                    self.SmokingTxtField.text = DataManager.getVal(smoking["name"]) as? String ?? ""

                }
                if let interests = DataManager.getVal(responseData?["interests"]) as? NSDictionary{
                    self.workout = DataManager.getVal(interests["workout"]) as? String ?? ""
                    self.haveChild = DataManager.getVal(interests["want_to_children"]) as? String ?? ""
                    self.sports_str = DataManager.getVal(interests["sports_str"]) as? String ?? ""
                    self.music_str = DataManager.getVal(interests["music_str"]) as? String ?? ""
                    self.iLikes_str = DataManager.getVal(interests["ilikes_str"]) as? String ?? ""
                    self.spendTime_str = DataManager.getVal(interests["spendtime_str"]) as? String ?? ""
                    self.vacation_str = DataManager.getVal(interests["vacation_str"]) as? String ?? ""
                    self.looking_str = DataManager.getVal(interests["looking_str"]) as? String ?? ""
                    self.likepet_str = DataManager.getVal(interests["pet_str"]) as? String ?? ""
                    
                    self.FavoriteSportTxtField.text = self.sports_str
                    self.FavoriteMusicTxtField.text = self.music_str
                    self.ILikeTxtField.text = self.iLikes_str
                    self.SpendTimeTxtFeild.text = self.spendTime_str
                    self.VacationTxtFeild.text = self.vacation_str
                    self.LookingTxtField.text = self.looking_str
                    self.likePetTxtField.text = self.likepet_str

                    let like_array = DataManager.getVal(interests["ilike"]) as? [Any] ?? []
                    let sports_array = DataManager.getVal(interests["sports"]) as? [Any] ?? []
                    let music_array = DataManager.getVal(interests["music"]) as? [Any] ?? []
                    let spendTime_array = DataManager.getVal(interests["spendtime"]) as? [Any] ?? []
                    let vacation_array = DataManager.getVal(interests["vacation"]) as? [Any] ?? []
                    let looking_array = DataManager.getVal(interests["looking"]) as? [Any] ?? []
                    let likePet_array = DataManager.getVal(interests["pet"]) as? [Any] ?? []
                    
                    for ilike_id in 0..<like_array.count{
                        let dict = DataManager.getVal(like_array[ilike_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.likes_Array.add(id)
                    }
                    for sports_id in 0..<sports_array.count{
                        let dict = DataManager.getVal(sports_array[sports_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.sports_Array.add(id)
                    }
                    for music_id in 0..<music_array.count{
                        let dict = DataManager.getVal(music_array[music_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.music_Array.add(id)
                    }
                    for spendTime_id in 0..<spendTime_array.count{
                        let dict = DataManager.getVal(spendTime_array[spendTime_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.spendTime_Array.add(id)
                    }
                    for vacation_id in 0..<vacation_array.count{
                        let dict = DataManager.getVal(vacation_array[vacation_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.vacation_Array.add(id)
                    }
                    for looking_id in 0..<looking_array.count{
                        let dict = DataManager.getVal(looking_array[looking_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.looking_Array.add(id)
                    }
                    for likePet_id in 0..<likePet_array.count{
                        let dict = DataManager.getVal(likePet_array[likePet_id]) as! [String: Any]
                        let id = DataManager.getVal(dict["id"]) as? String ?? ""
                        self.likePet_Array.add(id)
                    }
//                    if self.like_pet == "Cat"{
//                        self.CatButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                    }else if self.like_pet == "Dog"{
//                        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                    }else if self.like_pet == "Bird"{
//                        self.CatButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                    }else if self.like_pet == "Fish"{
//                        self.CatButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                    }else if self.like_pet == "No Pet"{
//                        self.CatButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
//                    }else {
//                        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
//                    }
                    if self.workout == "Every day"{
                        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.workout == "Several times a week" {
                        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.workout == "Several times a month" {
                        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAMonth.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.workout == "Less often" {
                        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                    }else{
                        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }
                    if self.haveChild == "1"{
                        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.haveChild == "2"{
                        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.somedayHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.haveChild == "3"{
                        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }else if self.haveChild == "4"{
                        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
                    }else{
                        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
                    }
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    @IBAction func CrossButtonAction(_ sender: ResponsiveButton) {
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    @IBAction func DoneButtonAction(_ sender: MyButton) {
        if self.type_select == "sport"{
            let select_name = self.sports_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.FavoriteSportTxtField.text = sports_str
            }else{
                self.FavoriteSportTxtField.text = select_name
            }
        }else if self.type_select == "like"{
            let select_name = self.likes_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.ILikeTxtField.text = iLikes_str
            }else{
                self.ILikeTxtField.text = select_name
            }
        }else if self.type_select == "spendTime"{
            let select_name = self.spendTime_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.SpendTimeTxtFeild.text = self.spendTime_str
            }else{
                self.SpendTimeTxtFeild.text = select_name
            }
        }else if self.type_select == "music"{
            let select_name = self.music_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.FavoriteMusicTxtField.text = self.music_str
            }else{
                self.FavoriteMusicTxtField.text = select_name
            }
        }else if self.type_select == "vacation" {
            let select_name = self.vacation_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.VacationTxtFeild.text = self.vacation_str
            }else{
                self.VacationTxtFeild.text = select_name
            }
        }
        else if self.type_select == "looking" {
            let select_name = self.looking_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.LookingTxtField.text = self.looking_str
            }else{
                self.LookingTxtField.text = select_name
            }
        }
        else if self.type_select == "like pet" {
            let select_name = self.likePet_name_Array.componentsJoined(by: ",")
            if select_name == "" {
                self.likePetTxtField.text = self.likepet_str
            }else{
                self.likePetTxtField.text = select_name
            }
        }
        self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
    }
    
    //MARK:- Like Pets
    @IBAction func CatButtonAction(_ sender: UIButton) {
        self.like_pet = "Cat"
        self.CatButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func DogButtonAction(_ sender: UIButton) {
        self.like_pet = "Dog"
        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func BirdButtonAction(_ sender: UIButton) {
        self.like_pet = "Bird"
        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func FishButtonAction(_ sender: UIButton) {
        self.like_pet = "Fish"
        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.NoPetButton.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func NoPetsButtonAction(_ sender: UIButton) {
        self.like_pet = "No Pet"
        self.CatButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.DogButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.BirdButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.FishButton.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.NoPetButton.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    
    //MARK:- Workout Button Actions
    
    @IBAction func WorkoutEveryDayBtnAction(_ sender: UIButton) {
        self.workout = "Every Day"
        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func WorkoutAWeekBtnAction(_ sender: UIButton) {
        self.workout = "Several times a week"
        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func WorkoutAMonthBtnAction(_ sender: UIButton) {
        self.workout = "Several times a month"
        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAMonth.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func WorkoutLessOftenBtnAction(_ sender: UIButton) {
        self.workout = "Less often"
        self.WorkoutEveryDayBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAWeekBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutAMonth.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.WorkoutLessOftenBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- Have Children Button Actions
    @IBAction func definitelyChildBtnAction(_ sender: UIButton) {
        self.haveChild = "1"
        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func somedayChildBtnAction(_ sender: UIButton) {
        self.haveChild = "2"
        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.somedayHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func noChildBtnAction(_ sender: UIButton) {
        self.haveChild = "3"
        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
    }
    @IBAction func noAnsChildBtnAction(_ sender: UIButton) {
        self.haveChild = "4"
        self.definitelyHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.somedayHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noHaveChildBtn.setImage(UIImage(named: "roundBlack"), for: .normal)
        self.noAnswerHaveChildBtn.setImage(UIImage(named: "roundRedFill"), for: .normal)
    }
    //MARK:- Next Button Action
    @IBAction func NextButtonAction(_ sender: MyButton) {
        self.nextBtn.isUserInteractionEnabled = false
        if self.SmokingTxtField.text == ""{
            self.view.makeToast(message: "Please select smoking type.")
        }else if self.DrinkingTxtField.text == ""{
            self.view.makeToast(message: "Please select drinking type.")
        }else if self.FavoriteSportTxtField.text == ""{
            self.view.makeToast(message: "Please select favorite sport.")
        }else if self.FavoriteMusicTxtField.text == ""{
            self.view.makeToast(message: "Please select favorite music.")
        }else if self.ILikeTxtField.text == ""{
            self.view.makeToast(message: "Please select favorite like.")
        }else if self.SpendTimeTxtFeild.text == ""{
            self.view.makeToast(message: "Please select favorite spend time.")
        }else if self.VacationTxtFeild.text == ""{
            self.view.makeToast(message: "Please select favorite vacation.")
        }else if self.LookingTxtField.text == ""{
            self.view.makeToast(message: "Please select favorite looking.")
        }else{
            self.pleaseWait()
            
            let sports = self.sports_Array.componentsJoined(by: ",")
            let ilike = self.likes_Array.componentsJoined(by: ",")
            let music = self.music_Array.componentsJoined(by: ",")
            let spendTime = self.spendTime_Array.componentsJoined(by: ",")
            let vacation = self.vacation_Array.componentsJoined(by: ",")
            let looking = self.looking_Array.componentsJoined(by: ",")
            let likePet = self.likePet_Array.componentsJoined(by: ",")
            
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(self.drinking_id), forKey: "drinking_id")
            dict.setValue(DataManager.getVal(self.smoking_id), forKey: "smoking_id")
//            dict.setValue(DataManager.getVal(self.like_pet), forKey: "like_pet")
            dict.setValue(DataManager.getVal(self.workout), forKey: "workout")
            dict.setValue(DataManager.getVal(self.haveChild), forKey: "want_to_children")
            dict.setValue(DataManager.getVal(sports), forKey: "sports")
            dict.setValue(DataManager.getVal(ilike), forKey: "i_likes")
            dict.setValue(DataManager.getVal(music), forKey: "music")
            dict.setValue(DataManager.getVal(spendTime), forKey: "spendtime")
            dict.setValue(DataManager.getVal(vacation), forKey: "vacation")
            dict.setValue(DataManager.getVal(looking), forKey: "looking")
            dict.setValue(DataManager.getVal(likePet), forKey: "pet_id")
            
            var methodName = String()
            if self.flag_comingfromLogin == true{
                methodName = "interest/add"
            }else{
                methodName = "interest/edit"
            }
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    if self.flag_comingfromLogin == true{
                        Config().AppUserDefaults.set("yes", forKey: "login")
                        let vc = QuestionsVC(nibName: "QuestionsVC", bundle: nil)
                        vc.flag_comingfromLogin = self.flag_comingfromLogin
                        self.onlyPushViewController(vc)
                    }else{
                        self.view.makeToast(message: message)
                        let vc = QuestionsVC(nibName: "QuestionsVC", bundle: nil)
                        vc.flag_comingfromLogin = self.flag_comingfromLogin
                        self.onlyPushViewController(vc)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
                self.nextBtn.isUserInteractionEnabled = true
            }
        }
    }
    @IBAction func backBtbAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.SmokingTxtField{
            self.view.endEditing(true)
            self.type_select = "smoking"
            self.TitleLbl.text = "Smoking"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.DrinkingTxtField{
            self.view.endEditing(true)
            self.type_select = "drinking"
            self.TitleLbl.text = "Drinking"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.FavoriteSportTxtField{
            self.view.endEditing(true)
            self.type_select = "sport"
            self.TitleLbl.text = "Sport"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.ILikeTxtField{
            self.view.endEditing(true)
            self.type_select = "like"
            self.TitleLbl.text = "Like"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.SpendTimeTxtFeild{
            self.view.endEditing(true)
            self.type_select = "spendTime"
            self.TitleLbl.text = "SpendTime"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.FavoriteMusicTxtField{
            self.view.endEditing(true)
            self.type_select = "music"
            self.TitleLbl.text = "Music"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.VacationTxtFeild{
            self.view.endEditing(true)
            self.type_select = "vacation"
            self.TitleLbl.text = "Vacation"
            self.getSportAndCuisinesAPI()
            return false
        }
        else if textField == self.LookingTxtField{
            self.view.endEditing(true)
            self.type_select = "looking"
            self.TitleLbl.text = "Looking"
            self.getSportAndCuisinesAPI()
            return false
        }else if textField == self.likePetTxtField{
            self.view.endEditing(true)
            self.type_select = "like pet"
            self.TitleLbl.text = "Like pet"
            self.getSportAndCuisinesAPI()
            return false
        }
        else{
            return true
        }
    }
    func getSportAndCuisinesAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        
        var methodName = String()
        
        if self.type_select == "smoking"{
            methodName = "option/interest"
        }else if self.type_select == "drinking"{
            methodName = "option/interest"
        }else if self.type_select == "sport"{
            methodName = "option/sport"
        }else if self.type_select == "like"{
            methodName = "option/i-like"
        }else if self.type_select == "spendTime"{
            methodName = "option/spendtime"
        }else if self.type_select == "music"{
            methodName = "option/music"
        }else if self.type_select == "vacation"{
            methodName = "option/vacation"
        }
        else if self.type_select == "looking"{
            methodName = "option/looking"
        }else if self.type_select == "like pet"{
            methodName = "option/pet"
        }
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                if self.type_select == "sport"{
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "sport")) as? [Any] ?? []
                }else if self.type_select == "like"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "ilike")) as? [Any] ?? []
                }else if self.type_select == "spendTime"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "spendtime")) as? [Any] ?? []
                }else if self.type_select == "music"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "music")) as? [Any] ?? []
                }else if self.type_select == "vacation"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "vacation")) as? [Any] ?? []
                }else if self.type_select == "looking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "looking")) as? [Any] ?? []
                }else if self.type_select == "smoking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "smoking")) as? [Any] ?? []
                }
                else if self.type_select == "drinking"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "drinking")) as? [Any] ?? []
                }
                else if self.type_select == "like pet"  {
                    self.dataArray = DataManager.getVal(responseData?.object(forKey: "pet")) as? [Any] ?? []
                }
                self.SelectTblView.reloadData()
                self.showAnimate(YourHiddenView: self.SelectMultipleView, ishidden: false)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell" ,for: indexPath) as! CountryTableCell
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! [String: Any]
        print(dict)
        cell.titleLbl.text = DataManager.getVal(dict["name"]) as? String ?? ""
        
        if self.type_select == "sport"{
            let id = DataManager.getVal(dict["sport_id"]) as? String ?? ""
            if self.sports_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "like" {
            let id = DataManager.getVal(dict["i_like_id"]) as? String ?? ""
            if self.likes_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "spendTime" {
            let id = DataManager.getVal(dict["spendtime_id"]) as? String ?? ""
            if self.spendTime_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "music" {
            let id = DataManager.getVal(dict["music_id"]) as? String ?? ""
            if self.music_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "vacation" {
            let id = DataManager.getVal(dict["vacation_id"]) as? String ?? ""
            if self.vacation_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }
        else if self.type_select == "looking" {
            let id = DataManager.getVal(dict["looking_id"]) as? String ?? ""
            if self.looking_Array.contains(id){
                cell.CheckImage.isHidden = false
            }else{
                cell.CheckImage.isHidden = true
            }
        }else if self.type_select == "like pet" {
            let id = DataManager.getVal(dict["pet_id"]) as? String ?? ""
            if self.likePet_Array.contains(id){
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
        if self.type_select == "sport"{
            let id = DataManager.getVal(dict["sport_id"]) as? String ?? ""
            if self.sports_Array.contains(id){
                self.sports_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.sports_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.sports_name_Array.contains(name){
                self.sports_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.sports_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "like" {
            let id = DataManager.getVal(dict["i_like_id"]) as? String ?? ""
            if self.likes_Array.contains(id){
                self.likes_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.likes_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.likes_name_Array.contains(name){
                self.likes_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.likes_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "music" {
            let id = DataManager.getVal(dict["music_id"]) as? String ?? ""
            if self.music_Array.contains(id){
                self.music_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.music_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.music_name_Array.contains(name){
                self.music_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.music_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }else if self.type_select == "spendTime" {
            let id = DataManager.getVal(dict["spendtime_id"]) as? String ?? ""
            if self.spendTime_Array.contains(id){
                self.spendTime_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.spendTime_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.spendTime_name_Array.contains(name){
                self.spendTime_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.spendTime_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }
        else if self.type_select == "vacation" {
            let id = DataManager.getVal(dict["vacation_id"]) as? String ?? ""
            if self.vacation_Array.contains(id){
                self.vacation_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.vacation_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.vacation_name_Array.contains(name){
                self.vacation_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.vacation_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }
        else if self.type_select == "looking" {
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
        }
        else if self.type_select == "like pet" {
            let id = DataManager.getVal(dict["pet_id"]) as? String ?? ""
            if self.likePet_Array.contains(id){
                self.likePet_Array.remove(id)
                self.SelectTblView.reloadData()
            }else{
                self.likePet_Array.add(id)
                self.SelectTblView.reloadData()
            }
            if self.likePet_name_Array.contains(name){
                self.likePet_name_Array.remove(name)
                self.SelectTblView.reloadData()
            }else{
                self.likePet_name_Array.add(name)
                self.SelectTblView.reloadData()
            }
        }
        else if self.type_select == "smoking" {
            self.smoking_id = DataManager.getVal(dict["smoking_id"]) as? String ?? ""
            self.SmokingTxtField.text = DataManager.getVal(dict["name"]) as? String ?? ""
            self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
        }else if self.type_select == "drinking" {
            self.drinking_id = DataManager.getVal(dict["drinking_id"]) as? String ?? ""
            self.DrinkingTxtField.text = DataManager.getVal(dict["name"]) as? String ?? ""
            self.removeAnimate(YourHiddenView: self.SelectMultipleView, ishidden: true)
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

