//
//  ViewController.swift
//  Swiggy Project
//
//  Created by Shivendra on 25/12/24.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var locatiomIMG: UIImageView!
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stickyHeader: UIView!
    @IBOutlet weak var stickyHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePgControl: UIPageControl!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    
    private var refreshControl: UIRefreshControl!
    private var imageArray = ["image1", "image2", "image1", "image2"]
    private var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        imagePgControl.currentPage = 1
        imagePgControl.numberOfPages = imageArray.count
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        restaurantCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restaurantCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            restaurantCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            restaurantCollectionView.heightAnchor.constraint(equalToConstant: 132)
        ])
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionViewLayout()
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.refreshControl.endRefreshing()
            self.restaurantCollectionView.reloadData()
            self.imageCollectionView.reloadData()
        }
    }
    
    func setupCollectionViewLayout() {
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            let screenWidth = view.bounds.width
            let padding: CGFloat = 8
            layout.itemSize = CGSize(width: screenWidth - (2 * padding), height: 160)
            layout.minimumLineSpacing = 0
        }
        if let layout = restaurantCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            let padding: CGFloat = 0
            layout.itemSize = CGSize(width: 200 - (2 * padding), height: 132)
            layout.minimumLineSpacing = 16
        }
    }
    
    func setUi() {
        scrollView.delegate = self
        
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        let cellNib = UINib(nibName: "ImageCell", bundle: nil)
        imageCollectionView.register(cellNib, forCellWithReuseIdentifier: "ImageCell")
        let cellNib1 = UINib(nibName: "RestaurantCell", bundle: nil)
        restaurantCollectionView.register(cellNib1, forCellWithReuseIdentifier: "RestaurantCell")
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return imageArray.count
        } else if collectionView == restaurantCollectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.imageView.image = UIImage(named: imageArray[indexPath.item])
            return cell
        } else if collectionView == restaurantCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == restaurantCollectionView {
            let restaurantDetailVC = RestaurantDetailVC(nibName: "RestaurantDetailVC", bundle: nil)
            restaurantDetailVC.modalPresentationStyle = .custom
            restaurantDetailVC.transitioningDelegate = self
            self.present(restaurantDetailVC, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        imagePgControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset > lastContentOffset && currentOffset > 0 {
            let offsetY = scrollView.contentOffset.y
            if offsetY >= 184 {
            }
            if offsetY >= 180 {
                stickyHeader.backgroundColor = UIColor(hex: "E67F4F")
                locatiomIMG.tintColor = UIColor(hex: "FFFFFF")
                locLabel.textColor = UIColor(hex: "FFFFFF")
                officeBtn.setTitleColor(UIColor(hex: "000000"), for: .normal)
                stickyHeader.isHidden = true
            } else {
            }
        } else if currentOffset < lastContentOffset {
            let offsetY = scrollView.contentOffset.y
            if offsetY >= 100 {
                stickyHeader.backgroundColor = UIColor.clear
                locatiomIMG.tintColor = UIColor(hex: "FFFFFF")
                locLabel.textColor = UIColor(hex: "FFFFFF")
                officeBtn.setTitleColor(UIColor(hex: "000000"), for: .normal)
                stickyHeader.isHidden = false
            }
            if offsetY <= 180 {
            } else {
                stickyHeader.backgroundColor = UIColor(hex: "FFFFFF")
                locatiomIMG.tintColor = UIColor(hex: "E67F4F")
                locLabel.textColor = UIColor(hex: "000000")
                officeBtn.setTitleColor(UIColor(hex: "000000"), for: .normal)
                stickyHeader.isHidden = false
            }
        }
        lastContentOffset = currentOffset
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentedController = FreeformPresentationController(presentedViewController: presented, presenting: presenting)
        presentedController.touchPoint = restaurantCollectionView.center
        return presentedController
    }
}

