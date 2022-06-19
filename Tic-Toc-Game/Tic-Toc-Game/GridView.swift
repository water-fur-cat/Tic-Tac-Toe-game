//
//  GridView.swift
//  Tic-Toc-Game
//
//  Created by 周越 on 2/6/22.
//

import UIKit

class GridView: UIView {

    var row: UIBezierPath!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        row = UIBezierPath()
        row.lineWidth = 5
    
        row.move(to: CGPoint(x: 125, y: 0))
        row.addLine(to: CGPoint(x: 125, y: self.frame.size.height))
        row.move(to: CGPoint(x: 265, y: 0))
        row.addLine(to: CGPoint(x: 265, y: self.frame.size.height))
        row.move(to: CGPoint(x: 0, y: 125))
        row.addLine(to: CGPoint(x: self.frame.size.width, y: 125))
        row.move(to: CGPoint(x: 0, y: 265))
        row.addLine(to: CGPoint(x: self.frame.size.width, y: 265))
        
        UIColor.orange.setStroke()
        row.stroke()
    }
    

}
