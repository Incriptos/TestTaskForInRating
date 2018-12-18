//
//  PostStatisticTVC.swift
//  TestTaskForInRating
//
//  Created by Andrew Vashulenko on 13.12.2018.
//  Copyright © 2018 AVTeam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostStatisticTVC: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesCollectionView: UICollectionView!{
        didSet {
            likesCollectionView.delegate = self
            likesCollectionView.dataSource = self
            likesCollectionView.register(UINib.init(nibName: "UserCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "UserCell")
        }
    }
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsCollectionView: UICollectionView! {
        didSet {
            commentsCollectionView.delegate = self
            commentsCollectionView.dataSource = self
            commentsCollectionView.register(UINib.init(nibName: "UserCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier: "UserCell")
            
        }
    }
    
    @IBOutlet weak var mentionsLabel: UILabel!
    @IBOutlet weak var mentionsCollectionView: UICollectionView! {
        didSet {
             mentionsCollectionView.delegate = self
             mentionsCollectionView.dataSource = self
             mentionsCollectionView.register(UINib.init(nibName: "UserCollectionViewCell", bundle: nil),
                                           forCellWithReuseIdentifier: "UserCell")
        }
    }
    
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var repostsCollectionView: UICollectionView! {
        didSet {
            repostsCollectionView.delegate = self
            repostsCollectionView.dataSource = self
            repostsCollectionView.register(UINib.init(nibName: "UserCollectionViewCell", bundle: nil),
                                           forCellWithReuseIdentifier: "UserCell")
        }
    }
    
    @IBOutlet weak var bookmarksLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInformation(with: baseURL, parameters: params, categories: .fetchID)
        
    }
    
    // MARK: Network
    func getInformation(with url: String, parameters: [String: String]?, categories: Category) {
        
        let header = ["Authorization": "Bearer \(accessToken)"]
        
        guard let url = URL(string: url) else { return }
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
            if response.result.isSuccess {
                
                guard let value = response.result.value else { return }
                let json = JSON(value)
                
                
                switch categories {
                case .fetchID:
                    let id = self.gettingID(with: json)
                    self.getInformation(with: likesLink,
                                   parameters: ["id" : id], categories: .fetchLikers)
                    self.getInformation(with: repostsLink,
                                        parameters: ["id" : id], categories: .fetchReposters)
                    self.getInformation(with: commentsLink,
                                        parameters: ["id" : id], categories: .fetchCommenters)
                    self.getInformation(with: mentionsLink,
                                        parameters: ["id" : id], categories: .fetchMentioned)
                default:
                    self.gettingUsers(with: json, for: categories.rawValue)
                }
            } else {
                print("Error \(String(describing: response.result.error)).")
            }
        }
    }
    
    //MARK: - Getting id
    func gettingID(with json: JSON) -> String {
        
        bookmarksLabel.text = "Закладки " + json["bookmarks_count"].stringValue
        repostsLabel.text = "Репосты " + json["reposts_count"].stringValue
        viewsLabel.text = "Просмотры " + json["views_count"].stringValue
        likesLabel.text = "Лайки " + json["likes_count"].stringValue
        mentionsLabel.text = "Отметки " + json["attachments"]["images"][0]["mentioned_users_count"].stringValue
        
        return json["id"].stringValue
    }
    
    func gettingUsers(with json: JSON, for row: Int) {
        
        let data = json["data"].arrayValue
        for i in 0..<data.count {
            let image = data[i]["avatar_image"]["url_medium"].stringValue
            let name = data[i]["nickname"].stringValue
            User.users[row].append(User(name: name, avatar: image))
        }
        
        switch row {
        case 1:
            if User.users[1].count != 0 {
                likesCollectionView.isHidden = false
            }
            likesCollectionView.reloadData()
        case 2:
            if User.users[2].count != 0 {
                commentsCollectionView.isHidden = false
            }
            commentsCollectionView.reloadData()
        case 3:
            if User.users[3].count != 0 {
                mentionsCollectionView.isHidden = false
            }
            mentionsCollectionView.reloadData()
        case 4:
            if User.users[4].count != 0 {
                repostsCollectionView.isHidden = false
            }
            repostsCollectionView.reloadData()
        default:
            break
        }
        tableView.reloadData()
    }
}
