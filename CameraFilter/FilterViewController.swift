//
//  FilterViewController.swift
//  CameraFilter
//
//  Created by Munesada Yohei on 2019/02/19.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class FilterViewController : UIViewController {
    
    // ユーザーが選択した画像.
    var image: UIImage!
    
    // 温かみフィルターを使うか
    var warmFilterEnabled = false
    
    // 彩度（画像の鮮やかさ）フィルターに利用する値.
    // -1 〜 1 までを画像のスライダーで指定できるようにします.
    var saturationFilterValue: Float = 0
    
    // オリジナル画像View.
    @IBOutlet weak var originalImageView: UIImageView!
    
    // フィルターをかけた画像View.
    @IBOutlet weak var filteredImageView: UIImageView!
    
    override func viewDidLoad() {
        self.title = "フィルター加工しよう！"
        
        // 最初は、どちらのImageViewにも、ユーザーの選択した画像を表示する.
        self.originalImageView.image = image
        self.filteredImageView.image = image
        
        // ナビゲーション右に保存ボタンを追加します.
        let rightButton = UIBarButtonItem(title: "保存する", style: .plain, target: self, action: #selector(FilterViewController.saveImage))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    // 温かみを追加ボタンがタップされた.
    @IBAction func onTapWarm(_ sender: Any) {
        
        // 温かみフィルターを利用するかを、トグルする.
        self.warmFilterEnabled = !self.warmFilterEnabled
        
        // フィルターを適用する.
        self.adaptFilter()
    }
    
    // スライダーで値が変わった.
    @IBAction func onChangeSlider(_ sender: UISlider) {

        // スライダーの値を取得.
        self.saturationFilterValue = sender.value
        
        // フィルターを適用する.
        self.adaptFilter()
    }
    
    // 画像にフィルターをかけます.
    private func adaptFilter() {
        
        // 加工対象の画像を用意します.
        guard var image = self.image else {
            return
        }
        
        // 温かみフィルターがONの場合は、適用します.
        if self.warmFilterEnabled {
            
            // CIImageに変換します.
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            // 温かみフィルターを作成します.
            guard let filter = CIFilter(name: "CIPhotoEffectTransfer") else {
                return
            }
            
            // 温かみフィルターを適用します.
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // CIImage から CGImage に変換します.
            guard
                let outputCIImage = filter.outputImage,
                let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: outputCIImage.extent) else {
                    return
            }
            
            // CGImage から UIImage に変換します.
            let filteredImage = UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
            
            // 加工対象の画像の変数に代入します.
            image = filteredImage
        }
        
        // 彩度フィルターを適用する.
        if self.saturationFilterValue != 0 {
            
            // CIImageの作成する.
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            // 彩度フィルターを作成する.
            guard let filter = CIFilter(name: "CIVibrance") else {
                return
            }
            
            // フィルターに彩度を指定する.
            filter.setValue(self.saturationFilterValue, forKey: "inputAmount")
            
            // フィルターを適用する.
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // CGImageを作成する.
            guard
                let outputCIImage = filter.outputImage,
                let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: outputCIImage.extent) else {
                    return
            }
            
            // CGImage から UIImage を作成する.
            let filteredImage = UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
            
            // 加工対象の画像の変数に代入します.
            image = filteredImage
        }
        
        
        // フィルター画像Viewに反映します.
        self.filteredImageView.image = image
    }
    
    
    // 画像を保存する.
    @objc func saveImage() {
        
        // フィルター加工した画像を取得します.
        guard let filteredImage = self.filteredImageView.image else {
            return
        }
        
        // 写真アプリに保存します.
        UIImageWriteToSavedPhotosAlbum(filteredImage, nil, nil, nil)
    }
}
