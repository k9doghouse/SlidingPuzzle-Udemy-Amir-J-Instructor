//
//  ViewController.swift
//  Sliding Game
//
//  Created by murph on 8/13/18.
//  Copyright © 2018 k9doghouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var gameView   : UIView!
    @IBOutlet weak var timerLabel : UILabel!
    
    var gameViewWidth  : CGFloat!
    var gameBlockWidth : CGFloat!
    
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    
    var blocksArray  : NSMutableArray = []
    var centersArray : NSMutableArray = []
    
    var timeCount : Int = 0
    var gameTimer : Timer = Timer()
    
    var empty: CGPoint!
    var howManyTiles = 4.0
    var spacer: CGFloat = 4.0
    
    func checkForWin()
    {
        var correctTiles: Int = 0
        
        for anyLabel in blocksArray as! [MyLabel]
        {
            if anyLabel.originalCenter == anyLabel.center
            { correctTiles += 1 }
        }
        
        if (correctTiles == blocksArray.count)
        {
            for this in blocksArray as! [MyLabel]
            {
                this.backgroundColor = UIColor.darkGray
                this.textColor = UIColor.orange
            }
            
            timeCount = 0
            gameTimer.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(timerAction),
                                             userInfo: nil,
                                             repeats: true)
            
            Alert.showCompletedAlert(on: self)
        } // end if correctTiles...
        else { /* nothing */ }
    } // end func checkForWin()

    
    @IBAction func resetAction(_ sender: UIButton)
    {
        timeCount = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        
        for this in blocksArray as! [MyLabel]
        {
            this.backgroundColor = UIColor.darkGray
            this.textColor = UIColor.orange
        }
        randomizeAction()
        timeCount = 0
    } // end @IBAction func resetAction()...
    
   
    @objc func timerAction()
    {
        timeCount += 1
        timerLabel.text =  secondsToMinutesSeconds(seconds: timeCount)
    } // end func timerAction()...
    
    
    func secondsToMinutesSeconds(seconds : Int) -> (String)
    {
        var daString: String
        
        let minutes = (seconds%3600)/60
        let seconds1 = (seconds%3600)%60
        daString = "min: \(minutes)  sec: \(seconds1)"
        
        return  daString
    } // end func secondsToMinutesSeconds()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        makeBlocks()
        self.resetAction(UIButton())
    } // end override func vDL()
    
    
    func makeBlocks()
    {
        blocksArray  = []
        centersArray = []
        
        gameViewWidth = gameView.frame.size.width
        gameBlockWidth = gameViewWidth / CGFloat(howManyTiles)
        
        xCenter = gameBlockWidth / 2
        yCenter = gameBlockWidth / 2
        
        var labelNumber : Int = 1
        
        for _ in Int(0)..<Int(howManyTiles)
        {
            for _ in Int(0)..<Int(howManyTiles)
            {
                let blockFrame : CGRect = CGRect(x : 0,
                                                 y : 0,
                                                 width : gameBlockWidth - spacer,
                                                 height : gameBlockWidth - spacer)
                
                let block : MyLabel = MyLabel(frame : blockFrame)
                block.isUserInteractionEnabled = true
                let thisCenter : CGPoint = CGPoint(x: xCenter,
                                                   y : yCenter)
                block.center = thisCenter
                block.originalCenter = thisCenter
                
                centersArray.add(thisCenter)
                block.textColor = UIColor.orange
                block.text = String(labelNumber)
                
                labelNumber += 1
                
                block.textAlignment = NSTextAlignment.center
                block.font = UIFont.systemFont(ofSize : 24)
                
                block.backgroundColor = UIColor.darkGray
                gameView.addSubview(block)
               
                blocksArray.add(block)
                
                xCenter = xCenter + gameBlockWidth
                
            } // end for horizontal
            
            xCenter = gameBlockWidth / 2
            yCenter = yCenter + gameBlockWidth
            
        } // end for vertical...
        
        let lastBlock : MyLabel = blocksArray[blocksArray.count - 1] as! MyLabel

        lastBlock.removeFromSuperview()
        blocksArray.removeObject(at: blocksArray.count - 1)
    
    } // end func makeBlocks()...
    
    
    func randomizeAction()
    {
        let tempCentersArray : NSMutableArray = centersArray.mutableCopy() as! NSMutableArray
        
        for anyBlock in blocksArray
        {
            let randomIndex : Int = Int(arc4random()) % tempCentersArray.count
            let randomCenter : CGPoint = tempCentersArray[randomIndex] as! CGPoint
            
            (anyBlock as! MyLabel).center = randomCenter
            tempCentersArray.removeObject(at: randomIndex)
        } // end for...
        
        empty = (tempCentersArray[0] as! CGPoint)
        
    } // end func randomizeAction()...
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch : UITouch = touches.first!
        
        if (blocksArray.contains(myTouch.view as Any))
        {
            let touchView: MyLabel = (myTouch.view)! as! MyLabel
            
            let xDifference: CGFloat = touchView.center.x - empty.x
            let yDifference: CGFloat = touchView.center.y - empty.y
            
            let distance : CGFloat = sqrt(pow(xDifference, 2) + pow(yDifference, 2))
            
            if (distance == gameBlockWidth)
            {
                let temporaryCenter : CGPoint = touchView.center
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                
                touchView.center = empty
                UIView.commitAnimations()
              
                if touchView.originalCenter == empty
                {
                    touchView.backgroundColor = UIColor.green
                    touchView.textColor = UIColor.darkGray
                }
                else
                {
                    touchView.backgroundColor = UIColor.darkGray
                    touchView.textColor = UIColor.orange
                }
                empty = temporaryCenter
                checkForWin()
            }// end if-distance...
        } // end if-blocksArray...
    } // end func touchesEnded()...
} // end class VC...


class MyLabel : UILabel
{ var originalCenter : CGPoint! } // end class MyLabel...
