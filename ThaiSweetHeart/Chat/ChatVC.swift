//
//  ChatVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 03/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import SocketIO
@available(iOS 13.0, *)
class ChatVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var ChatTblView: UITableView!
    @IBOutlet weak var TypingViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var MessageTxtField: UITextField!
    
    @IBOutlet weak var msgView: MyView!
    @IBOutlet weak var blockedImg: UIImageView!
    @IBOutlet weak var blockedLbl: UILabel!
    @IBOutlet weak var msgViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var ScrollViewBaseView: UIView!
    //MARK:- GIF View
    @IBOutlet weak var gifFileLbl: UILabel!
    @IBOutlet weak var GifView: UIView!
    @IBOutlet weak var GifViewHeightConstraint: NSLayoutConstraint!//180
    @IBOutlet weak var GifCollectionView: UICollectionView!
    @IBOutlet weak var CategoryView: UIView!
    @IBOutlet weak var GifHeaderCollectionView: UICollectionView!
    
    fileprivate var selectedCell: Int = 0
    var Sticker_Dict = [String:Any]()
    var GifCollectionArray = [Any]()
    var Heartfeeling_Arr = [Any]()
    var Love_Arr = [Any]()
    var Smiley_Arr = [Any]()
    var Text_Arr = [Any]()
    var Unicorn_Arr = [Any]()
    var profileImg = UIImageView()
    var nameLbl = UILabel()
    var room_id = String()
    var receiverid = String()
    var mReceiverid = String()
    var dataArray = [Any]()
    var UserName = String()
    var sender_id = String()
    var imagestr = String()
    var blockDict = [String:Any]()
    var selectIndexArray = [Any]()
    var membership = String()
    var chatIdArray = NSMutableArray()
    var is_Online = String()
    var Header_Arr = [String]()
    var reciever_Id = String()
    var goldImg = UIImageView()
    var r_memberShip = String()
    var m_recieverId = String()
    var member = String()
    var alertTitle = String()
    var isComingMatch = String()
    var isCommingFromlikeToChat = String()
    var menuPopUprecieverId = String()
    var menuPopUpFriendId = String()
    var menuBarBtn = UIBarButtonItem()
    var chatButton = UIBarButtonItem()
    var SuperLikeImg = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        SocketIoManager.sharedInstance.removeAllHandlers()
        var dict = [String: Any]()
        dict = ["sender": self.user_id,"room": self.room_id]
        SocketIoManager.sharedInstance.socket.connect(timeoutAfter: 2.0) {
            print("time _ out")
            SocketIoManager.sharedInstance.establishConnection()
            SocketIoManager.sharedInstance.connectToServerWithRoom(nickname: [dict])
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SocketIoManager.sharedInstance.removeAllHandlers()
        var dict = [String: Any]()
        dict = ["sender": self.user_id,"room": self.room_id]
        SocketIoManager.sharedInstance.establishConnection()
        SocketIoManager.sharedInstance.connectToServerWithRoom(nickname: [dict])
        NotificationCenter.default.addObserver(self, selector: #selector(self.new_showChatMessage(_:)), name: NSNotification.Name(rawValue: "new_message_coming"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar.png"), for: .default)
        
        self.profileImg.isUserInteractionEnabled = true
        self.blockedLbl.isHidden = true
        self.blockedImg.isHidden = true
        if self.member == "3" {
            self.goldImg.isHidden = false
        }else{
            self.goldImg.isHidden = true
        }
        self.Header_Arr = ["Heartfeeling","Love","Smiley","Emoji","Unicorn"]
        self.is_Online = "1"
        self.getUserChatStatusAPI()
        let nib = UINib(nibName: "SenderTableCell", bundle: nil)
        self.ChatTblView.register(nib, forCellReuseIdentifier: "SenderTableCell")
        
        let nibClass = UINib(nibName: "ReciverTableCell", bundle: nil)
        self.ChatTblView.register(nibClass, forCellReuseIdentifier: "ReciverTableCell")
        
        let gif1NibClass = UINib(nibName: "receiveGifCell", bundle: nil)
        self.ChatTblView.register(gif1NibClass, forCellReuseIdentifier: "receiveGifCell")
        
        let gif2NibClass = UINib(nibName: "senderGifCell", bundle: nil)
        self.ChatTblView.register(gif2NibClass, forCellReuseIdentifier: "senderGifCell")
        
        self.ChatTblView.rowHeight = UITableView.automaticDimension
        self.ChatTblView.delegate = self
        self.ChatTblView.dataSource = self
        self.ChatTblView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0);
        
        self.ChatTblView.keyboardDismissMode = .onDrag
        
        let HeadLayOut = UICollectionViewFlowLayout()
        HeadLayOut.itemSize = CGSize(width: 80, height: 50)
        HeadLayOut.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        HeadLayOut.minimumInteritemSpacing = 0
        HeadLayOut.minimumLineSpacing = 10
        HeadLayOut.scrollDirection = .horizontal
        
        let HeadLiberary = UINib(nibName: "GifTabCell", bundle: nil)
        self.GifHeaderCollectionView.register(HeadLiberary, forCellWithReuseIdentifier: "GifTabCell")
        self.GifHeaderCollectionView.collectionViewLayout = HeadLayOut
        self.GifHeaderCollectionView.layer.cornerRadius = 15
        self.CategoryView.layer.cornerRadius = 15
        
        let LayOut = UICollectionViewFlowLayout()
        LayOut.itemSize = CGSize(width: 122, height: 122)
        LayOut.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        LayOut.minimumInteritemSpacing = 0
        LayOut.minimumLineSpacing = 10
        LayOut.scrollDirection = .horizontal
        
        let Liberary = UINib(nibName: "GIFCollectionCell", bundle: nil)
        self.GifCollectionView.register(Liberary, forCellWithReuseIdentifier: "GIFCollectionCell")
        self.GifCollectionView.collectionViewLayout = LayOut
        
        self.GifViewHeightConstraint.constant = 0
        self.GifView.isHidden = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                self.GifViewHeightConstraint.constant = 0
            case 1334:
                print("iPhone 6/6S/7/8")
                self.GifViewHeightConstraint.constant = 0
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.GifViewHeightConstraint.constant = 0
            case 2436:
                print("iPhone X/XS/11 Pro")
                self.GifViewHeightConstraint.constant = 30
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                self.GifViewHeightConstraint.constant = 30
            case 1792:
                print("iPhone XR/ 11 ")
                self.GifViewHeightConstraint.constant = 30
            default:
                print("Unknown")
                self.GifViewHeightConstraint.constant = 30
            }
        }
        //        self.nameLbl.text = UserName
        //        Config().setimage(name: self.imagestr, image: self.profileImg)
        self.UpdateNavigationBarUI()
        self.getMessageListAPI()
        SocketIoManager.sharedInstance.removeAllHandlers()
        self.ChatTblView.allowsMultipleSelectionDuringEditing = true
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        
        let ChatImage : UIImage? = UIImage(named:"moreMenu")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(addMenu))
        navigationItem.rightBarButtonItems = [self.menuBarBtn,editButtonItem]
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        ChatTblView.addGestureRecognizer(longPress)
    }
    
    //MARK:- Tap gasture
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: ChatTblView)
            if let indexPath = ChatTblView.indexPathForRow(at: touchPoint) {
            // your code here, get the row for the indexPath or do whatever you want
                self.ChatTblView.isEditing = true
                self.ChatTblView.allowsMultipleSelection = true
                self.ChatTblView.allowsMultipleSelectionDuringEditing = true
             }
        }
    }
    //MARK:- viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        SocketIoManager.sharedInstance.socket.disconnect()
        SocketIoManager.sharedInstance.removeAllHandlers()
        self.is_Online = "0"
        self.getUserChatStatusAPI()
    }
    
    //MARK:- User chat status API
    func getUserChatStatusAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.is_Online), forKey: "is_online")
        
        let methodName = "chat/is-online"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
