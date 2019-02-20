//
//  ViewController.swift
//  CameraFilter
//
//  Created by Munesada Yohei on 2019/02/19.
//  Copyright © 2019年 Munesada Yohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションタイトルを設定します.
        self.title = "加工する画像を選ぼう"
    }

    // 「カメラを起動する」がタップされた.
    @IBAction func onTapCamera(_ sender: Any) {
        
        // カメラが利用できるかをチェックします.
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            self.showAlert(message: "カメラは利用できません")
            return
        }
        
        // カメラを表示する.
        let picker = UIImagePickerController()
        // 表示タイプは「カメラ」にする.
        picker.sourceType = .camera
        // delegate を指定する.
        picker.delegate = self
        // カメラ画面を起動する.
        self.present(picker, animated: true, completion: nil)
        
    }
    
    // 「写真から選ぶ」がタップされた.
    @IBAction func onTapPhoto(_ sender: Any) {
        
        // 写真アプリが利用できるかをチェックします.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            self.showAlert(message: "写真アプリは利用できません")
            return
        }
        
        // 写真アプリを起動します.
        let picker = UIImagePickerController()
        // 表示タイプは「カメラ」にします.
        picker.sourceType = .photoLibrary
        // delegate を指定します.
        picker.delegate = self
        // 起動します.
        self.present(picker, animated: true, completion: nil)
    }
    
    // Segue で画面遷移をする時.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // FilterViewController の image に画像を渡します.
        if let vc = segue.destination as? FilterViewController {
            if let image = sender as? UIImage {
                vc.image = image
            }
        }
    }
    
}

// 中身を実装する必要はないが、カメラなど使うために、継承する必要がある.
extension ViewController : UINavigationControllerDelegate { }

// カメラ撮影後など、画像取得する際に利用します.
extension ViewController : UIImagePickerControllerDelegate {
    
    // カメラ撮影後や写真選択後に呼び出されます.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // カメラ画面を閉じる.
        picker.dismiss(animated: true, completion: nil)
        
        // 画像を取得します.
        if let image = info[.originalImage] as? UIImage {
            
            // 加工画面に遷移します.
            self.performSegue(withIdentifier: "show", sender: image)
        }
    }
    
}
