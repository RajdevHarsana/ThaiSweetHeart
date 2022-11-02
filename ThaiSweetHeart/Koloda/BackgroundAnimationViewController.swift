
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.


import UIKit
import Koloda
import pop

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {

    var arr_data = ["abc","pqr","stu","xyz","mno","qwerty","yahhooo"]
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
//        super.viewDidLoad()
//        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
//        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
//        kolodaView.delegate = self
//        kolodaView.dataSource = self
//        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
//extension BackgroundAnimationViewController: KolodaViewDelegate {
//
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        kolodaView.resetCurrentCardIndex()
//    }
//
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//    }
//
//    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
//        return true
//    }
//
//    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
//        return false
//    }
//
//    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
//        return true
//    }
//
//    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
//        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
//        animation?.springBounciness = frameAnimationSpringBounciness
//        animation?.springSpeed = frameAnimationSpringSpeed
//        return animation
//    }
//}

// MARK: KolodaViewDataSource
//extension BackgroundAnimationViewController: KolodaViewDataSource {
//
//    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
//        return .default
//    }
//
//    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
//        return numberOfCards
//    }
//
//    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        let tempVw = myView()
//
//        tempVw.img_1.image = UIImage(named: "cards_\(index + 1)")
////        tempVw.img_2.image = UIImage(named: "cards_\(index + 1)")
////        tempVw.img_3.image = UIImage(named: "cards_\(index + 1)")
////        tempVw.img_4.image = UIImage(named: "cards_\(index + 1)")
////        tempVw.img_5.image = UIImage(named: "cards_\(index + 1)")
//
//        tempVw.collectionVw.dataSource = self
//        tempVw.collectionVw.delegate = self
//        tempVw.collectionVw.register(UINib.init(nibName: "myCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
//        tempVw.collectionVw.reloadData()
//
//        return tempVw
//       // return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
//    }
//
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
//}
//
//
//extension BackgroundAnimationViewController : UICollectionViewDelegate , UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arr_data.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! myCellCollectionViewCell
//        cell.lbl_data.text = arr_data[indexPath.row]
//
//        return cell
//    }
//
//
//}
