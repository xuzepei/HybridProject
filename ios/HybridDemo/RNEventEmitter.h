//
//  RNEventEmitter.h
//  HybridDemo
//
//  Created by xuzepei on 2019/4/26.
//  Copyright © 2019 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNEventEmitter : NSObject

//+ (RNEventEmitter*)shared;
- (void)sendEventToRN:name body:(id)body;

@end

