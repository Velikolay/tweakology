//
//  UIControlExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UIControlExecutor: UIViewExecutor {
    private let selectorMap = [
        UIControl.Event.touchUpInside.rawValue: #selector(handleTouchUpInside),
        UIControl.Event.touchUpOutside.rawValue: #selector(handleTouchUpOutside),
        UIControl.Event.touchDragInside.rawValue: #selector(handleTouchDragInside),
        UIControl.Event.touchDragOutside.rawValue: #selector(handleTouchDragOutside),
        UIControl.Event.touchDragEnter.rawValue: #selector(handleTouchDragEnter),
        UIControl.Event.touchDragExit.rawValue: #selector(handleTouchDragExit),
        UIControl.Event.touchDownRepeat.rawValue: #selector(handleTouchDownRepeat),
        UIControl.Event.touchDown.rawValue: #selector(handleTouchDown),
        UIControl.Event.touchCancel.rawValue: #selector(handleTouchCancel),
        UIControl.Event.valueChanged.rawValue: #selector(handleValueChanged),
        UIControl.Event.editingChanged.rawValue: #selector(handleEditingChanged),
    ]
    
    override func execute(_ config: [String : Any], view: UIView) -> Bool {
        if let uicontrol = view as? UIControl {
            super.execute(config, view: view)

            if let eventHandlers = config["eventHandlers"] as? [String] {
                updateTargets(manipFunc: uicontrol.removeTarget(_:action:for:), eventHandlers: uicontrol.eventHandlers)
                updateTargets(manipFunc: uicontrol.addTarget(_:action:for:), eventHandlers: eventHandlers)
                uicontrol.eventHandlers = eventHandlers
            }
            return true
        }
        return false
    }

    private func updateTargets(manipFunc: (_ target: Any?,_ action: Selector,_ for: UIControl.Event) -> Void, eventHandlers: [String]) {
        let events = eventHandlers.flatMap { (id) -> [Event] in
            self.context.eventHandlerIndex[id]?.getEvents() ?? []
        }.filter { (event) -> Bool in
            event.control != nil
        }

        for event in events {
            if let controlEvent = event.control,
                let selector = self.selectorMap[controlEvent.rawValue] {
                manipFunc(self, selector, controlEvent)
            }
        }
    }

    private func handleControlEvent(_ sender: UIControl, event: Event) {
        for id in sender.eventHandlers {
            if let eventHandler = self.context.eventHandlerIndex[id],
                let eventName = event.name {
                eventHandler.handle(event: eventName)
            }
        }
    }

    @objc private func handleTouchUpInside(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchUpInside))
    }

    @objc private func handleTouchUpOutside(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchUpOutside))
    }

    @objc private func handleTouchDragInside(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDragInside))
    }

    @objc private func handleTouchDragOutside(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDragOutside))
    }

    @objc private func handleTouchDragEnter(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDragEnter))
    }

    @objc private func handleTouchDragExit(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDragExit))
    }
    
    @objc private func handleTouchDownRepeat(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDownRepeat))
    }

    @objc private func handleTouchDown(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchDown))
    }

    @objc private func handleTouchCancel(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .touchCancel))
    }

    @objc private func handleValueChanged(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .valueChanged))
    }

    @objc private func handleEditingChanged(_ sender: UIControl) {
        handleControlEvent(sender, event: Event(control: .editingChanged))
    }
}
