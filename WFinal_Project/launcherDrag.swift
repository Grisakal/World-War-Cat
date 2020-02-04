//
//  launcherDrag.swift
//  WFinal_Project
//
//  Created by fg19aai on 07/11/2019.
//  Copyright © 2019 fg19aai. All rights reserved.
//

import UIKit

class launcherDrag: UIImageView {

    var startLocation: CGPoint?

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
            self.transform = CGAffineTransform(rotationAngle: 90)
            
            /*let currentLocation = touches.first?.location(in: self)
            startLocation!.x = self.center.x
            startLocation!.y = self.center.y
            
            let dx = currentLocation!.x - startLocation!.x
            let dy = currentLocation!.y - startLocation!.y
            let newCenter = CGPoint(x: self.center.x + dx, y:self.center.y + dy)
            
            let xDiff = startLocation!.x - currentLocation!.x
            let yDiff = startLocation!.y - currentLocation!.y
            
            if (atan(xDiff/yDiff)>0){
                self.transform = CGAffineTransform(rotationAngle: min(atan(xDiff/yDiff),.pi))
                //print(min(atan(xDiff/yDiff),.pi))
            }else{
                self.transform = CGAffineTransform(rotationAngle: max(atan(xDiff/yDiff),(-.pi)))
                //print(max(atan(xDiff/yDiff),(-.pi)))
            }
            print(currentLocation)*/
            
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            let projectile = UIImageView(image: nil)
            projectile.image = UIImage(named: "Missile.png")
            projectile.frame = CGRect(x:200, y:100, width: 60, height: 45)
            
            self.center = CGPoint(x:UIScreen.main.bounds.width/4 - self.bounds.midX, y:UIScreen.main.bounds.height/2)
        }

    }
