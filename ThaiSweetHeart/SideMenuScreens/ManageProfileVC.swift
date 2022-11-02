//
//  ManageProfileVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 24/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import PopBounceButton
import SDWebImage
import AVKit
import AVFoundation
import CoreLocation
import AlignedCollectionViewFlowLayout

@available(iOS 13.0, *)

class ManageProfileVC: BaseViewSideMenuController,SlideMenuControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
    @IBOutlet weak var QsnPageController: UIPageControl!
    
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    @IBOutlet weak var DetailCollectionViewHeightConstraint: NSLayoutConstraint!//40
    
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var VideoPageController: UIPageControl!
    @IBOutlet weak var quesAnsCollectionView: UICollectionView!
    
    @IBOutlet weak var quesTopConstrants: NSLayoutConstraint!
    @IBOutlet weak var quesHeightConstrants: NSLayoutConstraint!
    
    @IBOutlet weak var imageCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var imagesCollectionHeightCons: NSLayoutConstraint!
    @IBOutlet weak var detailCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var videoCollectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var videoCollectionHeightCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var superLikeBtnTop: PopBounceButton!
    @IBOutlet weak var superLikeBtnBottom: PopBounceButton!
    @IBOutlet weak var likeBtn: PopBounceButton!
    @IBOutlet weak var nopeBtn: PopBounceButton!
    
    fileprivate var selectedCell: Int = 0
    var categoriesArray = [String]()
    var categoriesImageArray = [String]()
    var profileDataArray = [Any]()
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
    var quesAnsArray = [[String:Any]]()
    var cityName = String()
    var petArray = String()
    var height1 = CGFloat()
    var width1 = CGFloat()
    var menuBarBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        
        QsnPageController.isUserInteractionEnabled = false
        HeaderImagePageController.isUserInteractionEnabled = false
        VideoPageController.isUserInteractionEnabled = false
        let flowLayout = DetailCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        flowLayout?.horizontalAlignment = .left
//        flowLayout?.estimatedItemSize = .init(width: 100, height: 40)
//        let lat = Config().AppUserDefaults.value(forKey: "LAT")
//        let long = Config().AppUserDefaults.value(forKey: "LONG")
//        if lat == nil {
//            cityView.isHidden = true
//        }else{
//            getAddressFromLatLon(pdblLatitude: lat as! String, withLongitude: long as! String)
//            cityView.isHidden = false
//        }
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Details"
        self.navigationItem.titleView = bar_title
        
        let ProfileImage : UIImage? = UIImage(named:"edit_profile_icon")!.withRenderingMode(.alwaysOriginal)
        let ProfileButton = UIBarButtonItem(image: ProfileImage, style: .plain, target: self, action: #selector(self.ProfileButton_Action))
        self.navigationItem.rightBarButtonItems = [ProfileButton]
        
        self.age.layer.cornerRadius = 8
        self.age.layer.masksToBounds = true
        self.cityView.layer.cornerRadius = 10
        self.city.layer.masksToBounds = true
        
        let LayOut = UICollectionViewFlowLayout()
        LayOut.itemSize = CGSize(width: screenWidth-60, height: 460)
        LayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LayOut.minimumInteritemSpacing = 0
        LayOut.minimumLineSpacing = 0
        LayOut.scrollDirection = .horizontal
        
        let Headernib = UINib(nibName: "HeaderCollectionCell", bundle: nil)
        self.HeaderCollectionView.register(Headernib, forCellWithReuseIdentifier: "HeaderCollectionCell")
        self.HeaderCollectionView.collectionViewLayout = LayOut
        self.HeaderCollectionView.layer.cornerRadius = 8
        self.HeaderCollectionView.tag = 1
        
        let VideoLayOut = UICollectionViewFlowLayout()
        VideoLayOut.itemSize = CGSize(width: screenWidth-55, height: 200)
        VideoLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        VideoLayOut.minimumInteritemSpacing = 0
        VideoLayOut.minimumLineSpacing = 0
        VideoLayOut.scrollDirection = .horizontal
        
        let Videonib = UINib(nibName: "VideoCollectionCell", bundle: nil)
        self.VideoCollectionView.register(Videonib, forCellWithReuseIdentifier: "VideoCollectionCell")
        self.VideoCollectionView.collectionViewLayout = VideoLayOut
        self.VideoCollectionView.layer.cornerRadius = 8
        self.VideoCollectionView.layer.cornerRadius = 8
        self.VideoCollectionView.tag = 2
        
        let detail_layout = UICollectionViewFlowLayout()
                detail_layout.itemSize = CGSize(width: self.screenWidth/2-30, height: 40)
        detail_layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detail_layout.minimumInteritemSpacing = 0
        detail_layout.minimumLineSpacing = 8
        detail_layout.scrollDirection = .vertical
        let Detailnib = UINib(nibName: "DetailCollectionCell", bundle: nil)
        self.DetailCollectionView.register(Detailnib, forCellWithReuseIdentifier: "DetailCollectionCell")
//        self.DetailCollectionView.collectionViewLayout = detail_layout
        self.DetailCollectionView.layer.cornerRadius = 8
        
        let QuesAnsoLayOut = UICollectionViewFlowLayout()
        QuesAnsoLayOut.itemSize = CGSize(width: screenWidth-55, height: 190)
        QuesAnsoLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        QuesAnsoLayOut.minimumInteritemSpacing = 5
        QuesAnsoLayOut.minimumLineSpacing = 5
        QuesAnsoLayOut.scrollDirection = .horizontal
        
        let Questnib = UINib(nibName: "QuesAnsCollectionCell", bundle: nil)
        self.quesAnsCollectionView.register(Questnib, forCellWithReuseIdentifier: "QuesAnsCollectionCell")
        self.quesAnsCollectionView.collectionViewLayout = QuesAnsoLayOut
        self.quesAnsCollectionView.isPagingEnabled = true
        self.quesAnsCollectionView.layer.cornerRadius = 6
        quesAnsCollectionView.clipsToBounds = true
        
        self.profileImg.layer.cornerRadius = 10
        
        self.getProfileDataAPI()
    }
    
    @objc func ProfileButton_Action(_ selector: UIBarButtonItem){
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        
        self.onlyPushViewController(vc)
    }
    //MARK:- GetAddressFromLatLong
    
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let lat: Double = Double("\(pdblLatitude)")!
//            let lon: Double = Double("\(pdblLongitude)")!
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = lat
//            center.longitude = lon
//
//            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//            ceo.reverseGeocodeLocation(loc, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                    }
//                    let pm = placemarks! as [CLPlacemark]
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        print(pm.country as Any)
//                        print(pm.locality as Any)
//                        self.city.text = pm.locality
//                        print(pm.subLocality as Any)
//                        print(pm.thoroughfare as Any)
//                        print(pm.postalCode as Any)
//                        print(pm.subThoroughfare as Any)
//                        var addressString : String = ""
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
//
//
//                        print(addressString)
//                  }
//            })
//
//        }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
        func getProfileDataAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        //        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")0
        
        let methodName = "profile"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let profile = DataManager.getVal(responseData?["profile"]) as! [String:Any]
                let build = DataManager.getVal(responseData?["build"]) as! [String:Any]
                let buildName = DataManager.getVal(build["name"]) as? String ?? ""
                let city = DataManager.getVal(profile["city"]) as? String ?? ""
                
