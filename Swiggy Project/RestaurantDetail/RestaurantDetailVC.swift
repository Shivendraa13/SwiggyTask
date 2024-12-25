//
//  RestaurantDetailVC.swift
//  Swiggy Project
//
//  Created by Shivendra on 25/12/24.
//

import UIKit

class RestaurantDetailVC: UIViewController {
    
    @IBOutlet weak var dataView: UIView!
    private var dotViews: [UIView] = []
    private let dotSize: CGFloat = 10
    private let dotSpacing: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataView.alpha = 0.0
                setupThreeDotLoader()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.hideLoaderAndShowDataView()
                }
            }
            
            private func setupThreeDotLoader() {
                let loaderContainer = UIView()
                loaderContainer.frame = CGRect(
                    x: (self.view.frame.width - (dotSize * 3 + dotSpacing * 2)) / 2,
                    y: (self.view.frame.height - dotSize) / 2,
                    width: dotSize * 3 + dotSpacing * 2,
                    height: dotSize
                )
                self.view.addSubview(loaderContainer)
                
                // Create three dots
                for i in 0..<3 {
                    let dot = UIView()
                    dot.frame = CGRect(
                        x: CGFloat(i) * (dotSize + dotSpacing),
                        y: 0,
                        width: dotSize,
                        height: dotSize
                    )
                    dot.backgroundColor = .lightGray
                    dot.layer.cornerRadius = dotSize / 2
                    dot.clipsToBounds = true
                    loaderContainer.addSubview(dot)
                    dotViews.append(dot)
                }
                
                // Start animation
                startThreeDotAnimation()
            }
            
            private func startThreeDotAnimation() {
                for (index, dot) in dotViews.enumerated() {
                    UIView.animateKeyframes(withDuration: 1.5, delay: Double(index) * 0.3, options: [.repeat, .autoreverse], animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                            dot.backgroundColor = .blue
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                            dot.backgroundColor = .lightGray
                        }
                    })
                }
            }
            
            private func hideLoaderAndShowDataView() {
                for dot in dotViews {
                    dot.layer.removeAllAnimations()
                    dot.isHidden = true
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.dataView.alpha = 1.0
                })
            }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
