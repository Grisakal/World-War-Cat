//
//  ViewController.swift
//  WFinal_Project
//
//  Created by fg19aai on 07/11/2019.
//  Copyright © 2019 fg19aai. All rights reserved.
//

import UIKit

protocol spawnMissile{
    func spawner(x:CGFloat, y:CGFloat, vx:CGFloat, vy:CGFloat)
}

class ViewController: UIViewController, spawnMissile , UICollisionBehaviorDelegate {
    
    var counter = 0
    var timer = Timer()
    var targets: [UIImageView]! = []
    var missiles: [UIImageView]! = []
    var n = 0
    var gameTime = Timer()
    var timeLeft = 30
    var spawnedMissile: UIImageView!
    var stopTimer = 0
    var score = 0
    var level = 1
    var sandbagOne: UIImageView!
    var sandbagTwo: UIImageView!
    var lastMissile = -1
    
    func createObjects(){
        for n in 0...5 {
            let item = UIImageView(frame: CGRect(x:Int(UIScreen.main.bounds.width)-100, y: 10+(n*65), width: (Int(UIScreen.main.bounds.height)-40)/6, height: (Int(UIScreen.main.bounds.height)-40)/6))
            item.image = UIImage(named: "Target.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            item.isHidden = false
            targets.append(item)
            view.addSubview(item)
            print(UIScreen.main.bounds.height)
        }
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBAction func play(_ sender: Any) {
        timeLeft = 30
        launcher.isHidden = false
        stopTimer = 0
        youWin.isHidden = true
        youLose.isHidden = true
        for n in 0...5 {
            targets[n].isHidden = false
        }
        clock.isHidden = false
        playButton.isHidden = true
        if(level == 2){
            colBeh.addItem(sandbagOne)
            sandbagBeh.addItem(sandbagOne)
            sandbagOne.isHidden = false
        }
        else if(level == 3){
            colBeh.addItem(sandbagOne)
            sandbagBeh.addItem(sandbagOne)
            sandbagOne.isHidden = false
            colBeh.addItem(sandbagTwo)
            sandbagBeh.addItem(sandbagTwo)
            sandbagTwo.isHidden = false
        }
    }
    @IBOutlet weak var youWin: UIImageView!
    
    @IBOutlet weak var youLose: UIImageView!
    @IBOutlet weak var scoreboard: UILabel!
    @IBOutlet weak var launcher: launcherAngle!
    var dynAnim: UIDynamicAnimator!
    var dynItemBeh: UIDynamicItemBehavior!
    var gravBeh: UIGravityBehavior!
    var colBeh: UICollisionBehavior!
    var sandbagBeh: UIDynamicItemBehavior!
    
    @IBOutlet weak var clock: UILabel!
    
    func spawner(x:CGFloat, y:CGFloat, vx:CGFloat, vy:CGFloat){
        
        
        let missile = UIImage(named:"Missile.png")
        let missileView = UIImageView(image: missile!)
        missileView.frame = CGRect(x:x,y:y,width:48,height:28)
        
        lastMissile = (lastMissile + 1)
        if(lastMissile >= 3){
            missiles[0].isHidden = true
            gravBeh.removeItem(missiles[0])
            colBeh.removeItem(missiles[0])
            dynItemBeh.removeItem(missiles[0])
            missiles.remove(at: 0)
        }
        missiles.append(missileView)
        if(lastMissile < 3){
            view.addSubview(missiles[lastMissile])
            gravBeh.addItem(missiles[lastMissile])
            colBeh.addItem(missiles[lastMissile])
            dynItemBeh.addItem(missiles[lastMissile])
            spawnedMissile = missiles[lastMissile]
            dynItemBeh.addLinearVelocity(CGPoint(x:vx*5,y:vy*5),for:missiles[lastMissile])
        }
        else{
            view.addSubview(missiles[2])
            gravBeh.addItem(missiles[2])
            colBeh.addItem(missiles[2])
            dynItemBeh.addItem(missiles[2])
            spawnedMissile = missiles[2]
            dynItemBeh.addLinearVelocity(CGPoint(x:vx*5,y:vy*5),for:missiles[2])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        playButton.isHidden = true
        youWin.isHidden = true
        youLose.isHidden = true
        
        launcher.frame = CGRect(x:UIScreen.main.bounds.width/6, y:UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width/6, height: UIScreen.main.bounds.height/3)
        launcher.center = CGPoint(x:UIScreen.main.bounds.width/4 - launcher.bounds.midX, y:UIScreen.main.bounds.height/2)
        
        dynAnim = UIDynamicAnimator(referenceView: self.view)
        dynItemBeh = UIDynamicItemBehavior(items:[])
        gravBeh = UIGravityBehavior(items: [])
        colBeh = UICollisionBehavior(items: [])
        sandbagBeh = UIDynamicItemBehavior(items:[])
        
        gravBeh.gravityDirection = CGVector(dx:0.0,dy:0.8)
        
        createObjects()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        launcher.delegate = self
        
        colBeh.addBoundary(withIdentifier: "leftBound" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height));
        colBeh.addBoundary(withIdentifier: "topBound" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: 0));
        colBeh.addBoundary(withIdentifier: "bottomBound" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height));
        
        dynAnim.addBehavior(dynItemBeh)
        dynAnim.addBehavior(sandbagBeh)
        dynAnim.addBehavior(gravBeh)
        dynAnim.addBehavior(colBeh)
        
        gameTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        colBeh.action = {
            for (item) in self.targets {
                if self.spawnedMissile != nil {
                    if self.spawnedMissile.frame.intersects(item.frame){
                        if(item.isHidden == false){
                            self.score = self.score + 1
                        }
                        item.isHidden = true
                        
                    }
                }
            }
        }
        
        let image = UIImage(named: "menuBackground.jpg")
        var background : UIImageView!
        background = UIImageView(frame: view.bounds)
        background.contentMode =  UIView.ContentMode.scaleAspectFill
        background.clipsToBounds = true
        background.image = image
        background.center = view.center
        view.addSubview(background)
        self.view.sendSubviewToBack(background)
        
        sandbagBeh.density = 999999
        
        let sandbag = UIImage(named:"sandbagFixed.png")
        
        sandbagOne = UIImageView(image: sandbag!)
        sandbagOne.frame = CGRect(x:UIScreen.main.bounds.width/2,y:UIScreen.main.bounds.height/2+48,width:72,height:30)
        view.addSubview(sandbagOne)
        sandbagOne.isHidden = true
        
        sandbagTwo = UIImageView(image: sandbag!)
        sandbagTwo.frame = CGRect(x:UIScreen.main.bounds.width/2,y:UIScreen.main.bounds.height/2-96,width:72,height:30)
        view.addSubview(sandbagTwo)
        sandbagTwo.isHidden = true
        
    }
    
