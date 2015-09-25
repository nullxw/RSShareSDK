//
//  RSWechatShareService.h
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareService.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface RSWechatShareService : RSShareService<WXApiDelegate>

+ (BOOL)isWeChatInstalled;
@end
