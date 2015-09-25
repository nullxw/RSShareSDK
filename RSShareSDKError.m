//
//  RSShareSDKError.m
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareSDKError.h"

@implementation RSShareSDKError

-(instancetype)initWithErrorCode:(RSErrorCode)errorCode{
    self = [super init];
    if(self){
        self.errorCode = errorCode;
    }
    return self;
}

-(NSString *)description{
    NSString *description = nil;
    switch (self.errorCode) {
        case 0:
            description = RSSuccessDescription;
            break;
        case -1:
            description = RSErrCommonDescription;
            break;
        case -2:
            description = RSErrUserCancelDescription;
            break;
        case -3:
            description = RSErrSentFailDescription;
            break;
        case -4:
            description = RSErrAuthDenyDescription;
            break;
        case -5:
            description = RSErrUnsupportDescription;
            break;
            
        default:
            description = RSErrUnknownDescription;
            break;
    }
    return description;
}
@end
