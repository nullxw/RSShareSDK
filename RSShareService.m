//
//  RSShareService.m
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareService.h"


@implementation RSShareService

+(instancetype)service{
     NSAssert(1, @"service未继承");
    return nil;
}
-(instancetype)initWithShareSuccess:(RSShareSuccess)shareSuccess
                        shareFailed:(RSShareFailed)shareFailed
                       loginSuccess:(RSLoginSuccess)loginSuccess
                        loginFailed:(RSLoginFailed)loginFailed{
    self = [super init];
    if(self){
        self.shareSuccessCallBack = shareSuccess;
        self.shareFailedCallBack = shareFailed;
        self.loginSuccessCallBack = loginSuccess;
        self.loginFailedCallBack = loginFailed;
    }
    return self;
}
- (RSShareSDKUser *)user{
    if(!_user){
        _user = [[RSShareSDKUser alloc] init];
    }
    return _user;
}
#pragma mark- callBack
-(void)handleShareSuccess{
    if(self.shareSuccessCallBack){
        self.shareSuccessCallBack(self.snsType);
    }
}
-(void)handleShareFailed:(RSErrorCode)errorCode{
    RSShareSDKError *error = [[RSShareSDKError alloc] initWithErrorCode:errorCode];
    if(self.shareFailedCallBack){
        self.shareFailedCallBack(self.snsType,error);
    }
}
-(void)handleLoginSuccess{
    if(self.loginSuccessCallBack){
        self.loginSuccessCallBack(self.loginType,self.user);
    }
}
-(void)handleLoginFailed:(RSErrorCode)errorCode{
     RSShareSDKError *error = [[RSShareSDKError alloc] initWithErrorCode:errorCode];
    if(self.loginFailedCallBack){
        self.loginFailedCallBack(self.loginType,error);
    }
}

- (BOOL)handleOpenURL:(NSURL *)url{
     NSAssert(1, @"handleOpenURL未继承");
    return NO;
}
- (void)registerApp{
    NSAssert(1, @"registerApp未继承");
}
- (void)shareText:(NSString *)text{
    NSAssert(1, @"shareText未继承");
}
- (void)shareImage:(UIImage *)image{
    NSAssert(1, @"shareImage未继承");
}
- (void)shareMedia:(NSString *)title
       description:(NSString *)description
      previewImage:(UIImage *)previewImage
           openURL:(NSURL *)openURL{
    NSAssert(1, @"shareMedia未继承");
}
-(void)snsLogin{
    NSAssert(1, @"snsLogin未继承");
}
@end
