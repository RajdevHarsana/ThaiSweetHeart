//
//  RequestVerificationVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 23/06/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class RequestVerificationVC: BaseViewSideMenuController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImg1: UIImageView!
    @IBOutlet weak var profileImage1widthCon: NSLayoutConstraint!
    @IBOutlet weak var profilevcImgleftConst: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var getVerifiedBtn: UIButton!
    var menuBarBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kRequest_Verification : kThRequest_Verification
        self.profileImage.layer.cornerRadius = 15
        self.profileImg1.layer.cornerRadius = 15
        self.uploadImgBtn.layer.cornerRadius = 15
        self.getVerifiedBtn.layer.cornerRadius = 15
        self.getVerifiedBtn.isHidden = true
        self.getSampleImage()
        // Do any additional setup after loading the view.
    }
    //MARK:- Sample Image API
    func getSampleImage(){
        self.pleaseWait()
        self.profileImg1.isHidden = true
        let dict = NSMutableDictionary()
        dict.setValue(self.user_id, forKey: "user_id")
        
        let methodName = "option/sample-pose-image"
        
        DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            if status == "1"{
                Config().setimage(name: DataManager.getVal(responseData?["image"]) as? String ?? "", image: self.profileImage)
                self.clearAllNotice()
            }else{
                
                self.view.makeToast(message: message)
                self.clearAllNotice()
            }
            self.clearAllNotice()
        }
    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Upload Image Button Action
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        let Picker = UIImagePickerController()
        Picker.delegate = self
        Picker.sourceType = .camera
        self.present(Picker, animated: true, completion: nil)
//
//        let actionSheet = UIAlertController(title: nil, message: "Choose your source", preferredStyle: UIAlertController.Style.actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
//
//            Picker.sourceType = .camera
//            self.present(Picker, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
//
//            Picker.sourceType = .photoLibrary
//            self.present(Picker, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
    }
    //MARK:- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                self.profileImg1.image = image   
                self.profileImg1.isHidden = false
                self.profilevcImgleftConst.constant = 200
                self.profileImg1.layer.cornerRadius = 15
            }else{
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    self.profileImg1.image = image
                    self.profileImg1.isHidden = false
                    self.profilevcImgleftConst.constant = 200
                    self.profileImg1.layer.cornerRadius = 15
                }
            }
        })
        self.getVerifiedBtn.isHidden = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- Get Verified Button Action
    @IBAction func getVerifiedBtnAction(_ sender: UIButton) {
        
        self.pleaseWait()
        
        let dict = NSMutableDictionary()
        dict.setValue(DataManager.getVal(self.user_id), forKey: "user_id")
        //For upload image
        let dataArr = NSMutableArray()
        let dataDict = NSMutableDictionary()
        dataDict.setObject("image", forKey: "image" as NSCopying)
        dataDict.setObject(resize(self.profileImg1.image!).pngData()!, forKey: "imageData" as NSCopying)
        dataDict.setObject("png", forKey: "ext" as NSCopying)
        dataArr.add(dataDict)
        
        let methodName = "profile/account-verity-request"
        
        DataManager.getAPIResponseFileSingleImage(dict, methodName: methodName as NSString ,dataArray: dataArr){(responseData,error)-> Void in
            
            let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
            let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
            
            if status == "1"{
                let nextview = RequestVerify.intitiateFromNib()
                let model = BackModel()
                nextview.layer.cornerRadius = 20
                nextview.buttonDoneHandler = {
                   model.closewithAnimation()
                    let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.RootViewWithSideManu(vc)
                }
                model.show(view: nextview)
            }else{
                self.view.makeToast(message: message)
            }
                self.clearAllNotice()
        }
    }
    
}
