//
//  TransactionTableViewCell.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    static let reuseID = String(describing: TransactionTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
