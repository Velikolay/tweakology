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
            "parentId": "MGQ3MDAyZD",
            "index": 2,
            "type": "UILabel",
            "props" : [
                "text": "TWEAKED",
                "textColor": "black",
                "textAlignment": "center",
                "backgroundColor": "red"
            ],
            "constraints": [
                "topAnchor": "$(MGQ3MDAyZD) + 20",
                "leadingAnchor": "$(MGQ3MDAyZD) + 20",
                "trailingAnchor": "$(MGQ3MDAyZD) - 20",
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
                "height": "$(MGQ3MDAyZD) - 20"
            ]
        ]
    ],
    [
        "operation": "modify",
        "view": [
            "id": "MjdhMzRjYj",
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
