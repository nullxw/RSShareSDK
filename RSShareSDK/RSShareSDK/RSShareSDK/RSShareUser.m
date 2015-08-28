//
//  RSShareUser.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "RSShareUser.h"

@implementation RSShareUser

-(NSString *)description{
    return [NSString stringWithFormat:@"name = %@ , genger = %@ , openid = %@ , avatar = %@ ",self.nickname,self.gender,self.openId,self.avatar];
}
@end
