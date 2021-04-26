//
//  SettingViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/22.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var displaynameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        //線の太さ(太さ)
        imageView.layer.borderWidth = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        if let user = user {
            displaynameTextField.text = user.displayName
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(user.uid + ".jpg")
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if error == nil {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            let user = Auth.auth().currentUser
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(user!.uid + ".jpg")
            imageRef.delete { (error) in
                if error != nil {
                    print("エラー")
                    print(error!)
                }
            }
            let image = info[.originalImage] as! UIImage
            let imageData = image.jpegData(compressionQuality: 0.75)
            let metaData = StorageMetadata()
            //update image
            metaData.contentType = "image/jpeg"
            imageRef.putData(imageData!, metadata: metaData) { (_: StorageMetadata?, error) in
                if error != nil {
                    // 画像のアップロード失敗
                    print(error!)
                    // 投稿処理をキャンセルし、先頭画面に戻る
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func changeNameButton(_ sender: Any) {
        if let displayname = displaynameTextField.text {
            if displayname.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayname
                changeRequest.commitChanges { (Error) in
                    if let error = Error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。22")

                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    
                    //SVProgressHUD.dismiss()
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        //logout
        try! Auth.auth().signOut()
        
        let loginViewController = storyboard!.instantiateViewController(identifier: "login")
        present(loginViewController, animated: true, completion: nil)
        
        tabBarController?.selectedIndex = 0
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
