//
//  VCReceitaNova.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/17/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit



class VCReceitaNova: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var receitaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, (receitaView.frame.size.height - scrollView.frame.size.height), 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
