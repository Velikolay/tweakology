//
//  UIControlExecutor.swift
//  TweakologyEngine
//
//  Created by Nikolay Ivanov on 20.01.20.
//

import Foundation

@available(iOS 10.0, *)
class UIControlExecutor: UIViewExecutor {
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
            if let eventName = event.name, let controlEvent = event.control {
                manipFunc(self, Selector("handle\(eventName)"), controlEvent)
            }
        }
    }

    private func handleControlEvent(_ sender: UIControl, event: Event) {
        for id in sender.eventHandlers {
            if let eventHandler = TweakologyLayoutEngine.sharedInstance.eventHandlerIndex[id],
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
