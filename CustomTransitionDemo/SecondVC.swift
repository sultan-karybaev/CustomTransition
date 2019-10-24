//
//  SecondVC.swift
//  CustomTransitionDemo
//
//  Created by Sultan Karybaev on 2/19/19.
//  Copyright © 2019 OpenSource. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        var v = UIView(frame: CGRect(x: 300, y: 0, width: 100, height: 44))
        v.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        //navigationController?.navigationBar.addSubview(v)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func asd(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
