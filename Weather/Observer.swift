//
//  Observer.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

protocol Invocable : class
{
    func invoke(_ data: Any)
}

final public class DisposeBag {
    
    var disposables = [Disposable]()
    
    public func insert(_ disposable: Disposable) {
        disposables.append(disposable)
    }
    
    func dispose() {
        disposables.forEach({$0.dispose()})
    }
    
    deinit {
        dispose()
    }
}

public protocol Disposable
{
    func dispose()
}

extension Disposable {
    public func disposed(by bag: DisposeBag) {
        bag.insert(self)
    }
}

public class Event<T>
{
    public typealias EventHandler = (T) -> ()
    
    var eventHandlers = [Invocable]()
    
    public func raise(_ data: T)
    {
        for handler in eventHandlers
        {
            handler.invoke(data)
        }
    }
    
    public func addHandler<U: AnyObject>
        (target: U, handler: @escaping (U) -> EventHandler?) -> Disposable
    {
        let subscription = Subscription(
            target: target, handler: handler, event: self)
        eventHandlers.append(subscription)
        return subscription
    }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
    weak var target: T?
    let handler: (T) -> ((U) -> ())?
    let event: Event<U>
    
    init(target: T?,
         handler: @escaping (T) -> ((U) -> ())?,
         event: Event<U>)
    {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let target = target,
            let data = data as? U {
            handler(target)?(data)
        }
    }
    
    func dispose()
    {
        event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
    }
}

