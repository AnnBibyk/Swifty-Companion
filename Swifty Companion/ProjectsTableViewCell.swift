//
//  ProjectsTableViewCell.swift
//  Swifty Companion
//
//  Created by Anna Bibyk on 22.02.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