    @objc func timerAction() {
        counter += 1
        var out = 1
        var count = 0
        if(counter%5 == 0 && stopTimer == 0){
            while(out == 1){
                let number = Int.random(in: 0 ..< 6)
                if(targets[number].isHidden == true){
                    targets[number].isHidden = false
                    //colBeh.addItem(targets[number])
                    out = 0
                }
                count += 1
                if(count>5){
                    out = 0
                }
            }
        }
    }
    @objc func countdown() {
        clock.text = "Time Left = " + String(timeLeft) + " Seconds"
        scoreboard.text = "Score = " + String(score)
        timeLeft = timeLeft - 1
        if(timeLeft < 0){
            launcher.isHidden = true
            stopTimer = 1
            for n in 0...5 {
                targets[n].isHidden = true
            }
            clock.isHidden = true
            sandbagOne.isHidden = true
            sandbagTwo.isHidden = true
            for missile in missiles {
                missile.isHidden = true
                gravBeh.removeItem(missile)
                colBeh.removeItem(missile)
                dynItemBeh.removeItem(missile)
                missiles.remove(at: 0)
            }
            lastMissile = -1
            if(score > 20){
                level = level + 1
                youWin.isHidden = false
            }else{
                level = 1
                youLose.isHidden = false
                colBeh.removeItem(sandbagTwo)
                sandbagBeh.removeItem(sandbagTwo)
                colBeh.removeItem(sandbagOne)
                sandbagBeh.removeItem(sandbagOne)
            }
            score = 0
            timeLeft = 999
            playButton.isHidden = false
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }

}
