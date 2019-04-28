//
//  RNEventManager.h
//  HybridDemo
//
//  Created by xuzepei on 2019/4/26.
//  Copyright © 2019 xuzepei. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTEventEmitter.h>

@interface RNEventManager : RCTEventEmitter<RCTBridgeModule>

@property(nonatomic, copy)RCTPromiseResolveBlock resolve;
@property(nonatomic, assign)BOOL isObserving;

+ (RNEventManager*)shared;
+ (instancetype)allocWithZone:(struct _NSZone *)zone;
- (void)callbackToRN;
- (void)sendEventToRN:(NSString*)name body:(id)body;

@end
