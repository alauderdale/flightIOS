//
//  beerCell.swift
//  brewTest
//
//  Created by Alex Lauderdale on 12/17/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit

class beerCell: UITableViewCell {

    @IBOutlet weak var beerLbl: UILabel!
    @IBOutlet weak var breweryLbl: UILabel!
    @IBOutlet weak var beerLabelImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
