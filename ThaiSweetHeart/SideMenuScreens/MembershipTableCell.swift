//
//  MembershipTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 03/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class MembershipTableCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var BackView: MyView!
    @IBOutlet weak var PlanListTblView: UITableView!
    @IBOutlet weak var buybtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var PlanListTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: MyButton!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
