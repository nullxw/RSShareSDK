//
//  RSQQShareService.h
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareService.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface RSQQShareService : RSShareService<QQApiInterfaceDelegate,TencentSessionDelegate>

@property (nonatomic,strong) TencentOAuth *tencentOAuth;

+ (BOOL)isQQInstalled;
@end
