//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/23.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likelabel: UILabel!
    @IBOutlet weak var CommentButton: UIButton!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var captionlabel: UILabel!
    @IBOutlet weak var commentlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        ImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        ImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionlabel.text = "\(postData.name!) : \(postData.caption!)"
        
        var comment = ""
        for value in postData.comment {
            comment = comment + "\(value)\n"
        }
        self.commentlabel.text = comment

        // 日時の表示
        self.datelabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.datelabel.text = dateString
            
            // いいね数の表示
            let likeNumber = postData.likes.count
            likelabel.text = "\(likeNumber)"

            // いいねボタンの表示
            if postData.isLiked {
                let buttonImage = UIImage(named: "like_exist")
                self.likeButton.setImage(buttonImage, for: .normal)
            } else {
                let buttonImage = UIImage(named: "like_none")
                self.likeButton.setImage(buttonImage, for: .normal)
            }
        }
    }
}
