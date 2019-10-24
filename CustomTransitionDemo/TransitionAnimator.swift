//
//  TransitionAnimator.swift
//  CustomTransitionDemo
//
//  Created by Artur Rymarz on 01.08.2018.
//  Copyright © 2018 OpenSource. All rights reserved.
//

import UIKit

final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // 1
    let presenting: Bool
    let nav: UINavigationController
    var fr: UIView?

    // 2
    init(presenting: Bool, nav: UINavigationController) {
        self.presenting = presenting
        self.nav = nav
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // 3
        return TimeInterval(UINavigationControllerHideShowBarDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 4
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        self.fr = fromView
        // 5
        let duration = transitionDuration(using: transitionContext)

        // 6
        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        
//        let a = nav.navigationBar.subviews.filter { (view) -> Bool in
//            return view.tag == 100
//        }
//        let rect = a[0]
//        print("nav.navigationBar.subviews \(a)")
        // 7
        let toViewFrame = toView.frame
        toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)

        if !presenting {
            fromView.addObserver(self, forKeyPath: "alpha", options: .old, context: nil)
        }
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        //displayLink.
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                toView.alpha = 1
                fromView.alpha = 0
//                if self.presenting {
//                    fromView.alpha = 0
//                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) {
                fromView.alpha = 1
                //                if self.presenting {
                //                    fromView.alpha = 0
                //                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                //rect.frame.origin.x = self.presenting ? 0 : self.nav.navigationBar.frame.width
                toView.frame = toViewFrame
                fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
//                if !self.presenting {
//                    fromView.alpha = 0
//                }
            }

        }

        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: animations,
                                completion: { finished in
                                    // 8
                                    container.addSubview(toView)
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                                    
                                    displayLink.isPaused = true
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "alpha" {
            print("TransitionAnimator observeValue")
        }
    }
    
    @objc func animationDidUpdate(displayLink: CADisplayLink) {
        print("TransitionAnimator animationDidUpdate \(self.fr?.layer.presentation()?.opacity)")
    }
    
}
