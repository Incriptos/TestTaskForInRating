//
//  UserCollectionViewCell.swift
//  TestTaskForInRating
//
//  Created by Andrew Vashulenko on 13.12.2018.
//  Copyright © 2018 AVTeam. All rights reserved.
//

import UIKit
import Alamofire

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configure(at indexPath: IndexPath, collectionViewNumber: Int) {
        
        guard let name = User.users[collectionViewNumber][indexPath.row].name else { return }
        nameLabel.text = name
        
        guard let avatar = User.users[collectionViewNumber][indexPath.row].avatar else { return }
        Alamofire.request(avatar).response { response in
            guard let data = response.data else { return }
            self.avatarImage.image = UIImage(data: data)
        }
    }
}
