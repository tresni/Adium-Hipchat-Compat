//
//  HipChatCompatPlugin.h
//  HipChatCompat
//
//  Created by Brian Hartvigsen on 10/30/15.
//  Copyright © 2015 Brian Hartvigsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Adium/AIPlugin.h>
#import <Adium/AIContentObject.h>
#import <Adium/AIListObject.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIContentControllerProtocol.h>

@interface HipChatCompatPlugin : AIPlugin <AIHTMLContentFilter, AIContentFilter>

@end
