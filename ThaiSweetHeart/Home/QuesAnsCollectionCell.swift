//
//  QuesAnsCollectionCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 18/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class QuesAnsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellView.layer.cornerRadius = 8
    }

}
