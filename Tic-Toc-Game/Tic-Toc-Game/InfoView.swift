//
//  InfoView.swift
//  Tic-Toc-Game
//
//  Created by 周越 on 2/6/22.
//

import UIKit

class InfoView: UIView {
    
    var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label?.textColor = .white
        label?.textAlignment = .center
        
        label?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label?.numberOfLines = 4
        
        label?.layer.cornerRadius = 20
        label?.layer.borderColor = UIColor.white.cgColor
        label?.layer.borderWidth = 3
        
        label?.layer.masksToBounds = true
        label?.lineBreakMode = .byWordWrapping
      }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
