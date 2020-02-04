//
//  launcherAngle.swift
//  WFinal_Project
//
//  Created by fg19aai on 11/11/2019.
//  Copyright © 2019 fg19aai. All rights reserved.
//

import UIKit

class launcherAngle: UIImageView {

    var startLocation: CGPoint?
    var delegate:spawnMissile?

    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?){
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event:UIEvent?){
        
        let currentLocation = touches.first?.location(in: self)
        
        let h = UIScreen.main.bounds.height
        let w = UIScreen.main.bounds.width
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var newCenter = CGPoint(x: self.center.x + dx, y:self.center.y + dy)
        
        let halfX = self.bounds.midX
        newCenter.x = max(halfX, newCenter.x)
        newCenter.x = min(w/4 - halfX, newCenter.x)
        
        let halfY = self.bounds.midY
        newCenter.y = max(h/2 - h/3 + halfY, newCenter.y)
        newCenter.y = min(h/2 + h/3 - halfY, newCenter.y)
        
        self.center = newCenter
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let xPos = UIScreen.main.bounds.width/4 - self.bounds.midX
        let yPos = UIScreen.main.bounds.height/2
        
        self.delegate?.spawner(x: 200, y: 200, vx:(self.bounds.maxX - self.center.x)*2, vy:(yPos - self.center.y)*2);
        self.center = CGPoint(x:UIScreen.main.bounds.width/4 - self.bounds.midX, y:UIScreen.main.bounds.height/2)
    }
}
