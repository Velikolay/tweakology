//
//  TweakologyDemoViewController.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 03/25/2018.
//  Copyright (c) 2018 Nikolay Ivanov. All rights reserved.
//

import UIKit
import tweakology

class TweakologyDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let tweaksView = TweakologyDemoView(frame: CGRect(x: 0, y: 30, width: screenSize.width, height: screenSize.height/2))
        self.view.addSubview(tweaksView)

        if #available(iOS 10.0, *) {
            var viewIndex = self.inspectLayout()
            print(viewIndex)
            let engine = TweakologyLayoutEngine()
            engine.tweak(viewIndex: &viewIndex, changeSeq: changeSeq)
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
