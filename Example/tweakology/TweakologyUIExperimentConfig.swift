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
            "id": "3",
            "parentId": "0",
            "index": 2,
            "type": "UILabel",
            "props" : [
                "text": "TWEAKED",
                "textColor": "black",
                "textAlignment": "center",
                "backgroundColor": "red"
            ],
            "constraints": [
                "topAnchor": "$0 + 20",
                "leadingAnchor": "$0 + 20",
                "trailingAnchor": "$0 - 20",
                "heightAnchor": "60"
            ]
        ]
    ],
    [
        "operation": "modify",
        "view": [
            "id": "1",
            "constraints": [
                "topAnchor": "$3.bottomAnchor + 20"
            ]
        ]
    ],
    [
        "operation": "modify",
        "view": [
            "id": "0",
            "frame": [
                "height": "$0 - 20"
            ]
        ]
    ],
    [
        "operation": "modify",
        "view": [
            "id": "2",
            "props": [
                "clipsToBounds": true,
                "title": "tweaked button",
                "titleColor": "red",
            ],
            "layer": [
                "borderColor": "black",
                "borderWidth": 4.0,
                "cornerRadius": 16
            ]
        ]
    ],
]
