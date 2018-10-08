//
//  TweakologyUIExperimentConfig.swift
//  tweakology_Example
//
//  Created by Nikolay Ivanov on 3/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

let changeSeq: [[String: Any]] = [
    [
        "operation": "insert",
        "view" : [
            "id": "ZDZiNTY5ZW",
            "superview": "MGQ3MDAyZD",
            "index": 3,
            "type": "UILabel",
            "properties" : [
                "text": "TWEAKED",
                "textColor": "black",
                "textAlignment": 1,
                "backgroundColor": "red"
            ],
            "constraints": [
                "topAnchor": "$(superview) + 20",
                "leadingAnchor": "$(superview) + 20",
                "trailingAnchor": "$(superview) - 20",
                "heightAnchor": "60"
            ]
        ]
    ],
//    [
//        "operation": "modify",
//        "view": [
//            "id": "MGQ3MDAyZD",
//            "constraints": [
//                [
//                    "first": [
//                        "item": "N2MyOTZhNT",
//                        "attribute": "top"
//                    ],
//                    "second": [
//                        "item": "ZDZiNTY5ZW",
//                        "attribute": "bottom"
//                    ],
//                    "relation": "=",
//                    "constant": 20,
//                    "isActive": true,
//                    "priority": 1000,
//                    "added": true,
//                    "idx": 2
//                ]
////                "topAnchor": "$(ZDZiNTY5ZW).bottomAnchor + 20"
//            ]
//        ]
//    ],
    [
        "operation": "modify",
        "view": [
            "id": "MGQ3MDAyZD",
            "frame": [
                "height": "$(self) - 20"
            ]
        ]
    ],
    [
        "operation": "modify",
        "view": [
            "id": "MjdhMzRjYj",
            "properties": [
                "clipsToBounds": true,
                "title": [
                    "text": "tweaked button",
                    "textColor": "red"
                ]
            ],
            "layer": [
                "borderColor": "#b3ff26",
                "borderWidth": 4.0,
                "cornerRadius": 16
            ]
        ]
    ],
]
