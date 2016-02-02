//
//  MonsterImg.swift
//  my-little-monster
//
//  Created by Anthony Torrero Collins on 1/28/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg : UIImageView {

    var pathPref: String
    var imgIdleName: String
    var imgDeadName: String
    
    override init(frame: CGRect) {
        self.pathPref = "h1"
        self.imgIdleName = "idle"
        self.imgDeadName = "dead"
        super.init(frame: frame)
    }
        
    func setCharacter(monsterIndex: Int) {
        switch monsterIndex {
        case 0:
            self.pathPref = "h1"
            self.imgIdleName = "idle"
            self.imgDeadName = "dead"
            break
        case 1:
            self.pathPref = "e2"
            self.imgIdleName = "idle"
            self.imgDeadName = "dead"
            break
        case 2:
            self.pathPref = "e1"
            self.imgIdleName = "idle"
            self.imgDeadName = "dead"
            break
        default:
            self.pathPref = "e1"
            self.imgIdleName = "idle"
            self.imgDeadName = "dead"
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pathPref = "h1"
        self.imgIdleName = "idle"
        self.imgDeadName = "dead"
        super.init(coder: aDecoder)
        
        playIdleAnimation()
    }

    func playIdleAnimation () {
        
        self.image = UIImage(named: "\(pathPref)/\(imgIdleName)1.png")
        self.animationImages?.removeAll()
        
        var a = [UIImage]()
        for x in 1...4 {
            let b = UIImage(named: "\(pathPref)/\(imgIdleName)\(x).png")!
            a.append(b)
        }
        
        self.animationImages = a
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "\(pathPref)/\(imgDeadName)5.png")
        self.animationImages?.removeAll()
        
        var d = [UIImage]()
        for x in 1...5 {
            let e = UIImage(named: "\(pathPref)/\(imgDeadName)\(x).png")!
            d.append(e)
        }
        
        self.animationImages = d
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
    
    func playRestoreAnimation() {
        
        self.image = UIImage(named: "dead1.png")
        self.animationImages = self.animationImages?.reverse()
        self.animationDuration = 2
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
    
}