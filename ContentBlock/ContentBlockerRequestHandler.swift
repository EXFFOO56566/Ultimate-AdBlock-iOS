//
//  ContentBlockerRequestHandler.swift
//  ContentBlock
//
//  Created by Iurii Dolotov on 21.04.2021.
//

import UIKit
import Purchases
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        
        let defaultsToContentBlock = UserDefaults(suiteName: "group.ad.block")
        if defaultsToContentBlock!.value(forKey: "user_is_subscribed") != nil {
            print("EXTENSTION - USER IS SUBSCRIBED")
            NSLog("EXTENSTION - USER IS SUBSCRIBED")
            
            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!

            let item = NSExtensionItem()
            item.attachments = [attachment]

            context.completeRequest(returningItems: [item], completionHandler: nil)
        } else {
            print("EXTENSTION - USER IS NOT SUBSCRIBED")
            NSLog("EXTENSTION - USER IS NOT SUBSCRIBED")
        }
    }
    
}
