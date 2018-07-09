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
            "index": 2,
            "type": "UILabel",
            "properties" : [
                "text": "TWEAKED",
                "textColor": "black",
                "textAlignment": "center",
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
    [
        "operation": "modify",
        "view": [
            "id": "N2MyOTZhNT",
            "constraints": [
                "topAnchor": "$(ZDZiNTY5ZW).bottomAnchor + 20"
            ]
        ]
    ],
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
