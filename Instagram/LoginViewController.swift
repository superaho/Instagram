//
//  LoginViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/22.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displaynameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { (AuthResult, error) in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                SVProgressHUD.dismiss()
                
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayname = displaynameTextField.text {
            
            //テキストフィールドが空の場合は何もしない
            if address.isEmpty || password.isEmpty || displayname.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            //アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) {
                authResult, error in
                if let error = error {
                    //エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayname
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                        SVProgressHUD.dismiss()
                        
                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