//                var components = city.components(separatedBy: " ")
//                var components1 = components.removeFirst()
//                components1 = components1.replacingOccurrences(of: ",", with: "")
//                print(components1)
//                self.cityName = String(components1)
                
                self.city.text = city
                if city == "" {
                    self.cityView.isHidden = true
                }else{
                    self.cityView.isHidden = false
                }
//                if let city = DataManager.getVal(responseData?["country"]) as? [String:Any]{
//                    self.cityName = DataManager.getVal(city["name"]) as? String ?? ""
//                    self.city.text = "" + self.cityName + "  "
//                }
                let interest = DataManager.getVal(responseData?["interest"]) as! [String:Any]
                self.pictureArray = DataManager.getVal(responseData?["picture_1"]) as? [Any] ?? []
                self.videoarray = DataManager.getVal(responseData?["video_1"]) as? [Any] ?? []
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
                    self.QsnPageController.isHidden = false
                }else{
                    self.quesTopConstrants.constant = 0
                    self.quesHeightConstrants.constant = 0
                    self.QsnPageController.isHidden = true
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
                let about = DataManager.getVal(profile["about"]) as? String ?? ""
                let age = DataManager.getVal(profile["age"]) as? String ?? ""
                let fullname = DataManager.getVal(profile["fullname"]) as? String ?? ""
                let image = DataManager.getVal(profile["image"]) as? String ?? ""
                let ethnicityStatus = DataManager.getVal(responseData?["ethnicity"]) as! [String:Any]
                let ethnicity = DataManager.getVal(ethnicityStatus["name"]) as? String ?? ""
                print(ethnicity)//ok
                let degreeStatus = DataManager.getVal(responseData?["degree"]) as! [String:Any]
                let degree = DataManager.getVal(degreeStatus["name"]) as? String ?? ""
                print(degree)
                let religionStatus = DataManager.getVal(responseData?["religion"]) as! [String:Any]
                let religion = DataManager.getVal(religionStatus["name"]) as? String ?? ""
                print(religion) //ok
                //                    self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
                self.name.text = fullname
                let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
                let ageLang = lang == "en" ? kage : kThage
                self.age.text = "\(ageLang) " + age
                
                self.aboutUser.text = about
                Config().setimage(name: image, image: self.profileImg)
                self.MemberShipStatus = DataManager.getVal(profile["membership"]) as? String ?? ""
                if self.MemberShipStatus == "3"{
                    self.goldMemberIconBtn.isHidden = false
                }else{
                    self.goldMemberIconBtn.isHidden = true
                }
                let height_feet = DataManager.getVal(profile["height_feet"]) as? String ?? ""
                let height_inch = DataManager.getVal(profile["height_inch"]) as? String ?? ""
                var height = String()
                height = height_feet + "\("'")" + height_inch + "\("''")"
                let childrenStatus = DataManager.getVal(profile["have_children"]) as? String ?? ""
                print(childrenStatus) //ok
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
                print(drinkingname) //ok
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
                let orientationStatus = DataManager.getVal(responseData?["orientation_str"]) as? String ?? ""
                print(orientationStatus)
                let maritalStatus = DataManager.getVal(responseData?["marital"]) as! [String:Any]
                let maritalName = DataManager.getVal(maritalStatus["name"]) as? String ?? ""
                print(maritalName)
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
                print(workout) //ok
                self.titleArray = [["key": orientationStatus,"image": "orientation"],["key": ethnicity,"image": "ethnicity"],
                                   ["key": religion,"image": "religion"],
                                   ["key": degree,"image": "education"],
//                                   ["key": genderStatus,"image": "gender"],
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
                                   ["key": DataManager.getVal(interest["vacation_str"]) as? String ?? "","image": "vacation"]
                                   ]
                print(self.titleArray)
                
                if self.titleArray.count != 0{
                    self.detailCollectionTopCons.constant = 20
//                    self.DetailCollectionViewHeightConstraint.constant = 700
                    let height = self.DetailCollectionView.contentSize.height
                    let hei = height * 36
//                    let collectionHeight = self.DetailCollectionView.frame.height
                    self.DetailCollectionViewHeightConstraint.constant = hei - 120
                    
//                    self.DetailCollectionViewHeightConstraint.constant = self.DetailCollectionView.collectionViewLayout.collectionViewContentSize.height
//                    self.view.setNeedsLayout()
                }else{
                    self.detailCollectionTopCons.constant = 0
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
            QsnPageController.numberOfPages = self.quesAnsArray.count
            QsnPageController.isHidden = !(self.quesAnsArray.count > 1)
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
                        cell.player = AVPlayer(url: videoURL)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            playerLayer.frame = cell.contentView.frame
//            playerLayer.frame = cell.imgView.bounds
//            playerLayer.videoGravity = .resizeAspect
//            cell.avpController = AVPlayerViewController()
//            cell.avpController.player = cell.player
//            cell.avpController.view.frame.size.width = cell.imgView.frame.size.width
//            cell.avpController.view.frame.size.height = cell.imgView.frame.size.height
//            self.addChild(cell.avpController)
//            self.avpController.view.frame = cell.imgView.frame;
//            cell.imgView.layer.cornerRadius = 8
//            cell.imgView.addSubview(cell.avpController.view)
//            if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
////                cell.player.pause()
//            }else if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.paused) {
////                cell.player.play()
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
            cell.backgroundColor = UIColor.white
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
            self.QsnPageController.currentPage = indexPath.item
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            switch collectionView.tag {
            case 1:
                HeaderImagePageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 2:
                VideoPageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            case 3:
                QsnPageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
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
                QsnPageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
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
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.VideoCollectionView)
//        let indexPath = self.VideoCollectionView.indexPathForItem(at: buttonPosition)
//        let cell = self.VideoCollectionView.cellForItem(at: indexPath!) as! VideoCollectionCell
//        VideoCollectionView.reloadData()
        let url = DataManager.getVal(videoarray[sender.tag]) as? String ?? ""
        let videoURL = URL(string: url)
        player = AVPlayer(url: videoURL!)
        avpController.player = player
        self.present(avpController, animated: true, completion: nil)
        self.avpController.player?.play()
//        cell.player = AVPlayer(url: videoURL!)
//        cell.avpController = AVPlayerViewController()
//        cell.avpController.player = player
//        cell.avpController.view.frame.size.width = cell.imgView.frame.size.width
//        cell.avpController.view.frame.size.height = cell.imgView.frame.size.height
//        self.addChild(cell.avpController)
//        if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
//            cell.player.pause()
//        }else if(cell.player.timeControlStatus == AVPlayer.TimeControlStatus.paused) {
//            cell.player.play()
//        }
       // NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(_:successfully:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
       // cell.player.play()
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
            return CGSize(width: screenWidth-55, height: 460)
        }else if collectionView == self.quesAnsCollectionView{
            return CGSize(width: screenWidth-55, height: 190)
        }else{
            return CGSize(width: screenWidth-55, height: 200)
        }
    }
    
}
