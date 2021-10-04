//
//  Repo_TableViewCell.swift
//  GitHubTest
//
//  Created by Carlos Bastida on 04/10/21.
//

import UIKit

class Repo_TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var starsLabel : UILabel!
    @IBOutlet weak var forksLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with model: Repo){
        self.nameLabel.text = model.name ?? "No Name"
        self.starsLabel.text = "\(model.stargazers_count ?? 0)"
        self.forksLabel.text = "\(model.forks_count ?? 0)"

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
