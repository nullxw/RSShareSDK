//
//  RSShareSDKUser.m
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareSDKUser.h"

@implementation RSShareSDKUser

-(NSString *)description{
    return [NSString stringWithFormat:@"name = %@ , genger = %@ , openid = %@ , avatar = %@ ",self.nickname,self.gender,self.openId,self.avatar];
}

@end
