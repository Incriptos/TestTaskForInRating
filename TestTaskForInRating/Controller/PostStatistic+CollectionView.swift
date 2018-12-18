//
//  PostStatistic+CollectionView.swift
//  TestTaskForInRating
//
//  Created by Andrew Vashulenko on 17.12.2018.
//  Copyright © 2018 AVTeam. All rights reserved.
//

import Foundation
import UIKit

extension PostStatisticTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 95, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case likesCollectionView:
            return User.users[1].count
        case commentsCollectionView:
            commentsLabel.text = "Комментаторы \(User.users[2].count)"
            return User.users[2].count
        case mentionsCollectionView:
            return User.users[3].count
        case repostsCollectionView:
            return User.users[4].count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCollectionViewCell
        
        switch collectionView {
        case likesCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 1)
        case commentsCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 2)
        case mentionsCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 3)
        case repostsCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 4)
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if User.users[indexPath.section].count == 0 {
            return 44
        } else {
            return 170
        }
    }
}
