//
//  SkillsTableViewCell.swift
//  Swifty Companion
//
//  Created by Dillon MATHER on 2017/11/08.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
