//
//  EntryKitAttributed.swift
//  Choose Figure
//
//  Created by 许浩渊 on 2022/6/21.
//  Copyright © 2022 ivansosnovik. All rights reserved.
//

import Foundation
import SwiftEntryKit

extension EKAttributes {

    static func gameCenterToast(duration: TimeInterval) -> EKAttributes {
        var toast = EKAttributes.float
        toast.statusBar = .light
        toast.position = .center
        toast.displayDuration = .infinity
        toast.screenBackground = .color(color: EKColor( UIColor.black.withAlphaComponent(0.3)))
        toast.precedence = .enqueue(priority: .normal)
        toast.positionConstraints.size = .init(width: .intrinsic, height: .intrinsic)
        toast.screenInteraction = .absorbTouches
        toast.entryInteraction = .absorbTouches
        toast.entranceAnimation = .init(translate: nil, scale: .init(from: 0.6, to: 1, duration: 0.25), fade: .init(from: 0, to: 1, duration: 0.25))
        toast.exitAnimation = .init(translate: nil, scale: .init(from: 1, to: 0.6, duration: 0.25), fade: .init(from: 1, to: 0, duration: 0.25))
        return toast
    }
}
