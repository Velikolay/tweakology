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

    var label = UILabel()
    var button = UIButton()
    var imageView = UIImageView(image: #imageLiteral(resourceName: "TestImages"))

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
        
        button.backgroundColor = UIColor.blue
        button.setTitle("button", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(self.pressButton(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(button)
        
//        imageView.image?.src = "TestImages"
        self.addSubview(imageView)
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

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    @objc func pressButton(_ sender: UIButton) {
        self.delegate?.pressButton(sender)
    }
}
