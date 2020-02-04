//
//  MenuController.swift
//  WFinal_Project
//
//  Created by fg19aai on 09/11/2019.
//  Copyright © 2019 fg19aai. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    @IBOutlet weak var text: UIImageView!
    @IBAction func toGameButton(_ sender: Any) {
        performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        let image = UIImage(named: "menuBackground.jpg")
        var background : UIImageView!
        background = UIImageView(frame: view.bounds)
        background.contentMode =  UIView.ContentMode.scaleAspectFill
        background.clipsToBounds = true
        background.image = image
        background.center = view.center
        text.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        view.addSubview(background)
        self.view.sendSubviewToBack(background)

    }
    override var shouldAutorotate: Bool {
        return true
    }
}
