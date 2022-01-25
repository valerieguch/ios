//
//  HW4TableViewCell.swift
//  HW_4
//
//  Created by Valerie Guch on January 2022
//

import UIKit

class HW4TableViewCell: UITableViewCell {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var cellimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
