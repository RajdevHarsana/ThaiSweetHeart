//
//  HomeVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import PopBounceButton
import SDWebImage
import AVKit
import AVFoundation
import Koloda
import pop
import AMPopTip
import AlignedCollectionViewFlowLayout

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

@available(iOS 13.0, *)
class HomeVC: BaseViewSideMenuController,SlideMenuControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AVPlayerViewControllerDelegate {
    
    //MARK:- IBOutlates
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var cardView: CustomKolodaView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var NoDataImage: UIImageView!
    @IBOutlet weak var NoDataLbl: UILabel!
    
    
    //MARK:- Variables
    fileprivate var selectedCell: Int = 0
    var categoriesArray = [String]()
    var categoriesImageArray = [String]()
    var profileDataArray = [Any]()
    var titleArray = [[String: Any]]()
    var pictureArray = [String]()
    var videoarray = [String]()
    var MemberShipStatus = String()
    private var cardModels = [TinderCardModel]()
    var avpController = AVPlayerViewController()
    var player = AVPlayer()
    var flag_comingfromLogin1 = Bool()
    var recieverId = String()
    var recieverName = String()
    var recieverImage = String()
    var methodName = String()
    var swipeCross = String()
    var arr_data = ["abc","pqr","stu","xyz","mno","qwerty","yahhooo"]
    var swipeUserId = [String]()
    var swipeUserName = [String]()
    var swipeUserImage = [String]()
    var isComingChat = String()
    
    var Notification_Button = MIBadgeButton()
    var Notifibutton = UIBarButtonItem()
    var Chat_Button = MIBadgeButton()
    var Chatbutton = UIBarButtonItem()
    var swipeType = String()
    var reciever_id = String()
    var isMembership = String()
    let popTip = PopTip()
    var Liketype = String()
    var isMatch = String()
    var room_id = String()
    var makeTost = String()
    var helloWorldTimer:Timer!
    var videoStr = [String]()
    
    //MARK:- View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.makeTost == "1" {
            self.view.makeToast(message: "You have successfully subscribed our plan")
            self.makeTost = ""
        }
        
        self.isMatch = "0"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "homeNavigationBarImg.png"), for: .default)
//        let flowLayout = habitsCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
//        flowLayout?.horizontalAlignment = .left
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.categoriesImageArray = ["suggested","match","gold","explore","online","new","nearbyme"]
//        self.categoriesImageArray = ["color-suggested","online","new","crown-tab","match","nea-by-me","search-icon"]
        if lang == "en"{
            self.categoriesArray = [kSuggested,kMatch,kGold,kExplore,kOnline,kNew,kNearBy]
        }else{
            self.categoriesArray = [kThSuggested,kThMatch,kThGold,kThexplore,kThOnline,kThNew,kThNearBy]
        }
        
        self.Liketype = "1"
        let logo = UIImage(named: "icon")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.titleView?.alignmentRect(forFrame: CGRect(x: 0, y: 0,width: 40,height: 35))
        
        self.helloWorldTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
        
//        let ChatImage : UIImage? = UIImage(named:"Chat")!.withRenderingMode(.alwaysOriginal)
        let NotificationImage : UIImage? = UIImage(named:"notification")!.withRenderingMode(.alwaysOriginal)
//        let SearchImage : UIImage? = UIImage(named:"SearchWhite")!.withRenderingMode(.alwaysOriginal)
//        let AppImage : UIImage? = UIImage(named:"icon")!.withRenderingMode(.alwaysOriginal)
        
