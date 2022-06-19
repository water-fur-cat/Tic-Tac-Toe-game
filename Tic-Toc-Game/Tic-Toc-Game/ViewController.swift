//
//  ViewController.swift
//  Tic-Toc-Game
//
//  Created by 周越 on 2/6/22.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var grid = Grid()
    var infoView:InfoView!
    
    @IBOutlet var cell: [UIView]!
    @IBOutlet weak var playerX: UILabel!
    @IBOutlet weak var playerO: UILabel!
    @IBOutlet weak var hint: UIButton!
    weak var shapeLayer: CAShapeLayer?
    
    var initialCenter = CGPoint()
    var player = 1
    
    let Xpos = CGPoint(x:90.0, y: 710.0)
    let Opos = CGPoint(x:300.0, y: 710.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGestures(playerX)
        addGestures(playerO)
        noticePlayer(playerX, initialPos: Xpos)
        
        playerO.isUserInteractionEnabled = false
        playerO.alpha = 0.5
        
        infoView = InfoView(frame: CGRect(x: 0, y: 0, width: 300, height: 780))
        infoView.label = UILabel(frame: CGRect(x: 95, y: -200, width: 200, height: 140))
        infoView.awakeFromNib()
        view.addSubview(infoView.label)
        
        let tapToDissmiss = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(recognizer:)))
        infoView.label.isUserInteractionEnabled = true
        infoView.label.addGestureRecognizer(tapToDissmiss)
        
        hint.addTarget(self,
                       action: #selector(self.tapButton(sender:)),
                         for: UIControl.Event.touchUpInside)
        
    }
    
    func noticePlayer(_ label:UILabel, initialPos:CGPoint){
        label.center = initialPos
        label.alpha = 1
        let rotate = CGAffineTransform(rotationAngle: 45)
        label.transform = rotate
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            label.transform = .identity},completion:{ (finished: Bool) in label.isUserInteractionEnabled = true
            })
    }
    
    func addGestures(_ view: UILabel) {
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
        panGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    
    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer){
        guard recognizer.view != nil else {return}
        let p = recognizer.view!
        var out = true
        self.view.bringSubviewToFront(p)
        let translation = recognizer.translation(in: self.view)
        p.center = CGPoint(x: p.center.x + translation.x, y: p.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .began {
            self.initialCenter = p.center
        }
        // check if player locates at an empty cell and update game info
        
        if recognizer.state == .ended {
            for i in 0...cell.count-1{
                if p.frame.intersects(cell[i].frame) && grid.checkEmpty(i){
                    UIView.animate(withDuration: 0.6) {
                        p.center = self.cell[i].center
                    }
                    grid.occupyGrid(i)
                    UpdateGame(i)
                    out = false
                    player = -(player)
                    break
                }
            }
            // reallocate player if released out of grid
            if out == true {
                UIView.animate(withDuration: 0.6) {
                    p.center = self.initialCenter
                }
            }
        }
    }
    
    func freezeGame(){
        playerO.center = Opos
        playerX.center = Xpos
        playerO.isUserInteractionEnabled = false
        playerX.isUserInteractionEnabled = false
        playerO.alpha = 0.5
        playerX.alpha = 0.5
        
    }
    
    func UpdateGame(_ index:Int) {
        if player == 1 {
            grid.patternX.append(index)
            let image = UIImage(named:"X.jpg")!
            let imageV = UIImageView(image: image)
            imageV.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            cell[index].addSubview(imageV)
            if grid.checkWin(grid.patternX) {
                freezeGame()
                drawLine(grid.patternX)
                // create delay refer to
                // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.modifyLabel(content: "X wins!    ————————————     OK")
                })
            }
            else if grid.checkTie() {
                freezeGame()
                modifyLabel(content: "Tie!    ————————————     OK")
            }
            else {
                playerX.center = Xpos
                playerX.isUserInteractionEnabled = false
                playerX.alpha = 0.5
                noticePlayer(playerO, initialPos: Opos)
            }
        }
        else{
            grid.patternO.append(index)
            let image = UIImage(named: "O.jpg")!
            let imageV = UIImageView(image: image)
            imageV.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            cell[index].addSubview(imageV)
            if grid.checkWin(grid.patternO) {
                freezeGame()
                drawLine(grid.patternO)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.modifyLabel(content: "O wins!    ————————————     OK")
                })
            }
            else {
                playerO.center = Opos
                playerO.isUserInteractionEnabled = false
                playerO.alpha = 0.5
                noticePlayer(playerX, initialPos: Xpos)
            }
        }
    }
    
    @objc func tapButton(sender: UIButton!) {
        modifyLabel(content: "Get 3 in a row to win!    ————————————     OK")
        print("button tapped")
    }
    
    func modifyLabel(content: String) {
        self.infoView.label.center = CGPoint(x: 190, y: -200)
        infoView.label.text = content
        self.view.bringSubviewToFront(infoView.label)
        UIView.animate(withDuration: 0.6) {
            self.infoView.label.center = CGPoint(x: 190, y: 400)
        }
    }
    
    @objc func tapLabel(recognizer:UITapGestureRecognizer){
        guard recognizer.view != nil else {return}
        let p = recognizer.view!
        UIView.animate(withDuration: 0.6) {
            p.center = CGPoint(x: 185, y: 1000)
        }
        if grid.gameActive == false {
            resetGame(with: grid)
        }
    }
    
    func resetGame(with grid:Grid){
        self.grid.reset()
        player = 1
        noticePlayer(playerX, initialPos: Xpos)
        for i in 0...cell.count-1{
            for sub in cell[i].subviews {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                                sub.alpha = 0.0},completion:{ (finished: Bool) in sub.removeFromSuperview()})
            }
        }
    }
    
    func drawLine(_ pattern:[Int]) {
        self.shapeLayer?.removeFromSuperlayer()

        let path = UIBezierPath()
        for win in grid.winner {
            if pattern.sorted() == win || Set(win).isSubset(of:pattern) {
                path.move(to: cell[win[0]].center)
                path.addLine(to: cell[win[2]].center)
                break
            }
        }
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.path = path.cgPath

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            shapeLayer.isHidden = true
        })
        view.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        shapeLayer.add(animation, forKey: "MyAnimation")
        CATransaction.commit()

    }

}

