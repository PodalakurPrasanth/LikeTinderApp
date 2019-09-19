//
//  HomeViewController.swift
//  DigiaptiOSTest
//
//  Created by Shivaji on 19/04/19.
//  Copyright © 2019 Shivaji. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    var fetchImagesArray = [ImagesList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if Constants.isAllreadySaved {
        }else{
            for imgVal in 1...5 {
                if let img = UIImage(named: "IMG_\(imgVal)") {//IMG_1
                    
                    if let data:Data = img.pngData() {
                        self.saveImagesData(showData: data)
                        
                    }
                }
            }
            Constants.isAllreadySaved = true
        }
        
        self.fetchImagesData()
       
        
    }
    

    func saveImagesData(showData:Data){
        let imageData:ImagesList  = NSEntityDescription.insertNewObject(forEntityName: "ImagesList", into: DataBaseController.persistentContainer.viewContext) as! ImagesList
        imageData.image = showData as NSData
        DataBaseController.saveContext()
       
    }
    func fetchImagesData(){
        
        let FeatchRequiest:NSFetchRequest<ImagesList> = ImagesList.fetchRequest()
        print(FeatchRequiest)
        do{
            let images = try DataBaseController.persistentContainer.viewContext.fetch(FeatchRequiest)
            self.fetchImagesArray = images
            self.mainCollectionView.delegate = self
            self.mainCollectionView.dataSource = self
            self.mainCollectionView.reloadData()
        }catch{
            print(" error\(error.localizedDescription)")
        }
        
    }
    

}
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.mainCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: "HomeCVC")
        let slideImageCell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
        let eachIMG = self.fetchImagesArray[indexPath.item]
        slideImageCell.slideImageView.image = UIImage(data: (eachIMG.image! as Data ) )
        
        if indexPath.item ==  5{
            
        }
        
        return slideImageCell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width)
        {
                print(" bottom is working")
            mainCollectionView.scrollToItem(at: IndexPath(item: 0 , section: 0), at: .centeredHorizontally, animated: true)
            self.mainCollectionView.layoutSubviews()

        }
        
    }
    
   
    
   /* func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let screenRect:CGRect = self.mainCollectionView.frame//UIScreen.main.bounds
        
        let pageWidth:Float = Float(screenRect.size.width) - 10 + 10;
        
        let currentOffSet:Float = Float(scrollView.contentOffset.x)
        // print(currentOffSet)
        let targetOffSet:Float = Float(targetContentOffset.pointee.x)
        //  print(targetOffSet)
        var newTargetOffset:Float = 0
        
        if(targetOffSet > currentOffSet){
            newTargetOffset = ceilf(currentOffSet / pageWidth) * pageWidth
        }else{
            newTargetOffset = floorf(currentOffSet / pageWidth) * pageWidth
        }
        
        if(newTargetOffset < 0){
            newTargetOffset = 0;
        }else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        targetContentOffset.pointee.x = CGFloat(currentOffSet)
        if CGFloat(currentOffSet) < scrollView.contentOffset.x  {
            print(true)
        }
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
        
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let screenRect:CGRect = self.mainCollectionView.frame//UIScreen.main.bounds
        
        return CGSize(width:Int(Float(screenRect.size.width) - 10), height: Int(screenRect.size.height))
    }
    
}



