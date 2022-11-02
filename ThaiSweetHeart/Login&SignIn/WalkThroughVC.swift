//
//  WalkThroughVC.swift
//  Directory Cum
//
//  Created by mac-15 on 05/12/19.
//  Copyright © 2019 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class WalkThroughVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var WalkThroughCollectionView: UICollectionView!
    @IBOutlet weak var SkipButton: UIButton!
    @IBOutlet weak var Nextbutton: MyButton!
    @IBOutlet weak var PageController: UIPageControl!
    @IBOutlet weak var CollectionHeightConstraint: NSLayoutConstraint!//550
    var logoImage = [String]()
    var DetailsLbl = [String]()
    var titleLbl = [String]()
    var layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
        self.navigationController?.isNavigationBarHidden = true
        self.logoImage = ["intro1","intro2","intro3"]
        self.DetailsLbl = ["Your profile is very important, the more effort you put into your dating profile to show others you're available and interested, also help our system to find your matches.","Not just 1 but 7 Features that will match with your preference.","Make your first move, message your match and do respond. Show that you've read their profile by commenting on something they've written or about a specific photo of theirs, or better yet. Make it engaging!"]
        self.titleLbl = ["Fill in All the Fields","Enjoy our 7 Features","Breaking an Ice"]
        self.layout.itemSize = CGSize(width: Config().screenWidth, height: self.WalkThroughCollectionView.frame.height)
        self.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layout.minimumInteritemSpacing = 0
        self.layout.minimumLineSpacing = 0
        self.layout.scrollDirection = .horizontal
        
        let nib = UINib(nibName: "WalkthroughCollectionCell", bundle: nil)
        self.WalkThroughCollectionView.register(nib, forCellWithReuseIdentifier: "WalkthroughCollectionCell")
        self.WalkThroughCollectionView.collectionViewLayout = layout

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                self.CollectionHeightConstraint.constant = 350
            case 1334:
                print("iPhone 6/6S/7/8")
                self.CollectionHeightConstraint.constant = 520
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                self.CollectionHeightConstraint.constant = 550
            case 2436:
                print("iPhone X/XS/11 Pro")
                self.CollectionHeightConstraint.constant = 550
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                self.CollectionHeightConstraint.constant = 550
            case 1792:
                print("iPhone XR/ 11 ")
                self.CollectionHeightConstraint.constant = 550
            default:
                print("Unknown")
                self.CollectionHeightConstraint.constant = 550
            }
        }
    }
    @IBAction func SkipButtonAction(_ sender: UIButton) {
        Config().AppUserDefaults.set("1", forKey: "WalkthroughCompleted")
        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
        self.onlyPushViewController(vc)
    }
    @IBAction func NextButtonAction(_ sender: UIButton) {
        if self.PageController.currentPage == self.logoImage.count - 1 {
            Config().AppUserDefaults.set("1", forKey: "WalkthroughCompleted")
            let vc = LoginVC(nibName: "LoginVC", bundle: nil)
            self.onlyPushViewController(vc)
        }else{
            self.PageController.currentPage += 1
            let visibleItems : NSArray = self.WalkThroughCollectionView.indexPathsForVisibleItems as NSArray
            let currentItem : IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem : IndexPath = IndexPath(item: (currentItem.item + 1), section: 0)
            
            if nextItem.row < self.logoImage.count {
                self.WalkThroughCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.PageController.currentPage = indexPath.row
        if indexPath.row == 0{
            self.SkipButton.isHidden = false
            self.Nextbutton.setTitle("Next", for: .normal)
        }else if indexPath.row == 1{
            self.Nextbutton.setTitle("Next", for: .normal)
            self.SkipButton.isHidden = false
        }else if indexPath.row == 2{
            self.Nextbutton.setTitle("Finish", for: .normal)
            self.SkipButton.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.logoImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCollectionCell", for: indexPath) as! WalkthroughCollectionCell
        cell.tag = indexPath.row
        cell.Details_lbl.text = DetailsLbl[indexPath.row]
        cell.titleLbl.text = titleLbl[indexPath.row]
        cell.ImgView.image = UIImage(named: logoImage[indexPath.item])
        return cell
    }
}

