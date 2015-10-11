//
//  eventTableCell.swift
//  socializr
//
//  Created by Max Saienko on 6/9/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var flagIcon: UIImageView!
    var isFlagged: Bool = false
    
    func loadCell(title title: String, isFlagged: Bool) {
        flagIcon.image = isFlagged ? UIImage(named: "redFlagIcon") : nil
        self.isFlagged = isFlagged
        label.text = title
    }
}
