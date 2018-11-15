//
//  TweakologyDemoViewController.swift
//  tweakology
//
//  Created by Nikolay Ivanov on 03/25/2018.
//  Copyright (c) 2018 Nikolay Ivanov. All rights reserved.
//

import UIKit

class TweakologyDemoViewController: UIViewController {
    var tweakologyView: TweakologyDemoView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        if self.tweakologyView == nil {
            tweakologyView = TweakologyDemoView(frame: CGRect(x: 0, y: 30, width: screenSize.width, height: screenSize.height/2))
            tweakologyView!.delegate = self
            self.view.addSubview(tweakologyView!)
        }
    }

    func imagesViewWith(frame: CGRect, images: [UIImage?]) -> UIView {
        let stackView = UIStackView()
        let stackContainerView = UIView(frame: frame)
        stackContainerView.backgroundColor = UIColor.cyan
        stackContainerView.addSubview(stackView)

        stackView.alignment = UIStackViewAlignment.center
        stackView.axis = UILayoutConstraintAxis.vertical
        for image in images {
            if let viewImage = image {
                let imageView = UIImageView(image: viewImage)
//                imageView.frame = CGRect(x: 0, y: 0, width: viewImage.size.width, height: viewImage.size.height)
                stackView.addArrangedSubview(imageView)
                imageView.heightAnchor.constraint(equalToConstant: viewImage.size.height).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: viewImage.size.width).isActive = true
            }
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.topAnchor.constraint(equalTo: stackContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: stackContainerView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: stackContainerView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: stackContainerView.trailingAnchor).isActive = true
        return stackContainerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pressButton(_ sender: UIButton) {
        print("Button pressed in delegate!")
        if let topView = self.tweakologyView, let vcView = self.view {
            vcView.recursiveRender()
            let screenSize = UIScreen.main.bounds
            let imagesViewFrame = CGRect(x: 0, y: topView.frame.maxY, width: screenSize.width, height: screenSize.height - 80)
            let imagesView = self.imagesViewWith(frame: imagesViewFrame, images: [vcView.subviews[0].subviews[1].renderedImage])
            self.view.addSubview(imagesView)
            self.view.setNeedsLayout()
        }
    }
}
