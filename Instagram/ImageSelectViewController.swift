//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI553 on 2021/04/22.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            
            print("DEBUG_PRINT: image = \(image)")
            
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            editor.modalPresentationStyle = .fullScreen
            //UIImageControllerのpickerから遷移するのでpickerは必須
            picker.present(editor, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //質問で聞きたいところ
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        let postViewContriller = storyboard!.instantiateViewController(identifier: "post") as! PostViewController
        postViewContriller.image = image!
        editor.present(postViewContriller, animated: true, completion: nil)
    }
    
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func libraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    @IBAction func cameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
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
