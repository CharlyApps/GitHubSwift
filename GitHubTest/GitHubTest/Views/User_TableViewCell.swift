//
//  User_TableViewCell.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import UIKit
import SDWebImage

class User_TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model: Item){
        self.nameLabel.text = model.login
        self.profileImage.sd_setImage(with: URL(string: model.avatar_url!))
        self.scoreLabel.text = "Score: \(model.score ?? 0.0)"
    }

}
