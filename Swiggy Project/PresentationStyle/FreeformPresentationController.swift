//
//  FreeformPresentationController.swift
//  Swiggy Project
//
//  Created by Shivendra on 25/12/24.
//

import UIKit

class FreeformPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    public var heightView: CGFloat = 0
    private var initialPresentedFrame: CGRect!
    private var initialButtonFrame: CGRect!

    var touchPoint: CGPoint?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
        setupPanGesture()
        setupTapGesture()
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
    }
    
    private func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: presentedViewController.view)
        let progress = translation.y / presentedViewController.view.bounds.height
        
        switch gestureRecognizer.state {
        case .changed:
            if translation.y > 0 {
                presentedViewController.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
                dimmingView.alpha = max(0, 1.0 - progress)
            }
        case .ended:
            let velocity = gestureRecognizer.velocity(in: presentedViewController.view).y
            let threshold: CGFloat = 200
            if translation.y > threshold || velocity > threshold {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.presentedViewController.view.transform = .identity
                    self.dimmingView.alpha = 1.0
                }
            }
        default:
            break
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        let x: CGFloat = 0
        let y: CGFloat = 0
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        if let touchPoint = self.touchPoint {
            initialButtonFrame = CGRect(x: touchPoint.x, y: touchPoint.y, width: 0, height: 0)
        } else {
            initialButtonFrame = CGRect(x: containerView.bounds.midX, y: containerView.bounds.midY, width: 0, height: 0)
        }

        presentedViewController.view.frame = initialButtonFrame
        presentedViewController.view.layer.cornerRadius = 10
        
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.presentedViewController.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.presentedViewController.view.transform = .identity
            }
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
            self.presentedViewController.view.frame = self.initialButtonFrame
            self.presentedViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Shrink it
        }) { _ in
            self.dimmingView.removeFromSuperview()
        }
    }
}

