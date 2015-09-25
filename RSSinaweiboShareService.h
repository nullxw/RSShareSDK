//
//  RSSinaweiboShareService.h
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareService.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

@interface RSSinaweiboShareService : RSShareService<WeiboSDKDelegate>
+ (BOOL)isSinaWeiboInstalled;
@end
