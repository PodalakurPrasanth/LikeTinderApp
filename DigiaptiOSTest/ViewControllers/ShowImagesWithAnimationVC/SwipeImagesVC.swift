//
//  SwipeImagesVC.swift
//  DigiaptiOSTest
//
//  Created by Shivaji on 22/04/19.
//  Copyright © 2019 Shivaji. All rights reserved.
//

import UIKit
import CoreData

let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;


class SwipeImagesVC: UIViewController {
    
    @IBOutlet weak var viewTinderBackGround: UIView!
    var currentIndex = 0
    var currentLoadedCardsArray = [SwipeImageCard]()
    var allCardsArray = [SwipeImageCard]()
    var valueArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        let FeatchRequiest:NSFetchRequest<ImagesList> = ImagesList.fetchRequest()
        print(FeatchRequiest)
        do{
            let images = try DataBaseController.persistentContainer.viewContext.fetch(FeatchRequiest)
            for imageDATA in images as [ImagesList] {
                let getImage = UIImage(data: imageDATA.image! as Data)
                valueArray.append(getImage!)
            }
            
            
        }catch{
            print(" error\(error.localizedDescription)")
        }
        loadCardValues()
    }
    func loadCardValues() {
        
        if valueArray.count > 0 {
            
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            
            for (i,value) in valueArray.enumerated() {
                let newCard = createTinderCard(at: i,value: value)
                allCardsArray.append(newCard)
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
            }
            
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                }else {
                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping(index: 0)
        }
    }
    
    
    
    func createTinderCard(at index: Int , value :UIImage) -> SwipeImageCard {
        
        let card = SwipeImageCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,value : value)
        card.delegate = self
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }
        print(currentIndex)
        animateCardAfterSwiping(index: currentIndex)
    }
    
    func animateCardAfterSwiping(index:Int) {
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
        
        if currentIndex == self.valueArray.count {
            resetAllCards()
        }
        
    }
    func resetAllCards(){
        for _ in 0...allCardsArray.count-1{
            currentIndex =  currentIndex - 1
            if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
                
                let lastCard = currentLoadedCardsArray.last
                lastCard?.rollBackCard()
                currentLoadedCardsArray.removeLast()
            }
            let undoCard = allCardsArray[currentIndex]
            undoCard.layer.removeAllAnimations()
            viewTinderBackGround.addSubview(undoCard)
            undoCard.makeUndoAction()
            currentLoadedCardsArray.insert(undoCard, at: 0)
            animateCardAfterSwiping(index: 0)
        }
       

    }

}
extension SwipeImagesVC : SwipeImageCardDelegate{
    
    // action called when the card goes to the left.
    func cardGoesUp(card: SwipeImageCard) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesDown(card: SwipeImageCard) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: SwipeImageCard, distance: CGFloat) {
       
        
    }
}
