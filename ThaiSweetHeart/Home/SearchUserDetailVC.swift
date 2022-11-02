//
//  SearchUserDetailVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 01/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import PopBounceButton
import SDWebImage
import AVKit
import AVFoundation
import AlignedCollectionViewFlowLayout

class SearchUserDetailVC: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var SwipeView: SwipeCardStack!
    
    @IBOutlet weak var goldMemberIconBtn: PopBounceButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var aboutUser: UILabel!
    @IBOutlet weak var HeaderCollectionView: UICollectionView!
    @IBOutlet weak var HeaderImagePageController: UIPageControl!
    
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    @IBOutlet weak var DetailCollectionViewHeightConstraint: NSLayoutConstraint!//40
    @IBOutlet weak var DetailCollectionViewTopConstant: NSLayoutConstraint!
    
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var VideoPageController: UIPageControl!
    @IBOutlet weak var quesAnsCollectionView: UICollectionView!
    @IBOutlet weak var quesPageController: UIPageControl!
    
    @IBOutlet weak var quesTopConstrants: NSLayoutConstraint!
    @IBOutlet weak var quesHeightConstrants: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var imageCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var imagesCollectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var habitsCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var habitsCollectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var videoCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var videoCollectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var likeBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var crossBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var superLikeBtnHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var blockBtn: ResponsiveButton!
    @IBOutlet weak var superLikeBtn: PopBounceButton!
    @IBOutlet weak var likeBtn: PopBounceButton!
    @IBOutlet weak var nopeBtn: PopBounceButton!
    @IBOutlet weak var buttonView: UIView!
    
    fileprivate var selectedCell: Int = 0
    var categoriesArray = [String]()
    var categoriesImageArray = [String]()
    var profileDataArray = [Any]()
    var profileArray = NSDictionary()
    var titleArray = [[String: Any]]()
    var pictureArray = [Any]()
    var videoarray = [Any]()
    var MemberShipStatus = String()
    private var cardModels = [TinderCardModel]()
    var avpController = AVPlayerViewController()
    var player = AVPlayer()
    var flag_comingfromLogin1 = Bool()
    var recieverId = String()
    var methodName = String()
    var swipeCross = String()
    var isblock = String()
    var quesAnsArray = [[String:Any]]()
    var UserDetailID = String()
    var userData = [String:Any]()
    var userID = String()
    var friendId = String()
    
    var room_id = String()
    var recieverName = String()
    var recieverImage = String()
    var Liketype = String()
    var is_superlike = String()
    var is_like = String()
    var is_friend = String()
    var profileID = String()
    var profile_Dict = [String: Any]()
    var height1 = CGFloat()
    var isComingChat = String()
    var isComingMatch1 = String()
    var isCommingSuperlike = String()
    var isCommingFromlikeToChat = String()
    var alertTitle = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar.png"), for: .default)
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Details"
        self.navigationItem.titleView = bar_title
        
        
        let flowLayout = DetailCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        flowLayout?.horizontalAlignment = .left
        
        self.age.layer.cornerRadius = 8
        self.age.layer.masksToBounds = true
        self.city.layer.cornerRadius = 8
        self.city.layer.masksToBounds = true
        
        let LayOut = UICollectionViewFlowLayout()
        LayOut.itemSize = CGSize(width: screenWidth-60, height: 380)
        LayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LayOut.minimumInteritemSpacing = 0
        LayOut.minimumLineSpacing = 0
        LayOut.scrollDirection = .horizontal
        
        let Headernib = UINib(nibName: "HeaderCollectionCell", bundle: nil)
        self.HeaderCollectionView.register(Headernib, forCellWithReuseIdentifier: "HeaderCollectionCell")
        self.HeaderCollectionView.collectionViewLayout = LayOut
        self.HeaderCollectionView.layer.cornerRadius = 6
        self.HeaderCollectionView.tag = 1
        
        let VideoLayOut = UICollectionViewFlowLayout()
        VideoLayOut.itemSize = CGSize(width: screenWidth-60, height: 200)
        VideoLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        VideoLayOut.minimumInteritemSpacing = 0
        VideoLayOut.minimumLineSpacing = 0
        VideoLayOut.scrollDirection = .horizontal
        
        let Videonib = UINib(nibName: "VideoCollectionCell", bundle: nil)
        self.VideoCollectionView.register(Videonib, forCellWithReuseIdentifier: "VideoCollectionCell")
        self.VideoCollectionView.collectionViewLayout = VideoLayOut
        self.VideoCollectionView.layer.cornerRadius = 6
        self.VideoCollectionView.tag = 2
        
        let detail_layout = UICollectionViewFlowLayout()
