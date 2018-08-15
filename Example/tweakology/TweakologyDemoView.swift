//
//  TweakologyDemoView.swift
//  tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class TweakologyDemoView: UIView {
    weak var delegate:TweakologyDemoViewController?

    var label: UILabel = UILabel()
    var button: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCustomView()
        setConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        self.backgroundColor = UIColor.brown
        
        label.backgroundColor = UIColor.green
        label.tag = 2;
        label.textAlignment = NSTextAlignment.center
        label.text = "test label"
        label.textColor = UIColor.black
        self.addSubview(label)
        
        button.backgroundColor=UIColor.blue
        button.setTitle("button", for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.pressButton(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
    }

    func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    @objc func pressButton(_ sender: UIButton) {
        self.delegate?.pressButton(sender)
    }
}
