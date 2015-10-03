//
//  resultsCell.swift
//  weDrive
//
//  Created by Manab Chetia on 3/10/2015.
//  Copyright © 2015 michelle. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let theWidith = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidith, 120)
        
        usernameLbl.center = CGPointMake(230, 55)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
