//
//  OnBoardViewController.swift
//  Solid-ICT Project1
//
//  Created by Buğra Tunçer on 8.08.2019.
//  Copyright © 2019 Buğra Tunçer. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var onboardArray = [OnboardingModel]()
    override func viewDidLoad() {
        configureCollectionView()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        pageControl.numberOfPages = onboardArray.count
        super.viewDidLoad()
        
    }
    
    private func configureCollectionView() {
        
        myCollectionView.decelerationRate = .fast
        myCollectionView.isPagingEnabled = true
        myCollectionView.showsHorizontalScrollIndicator = false
        onboardArray = getInfos()
        myCollectionView.register(UINib(nibName: "OnBoardCell", bundle: nil), forCellWithReuseIdentifier: "onboardcell")
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardArray.count
    }
    func getInfos() -> [OnboardingModel]
    {
        let array1=OnboardingModel(onboardingDescription: "Welcome to Solid-ICT Chat App", onboardingImage: UIImage(named: "background1")!,onboardingLastCell: false)
        let array2=OnboardingModel(onboardingDescription: "You can message to your friend !", onboardingImage: UIImage(named: "background1")!,onboardingLastCell: true)

        onboardArray.append(array1)
        onboardArray.append(array2)
        return onboardArray
    }
    @IBAction func exitButton(_ sender: Any) {
        
        let myViewController = LoginController(nibName: "LoginController", bundle: nil)
        present(myViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardcell", for: indexPath) as! OnBoardCell
        cell.imageView.image = onboardArray[indexPath.row].onboardingImage
        cell.descpritionLabel.text = onboardArray[indexPath.row].onboardingDescription
        cell.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        if !onboardArray[indexPath.row].onboardingLastCell {
            cell.startButton.isHidden = true
        } else {
            cell.startButton.isHidden = false
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let indexPath = myCollectionView.indexPathForItem(at: center) {
            self.pageControl.currentPage = indexPath.row
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.myCollectionView.contentOffset, size: self.myCollectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        if let visibleIndexPath = self.myCollectionView.indexPathForItem(at: visiblePoint) {
//            self.pageControl.currentPage = visibleIndexPath.row
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: self.myCollectionView.frame.height)
    }
    @objc func startButtonTapped() {
        let myViewController = LoginController(nibName: "LoginController", bundle: nil)
        present(myViewController, animated: true, completion: nil)
    }
    
}
