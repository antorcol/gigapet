//
//  ViewController.swift
//  my-little-monster
//
//  Created by Anthony Torrero Collins on 1/28/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var giveSomeLuv: DragImage!
    @IBOutlet weak var giveSomeGrub: DragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var btnRip: UIButton!
    
    let DIM_ALPHA:CGFloat = 0.2
    let OPAQUE:CGFloat = 1.0
    let MAX_PENALTY:Int = 3
    let IS_LUV: UInt32 = 0
    let IS_GRUB: UInt32 = 1
    var penalties = 0
    
    var timer : NSTimer!
    var monsterHappy: Bool = false
    var currItem: UInt32 = 0
    
    var gameBgSound: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxPurr: AVAudioPlayer!
    var sfxWarn: AVAudioPlayer!
    var sfxDie: AVAudioPlayer!
    
    var chosenMonsterIndex : Int = -1
    
    //MARK: Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterImg.setCharacter(chosenMonsterIndex)
        monsterImg.playIdleAnimation()
        
        giveSomeGrub.dropTarget = monsterImg
        giveSomeLuv.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)

        let gameBgSoundPath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")
        let gameBgSoundPathURL = NSURL(fileURLWithPath: gameBgSoundPath!)
        let sfxBitePath = NSBundle.mainBundle().pathForResource("bite", ofType: "wav")
        let sfxBitePathURL = NSURL(fileURLWithPath: sfxBitePath!)
        let sfxPurrPath = NSBundle.mainBundle().pathForResource("heart", ofType: "wav")
        let sfxPurrPathURL = NSURL(fileURLWithPath: sfxPurrPath!)
        let sfxWarnPath = NSBundle.mainBundle().pathForResource("skull", ofType: "wav")
        let sfxWarnPathURL = NSURL(fileURLWithPath: sfxWarnPath!)
        let sfxDiePath = NSBundle.mainBundle().pathForResource("death", ofType: "wav")
        let sfxDiePathURL = NSURL(fileURLWithPath: sfxDiePath!)
        
        
        do {
            try gameBgSound = AVAudioPlayer(contentsOfURL: gameBgSoundPathURL)
            try sfxBite = AVAudioPlayer(contentsOfURL: sfxBitePathURL)
            try sfxPurr = AVAudioPlayer(contentsOfURL: sfxPurrPathURL)
            try sfxWarn = AVAudioPlayer(contentsOfURL: sfxWarnPathURL)
            try sfxDie = AVAudioPlayer(contentsOfURL: sfxDiePathURL)
        } catch let err as NSError {
            print(err.debugDescription)
        }


        gameBgSound.prepareToPlay()
        gameBgSound.numberOfLoops = -1
        gameBgSound.play()
        
        sfxBite.prepareToPlay()
        sfxPurr.prepareToPlay()
        sfxWarn.prepareToPlay()
        sfxDie.prepareToPlay()
        
        setWhichNeed()
        startTimer()
    }
    
    //MARK: Game Actions
    func itemDroppedOnCharacter(notif: AnyObject) {
        
        monsterHappy = true
        giveSomeGrub.alpha = DIM_ALPHA
        giveSomeGrub.userInteractionEnabled = false
        giveSomeLuv.alpha = DIM_ALPHA
        giveSomeLuv.userInteractionEnabled = false
        startTimer()

        if(currItem == IS_LUV) {
            sfxBite.play()
        } else {
            sfxPurr.play()
        }
        
        return
    }
    
    @IBAction func btnRip_Pressed(sender: AnyObject) {
        btnRip.hidden = true
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        gameBgSound.stop()
        
        penalties=0
        
        monsterImg.playRestoreAnimation()
        monsterImg.playIdleAnimation()
        gameBgSound.play()
        startTimer()
    }
    
    
    func startTimer() {
        
        if(timer != nil) {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            sfxWarn.play()
            
            switch penalties {
            case 1:
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            case 2:
                penalty2Img.alpha = OPAQUE
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
                break
            case 3:
                penalty3Img.alpha = OPAQUE
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = OPAQUE
                break
            default:
                penalty3Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
                break
            }
            
        
        }

        if(penalties >= MAX_PENALTY) {
            giveSomeGrub.alpha = DIM_ALPHA
            giveSomeGrub.userInteractionEnabled = false
            giveSomeLuv.alpha = DIM_ALPHA
            giveSomeLuv.userInteractionEnabled = false
            gameOver()
        } else {
            
            currItem = setWhichNeed()
            monsterHappy = false
        }
    }
    
    func setWhichNeed() -> UInt32 {
        let rand = arc4random_uniform(2)
        if rand == IS_GRUB {
            giveSomeGrub.alpha = DIM_ALPHA
            giveSomeGrub.userInteractionEnabled = false
            giveSomeLuv.alpha = OPAQUE
            giveSomeLuv.userInteractionEnabled = true
        } else {
            giveSomeGrub.alpha = OPAQUE
            giveSomeGrub.userInteractionEnabled = true
            giveSomeLuv.alpha = DIM_ALPHA
            giveSomeLuv.userInteractionEnabled = false
        }
        
        return rand
        
    }
    
    func gameOver() {
        sfxDie.play()
        monsterImg.playDeathAnimation()
        gameBgSound.stop()
        timer.invalidate()
        btnRip.hidden = false
    }
}

