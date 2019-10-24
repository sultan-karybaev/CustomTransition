//
//  TransitionCoordinator.swift
//  CustomTransitionDemo
//
//  Created by Artur Rymarz on 01.08.2018.
//  Copyright © 2018 OpenSource. All rights reserved.
//

import UIKit

import UIKit

extension UINavigationController {
    // 1
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"

    // 2
    var transitionCoordinatorHelper: TransitionCoordinator? {
        return objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionCoordinator
    }

    func addCustomTransitioning() {
        // 3
        var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey)

        guard object == nil else {
            return
        }

        object = TransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)

        // 4
        delegate = object as? TransitionCoordinator


        // 5
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        
//        var vw = UIView(frame: CGRect(x: self.navigationBar.frame.width, y: 0, width: 100, height: 44))
//        vw.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//        vw.tag = 100
//        self.navigationBar.addSubview(vw)
    }

    // 6
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper?.interactionController = nil
            return
        }

        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width

        if gestureRecognizer.state == .began {
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            transitionCoordinatorHelper?.interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                transitionCoordinatorHelper?.interactionController?.finish()
            } else {
                transitionCoordinatorHelper?.interactionController?.cancel()
            }
            transitionCoordinatorHelper?.interactionController = nil
        }
    }
}

final class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return TransitionAnimator(presenting: true, nav: navigationController)
        case .pop:
            return TransitionAnimator(presenting: false, nav: navigationController)
        default:
            return nil
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
