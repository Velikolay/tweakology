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
            "id": "testLabel",
            "superview": "MGQ3MDAyZD",
            "index": 3,
            "type": "UILabel",
            "properties" : [
                "text": "TWEAKED",
                "textColor": "black",
                "textAlignment": 1,
                "backgroundColor": "red"
            ],
//            "constraints": [
//                "topAnchor": "$(superview) + 20",
//                "leadingAnchor": "$(superview) + 20",
//                "trailingAnchor": "$(superview) - 20",
//                "heightAnchor": "60"
//            ],
            "constraints": [
                [
                    "first": [
                        "item": "testLabel",
                        "attribute": "top",
                    ],
                    "second": [
                        "item": "MGQ3MDAyZD",
                        "attribute": "top",
                    ],
                    "constant": 20,
                    "relation": "="
                ],
                [
                    "first": [
                        "item": "testLabel",
                        "attribute": "leading",
                    ],
                    "second": [
                        "item": "MGQ3MDAyZD",
                        "attribute": "leading",
                    ],
                    "constant": 20,
                    "relation": "="
                ],
                [
                    "first": [
                        "item": "testLabel",
                        "attribute": "trailing",
                    ],
                    "second": [
                        "item": "MGQ3MDAyZD",
                        "attribute": "trailing",
                    ],
                    "constant": -20,
                    "relation": "="
                ],
                [
                    "first": [
                        "item": "testLabel",
                        "attribute": "height",
                    ],
                    "constant": 60,
                    "relation": "="
                ]
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
//                        "item": "testLabel",
//                        "attribute": "bottom"
//                    ],
//                    "relation": "=",
//                    "constant": 20,
//                    "isActive": true,
//                    "priority": 1000,
//                    "added": true,
//                    "idx": 2
//                ]
////                "topAnchor": "$(testLabel).bottomAnchor + 20"
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
