//
//  CommentViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/26.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var textfield: UITextField!
    
    var postArray: [PostData] = []
    var postData: PostData!
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    if self.postData.id == document.documentID {
                        self.postData = PostData(document: document)
                    }
                    return self.postData
                }
                // TableViewの表示を更新する
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = .none
        cell.CommentButton.isHidden = true
        cell.setPostData(postData)
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    @IBAction func firmbutton(_ sender: Any) {
        let user = Auth.auth().currentUser
        var updateValue: FieldValue
        let comment = user!.displayName! + ": " + textfield.text!
        
        updateValue = FieldValue.arrayUnion([comment])
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        postRef.updateData(["comment" : updateValue])
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
