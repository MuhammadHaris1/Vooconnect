//
//  RatioView.swift
//  Vooconnect
//
//  Created by Mac on 15/06/2023.
//

import UIKit
import ARGear

let kRatioViewTopBottomAlign169 = -44
let kRatioViewTopBottomAlign43 = 0
let kRatioViewTopBottomAlign11 = 64

let kRatioViewBottomViewTopAlign169 = 260
let kRatioViewBottomViewTopAlign43 = 0
let kRatioViewBottomViewTopAlign11 = -(UIScreen.main.bounds.size.width * 4/3 - UIScreen.main.bounds.size.width) + 64

typealias RatioViewCompletion = () -> Void

class RatioView: UIView{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var bottomView: UIView!

    
    @IBOutlet weak var topView: UIView!
    
//    setRatio(ARGMediaRatio(rawValue: self.tag) ?? ._4x3)
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        let screenRatio = UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
        switch ratio {
        case ._16x9:
            break
    //        bottomView.isHidden = true
        case ._4x3: break
            
            
    //        bottomView.isHidden = false
            
        case ._1x1: break
    //        self.bottomView.isHidden = false
            
        default:
            break
        }
        
    }

    func blur(_ blur: Bool) {
        blurView.isHidden = !blur
    }

    private func animate(_ animate: @escaping RatioViewCompletion, completion: RatioViewCompletion?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                animate()
                self.layoutIfNeeded()
            }) { complete in
                completion?()
                self.blur(false)
            }
        }
    }
}



