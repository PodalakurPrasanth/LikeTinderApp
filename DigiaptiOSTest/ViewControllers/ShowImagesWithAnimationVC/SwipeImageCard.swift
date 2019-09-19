//
//  SwipeImagesVC.swift
//  DigiaptiOSTest
//
//  Created by Shivaji on 22/04/19.
//  Copyright © 2019 Shivaji. All rights reserved.
//

let THERESOLD_MARGIN = (UIScreen.main.bounds.size.height/2) * 0.75
let SCALE_STRENGTH : CGFloat = 4
let SCALE_RANGE : CGFloat = 0.90

import UIKit

protocol SwipeImageCardDelegate: NSObjectProtocol {
    func cardGoesUp(card: SwipeImageCard)
    func cardGoesDown(card: SwipeImageCard)
    func currentCardStatus(card: SwipeImageCard, distance: CGFloat)
}

class SwipeImageCard: UIView {
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero

    var isLiked = false
    
    weak var delegate: SwipeImageCardDelegate?
    
    public init(frame: CGRect, value: UIImage) {
        super.init(frame: frame)
        setupView(at: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(at value:UIImage) {
        print("prasanth \(value)")
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = false
        
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        let backGroundImageView = UIImageView(frame:bounds)
        backGroundImageView.image =  value
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true;
        addSubview(backGroundImageView)
    
        
        
    }
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    func updateOverlay(_ distance: CGFloat) {
        
       
        delegate?.currentCardStatus(card: self, distance: distance)
    }
    
    func afterSwipeAction() {
        
        if yCenter > THERESOLD_MARGIN {
            cardGoesDown()
        }
        else if yCenter < -THERESOLD_MARGIN {
            cardGoesUp()
        }
        else {
            //reseting image
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
               
                self.delegate?.currentCardStatus(card: self, distance:0)
            })
        }
    }
    
    func cardGoesDown() {
        
        let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: frame.size.height*2)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesDown(card: self)
        print("WATCHOUT RIGHT")
    }
    
    func cardGoesUp() {
        
        let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: -frame.size.height*2)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesUp(card: self)
        print("WATCHOUT LEFT")
    }
    
    // right click action
    func rightClickAction() {
        
        
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: 1)
           
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesDown(card: self)
        print("WATCHOUT RIGHT ACTION")
    }
    // left click action
    func leftClickAction() {
        

        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
       
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -1)
           
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesUp(card: self)
        print("WATCHOUT LEFT ACTION")
    }
    
    // undoing  action
    func makeUndoAction() {
        

        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.center = self.originalPoint
            self.transform = CGAffineTransform(rotationAngle: 0)
          
        })
        
        print("WATCHOUT UNDO ACTION")
    }
    
    func rollBackCard(){
        
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()
        }
    }
    
}