//                print(data1)
//                self.MessageListTblView.reloadData()
//                self.MessageListTblView.backgroundView = nil
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @objc func RightImageButtonAction(_ sender: UIBarButtonItem){
    }
    
    @IBAction func MessageSendButtonAction(_ sender: ResponsiveButton) {
        if isBlank(self.MessageTxtField) {
            self.view.makeToast(message: "Message can't be blank.")
        }else{
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "hh:mm"
            let dateString = formatter.string(from: now)
            print(dateString)
            SocketIoManager.sharedInstance.sendMessage(sender_id: self.user_id, reciever_id: self.m_recieverId, message: self.MessageTxtField.text!, withRoom: self.room_id, is_file: "1")
            let chatDict = NSMutableDictionary()
            chatDict.setValue(self.user_id, forKey: "sender")
            chatDict.setValue(self.MessageTxtField.text!, forKey: "message")
            chatDict.setValue(dateString, forKey: "time")
            UserDefaults.standard.setValue("popshow", forKey: "PopUp")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: chatDict, userInfo: nil)
            self.MessageTxtField.text = ""
            self.ChatTblView.reloadData()
            if self.dataArray.count != 0{
                self.ChatTblView.scrollToRow(at: IndexPath(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }else{
                
            }
            self.getMessageListAPI()
        }
    }
    @IBAction func EmojiButtonAction(_ sender: ResponsiveButton) {
        
    }
    @objc func new_showChatMessage(_ notification: NSNotification) {
        print("new message aaya")
        var dict = NSMutableDictionary()
        dict = notification.object as! NSMutableDictionary
        
        self.dataArray.append(dict)
        self.ChatTblView.reloadData()
        self.ChatTblView.scrollToRow(at: IndexPath(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "new_message_coming"), object: dict)
    }
    
    @IBAction func GifButtonAction(_ sender: ResponsiveButton) {
        self.view.endEditing(true)
        self.pleaseWait()
        
        let parameterDictionary = NSMutableDictionary()
        
        let methodName = "option/sticker"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
            let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
            
            if status == "1"{
                self.Sticker_Dict = DataManager.getVal(responseData?.object(forKey: "sticker")) as? [String:Any] ?? [:]
                self.Heartfeeling_Arr = DataManager.getVal(self.Sticker_Dict["Heartfeeling"]) as? [Any] ?? []
                self.Love_Arr = DataManager.getVal(self.Sticker_Dict["Love"]) as? [Any] ?? []
                self.Smiley_Arr = DataManager.getVal(self.Sticker_Dict["Smiley"]) as? [Any] ?? []
                self.Text_Arr = DataManager.getVal(self.Sticker_Dict["Text"]) as? [Any] ?? []
                self.Unicorn_Arr = DataManager.getVal(self.Sticker_Dict["Unicorn"]) as? [Any] ?? []
                self.GifCollectionArray = self.Heartfeeling_Arr
                self.GifHeaderCollectionView.reloadData()
                self.GifCollectionView.reloadData()
                UIView.animate(withDuration: 0.7) {
                    self.GifViewHeightConstraint.constant = 257
                    self.GifView.isHidden = false
                    self.view.layoutIfNeeded()
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    @IBAction func GifCrossButtonAction(_ sender: ResponsiveButton) {
        self.GifViewHeightConstraint.constant = 0
        self.GifView.isHidden = true
    }
    
    func getMessageListAPI(){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(self.room_id), forKey: "room_id")
        print(self.user_id)
        print(self.room_id)
        let methodName = "chat"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            let stillFriend = DataManager.getVal(responseData?["still_friends"]) as? String ?? ""
            if status == "1"{
                self.dataArray = DataManager.getVal(responseData?["chat"]) as? [Any] ?? []
                self.blockDict = DataManager.getVal(responseData?["block"]) as? [String:Any] ?? [:]
                self.membership = DataManager.getVal(responseData?["membership"]) as? String ?? ""
                print(self.membership)
                let blockBy = DataManager.getVal(self.blockDict["block_by"]) as? String ?? ""
                let blockStatus = DataManager.getVal(self.blockDict["status"]) as? String ?? ""
                
                self.menuPopUpFriendId = DataManager.getVal(responseData?["friend_id"]) as? String ?? ""

                var recDict = NSDictionary()
                recDict = DataManager.getVal(responseData?["receiver"]) as! NSDictionary
                self.reciever_Id = DataManager.getVal(recDict["user_id"]) as? String ?? ""
                self.menuPopUprecieverId = DataManager.getVal(recDict["user_id"]) as? String ?? ""
                print(self.menuPopUprecieverId)
                print(recDict)
                print(self.receiverid)
                var dict = NSDictionary()
                dict = DataManager.getVal(responseData?["sender"]) as! NSDictionary
                self.UserName = dict.value(forKey: "fullname") as? String ?? ""
                self.imagestr = dict.value(forKey: "image") as? String ?? ""
                self.sender_id = dict.value(forKey: "user_id") as? String ?? ""
                print(self.UserName)
                print(dict)
                print(self.sender_id)
                self.ChatTblView.reloadData()
                self.ChatTblView.backgroundView = nil
                
                if self.dataArray.count != 0{
                    self.ChatTblView.scrollToRow(at: IndexPath(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
                }else{
                    Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.ChatTblView, message: "Sorry, No message found")
                }
                if stillFriend == "1" || blockStatus == "1"{
                    if self.user_id == blockBy {
                        self.view.makeToast(message: "You have blocked this user. Kindly unblock to resume chat.")
                        self.msgView.isHidden = true
                        self.msgViewHeightConstrant.constant = 0
                    }else if self.reciever_Id == blockBy{
                        self.profileImg.isUserInteractionEnabled = false
                        
                        self.blockedLbl.text = "You have been blocked by this user"
                        self.blockedImg.image = UIImage(named: "blockicon.png")
                        self.blockedLbl.isHidden = false
                        self.blockedImg.isHidden = false
//                        self.view.makeToast(message: "You have been blocked by this user")
                        self.msgView.isHidden = true
                        self.msgViewHeightConstrant.constant = 0
                    }else{
                        self.msgView.isHidden = false
                        self.msgViewHeightConstrant.constant = 60
                    }
                }else if stillFriend == "0"{
                    self.view.makeToast(message: "You can not send message to this user")
                    self.msgView.isHidden = true
                    self.msgViewHeightConstrant.constant = 0
                }else{
                    self.msgView.isHidden = false
                    self.msgViewHeightConstrant.constant = 60
                }
                
            }
            else if status == "0"{
                self.dataArray.removeAll()
                Config().TblViewbackgroundLbl(array: self.dataArray, tblName: self.ChatTblView, message: message)
                
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.view.endEditing(true)
        let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! NSDictionary
        print(dict)
        let sender = DataManager.getVal(dict.object(forKey: "sender")) as? String ?? ""
        let is_file = DataManager.getVal(dict.object(forKey: "is_file")) as? String ?? ""
        assert(indexPath.section == 0)
        if self.user_id == sender {
            if is_file == "2"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiveGifCell" ,for: indexPath) as! receiveGifCell
                Config().setimage(name: DataManager.getVal(dict["message"]) as? String ?? "", image: cell.gifIMage)
                cell.timeDateLbl.text = DataManager.getVal(dict["created"]) as? String ?? ""
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableCell" ,for: indexPath) as! SenderTableCell
                cell.TitleLbl.text = DataManager.getVal(dict["message"]) as? String ?? ""
                cell.timelbl.text = DataManager.getVal(dict["created"]) as? String ?? ""
                return cell
            }
        }else{
            if is_file == "2"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderGifCell" ,for: indexPath) as! senderGifCell
                Config().setimage(name: DataManager.getVal(dict["message"]) as? String ?? "", image: cell.gifIMage)
                cell.timeDateLbl.text = DataManager.getVal(dict["created"]) as? String ?? ""
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverTableCell" ,for: indexPath) as! ReciverTableCell
                cell.TitleLbl.text = DataManager.getVal(dict["message"]) as? String ?? ""
                cell.timelbl.text = DataManager.getVal(dict["created"]) as? String ?? ""
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ee")
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && tableView.isEditing {
            let dict = DataManager.getVal(self.dataArray[indexPath.row]) as! NSDictionary
            let chat_id = DataManager.getVal(dict.object(forKey: "chat_id")) as? String ?? ""
            let ChatImage : UIImage? = UIImage(named:"deletemsg")?.withRenderingMode(.alwaysOriginal)
            self.chatButton = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(self.DeleteButton_Action))
            
            navigationItem.rightBarButtonItems = [self.menuBarBtn,editButtonItem]
            self.navigationItem.rightBarButtonItem = self.chatButton
            if self.chatIdArray.contains(chat_id){
                self.chatIdArray.remove(chat_id)
                print(self.chatIdArray)
                if self.chatIdArray.count > 0{
                    self.navigationItem.rightBarButtonItem = self.chatButton
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }else{
                    self.chatButton.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.editButtonItem.isEnabled = true
                    navigationItem.rightBarButtonItems = [self.menuBarBtn,editButtonItem]
                }
            }else{
                self.chatIdArray.add(chat_id)
                print(self.chatIdArray)
                if self.chatIdArray.count > 0{
                    self.editButtonItem.isEnabled = false
                    navigationItem.rightBarButtonItems = [self.menuBarBtn,self.chatButton]
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    
                }else{
                    self.chatButton.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    navigationItem.rightBarButtonItems = [self.menuBarBtn,editButtonItem]
                }
            }
            return true
        }
        return false
    }
    @objc func addMenu(){

        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let unmatchAction = UIAlertAction(title: "Unmatch", style: UIAlertAction.Style.default){
            UIAlertAction in
            let nextview = UnMatchActionPopUp.intitiateFromNib()
            let model = BackModel2()
            nextview.layer.cornerRadius = 20
            nextview.buttonYesHandler = {
                print(self.menuPopUpFriendId)
                self.getunMatchAPI(friend_id: self.menuPopUpFriendId, type: "1")
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
                    self.getReportAPI(author_id: self.m_recieverId, message: message)
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

            self.getBlockAPI(receiver_id: self.m_recieverId)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        alert.view.tintColor = UIColor.red
        alert.addAction(unmatchAction)
        alert.addAction(BlockAction)
        alert.addAction(ReportAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getunMatchAPI(friend_id: String, type: String){
        self.pleaseWait()
//        if self.isComingMatch1 == "match" {
//            self.isComingChat.removeAll()
//        }
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(friend_id), forKey: "friend_id")
        dict.setValue(DataManager.getVal(type), forKey: "type")
        
        let methodName = "friend/remove"
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            print(self.isCommingFromlikeToChat)
            if status == "1"{
                
                self.navigationController?.popViewController(animated: true)
                
//                if self.isComingChat == "chat" {
//                    if self.isCommingFromlikeToChat == "likeToChat" {
//                        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//                        self.RootViewWithSideManu(vc)
//                    }else{
//                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//                        for aViewController in viewControllers {
//                            if aViewController is MessageListVC {
//                                self.navigationController!.popToViewController(aViewController, animated: true)
//                            }
//                        }
//                    }
//                }
//                else if self.isComingMatch1 == "match"{
//                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//                    self.RootViewWithSideManu(vc)
//                }
                
//                else{
//                    self.navigationController?.popViewController(animated: true)
//                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    func getReportAPI(author_id:String, message:String){
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(author_id), forKey: "author_id")
        dict.setValue(DataManager.getVal(message), forKey: "message")

        print(author_id)
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
    
    func getBlockAPI(receiver_id:String){
        self.pleaseWait()
//        print(self.isComingMatch1)
//        if self.isComingMatch1 == "match" {
//            self.isComingChat.removeAll()
//        }
//        print(self.isComingChat)
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        dict.setValue(DataManager.getVal(receiver_id), forKey: "receiver_id")
        print(dict)
        let methodName = "blacklist/add"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                
                self.navigationController?.popViewController(animated: true)
//                if self.isComingChat == "chat" {
//                    if self.isCommingFromlikeToChat == "likeToChat" {
//                        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
//                        self.RootViewWithSideManu(vc)
//                    }else{
//                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//                        for aViewController in viewControllers {
//                            if aViewController is MessageListVC {
//                                self.navigationController!.popToViewController(aViewController, animated: true)
//                            }
//                        }
//                    }
//                }
//                else{
//                    self.navigationController?.popViewController(animated: true)
//                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    
    @objc func DeleteButton_Action(_ selector: UIBarButtonItem){
        let nextview = DeleteMessagePopUp.intitiateFromNib()
        let model = BackModel()
        nextview.layer.cornerRadius = 20
        nextview.buttonYesHandler = {
            var ids:String!
            ids = self.JSONStringify(value: self.chatIdArray as AnyObject)
            let newids = ids.replacingOccurrences(of: "[", with: "")
            let chatIds = newids.replacingOccurrences(of: "]", with: "")
            self.deleteMsgAPI(chat_id: chatIds)
            model.closewithAnimation()
        }
        nextview.buttonNoHandler = {
            model.closewithAnimation()
        }
        model.show(view: nextview)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 0 else { return false }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
//            vegetables.remove(at: indexPath.item)
            ChatTblView.reloadData()
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        ChatTblView.setEditing(editing, animated: true)
    }

    func deleteMsgAPI(chat_id:String){
        self.pleaseWait()
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(chat_id), forKey: "chat_ids")
        dict.setValue(DataManager.getVal(user_id), forKey: "user_id")
        
        let methodName = "chat/remove"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){ [self](responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                self.editButtonItem.isEnabled = true
                self.navigationItem.rightBarButtonItems = [self.menuBarBtn,editButtonItem];
                self.chatButton.isEnabled = false
                self.view.makeToast(message: message)
                self.getMessageListAPI()
            }else{
                self.view.makeToast(message: message)
            }
            self.clearAllNotice()
        }
    }
    //MARK:- Collection View Deleget
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == GifHeaderCollectionView {
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == GifHeaderCollectionView {
            return self.Header_Arr.count
        }else{
            return self.GifCollectionArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == GifHeaderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifTabCell", for: indexPath) as! GifTabCell
            cell.layer.cornerRadius = 15
            cell.tag = indexPath.row
            if self.selectedCell == indexPath.row {
                cell.lineLbl.isHidden = false
                cell.tabLbl.textColor = UIColor.systemPink
            }else{
                cell.lineLbl.isHidden = true
                cell.tabLbl.textColor = UIColor.white
            }
            cell.tabLbl.text = DataManager.getVal(self.Header_Arr[indexPath.item]) as? String ?? ""
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GIFCollectionCell", for: indexPath) as! GIFCollectionCell
            cell.tag = indexPath.row
            
            let dict = DataManager.getVal(self.GifCollectionArray[indexPath.row]) as! NSDictionary
            Config().setimage(name: DataManager.getVal(dict["url"]) as? String ?? "", image: cell.GifImageView)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == GifHeaderCollectionView {
            self.selectedCell = indexPath.row
            self.GifHeaderCollectionView.reloadData()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifTabCell", for: indexPath) as! GifTabCell
            if indexPath.item == 0 {
                self.GifCollectionArray.removeAll()
                cell.lineLbl.backgroundColor = UIColor(red: 116/255, green: 207/255, blue: 253/255, alpha: 1.0)
                self.GifCollectionArray = self.Heartfeeling_Arr
                self.GifCollectionView.reloadData()
            }else if indexPath.item == 1 {
                self.GifCollectionArray.removeAll()
                cell.lineLbl.backgroundColor = UIColor(red: 116/255, green: 207/255, blue: 253/255, alpha: 1.0)
                self.GifCollectionArray = self.Love_Arr
                self.GifCollectionView.reloadData()
            }else if indexPath.item == 2 {
                self.GifCollectionArray.removeAll()
                cell.lineLbl.backgroundColor = UIColor(red: 116/255, green: 207/255, blue: 253/255, alpha: 1.0)
                self.GifCollectionArray = self.Smiley_Arr
                self.GifCollectionView.reloadData()
            }else if indexPath.item == 3 {
                self.GifCollectionArray.removeAll()
                cell.lineLbl.backgroundColor = UIColor(red: 116/255, green: 207/255, blue: 253/255, alpha: 1.0)
                self.GifCollectionArray = self.Text_Arr
                self.GifCollectionView.reloadData()
            }else if indexPath.item == 4 {
                self.GifCollectionArray.removeAll()
                cell.lineLbl.backgroundColor = UIColor(red: 116/255, green: 207/255, blue: 253/255, alpha: 1.0)
                self.GifCollectionArray = self.Unicorn_Arr
                self.GifCollectionView.reloadData()
            }
        }else{
            let dict = DataManager.getVal(self.GifCollectionArray[indexPath.row]) as! NSDictionary
            let url = DataManager.getVal(dict["url"]) as? String ?? ""
            
            self.GifViewHeightConstraint.constant = 0
            self.GifView.isHidden = true
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "hh:mm"
            let dateString = formatter.string(from: now)
            
            SocketIoManager.sharedInstance.sendMessage(sender_id: self.user_id, reciever_id: self.receiverid, message: url, withRoom: self.room_id, is_file: "2")
            
            let chatDict = NSMutableDictionary()
            chatDict.setValue(self.user_id, forKey: "sender")
            chatDict.setValue(url, forKey: "message")
            chatDict.setValue(dateString, forKey: "time")
            
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: chatDict, userInfo: nil)
            self.MessageTxtField.text = ""
            self.ChatTblView.reloadData()
            
            if self.dataArray.count != 0{
                self.ChatTblView.scrollToRow(at: IndexPath(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == GifHeaderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifTabCell", for: indexPath) as! GifTabCell
            cell.lineLbl.backgroundColor = .clear
        }else{
            
        }
        
    }
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    //MARK:- TextField Delegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.MessageTxtField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        print(topBarHeight)
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            return
        }
        self.ScrollViewBaseView.frame.origin.y = 0 - keyboardSize.height + topBarHeight
        print(self.ScrollViewBaseView.frame.origin.y)
        print(keyboardSize)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0) - 90
        print(topBarHeight)
        self.ScrollViewBaseView.frame.origin.y = topBarHeight
    }
    func UpdateNavigationBarUI(){
        
        let titleview = UIView()
        titleview.frame = CGRect(x: 0, y: 0, width: Config().screenWidth, height: 50)
        titleview.backgroundColor = UIColor.clear
        self.navigationItem.titleView?.addSubview(titleview)
        self.navigationItem.titleView = titleview
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.profileImg.frame = CGRect(x: 0, y: 4, width: 36, height: 36)
        self.profileImg.layer.cornerRadius = 20
        self.profileImg.layer.borderWidth = 1
        self.profileImg.isUserInteractionEnabled = true
        self.profileImg.addGestureRecognizer(tap)
        self.profileImg.sd_setImage(with: URL(string: self.imagestr), placeholderImage: UIImage(named: "No image available"))
        self.profileImg.layer.borderColor = UIColor.lightGray.cgColor
        self.profileImg.contentMode = .scaleAspectFill
        self.profileImg.clipsToBounds = true
        
        self.goldImg.image = UIImage(named: "gold.png")
        self.goldImg.frame = CGRect(x: 25, y: 3, width: 20, height: 20)
        titleview.addSubview(self.profileImg)
        titleview.addSubview(self.goldImg)
        
        self.nameLbl.frame = CGRect(x: 50, y: 0, width: titleview.frame.size.width-80, height: 40)
        self.nameLbl.textColor = UIColor.white
        self.nameLbl.text = UserName
        print(UserName)
        self.nameLbl.font = Config().AppGlobalFont(18, isBold: true)
        self.nameLbl.clipsToBounds = true
        titleview.addSubview(self.nameLbl)
    
        
        self.SuperLikeImg.image = UIImage(named: "Super-like")
        self.SuperLikeImg.frame = CGRect(x: (nameLbl.text?.count ?? 0) * 9 + 7, y: 10, width: 22, height: 22)
        nameLbl.addSubview(self.SuperLikeImg)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let vc = SearchUserDetailVC(nibName: "SearchUserDetailVC", bundle: nil)
        vc.UserDetailID = self.m_recieverId
        vc.MemberShipStatus = member
        vc.isComingChat = "chat"
        vc.isComingMatch1 = self.isComingMatch
        vc.isCommingFromlikeToChat = self.isCommingFromlikeToChat
        print(vc.UserDetailID)
        self.onlyPushViewController(vc)
    }
}
