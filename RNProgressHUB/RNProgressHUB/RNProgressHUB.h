//
//  RNProgressHUB.h
//  RNProgressHUB
//
//  Created by ma arno on 16/9/12.
//  Copyright © 2016年 amsoft. All rights reserved.
//

#import "RCTBridgeModule.h"

@interface RNProgressHUB : NSObject<RCTBridgeModule>

+(UIColor *)colorFromHexString:(NSString *)hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;


@end
