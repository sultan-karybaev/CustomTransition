//
//  ViewController.swift
//  CustomTransitionDemo
//
//  Created by Artur Rymarz on 01.08.2018.
//  Copyright © 2018 OpenSource. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.addCustomTransitioning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SecondVC else { return }
        vc.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func asd(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondVC else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        //self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
}

