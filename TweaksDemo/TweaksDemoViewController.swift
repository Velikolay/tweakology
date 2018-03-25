//
//  ViewController.swift
//  TweaksDemo
//
//  Created by Nikolay Ivanov on 3/11/18.
//  Copyright © 2018 Nikolay Ivanov. All rights reserved.
//

import UIKit

class TweaksDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let tweaksView = TweaksDemoView(frame: CGRect(x: 0, y: 30, width: screenSize.width, height: screenSize.height/2))
        self.view.addSubview(tweaksView)
        var viewIndex = self.inspectLayout()
        let engine = TweaksUIConfigEngine()
        engine.tweak(viewIndex: &viewIndex, changeSeq: changeSeq)
        print(viewIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