//        detail_layout.itemSize = CGSize(width: self.screenWidth/2-30, height: 40)
        detail_layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detail_layout.minimumInteritemSpacing = 0
        detail_layout.minimumLineSpacing = 10
        
        detail_layout.scrollDirection = .horizontal

        let Detailnib = UINib(nibName: "DetailCollectionCell", bundle: nil)
        self.DetailCollectionView.register(Detailnib, forCellWithReuseIdentifier: "DetailCollectionCell")
//        self.DetailCollectionView.collectionViewLayout = detail_layout
        
        let QuesAnsoLayOut = UICollectionViewFlowLayout()
        QuesAnsoLayOut.itemSize = CGSize(width: screenWidth-50, height: 190)
        QuesAnsoLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        QuesAnsoLayOut.minimumInteritemSpacing = 5
        QuesAnsoLayOut.minimumLineSpacing = 5
        QuesAnsoLayOut.scrollDirection = .horizontal
        
        let Questnib = UINib(nibName: "QuesAnsCollectionCell", bundle: nil)
        self.quesAnsCollectionView.register(Questnib, forCellWithReuseIdentifier: "QuesAnsCollectionCell")
        self.quesAnsCollectionView.collectionViewLayout = QuesAnsoLayOut
        quesAnsCollectionView.layer.cornerRadius = 6
        quesAnsCollectionView.clipsToBounds = true
        self.profileImg.layer.cornerRadius = 10
        quesAnsCollectionView.isPagingEnabled = true
        self.getProfileDataAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func blockBtnAction(_ sender: UIButton) {
        
//        if self.isCommingSuperlike == "superlike" {
//            self.alertTitle = "Rport/Block"
//        }else{
//            self.alertTitle = "Rport/Block/Unmatch"
//        }
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let unmatchAction = UIAlertAction(title: "Unmatch", style: UIAlertAction.Style.default){
            UIAlertAction in
            let nextview = UnMatchActionPopUp.intitiateFromNib()
            let model = BackModel2()
            nextview.layer.cornerRadius = 20
            nextview.buttonYesHandler = {
                self.getunMatchAPI(friend_id: self.friendId, type: "1")
                model.closewithAnimation()
            }
            nextview.buttonNoHandler = {
               model.closewithAnimation()
            }
            model.show(view: nextview)
        }
        
        let ReportAction = UIAlertAction(title: "Report", style: UIAlertAction.Style.default){
            UIAlertAction in
            let nextview = ReportPopUp.intitiateFromNib()
            let model = ReportBackModel()
            nextview.layer.cornerRadius = 20
            nextview.buttonYesHandler = {
                if nextview.reportTxtFeild.text == "" {
                    self.view.makeToast(message: "Please enter report message")
                }else{
                    let message = nextview.reportTxtFeild.text!
                    nextview.reportTxtFeild.textColor = UIColor.black
                    self.getReportAPI(author_id: self.userID, message: message)
                    model.closewithAnimation()
                }
            }
            nextview.buttonNoHandler = {
               model.closewithAnimation()
            }
            model.show(view: nextview)
        }
        let BlockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.default){
            UIAlertAction in
//            let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
//            self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
            self.getBlockAPI(receiver_id: self.userID)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        alert.view.tintColor = UIColor.red
//        alert.addAction(ReportAction)
//        alert.addAction(BlockAction)
//        alert.addAction(cancelAction)
//        alert.addAction(unmatchAction)
        if self.isCommingSuperlike == "superlike" {
            alert.addAction(BlockAction)
            alert.addAction(ReportAction)
            alert.addAction(cancelAction)
        }else{
            alert.addAction(unmatchAction)
            alert.addAction(BlockAction)
            alert.addAction(ReportAction)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
        }
    //MARK:- Unmatch API
    func getunMatchAPI(friend_id: String, type: String){
        self.pleaseWait()
        if self.isComingMatch1 == "match" {
            self.isComingChat.removeAll()
        }
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(friend_id), forKey: "friend_id")
        dict.setValue(DataManager.getVal(type), forKey: "type")
        print(friend_id)
        let methodName = "friend/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            print(self.isCommingFromlikeToChat)
            if status == "1"{
                if self.isComingChat == "chat" {
                    if self.isCommingFromlikeToChat == "likeToChat" {
                        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.RootViewWithSideManu(vc)
                    }else{
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is MessageListVC {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
                }
                else if self.isComingMatch1 == "match"{
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    //MARK:- Report API
    func getReportAPI(author_id:String, message:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(author_id), forKey: "author_id")
        dict.setValue(DataManager.getVal(message), forKey: "message")

        let methodName = "report/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Block API
        func getBlockAPI(receiver_id:String){
            self.pleaseWait()
            print(self.isComingMatch1)
            if self.isComingMatch1 == "match" {
                self.isComingChat.removeAll()
            }
            print(self.isComingChat)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
            dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
            print(dict)
            let methodName = "blacklist/add"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                
                if status == "1"{
                    if self.isComingChat == "chat" {
                        if self.isCommingFromlikeToChat == "likeToChat" {
                            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                            self.RootViewWithSideManu(vc)
                        }else{
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                            for aViewController in viewControllers {
                                if aViewController is MessageListVC {
                                    self.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
                        }
                    }
                    else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            }
        }
    
    //MARK:- Profile API
    func getProfileDataAPI(){
        self.pleaseWait()
        
        HeaderImagePageController.isUserInteractionEnabled = false
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "current_user_id")
        dict.setValue(DataManager.getVal(self.UserDetailID), forKey: "user_id")
        print(self.user_id)
        print(self.UserDetailID)
        let methodName = "profile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.profile_Dict = DataManager.getVal(responseData?["profile"]) as! [String:Any]
                let dictt = DataManager.getVal(responseData?["user"]) as? NSDictionary
                self.userID = DataManager.getVal(dictt?["user_id"]) as? String ?? ""
                let build = DataManager.getVal(responseData?["build"]) as! [String:Any]
                let buildName = DataManager.getVal(build["name"]) as? String ?? ""
                self.friendId = DataManager.getVal(self.profile_Dict["friend_id"]) as? String ?? ""
                let cityName1 = DataManager.getVal(self.profile_Dict["city"]) as? String ?? ""
//                var components = cityName1.components(separatedBy: " ")
//                var components1 = components.removeFirst()
//                components1 = components1.replacingOccurrences(of: ",", with: "")
//                let cityName  = String(components1)
                
//                let city = DataManager.getVal(profile["city"]) as? String ?? ""
//                var components = city.components(separatedBy: " ")
//                var components1 = components.removeFirst()
//                components1 = components1.replacingOccurrences(of: ",", with: "")
//                print(components1)
                self.isblock = DataManager.getVal(self.profile_Dict["is_blocked"]) as? String ?? ""
//                self.profileDataArray = DataManager.getVal(responseData?["profile"]) as? [Any] ?? []
//                self.profileArray = DataManager.getVal(responseData?["profile"]) as! NSDictionary
                print(self.profileArray)
                if self.isblock == "1" {
                    self.likeBtnHeightConstant.constant = 0
                    self.superLikeBtnHeightConstant.constant = 0
                    self.crossBtnHeightConstant.constant = 0
                    self.videoCollectionHeightCons.constant = 0
                    self.buttonViewHeightConstrant.constant = 0
                    self.blockBtn.isHidden = true
                }else{
                    self.likeBtnHeightConstant.constant = 70
                    self.superLikeBtnHeightConstant.constant = 60
                    self.crossBtnHeightConstant.constant = 60
                    self.videoCollectionHeightCons.constant = 294
                    self.buttonViewHeightConstrant.constant = 163
                    self.blockBtn.isHidden = false
                }
                self.profileID = DataManager.getVal(self.profile_Dict["profile_id"]) as? String ?? ""
                print(self.profileID)
                self.userData = DataManager.getVal(responseData?["user"]) as! [String:Any]
                let interest = DataManager.getVal(responseData?["interest"]) as! [String:Any]
                self.pictureArray = DataManager.getVal(responseData?["picture_1"]) as? [Any] ?? []
                self.videoarray = DataManager.getVal(responseData?["video_1"]) as? [Any] ?? []
                print(self.videoarray)
                self.quesAnsArray = DataManager.getVal(responseData?["questions"]) as? [[String:Any]] ?? []
                
                if self.pictureArray.count != 0{
                    self.imageCollectionTopCons.constant = 35
                    self.imagesCollectionHeightCons.constant = 380
                    self.HeaderImagePageController.isHidden = false
                }else{
                    self.imageCollectionTopCons.constant = 0
                    self.imagesCollectionHeightCons.constant = 0
                    self.HeaderImagePageController.isHidden = true
                }
                if self.quesAnsArray.count != 0{
                    self.quesTopConstrants.constant = 12
                    self.quesHeightConstrants.constant = 189
                }else{
                    self.quesTopConstrants.constant = 0
                    self.quesHeightConstrants.constant = 0
                }
                if self.videoarray.count != 0{
                    self.videoCollectionTopCons.constant = 8
                    self.videoCollectionHeightCons.constant = 294
                    self.VideoPageController.isHidden = false
                }else{
                    self.videoCollectionTopCons.constant = 0
                    self.videoCollectionHeightCons.constant = 0
                    self.VideoPageController.isHidden = true
                }
                self.VideoCollectionView.reloadData()
                self.HeaderCollectionView.reloadData()
                self.quesAnsCollectionView.reloadData()
                let about = DataManager.getVal(self.profile_Dict["about"]) as? String ?? ""
                let age = DataManager.getVal(self.profile_Dict["age"]) as? String ?? ""
                let fullname = DataManager.getVal(self.profile_Dict["fullname"]) as? String ?? ""
                self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
                self.recieverName = DataManager.getVal(dict["fullname"]) as? String ?? ""
                self.recieverImage = DataManager.getVal(dict["image"]) as? String ?? ""
                let image = DataManager.getVal(self.profile_Dict["image"]) as? String ?? ""
                let ethnicityStatus = DataManager.getVal(responseData?["ethnicity"]) as! [String:Any]
                let ethnicity = DataManager.getVal(ethnicityStatus["name"]) as? String ?? ""
                let degreeStatus = DataManager.getVal(responseData?["degree"]) as! [String:Any]
                let degree = DataManager.getVal(degreeStatus["name"]) as? String ?? ""
                let religionStatus = DataManager.getVal(responseData?["religion"]) as! [String:Any]
                let religion = DataManager.getVal(religionStatus["name"]) as? String ?? ""
//                    self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
                print(self.profile_Dict)
                self.name.text = fullname
                let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
                let ageLang = lang == "en" ? kage : kThage
                self.age.text = "\(ageLang)-" + age
                if cityName1 == "" {
                    self.city.isHidden = true
                }else{
                    self.city.isHidden = false
                    self.city.text = cityName1
//                    self.city.text = "" + cityName + "  "
                }
                self.aboutUser.text = about
                Config().setimage(name: image, image: self.profileImg)
                self.MemberShipStatus = DataManager.getVal(self.profile_Dict["membership"]) as? String ?? ""
                
                self.is_superlike = DataManager.getVal(self.profile_Dict["is_superlike"]) as? String ?? ""
                self.is_like = DataManager.getVal(self.profile_Dict["is_like"]) as? String ?? ""
                self.is_friend = DataManager.getVal(self.profile_Dict["is_friend"]) as? String ?? ""
                
                if self.is_superlike == "1" || self.is_like == "1" || self.is_friend == "1"{
                    self.buttonViewHeightConstrant.constant = 0
                    self.buttonView.isHidden = true
                }else{
                    self.buttonViewHeightConstrant.constant = 163
                    self.buttonView.isHidden = false
                }
                if self.MemberShipStatus == "3"{
                    self.goldMemberIconBtn.isHidden = false
                }else{
                    self.goldMemberIconBtn.isHidden = true
                }
                let height_feet = DataManager.getVal(self.profile_Dict["height_feet"]) as? String ?? ""
                let height_inch = DataManager.getVal(self.profile_Dict["height_inch"]) as? String ?? ""
                var height = String()
                height = height_feet + "\("'")" + height_inch + "\("''")"
                let childrenStatus = DataManager.getVal(self.profile_Dict["have_children"]) as? String ?? ""
                var children = ""
                if childrenStatus == "1"{
                    children = "Yes, they sometimes live with me"
                }else if childrenStatus == "2"{
                    children = "Yes, they live with me"
                }else if childrenStatus == "3"{
                    children = "No"
                }
                let genderStatus = DataManager.getVal(responseData?["gender_str"]) as? String ?? ""
                let drinkingStatus = DataManager.getVal(responseData?["drinking"]) as! [String:Any]
                let drinkingname = DataManager.getVal(drinkingStatus["name"]) as? String ?? ""
                var drinking = ""
                if drinkingname == "On special occasion"{
                    drinking = "On special occasion"
                }else if drinkingname == "Once a week"{
                    drinking = "Once a week"
                }else if drinkingname == "Few times a week"{
                    drinking = "Few times a week"
                }else if drinkingname == "Daily"{
                    drinking = "Daily"
                }else if drinkingname == "Any"{
                    drinking = "Any"
                }
                
                let smokingStatus = DataManager.getVal(responseData?["smoking"]) as! [String:Any]
                let smokingname = DataManager.getVal(smokingStatus["name"]) as? String ?? ""
                print(smokingname)
                var smoking = ""
                if smokingname == "Non-smoker"{
                    smoking = "Non-smoker"
                }else if smokingname == "Occasional smoker"{
                    smoking = "Occasional smoker"
                }else if smokingname == "Smoker"{
                    smoking = "Smoker"
                }else if smokingname == "Trying to quit"{
                    smoking = "Trying to quit"
                }else if smokingname == "Any"{
                    smoking = "Any"
                }
                
                let likePetStatus = DataManager.getVal(interest["like_pet"]) as? String ?? ""
                let orientationStatus = DataManager.getVal(responseData?["orientation_str"]) as? String ?? ""
                let maritalStatus = DataManager.getVal(responseData?["marital"]) as! [String:Any]
                let maritalName = DataManager.getVal(maritalStatus["name"]) as? String ?? ""
                var marital = ""
                if maritalName == "Single"{
                    marital = "Single"
                }else if maritalName == "Married"{
                    marital = "Married"
                }else if maritalName == "Divorced"{
                    marital = "Divorced"
                }else if maritalName == "Separated"{
                    marital = "Separated"
                }else if maritalName == "Widowed"{
                    marital = "Widowed"
                }else if maritalName == "Open relationship"{
                    marital = "Open Rlationship"
                }else if maritalName == "Any"{
                    marital = "Any"
                }
                let workout = DataManager.getVal(interest["workout"]) as? String ?? ""
                self.titleArray = [
                    ["key": orientationStatus,"image": "orientation"],
                    
//                    ["key": genderStatus,"image": "gender"],
                    
                                ["key": ethnicity,"image": "ethnicity"],
                                ["key": religion,"image": "religion"],
                                ["key": degree,"image": "education"],
                                ["key": buildName,"image": "fit"],
                                ["key": height,"image": "height"],
                                ["key": children,"image": "child"],
                                ["key": drinking,"image": "drink"],
                                ["key": smoking,"image": "smoking-1"],
                                ["key": workout,"image": "Workout"],
                    
                                ["key": DataManager.getVal(interest["pet_str"]) as? String ?? "","image": "pat"],
                                ["key": DataManager.getVal(interest["music_str"]) as? String ?? "","image": "music"],
                    
                                ["key": DataManager.getVal(interest["sports_str"]) as? String ?? "","image": "sport"],
                                ["key": marital,"image": "Marital"],
                                ["key": DataManager.getVal(interest["ilikes_str"]) as? String ?? "","image": "like1"],
                                ["key": DataManager.getVal(interest["spendtime_str"]) as? String ?? "","image": "spend_time"],
                                ["key": DataManager.getVal(interest["vacation_str"]) as? String ?? "","image": "vacation"],
                                
                                ]
                print(self.titleArray)
                if self.titleArray.count != 0{
                    self.DetailCollectionViewTopConstant.constant = 20
//                    self.DetailCollectionViewHeightConstraint.constant = 700
                    let height = self.DetailCollectionView.contentSize.height
                    let hei = height * 36
//                    let collectionHeight = self.DetailCollectionView.frame.height
                    self.DetailCollectionViewHeightConstraint.constant = hei - 150
//                    self.DetailCollectionViewHeightConstraint.constant = self.DetailCollectionView.collectionViewLayout.collectionViewContentSize.height
//                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }else{
                    self.DetailCollectionViewTopConstant.constant = 0
                    self.DetailCollectionViewHeightConstraint.constant = 0
                }
                self.DetailCollectionView.reloadData()
//                self.DetailCollectionViewHeightConstraint.constant = CGFloat((self.titleArray.count/2)*40) + CGFloat((self.titleArray.count*5))
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    //MARK:- Superlike Button Action
    @IBAction func superlikeBtnAction(_ sender: PopBounceButton) {
        let Rid = Int(self.recieverId) ?? 0
        let Uid = Int(self.user_id) ?? 0
        if Rid < Uid {
            self.room_id = recieverId + "-" + user_id
            print(self.room_id)
        }else{
            self.room_id = user_id + "-" + recieverId
            print(self.room_id)
        }
        
        self.Liketype = "2"
        SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: self.recieverId, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: self.Liketype, Room_id: "1")
    }
    //MARK:- Like Button Action
    @IBAction func likeBtnAction(_ sender: PopBounceButton) {
        let Rid = Int(self.recieverId) ?? 0
        let Uid = Int(self.user_id) ?? 0
        if Rid < Uid {
            self.room_id = recieverId + "-" + user_id
            print(self.room_id)
        }else{
            self.room_id = user_id + "-" + recieverId
            print(self.room_id)
        }
        self.Liketype = "1"
        SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: self.recieverId, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: self.Liketype, Room_id: room_id)
    }
    //MARK:- Dislike Button Action
    @IBAction func dislikeBtnAction(_ sender: PopBounceButton) {
        let Rid = Int(self.recieverId) ?? 0
        let Uid = Int(self.user_id) ?? 0
        if Rid < Uid {
            self.room_id = recieverId + "-" + user_id
            print(self.room_id)
        }else{
            self.room_id = user_id + "-" + recieverId
            print(self.room_id)
        }
        self.Liketype = ""
        SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: self.recieverId, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: self.Liketype, Room_id: room_id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.HeaderCollectionView{
            HeaderImagePageController.numberOfPages = self.pictureArray.count
            HeaderImagePageController.isHidden = !(self.pictureArray.count > 1)
            return self.pictureArray.count
        }else if collectionView == self.VideoCollectionView{
            VideoPageController.numberOfPages = self.videoarray.count
            VideoPageController.isHidden = !(self.videoarray.count > 1)
            return self.videoarray.count
        }else if collectionView == self.DetailCollectionView{
            return self.titleArray.count
        }else{
            quesPageController.isUserInteractionEnabled = false
            quesPageController.numberOfPages = self.quesAnsArray.count
            quesPageController.isHidden = !(self.quesAnsArray.count > 1)
            return self.quesAnsArray.count
        }
    }
    
    func getThumbnailImage(url: URL, completion: @escaping ((_ image : UIImage?)-> Void)){
        DispatchQueue.global().async {
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let time: CMTime = CMTimeMakeWithEpoch(value: 2, timescale: 2, epoch: 1)
            do {
                let cgthubImahe = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                
                let thubimage = UIImage(cgImage: cgthubImahe)
                
                DispatchQueue.main.async {
                    completion(thubimage)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.HeaderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HeaderCollectionCell
            cell.tag = indexPath.row
            cell.clipsToBounds = true
            Config().setimage(name: DataManager.getVal(self.pictureArray[indexPath.item]) as? String ?? "", image: cell.imgView)
            cell.imgView.layer.cornerRadius = 8
            return cell
        }else if collectionView == self.VideoCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCell", for: indexPath) as! VideoCollectionCell
            cell.tag = indexPath.row
            cell.clipsToBounds = true
            let url = DataManager.getVal(videoarray[indexPath.item]) as? String ?? ""
            let videoURL = URL(string: url)!
//            cell.player = AVPlayer(url: videoURL)
//            cell.avpController = AVPlayerViewController()
//            cell.avpController.player = cell.player
//            cell.avpController.view.frame.size.width = cell.imgView.frame.size.width
//            cell.avpController.view.frame.size.height = cell.imgView.frame.size.height
//            self.addChild(cell.avpController)
//            cell.imgView.layer.cornerRadius = 8
//            cell.imgView.addSubview(cell.avpController.view)
//            if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
//                cell.player.pause()
//            }else if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.paused) {
//                cell.player.play()
//            }
//            NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(_:successfully:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//            cell.playButton.tag = indexPath.item
            
            getThumbnailImage(url: videoURL) { (thubnailImage) in
                cell.imgView.image = thubnailImage
            }
            cell.playButton.addTarget(self, action: #selector(playvideo(_:)), for: .touchUpInside)
            return cell
        }else if collectionView == self.DetailCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as! DetailCollectionCell
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
//            cell.layer.borderWidth = 1
//            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            let dict = DataManager.getVal(self.titleArray[indexPath.row]) as! [String: Any]
            cell.titleLbl.text = DataManager.getVal(dict["key"]) as? String ?? ""
            cell.imgView.image = UIImage(named: DataManager.getVal(dict["image"]) as? String ?? "")
            if cell.titleLbl.text == ""{
                cell.imgView.isHidden = true
            }else{
                cell.imgView.isHidden = false
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuesAnsCollectionCell", for: indexPath) as! QuesAnsCollectionCell
            let dict = DataManager.getVal(quesAnsArray[indexPath.row]) as! [String: Any]
            cell.questionLbl.text = "Q. " + (DataManager.getVal(dict["question"]) as? String ?? "")
            cell.answerLbl.text = "A. " + (DataManager.getVal(dict["answer"]) as? String ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.HeaderCollectionView{
            self.HeaderImagePageController.currentPage = indexPath.item
        }else if collectionView == self.VideoCollectionView{
            self.VideoPageController.currentPage = indexPath.item
        }else if collectionView == self.quesAnsCollectionView{
            self.quesPageController.currentPage = indexPath.item
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            //
            switch collectionView.tag {
            case 1:
                HeaderImagePageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 2:
                VideoPageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 3:
                quesPageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.height)
            default:
                let whichCollectionViewScrolled = "unknown"
                print(whichCollectionViewScrolled)
            }
        } else{
            print("cant cast")
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            switch collectionView.tag {
            case 1:
                HeaderImagePageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 2:
                VideoPageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 3:
                quesPageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.height)
            default:
                let whichCollectionViewScrolled = "unknown"
                print(whichCollectionViewScrolled)
            }
        }else{
            print("cant cast")
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Video Ended")
    }
    
    
    @objc func playvideo(_ sender:UIButton) {
        let url = DataManager.getVal(videoarray[sender.tag]) as? String ?? ""
        let videoURL = URL(string: url)
        player = AVPlayer(url: videoURL!)
        avpController.player = player
        self.present(avpController, animated: true, completion: nil)
        self.avpController.player?.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.DetailCollectionView{
            return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.DetailCollectionView{
            return 5
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.DetailCollectionView{
            return 5
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.DetailCollectionView{
            let dict = DataManager.getVal(self.titleArray[indexPath.row]) as! [String: Any]
            let text = DataManager.getVal(dict["key"]) as? String ?? ""
            var cellWidth = CGFloat()
            if text == "" {
                cellWidth = 0
            }else{
                cellWidth = (text as AnyObject).size(withAttributes:[.font: UIFont.systemFont(ofSize:17.0)]).width + 50
                if cellWidth > screenWidth - 30 {
                    cellWidth = screenWidth - 70
                     height1 = 45
                }else{
                    height1 = 35
                    cellWidth = (text as AnyObject).size(withAttributes:[.font: UIFont.systemFont(ofSize:17.0)]).width + 50
                }
            }
            return CGSize(width: cellWidth, height: height1)
        }else if collectionView == self.HeaderCollectionView{
            return CGSize(width: screenWidth-50, height: 380)
        }else if collectionView == self.quesAnsCollectionView{
            return CGSize(width: screenWidth-50, height: 190)
        }else{
            return CGSize(width: screenWidth-50, height: 200)
        }
    }
    
}
