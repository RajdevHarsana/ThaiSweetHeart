//
//  QuestionCellNew.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 10/12/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class QuestionCellNew: UITableViewCell {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var ansTxt: UITextField!
    @IBOutlet weak var andTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.andTextView.layer.cornerRadius = 6
        self.andTextView.layer.borderWidth = 0.6
        self.andTextView.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