//        let ChatButton = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(self.ChatButton_Action))
        
        let rightImage = UIImage(named: "Chat")
        let rightFrameimg = CGRect(x: 0, y: 0,width: 55,height: 30)
        self.Chat_Button.frame = rightFrameimg
        self.Chat_Button.setImage(rightImage, for: UIControl.State())
        self.Chat_Button.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        self.Chat_Button.backgroundColor = .clear
        self.Chat_Button.badgeTextColor = UIColor.red
        self.Chat_Button.badgeBackgroundColor = UIColor.yellow

        self.Chat_Button.addTarget(self, action: #selector(self.ChatButton_Action), for: UIControl.Event.touchUpInside)
        
        self.Chatbutton.customView = self.Chat_Button
        //self.navigationItem.rightBarButtonItem = self.Notifibutton
        let NotificationButton = UIBarButtonItem(image: NotificationImage, style: .plain, target: self, action: #selector(self.NotificationButton_Action))
        
        let rightNotiImage = UIImage(named: "heart")
        let rightNotiFrameimg = CGRect(x: 0, y: 0,width: 55,height: 30)
        self.Notification_Button.frame = rightNotiFrameimg
        self.Notification_Button.setImage(rightNotiImage, for: UIControl.State())
        self.Notification_Button.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        self.Notification_Button.backgroundColor = .clear
        self.Notification_Button.badgeTextColor = UIColor.red
        self.Notification_Button.badgeBackgroundColor = UIColor.yellow

        self.Notification_Button.addTarget(self, action: #selector(self.NotificationButton_Action), for: UIControl.Event.touchUpInside)
        self.Notifibutton.customView = self.Notification_Button
        
//        let SearchButton = UIBarButtonItem(image: SearchImage, style: .plain, target: self, action: #selector(self.SearchButton_Action))
//        let AppButton = UIBarButtonItem(image: AppImage, style: .plain, target: self, action: #selector(self.AppButton_Action))
        
        self.navigationItem.rightBarButtonItems = [self.Chatbutton, self.Notifibutton]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 81)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let nib = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        self.CategoryCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        self.CategoryCollectionView.collectionViewLayout = layout
        
        self.swipeCross = Config().AppUserDefaults.value(forKey: "SwipeCount") as? String ?? ""
        self.homeAPI(method_name: "profile/home")
        self.swipeType = "1"
        if self.flag_comingfromLogin1 == true{
            let nextview = WelcomePopUp.intitiateFromNib()
            let model = BackModel()
            nextview.layer.cornerRadius = 20
            nextview.buttonCancelHandler = {
               model.closewithAnimation()
            }
            model.show(view: nextview)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.helloWorldTimer.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "homeNavigationBarImg.png"), for: .default)
        
        super.viewWillAppear(animated)
        sayHello()
        SocketIoManagerNotification.sharedInstance.socket.connect(timeoutAfter: 2.0) {
            print("time _ out")
            SocketIoManagerNotification.sharedInstance.establishConnection()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SocketIoManagerNotification.sharedInstance.establishConnection()
        NotificationCenter.default.addObserver(self, selector: #selector(self.new_showLikeMessage(_:)), name: NSNotification.Name(rawValue: "new_message_coming"), object: nil)
    }
    
    @objc func new_showLikeMessage(_ notification: NSNotification) {
        
        print("new message aaya")
        var dict = NSMutableDictionary()
        dict = notification.object as! NSMutableDictionary
        let reciever_ID = DataManager.getVal(dict["receiver_id"]) as? String ?? ""
        let reciever_Name = DataManager.getVal(dict["receiver_name"]) as? String ?? ""
        let reciever_Image = DataManager.getVal(dict["receiver_image"]) as? String ?? ""
        let senderId = DataManager.getVal(dict["sender_id"]) as? String ?? ""
        let isFriend = DataManager.getVal(dict["is_friend"]) as? String ?? ""
        let notiType = DataManager.getVal(dict["notification_type"]) as? String ?? ""
        let room_Id = DataManager.getVal(dict["room_id"]) as? String ?? ""
        print(dict)
//        let image = DataManager.getVal(dict["sender_image"]) as? String ?? ""
//        let userName = DataManager.getVal(dict["sender_name"]) as? String ?? ""
        if notiType == "1"{
            if isFriend == "1" && self.user_id == senderId && reciever_ID == self.recieverId {
                if membershiptype == "3" {
                    let nextview = SwipeMatchPopUp.intitiateFromNib()
                    let model = BackModel1()
                    nextview.layer.cornerRadius = 20
                    nextview.sendMsgBtn.layer.cornerRadius = 8
                    nextview.keepSwipingBtn.layer.cornerRadius = 8
                    nextview.sendMsgHandler = {
                        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
                        vc.room_id = room_Id
                        vc.imagestr = reciever_Image
                        vc.UserName = reciever_Name
                        vc.m_recieverId = reciever_ID
                        vc.member = self.isMembership
                        print(vc.member)
                        vc.isComingMatch = "match"
                        print(vc.member)
                        print(self.isMembership)
                        self.onlyPushViewController(vc)
                        model.closewithAnimation()
                    }
                    nextview.KeepSwipingHandler = {
                        model.closewithAnimation()
                    }
                    model.show(view: nextview)
                }else{
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("Buy", backgroundColor: UIColor.systemPink){
                        let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                        detailVC.comeFromHome = "yes"
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                    }
                    alert.addButton("Cancel", backgroundColor: UIColor.black){
                        print("NO")
                    }
                    alert.showEdit("Matched Successfully", subTitle: "Congrats! You both liked each other. To further intiate chat please buy our membership plan and unlock more features.")
                }
            }else{
                let PopUp = UserDefaults.standard.value(forKey: "PopUp") as? String
                if PopUp == "popshow" {
                    UserDefaults.standard.removeObject(forKey: "PopUp")
                }else{
                    let model =  DynamicsidemenuModel()
                    let nextView = GoldLikePopUp.intitiateFromNib()
                    nextView.buttonDoneHandler = {
                        let detailVC = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
                        detailVC.memberShipe = membershiptype
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                        model.closewithAnimation()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        model.closewithAnimation()
                    }
                    model.show(view: nextView)
                }
            }
        }else{
            if membershiptype == "3" {
                let PopUp = UserDefaults.standard.value(forKey: "PopUp") as? String
                if PopUp == "popshow" {
                    UserDefaults.standard.removeObject(forKey: "PopUp")
                }else{
                    let model = DynamicsidemenuModel()
                    let nextView = GoldLikePopUp.intitiateFromNib()
                    nextView.buttonDoneHandler = {
                        let detailVC = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
                        detailVC.memberShipe = membershiptype
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                        model.closewithAnimation()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        model.closewithAnimation()
                    }
                    model.show(view: nextView)
                }
            }else{
                let model =  DynamicsidemenuModel()
                let nextView = FreeUserLikePopUp.intitiateFromNib()
                nextView.buttonDoneHandler = {
                    let detailVC = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
                    detailVC.memberShipe = membershiptype
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                    model.closewithAnimation()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    model.closewithAnimation()
                }
                model.show(view: nextView)
            }
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "new_message_coming"), object: nil)
    }

    
    @objc func sayHello(){
//        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        dict.setValue(DataManager.getVal(lang), forKey: "lang")
        
        let methodName = "profile/counts"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.Notification_Button.badgeString = DataManager.getVal(responseData?["likeCount"]) as? String ?? ""
                if self.Notification_Button.badgeString == "0"{
//                    self.Notification_Button.isHidden = true
                    self.Notification_Button.badgeTextColor = UIColor.clear
                    self.Notification_Button.badgeBackgroundColor = UIColor.clear
                }else{
//                    self.Notification_Button.isHidden = false
                    self.Notification_Button.badgeTextColor = UIColor.white
                    self.Notification_Button.badgeBackgroundColor = UIColor.red
                }
                
                self.Chat_Button.badgeString = DataManager.getVal(responseData?["chat"]) as? String ?? ""
                if self.Chat_Button.badgeString == "0"{
//                    self.Chat_Button.isHidden = true
                    self.Chat_Button.badgeTextColor = UIColor.clear
                    self.Chat_Button.badgeBackgroundColor = UIColor.clear
                }else{
//                    self.Chat_Button.isHidden = false
                    self.Chat_Button.badgeTextColor = UIColor.white
                    self.Chat_Button.badgeBackgroundColor = UIColor.red
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
        
    @objc func blockBtnAction(_ sender: UIButton) {
        let alert : UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let ReportAction = UIAlertAction(title: "Report", style: UIAlertAction.Style.default){
            UIAlertAction in
            let nextview = ReportPopUp.intitiateFromNib()
            let model = ReportBackModel()
            nextview.layer.cornerRadius = 20
            nextview.buttonYesHandler = {
                if nextview.reportTxtFeild.text == "" {
                    self.view.makeToast(message: "Please enter report message")
                }else{
                    let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
                    let author_id = DataManager.getVal(dict["user_id"]) as? String ?? ""
                    let message = nextview.reportTxtFeild.text!
                    self.getReportAPI(author_id: author_id, message: message)
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
            let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
            let recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
            self.getBlockAPI(receiver_id: recieverId)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        alert.view.tintColor = UIColor.red
        alert.addAction(ReportAction)
        alert.addAction(BlockAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
                self.view.makeToast(message: message)
                self.homeAPI(method_name: self.methodName)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Block API
    func getBlockAPI(receiver_id:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
        
        let methodName = "blacklist/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.view.makeToast(message: message)
                self.homeAPI(method_name: self.methodName)
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    func homeAPI(method_name: String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        print(lat)
        print(Long)
        
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(lat), forKey: "lat")
        dict.setValue(DataManager.getVal(Long), forKey: "long")

        print(latNew)
        print(longNew)
        methodName = method_name
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.profileDataArray.removeAll()
                self.videoarray.removeAll()
                self.pictureArray.removeAll()
                self.profileDataArray = DataManager.getVal(responseData?["profile"]) as? [Any] ?? []
//                let dict = DataManager.getVal(responseData?[""]) as? [String: Any]
                print(self.profileDataArray)
                self.cardModels.removeAll()
                
                cardView.isHidden = false
                cardView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
                cardView.countOfVisibleCards = kolodaCountOfVisibleCards
                cardView.delegate = self
                cardView.dataSource = self
                cardView.reloadData()
                cardView.animator = BackgroundKolodaAnimator(koloda: cardView)
                
                self.NoDataLbl.isHidden = true
                self.NoDataImage.isHidden = true
                
            }else if status == "0"{
                cardView.isHidden = true
//                self.SwipeView.isHidden = true
                self.NoDataLbl.isHidden = false
                self.NoDataImage.isHidden = false
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @objc func ChatButton_Action(_ selector: UIBarButtonItem){
        let vc = MessageListVC(nibName: "MessageListVC", bundle: nil)
        self.onlyPushViewController(vc)
    }
    @objc func NotificationButton_Action(_ selector: UIBarButtonItem){
        
                let vc = ConnectionRequestVC(nibName: "ConnectionRequestVC", bundle: nil)
               self.onlyPushViewController(vc)
//        let vc = NotificationVC(nibName: "NotificationVC", bundle: nil)
//        self.onlyPushViewController(vc)
    }
    @objc func SearchButton_Action(_ selector: UIBarButtonItem){
        let vc = UserSearchVC(nibName: "UserSearchVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        self.presentViewController(vc)
    }
    @objc func AppButton_Action(_ selector: UIBarButtonItem){
    }
    
    @objc func LikeButtonAction(_ sender: PopBounceButton) {
//        if self.swipeCross == "1"{
//
//        }else{
            
//            let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
//            self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
//        let recvrId = DataManager.getVal(self.swipeUserId[0]) as? String ?? ""
//        print(recvrId)
//        self.swipeUserId.remove(at: 0)
        self.Liketype = "1"
//        self.swipeCountAPI(recieverId: self.recieverId, type: "1", isLike: true)
        self.cardView.swipe(.right)
//            self.LikeAPI(receiver_id: self.recieverId)
//        }
    }
    @objc func SuperLikeButtonAction(_ sender: PopBounceButton) {
        UIView.animate(withDuration: 0.25, animations: {
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if membershiptype == "3"{
            //            let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
            //            self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
            //            let rcvrId = DataManager.getVal(self.swipeUserId[0]) as? String ?? ""
            //            print(rcvrId)
            //            self.swipeUserId.remove(at: 0)
            //            print(self.swipeUserId)
                        self.Liketype = "2"
            //            self.swipeCountAPI(recieverId: self.recieverId, type: "2", isLike: false)
                        self.cardView.swipe(.up)
            //            self.SuperLikeAPI(receiver_id: self.recieverId)
                    }else{
                        let nextview = GoldMemberPopUp.intitiateFromNib()
                        let model = BackModel()
                        nextview.layer.cornerRadius = 8
                        nextview.buttonbuyHandler = {
                            let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                           model.closewithAnimation()
                        }
                        nextview.buttonCancelHandler = {
                            model.closewithAnimation()
                        }
                        model.show(view: nextview)
                    }
        }

    }
    @objc func DislikeButtonAction(_ sender: PopBounceButton) {
//        if self.swipeCross == "1"{
//            let nextview = SwipeLimitView.intitiateFromNib()
//            let model = BackModel()
//            nextview.layer.cornerRadius = 8
//            nextview.buttonbuyHandler = {
//                let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
//                self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
//               model.closewithAnimation()
//            }
//            nextview.buttonCancelHandler = {
//                model.closewithAnimation()
//            }
//            model.show(view: nextview)
//        }else{
        let dict = DataManager.getVal(self.profileDataArray[sender.tag]) as! [String: Any]
        self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
        self.swipeCountAPI(recieverId: self.recieverId, type: "", isLike: false)
        self.cardView?.swipe(.left)
//            self.DisLikeAPI(receiver_id: self.recieverId)
//        }
    }
    
    func SuperLikeAPI(receiver_id:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
        
        let methodName = "like/superAdd"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
//            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let is_friend = DataManager.getVal(responseData?["is_friend"]) as? String ?? ""
            let roomId = DataManager.getVal(responseData?["room"]) as? String ?? ""
            if status == "1"{
//                self.view.makeToast(message: message)
                if is_friend == "1"{
                        let profile = DataManager.getVal(responseData?["profile"]) as! [String: Any]
                        let Name = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        let image = DataManager.getVal(profile["image"]) as? String ?? ""
                        let userId = DataManager.getVal(profile["user_id"]) as? String ?? ""
//                        self.homeAPI(method_name: self.methodName)
                    print(profile)
                        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
                        vc.UserName = Name
                        vc.imagestr = image
                        vc.m_recieverId = userId
                        vc.room_id = roomId
                        self.onlyPushViewController(vc)
                }else{
//                    self.homeAPI(method_name: self.methodName)
                }
                
            }else{
//                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func LikeAPI(receiver_id:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
        
        let methodName = "like/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
//            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let is_friend = DataManager.getVal(responseData?["is_friend"]) as? String ?? ""
            let roomId = DataManager.getVal(responseData?["room"]) as? String ?? ""
            if status == "1"{
//                self.view.makeToast(message: message)
                if is_friend == "1"{
                    if membershiptype == "3" || membershiptype == "2"{
                        let profile = DataManager.getVal(responseData?["profile"]) as! [String: Any]
                        let Name = DataManager.getVal(profile["fullname"]) as? String ?? ""
                        let image = DataManager.getVal(profile["image"]) as? String ?? ""
                        let userId = DataManager.getVal(profile["user_id"]) as? String ?? ""
//                        self.homeAPI(method_name: self.methodName)
                        print(profile)
                        let vc = ChatVC(nibName: "ChatVC", bundle: nil)
                        vc.UserName = Name
                        vc.imagestr = image
                        vc.m_recieverId = userId
                        vc.room_id = roomId
                        self.onlyPushViewController(vc)
                    }else{
                        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("Buy", backgroundColor: UIColor.systemPink){
                            //yaha click h
                            let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                        }
                        alert.addButton("Cancel", backgroundColor: UIColor.black){
                            print("NO")
                        }
                        alert.showEdit("Matched Successfully", subTitle: "Congrats! You both liked each other. To further intiate chat please buy our membership plan and unlock more features.")
                    }
//                    self.swipeCountAPI()
                }else{
//                    self.swipeCountAPI()
                }
                
            }else{
//                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    @objc func playBtnAction1(_ sender:UIButton){
        
    }
    
    func DisLikeAPI(receiver_id:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
        
        let methodName = "like/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            //let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
//                self.view.makeToast(message: message)
//                self.swipeCountAPI()
            }else{
//                self.view.makeToast(message: message)
//                self.swipeCountAPI()
            }
            self.clearAllNotice()
        }
    }
    func swipeCountAPI(recieverId:String, type:String, isLike:Bool){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(recieverId), forKey: "user_id")
        dict.setValue(DataManager.getVal(isLike), forKey: "type")
        
        let methodName = "profile/swipes-day"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            //let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            //let memberShip = DataManager.getVal(responseData?["membership"]) as? String ?? ""
            self.swipeCross = DataManager.getVal(responseData?["swipe_cross"]) as? String ?? ""
            
            if status == "1"{
                Config().AppUserDefaults.setValue(self.swipeCross, forKey: "SwipeCount")
                if self.swipeCross == "0"{
//                    if type == ""{
//                        self.cardView?.swipe(.left)
//                    }else{
//                        SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: recieverId, Type: type)
//                        if isLike == true{
//                            self.cardView.swipe(.right)
//                        }else{
//                            self.cardView.swipe(.topRight)
//                        }
//                    }
                }else{
                    let nextview = SwipeLimitView.intitiateFromNib()
                    let model = BackModel()
                    nextview.layer.cornerRadius = 8
                    nextview.buttonbuyHandler = {
                        let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                       model.closewithAnimation()
                    }
                    nextview.buttonCancelHandler = {
                        model.closewithAnimation()
                    }
                    model.show(view: nextview)
                }
            }else{
//                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.categoriesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
            cell.tag = indexPath.row
            if self.selectedCell == indexPath.row {
                cell.BottomLineLbl.isHidden = false
                cell.ImgView.layer.cornerRadius = cell.ImgView.bounds.size.width/2
                cell.ImgView.layer.borderColor = UIColor(red: 245/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
                cell.ImgView.layer.borderWidth = 1
                cell.TitleLbl.textColor = UIColor(red: 245/255, green: 0/255, blue: 0/255, alpha: 1)
//                cell.bottomLinelblwidthConstraint.constant = CGFloat(cell.TitleLbl.text!.count * 9)
            }else{
                cell.ImgView.layer.cornerRadius = cell.ImgView.bounds.size.width/2
                cell.ImgView.layer.borderColor = UIColor(red: 49/255, green: 149/255, blue: 224/255, alpha: 1).cgColor
                cell.ImgView.layer.borderWidth = 1
                cell.BottomLineLbl.isHidden = true
                cell.TitleLbl.textColor = UIColor(red: 49/255, green: 149/255, blue: 224/255, alpha: 1)
            }
            print(categoriesArray)
            cell.TitleLbl.text = self.categoriesArray[indexPath.row]
            cell.ImgView.image = UIImage(named: self.categoriesImageArray[indexPath.row])
            return cell
    }
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Video Ended")
    }
    @objc func playvideo(_ sender:UIButton) {
        print(self.videoStr[sender.tag])
        let url = DataManager.getVal(self.videoStr[sender.tag]) as? String ?? ""
        let videoURL = URL(string: url)
                player = AVPlayer(url: videoURL!)
                avpController.player = player
                self.present(avpController, animated: true, completion: nil)
                self.avpController.player?.play()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Config().VibrateOnClick()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
        
        self.selectedCell = indexPath.row
        self.CategoryCollectionView.reloadData()
        if collectionView == CategoryCollectionView{
            if indexPath.item == 0 {
                self.swipeUserId.removeAll()
                self.swipeUserName.removeAll()
                self.swipeUserImage.removeAll()
                self.isMatch = "0"
                self.homeAPI(method_name: "profile/home")
                self.swipeType = "1"
            }
            else if indexPath.item == 4 {
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/online-connection")
                    self.swipeType = "3"
                }else if membershiptype == "2"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/online-connection")
                    self.swipeType = "3"
                }else{
                    let nextview = GoldMemberPopUp.intitiateFromNib()
                    let model = BackModel()
                    nextview.layer.cornerRadius = 20
                    nextview.buttonbuyHandler = {
                        let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                        detailVC.comeFromHome = "yes"
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                       model.closewithAnimation()
                    }
                    nextview.buttonCancelHandler = {
                        model.closewithAnimation()
                    }
                    model.show(view: nextview)
                }
            }else if indexPath.item == 5 {
                self.isMatch = "0"
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/new-connection")
                    self.swipeType = "4"
                }else if membershiptype == "2"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/new-connection")
                    self.swipeType = "4"
                }else{
                    let nextview = GoldMemberPopUp.intitiateFromNib()
                    let model = BackModel()
                    nextview.layer.cornerRadius = 20
                    nextview.buttonbuyHandler = {
                        let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                        detailVC.comeFromHome = "yes"
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                       model.closewithAnimation()
                    }
                    nextview.buttonCancelHandler = {
                        model.closewithAnimation()
                    }
                    model.show(view: nextview)
                }
            }else if indexPath.item == 2 {
                self.isMatch = "0"
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/gold-connection")
                    self.swipeType = "5"
                }else if membershiptype == "2"{
                    if membership_limit == "0"{
                        self.swipeUserId.removeAll()
                        self.swipeUserName.removeAll()
                        self.swipeUserImage.removeAll()
                        self.homeAPI(method_name: "profile/gold-connection")
                        self.swipeType = "5"
                    }else{
                        let nextview = PremiumMemberLimitPopUp.intitiateFromNib()
                        let model = BackModel()
                        nextview.layer.cornerRadius = 20
                        nextview.buttonCancelHandler = {
                           model.closewithAnimation()
                        }
                        model.show(view: nextview)
                    }
                }else{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/gold-connection")
                    self.swipeType = "5"
                }
            }
            else if indexPath.item == 1 {
                self.isMatch = "1"
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/match-connection")
                    self.swipeType = "2"
                }else if membershiptype == "2"{
                    if membership_limit == "0"{
                        self.swipeUserId.removeAll()
                        self.swipeUserName.removeAll()
                        self.swipeUserImage.removeAll()
                        self.homeAPI(method_name: "profile/match-connection")
                        self.swipeType = "2"
                    }else{
                        let nextview = PremiumMemberLimitPopUp.intitiateFromNib()
                        let model = BackModel()
                        nextview.layer.cornerRadius = 20
                        nextview.buttonCancelHandler = {
                           model.closewithAnimation()
                        }
                        model.show(view: nextview)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.swipeUserId.removeAll()
                        self.swipeUserName.removeAll()
                        self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/match-connection")
                    self.swipeType = "2"
                    }
                }
            }
            else if indexPath.item == 6 {
                self.isMatch = "0"
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/nearby-connection")
                    self.swipeType = "6"
                }else if membershiptype == "2"{
                    if membership_limit == "0"{
                        self.swipeUserId.removeAll()
                        self.swipeUserName.removeAll()
                        self.swipeUserImage.removeAll()
                        self.homeAPI(method_name: "profile/nearby-connection")
                        self.swipeType = "6"
                    }else{
                        let nextview = GoldMemberPopUp.intitiateFromNib()
                        let model = BackModel()
                        nextview.layer.cornerRadius = 20
                        nextview.buttonbuyHandler = {
                            let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                            detailVC.comeFromHome = "yes"
                            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                           model.closewithAnimation()
                        }
                        nextview.buttonCancelHandler = {
                            model.closewithAnimation()
                        }
                        model.show(view: nextview)
                    }
                }else{
                    let nextview = GoldMemberPopUp.intitiateFromNib()
                    let model = BackModel()
                    nextview.layer.cornerRadius = 20
                    nextview.buttonbuyHandler = {
                        let detailVC = MembershipDetailVC(nibName: "MembershipDetailVC", bundle: nil)
                        detailVC.comeFromHome = "yes"
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                       model.closewithAnimation()
                    }
                    nextview.buttonCancelHandler = {
                        model.closewithAnimation()
                    }
                    model.show(view: nextview)
                }
            }
            else if indexPath.item == 3 {
                self.isMatch = "0"
                if membershiptype == "3"{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/explore")
                    self.swipeType = "5"
                }else if membershiptype == "2"{
                    if membership_limit == "0"{
                        self.swipeUserId.removeAll()
                        self.swipeUserName.removeAll()
                        self.swipeUserImage.removeAll()
                        self.homeAPI(method_name: "profile/explore")
                        self.swipeType = "5"
                    }else{
                        let nextview = PremiumMemberLimitPopUp.intitiateFromNib()
                        let model = BackModel()
                        nextview.layer.cornerRadius = 20
                        nextview.buttonCancelHandler = {
                           model.closewithAnimation()
                        }
                        model.show(view: nextview)
                    }
                }else{
                    self.swipeUserId.removeAll()
                    self.swipeUserName.removeAll()
                    self.swipeUserImage.removeAll()
                    self.homeAPI(method_name: "profile/explore")
                    self.swipeType = "5"
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.CategoryCollectionView{
            return UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.CategoryCollectionView{
            return 5
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.CategoryCollectionView{
            return 20
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.CategoryCollectionView{
            return CGSize(width: 60, height: 79)
        }else{
            return CGSize(width: screenWidth-50, height: 200)
        }
    }
}
extension Array {
    func group(of n: IndexDistance) -> Array<Array> {
        return stride(from: 0, to: count, by: n)
        .map { Array(self[$0..<Swift.min($0+n, count)]) }
    }
}
@available(iOS 13.0, *)
extension HomeVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        cardView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection]{
        
        return [.left,.topLeft,.bottomLeft,.right,.topRight,.bottomRight,.up]
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool{
        if direction == .left || direction == .topLeft || direction == .bottomLeft{
            if suggestionSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                    if membershiptype == "2" {
                        nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                    }else{
                        nextview.outOfSwipeMsgLbl.text = "We give 5 suggestion profiles per day, Please Come back tomorrow"
                    }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if matchSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
//                    nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if newSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
//                nextview.outOfSwipeMsgLbl.text = "To unlock this feature please buy our Gold membership plan"
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if goldSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if self.swipeCross == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if self.swipeType == "1"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "2"{
//                    nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "4"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "5"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else{
                return true
            }
            
        }else if direction == .right || direction == .topRight || direction == .bottomRight{
            if suggestionSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                    if membershiptype == "2" {
                        nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                    }else{
                        nextview.outOfSwipeMsgLbl.text = "We give 5 suggestion profiles per day, Please Come back tomorrow"
                    }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if matchSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
//                    nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if newSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
//                nextview.outOfSwipeMsgLbl.text = "To unlock this feature please buy our Gold membership plan"
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if goldSwipeCountLimit == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if membershiptype == "2" {
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else if self.swipeCross == "1"{
                let nextview = SwipeLimitView.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 8
                if self.swipeType == "1"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "2"{
//                    nextview.outOfSwipeMsgLbl.text = "We only give 5 suggestion per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "4"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 Match% profiles per day, to get more profile please buy our Gold member"
                }
                if self.swipeType == "5"{
                    nextview.outOfSwipeMsgLbl.text = "We only give 10 profiles per day , Please Come back tomorrow"
                }else{
                    nextview.outOfSwipeMsgLbl.text = "We give 5 profiles per day, to get more profile please buy our Gold member"
                }
                nextview.buttonbuyHandler = {
                    let detailVC = MembershipVC(nibName: "MembershipVC", bundle: nil)
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: detailVC), close: true)
                   model.closewithAnimation()
                }
                nextview.buttonCancelHandler = {
                    model.closewithAnimation()
                }
                model.show(view: nextview)
                return false
            }else{
                return true
            }
        }else if direction == .up {
            return true
        }
        else{
            return false
        }
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection){

        if direction == .left || direction == .topLeft || direction == .bottomLeft{
            self.recieverId = DataManager.getVal(self.swipeUserId[0]) as? String ?? ""
            self.recieverName = DataManager.getVal(self.swipeUserName[0]) as? String ?? ""
            self.recieverImage = DataManager.getVal(self.swipeUserImage[0]) as? String ?? ""
            print(recieverId)
            print(recieverName)
            
            self.swipeUserId.remove(at: 0)
            self.swipeUserName.remove(at: 0)
            self.swipeUserImage.remove(at: 0)
            print(self.swipeUserId)
            print(self.swipeUserName)
            print(self.swipeUserImage)
            self.swipeCountAPI(recieverId: self.recieverId, type: "", isLike: false)
        }else if direction == .right || direction == .topRight || direction == .bottomRight{
            
            self.recieverId = DataManager.getVal(self.swipeUserId[0]) as? String ?? ""
            self.recieverName = DataManager.getVal(self.swipeUserName[0]) as? String ?? ""
            print(self.swipeUserName)
            print(self.swipeUserId)
            print(recieverId)
            print(recieverName)
            self.recieverImage = DataManager.getVal(self.swipeUserImage[0]) as? String ?? ""
            self.swipeUserId.remove(at: 0)
            self.swipeUserName.remove(at: 0)
            self.swipeUserImage.remove(at: 0)
            print(self.swipeUserId)
            print(self.swipeUserName)
            print(self.swipeUserImage)
            print(self.recieverId)
            print(self.user_id)
            let Rid = Int(self.recieverId) ?? 0
            let Uid = Int(self.user_id) ?? 0
            if Rid < Uid {
                self.room_id = recieverId + "-" + user_id
                print(self.room_id)
            }else{
                self.room_id = user_id + "-" + recieverId
                print(self.room_id)
            }
            self.swipeCountAPI(recieverId: self.recieverId, type: self.Liketype, isLike: true)
            SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: self.recieverId, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: self.Liketype, Room_id: room_id)
        }else if direction == .up {
            self.recieverId = DataManager.getVal(self.swipeUserId[0]) as? String ?? ""
            self.recieverName = DataManager.getVal(self.swipeUserName[0]) as? String ?? ""
            print(self.swipeUserName)
            print(self.swipeUserId)
            print(recieverId)
            print(recieverName)
            self.recieverImage = DataManager.getVal(self.swipeUserImage[0]) as? String ?? ""
            self.swipeUserId.remove(at: 0)
            self.swipeUserName.remove(at: 0)
            self.swipeUserImage.remove(at: 0)
            print(self.swipeUserId)
            print(self.swipeUserName)
            print(self.swipeUserImage)
            print(self.recieverId)
            print(self.user_id)
            let Rid = Int(self.recieverId) ?? 0
            let Uid = Int(self.user_id) ?? 0
            if Rid < Uid {
                self.room_id = recieverId + "-" + user_id
                print(self.room_id)
            }else{
                self.room_id = user_id + "-" + recieverId
                print(self.room_id)
            }
            self.swipeCountAPI(recieverId: self.recieverId, type: self.Liketype, isLike: true)
            SocketIoManagerNotification.sharedInstance.sendLikeNoti(Sender_Id: self.user_id, Sender_Name: self.user_name, Sender_Image: self.user_image, Reciever_Id: self.recieverId, Reciver_Name: self.recieverName, Reciver_Image: self.recieverImage, Type: self.Liketype, Room_id: room_id)
        }
        else{
            print("No action perform")
        }
    }
}

@available(iOS 13.0, *)
extension HomeVC: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return profileDataArray.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
//        self.videoarray.removeAll()
        self.pictureArray.removeAll()
        let tempVw = myView()
//        tempVw.dropShadow()
//        self.cardView.dropShadow()
        tempVw.layer.cornerRadius = 20
        self.cardView.layer.cornerRadius = 20
        koloda.layer.cornerRadius = 20
        self.topView.layer.cornerRadius = 20
        tempVw.contentView.layer.cornerRadius = 20
        tempVw.mainView.layer.cornerRadius = 20
        tempVw.scrollView.layer.cornerRadius = 20
        tempVw.ageLbl.layer.cornerRadius = 10
        tempVw.matchLbl.layer.cornerRadius = 10
        tempVw.playerButton1.addTarget(self, action: #selector(playvideo(_:)), for: .touchUpInside)
        if isMatch == "1" {
            tempVw.matchLblView.isHidden = false
        }else{
            tempVw.matchLblView.isHidden = true
        }
        tempVw.picturesArray.removeAll()
        tempVw.videosArray.removeAll()
        tempVw.titlesArray.removeAll()
        let dict = DataManager.getVal(self.profileDataArray[index]) as! [String: Any]
        print(dict)
        let image = DataManager.getVal(dict["image"]) as? String ?? ""
        let about = DataManager.getVal(dict["about"]) as? String ?? ""
        let age = DataManager.getVal(dict["age"]) as? String ?? "" //
        let fullname = DataManager.getVal(dict["fullname"]) as? String ?? ""
        let Citys = DataManager.getVal(dict["city"]) as? String ?? ""
        var components = Citys.components(separatedBy: " ")
        var components1 = components.removeFirst()
        components1 = components1.replacingOccurrences(of: ",", with: "")
        let City = String(components1)
        let verifiedStatus = DataManager.getVal(dict["show_verified"]) as? String ?? ""//
        if verifiedStatus == "1"{
//            tempVw.Verifiedimg.isHidden = false
        }else{
//            tempVw.Verifiedimg.isHidden = true
        }
        //let City = DataManager.getVal(dict["country"]) as? String ?? ""
        let percentage = DataManager.getVal(dict["percentage"]) as? String ?? ""
        let ethnicity = DataManager.getVal(dict["ethnicity"]) as? String ?? ""
        let degree = DataManager.getVal(dict["degree"]) as? String ?? ""
        let religion = DataManager.getVal(dict["religion"]) as? String ?? ""
        tempVw.userName.text = (fullname)
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        let ageLang = lang == "en" ? kage : kThage
        tempVw.ageLbl.text = "\(ageLang) " + age
        if Citys == "" {
            tempVw.cityLblView.isHidden = true
        }else{
            tempVw.cityLblView.isHidden = false
            tempVw.cityLbl.text = Citys
//            tempVw.cityLbl.text = City + "   "
        }
        tempVw.matchLbl.text = "\(percentage)% Match" + "   "
        tempVw.userBioLbl.text = about
        Config().setDummyimage(name: image, image: tempVw.img_1)
        print(dict)
        self.isMembership = DataManager.getVal(dict["membership"]) as? String ?? ""
        if self.isMembership == "3"{
            tempVw.goldIcon.isHidden = false
        }else{
            tempVw.goldIcon.isHidden = true
        }
        print(dict)
        tempVw.memberStatus = self.isMembership
        self.videoarray = DataManager.getVal(dict["videos"]) as? [String] ?? []
        self.pictureArray = DataManager.getVal(dict["pictures"]) as? [String] ?? []
        self.recieverId = DataManager.getVal(dict["user_id"]) as? String ?? ""
        if self.videoarray.count != 0 {
            self.videoStr = self.videoarray
        }
        print(dict)
        print(self.recieverId)
        if self.swipeUserId.contains(self.recieverId){
            print(self.swipeUserId)
        }else{
            self.swipeUserId.append(self.recieverId)
            self.swipeUserName.append(fullname)
            self.swipeUserImage.append(image)
            print(self.swipeUserId)
            print(self.swipeUserName)
            print(self.swipeUserImage)
        }
        let interests_dict = DataManager.getVal(dict["interests"]) as! [String: Any]
        print(interests_dict)
        let height_feet = DataManager.getVal(dict["height_feet"]) as? String ?? ""
        let height_inch = DataManager.getVal(dict["height_inch"]) as? String ?? ""
        var height = String()
        height = height_feet + "\("'")" + height_inch + "\("''")"
        let childrenStatus = DataManager.getVal(dict["have_children"]) as? String ?? ""
        var children = ""
        if childrenStatus == "1"{
            children = "Yes, they sometimes live with me"
        }else if childrenStatus == "2"{
            children = "Yes, they live with me"
        }else if childrenStatus == "3"{
            children = "No"
        }
        let genderStatus = DataManager.getVal(dict["gender_str"]) as? String ?? ""//
        print(genderStatus)
        
        let interest = DataManager.getVal(self.profileDataArray[index]) as! [String: Any]
        
        let orientationStr = DataManager.getVal(interest["orientation_str"]) as? String ?? ""
        print(orientationStr)
//        var gender = ""
//        if genderStatus == "Transsexual"{
//            gender = "Transsexual"
//        }else if genderStatus == "Female"{
//            gender = "Female"
//        }else if genderStatus == "Male"{
//            gender = "Male"
//        }
        let drinkingStatus = DataManager.getVal(interests_dict["drinking"]) as? String ?? ""
        var drinking = ""
        if drinkingStatus == "On special occasion"{
            drinking = "On special occasion"
        }else if drinkingStatus == "Once a week"{
            drinking = "Once a week"
        }else if drinkingStatus == "Few times a week"{
            drinking = "Few times a week"
        }else if drinkingStatus == "Daily"{
            drinking = "Daily"
        }else if drinkingStatus == "Any"{
            drinking = "Any"
        }
        let smokingStatus = DataManager.getVal(interests_dict["smoking"]) as? String ?? ""
        var smoking = ""
        if smokingStatus == "Non-smoker"{
            smoking = "Non-smoker"
        }else if smokingStatus == "Occasional smoker"{
            smoking = "Occasional smoker"
        }else if smokingStatus == "Smoker"{
            smoking = "Smoker"
        }else if smokingStatus == "Trying to quit"{
            smoking = "Trying to quit"
        }else if smokingStatus == "Any"{
            smoking = "Any"
        }
        let likePetStatus = DataManager.getVal(interests_dict["pet_str"]) as? String ?? ""//
        print(likePetStatus)
//        var LikePet = ""
//        if likePetStatus == "Cat"{
//            LikePet = "Cat"
//        }else if likePetStatus == "Dog"{
//            LikePet = "Dog"
//        }else if likePetStatus == "Bird"{
//            LikePet = "Bird"
//        }else if likePetStatus == "Fish"{
//            LikePet = "Fish"
//        }else if likePetStatus == "No Pet"{
//            LikePet = "No Pet"
//        }
        let maritalStatus = DataManager.getVal(dict["marital_status"]) as? String ?? ""
        var marital = ""
        if maritalStatus == "Single"{
            marital = "Single"
        }else if maritalStatus == "Married"{
            marital = "Married"
        }else if maritalStatus == "Divorced"{
            marital = "Divorced"
        }else if maritalStatus == "Separated"{
            marital = "Separated"
        }else if maritalStatus == "Widowed"{
            marital = "Widowed"
        }else if maritalStatus == "Open relationship"{
            marital = "Open Rlationship"
        }else if maritalStatus == "Any"{
            marital = "Any"
        }
        let workout = DataManager.getVal(interests_dict["workout"]) as? String ?? ""
        print(workout)
        self.titleArray = [
            ["key": DataManager.getVal(dict["gender_str"]) as? String ?? "","image": "gender"],
            ["key": orientationStr,"image": "orientation"],
//            ["key": DataManager.getVal(dict["city"]) as? String ?? "","image": "location"],
                        
                        ["key": ethnicity,"image": "ethnicity"],
                        ["key": religion,"image": "religion"],
                        ["key": degree,"image": "education"],
                        ["key": DataManager.getVal(dict["build"]) as? String ?? "","image": "fit"],
                        ["key": height,"image": "height"],
                        ["key": children,"image": "child"],
                        ["key": drinking,"image": "drink"],
                        ["key": smoking,"image": "smoking-1"],
                        ["key": workout,"image": "Workout"],
                        ["key": DataManager.getVal(interests_dict["pet_str"]) as? String ?? "","image": "pat"],
                        ["key": DataManager.getVal(interests_dict["music_str"]) as? String ?? "","image": "music"],
                        ["key": DataManager.getVal(interests_dict["ilikes_str"]) as? String ?? "","image": "like1"],
                        ["key": DataManager.getVal(interests_dict["sports_str"]) as? String ?? "","image": "sport"],
                        ["key": marital,"image": "Marital"],
                        ["key": DataManager.getVal(interests_dict["spendtime_str"]) as? String ?? "","image": "spend_time"],
                        ["key": DataManager.getVal(interests_dict["vacation_str"]) as? String ?? "","image": "vacation"]
                        ]
                        
        print(self.titleArray)
        let Questionarray = DataManager.getVal(dict["questions"]) as? [[String:Any]] ?? []
        tempVw.quesAnsArray = Questionarray
        tempVw.picturesArray = self.pictureArray
        tempVw.videosArray = self.videoarray
        tempVw.titlesArray = self.titleArray
        tempVw.imageCollectionView.reloadData()
        tempVw.videoCollectionView.reloadData()
        tempVw.habitsCollectionView.reloadData()
        tempVw.quesAnsCollectionView.reloadData()
        let flowLayout = tempVw.habitsCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        flowLayout?.horizontalAlignment = .left

//        self.DetailCollectionViewHeightConstraint.constant = CGFloat((self.titleArray.count/2)*40) + CGFloat((self.titleArray.count*5))
        
        if tempVw.picturesArray.count != 0{
            tempVw.imageCollectionTopCons.constant = 35
            tempVw.imagesCollectionHeightCons.constant = 334
            tempVw.imagePageControl.isHidden = false
        }else{
            tempVw.imageCollectionTopCons.constant = 0
            tempVw.imagesCollectionHeightCons.constant = 0
            tempVw.imagePageControl.isHidden = true
        }
        if tempVw.titlesArray.count != 0{
            tempVw.habitsCollectionTopCons.constant = 20
//            tempVw.habitsCollectionHeightCons.constant = 700
            
            tempVw.habitsCollectionHeightCons.constant = tempVw.habitsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.view.setNeedsLayout()
            
//            let height = tempVw.habitsCollectionView.contentSize.height
//            let minus = height - 2
//            let hei = minus * 36
////                    let collectionHeight = self.DetailCollectionView.frame.height
//            tempVw.habitsCollectionHeightCons.constant = hei - 50
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
        }else{
            tempVw.habitsCollectionTopCons.constant = 0
            tempVw.habitsCollectionHeightCons.constant = 0
        }
        if tempVw.quesAnsArray.count != 0{
            tempVw.quesTopConstrants.constant = 12
            tempVw.quesHeightConstrants.constant = 189
        }else{
            tempVw.quesTopConstrants.constant = 0
            tempVw.quesHeightConstrants.constant = 0
        }
        if tempVw.videosArray.count != 0{
            tempVw.videoCollectionTopCons.constant = 8
            tempVw.videoCollectionHeightCons.constant = 294
            tempVw.playerButton1.isHidden = false
            tempVw.videoPageControl.isHidden = false
        }else{
            tempVw.videoCollectionTopCons.constant = 45
            tempVw.videoCollectionHeightCons.constant = 0
            tempVw.playerButton1.isHidden = true
            tempVw.videoPageControl.isHidden = true
        }
        tempVw.blockBtn.addTarget(self, action: #selector(blockBtnAction), for: .touchUpInside)
        tempVw.likeBtn.addTarget(self, action: #selector(LikeButtonAction), for: .touchUpInside)
        tempVw.disLikeBtn.addTarget(self, action: #selector(DislikeButtonAction), for: .touchUpInside)
        tempVw.superLikeBtn.addTarget(self, action: #selector(SuperLikeButtonAction), for: .touchUpInside)
        tempVw.superLikeBtnTop.addTarget(self, action: #selector(SuperLikeButtonAction), for: .touchUpInside)
        return tempVw
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
