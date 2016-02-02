//
//  CharPicker.swift
//  my-little-monster
//
//  Created by Anthony Torrero Collins on 2/1/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation

class CharPicker : UIViewController {

    let monsters : [String] = ["h1/charPick03","e2/charPick02","e1/charPick01"]
    var curSelection : Int = 0
    var MAX_MONSTERS : Int = 0
    
    
    override func viewDidLoad() {
        MAX_MONSTERS =  (monsters.count) - 1
        curSelection = 0
        switchMonsterImage(curSelection)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? ViewController {
            destinationViewController.chosenMonsterIndex = btnMonsters.tag
        }
    }
    
    @IBOutlet weak var btnMonsters: UIButton!
    
    @IBAction func bntPrev_Press(sender: UIButton) {
        curSelection--
        switchMonsterImage(curSelection)
        
        return
    }
    
    @IBAction func btnNext_Press(sender: UIButton) {
        curSelection++
        switchMonsterImage(curSelection)
        
        return
    }
    
    @IBAction func btnMonsters_Press(sender: UIButton) {
        return
        
    }
    
    func switchMonsterImage(monImageIndex: Int) {
        
        if(curSelection > MAX_MONSTERS) {
            curSelection = 0
        } else if (curSelection < 0) {
            curSelection = MAX_MONSTERS
        }
        
        if let someMon = UIImage(named: monsters[curSelection]) {
            btnMonsters.setImage(someMon, forState: .Normal)
            btnMonsters.tag = curSelection
        }
        
        return
    }
    
}