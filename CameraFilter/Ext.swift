//
//  Ext.swift
//  Map
//
//  Created by Munesada Yohei on 2019/02/07.
//  Copyright © 2019年 Munesada Yohei. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // アラートを表示する.
    func showAlert(message: String) {
        // アラートを作成します.
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        // OKボタンを追加.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        // アラートを表示します.
        self.present(alert, animated: true)
    }
}
