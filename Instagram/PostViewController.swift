//
//  PostViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/22.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
    }
    @IBAction func SenderButton(_ sender: Any) {
        //画像をファイルとして保存するためにJPEG形式のデータに変換する
        //JPEG形式のデータを画像ファイルとしてCloud Storageにアップロードする
        //投稿データ（投稿者名、キャプション、投稿日時等）をCloud Firestoreに保存する
        let imageData = image.jpegData(compressionQuality: 0.75)
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        let metaData = StorageMetadata()
        //update image
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metaData) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            //update postData
            let name = Auth.auth().currentUser?.displayName
            let postDic =
                ["name": name!,
                 "caption": self.textField.text!,
                 "date": FieldValue.serverTimestamp()
                ] as [String : Any]
            postRef.setData(postDic)
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了し、先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
