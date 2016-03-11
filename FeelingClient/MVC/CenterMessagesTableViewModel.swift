//
//  CenterMessagesTableViewModel.swift
//  FeelingClient
//
//  Created by vincent on 11/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation

public class CenterMessagesListViewModel {
    
    public let context = Messages.defaultMessages
    public var items = [Item]()
    
    
    public func refresh() {
        items = context.msgs.map { self.itemForPayback($0) }
        print(items)
    }
    
    func itemForPayback(bean: MessageBean) -> Item {
        let item = Item(to: bean.to, date: bean.limitDate)
        return item
    }
    
    func removePayback(index: Int) {
        context.msgs.removeAtIndex(index)
    }
    
    
    public struct Item {
        public let to: String
        public let date: String
    }
    
}
