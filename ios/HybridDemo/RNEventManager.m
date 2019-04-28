//
//  RNEventManager.m
//  HybridDemo
//
//  Created by xuzepei on 2019/4/26.
//  Copyright © 2019 xuzepei. All rights reserved.
//

#import "RNEventManager.h"
#import "HybridDemo-Swift.h"

typedef BOOL (^MyBlock)(NSString*, NSString*);
static RNEventManager* shared = nil;

@implementation RNEventManager

RCT_EXPORT_MODULE(); //指定MODULE的名字，默认为当前类名

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [super allocWithZone:zone];
    });
    return shared;
}

+ (RNEventManager*)shared
{
    if(shared)
        return shared;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shared = [RNEventManager new];
//    });
    
    return nil;
}

#pragma mark - Call OC methods in RN

RCT_EXPORT_METHOD(showAlert:(NSString *)name)
{
    NSLog(@"$$$: show alert: %@", name);
    
    [RNEventManagerSwift showAlert:name message: nil];
}

RCT_EXPORT_METHOD(test:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"$$$: test: %@", name);
    
    [RNEventManager shared].resolve = resolve;
    //resolve(@{@"name": name, @"desc": @"not hard"});
}

- (void)callbackToRN {
    
    if([RNEventManager shared].resolve) {
        [RNEventManager shared].resolve(@{@"name": @"callback", @"msg": @"This is a callback from OC!"});
        [RNEventManager shared].resolve = nil;
    }
}

#pragma mark - Send Event to RN

- (void)startObserving
{
    [RNEventManager shared].isObserving = YES;
}

- (void)stopObserving
{
    [RNEventManager shared].isObserving = NO;
}

- (void)sendEventToRN:(NSString*)name body:(id)body {
    
    if(name.length == 0)
        return;
    
    if([RNEventManager shared].isObserving) {
        
        [[RNEventManager shared] sendEventWithName:name body:body];
    }
}

//Must has this method
- (NSArray<NSString *> *)supportedEvents {
    return @[@"onTestEvent"];
}



@end
