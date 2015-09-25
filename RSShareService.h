//
//  RSShareService.h
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RSShareSDKDefine.h"
#import "RSShareSDKError.h"
#import "RSShareSDKUser.h"
#import "RSShareHttp.h"

@interface RSShareService : NSObject
//login
@property (nonatomic,copy)   RSLoginSuccess loginSuccessCallBack;
@property (nonatomic,copy)   RSLoginFailed  loginFailedCallBack;
@property (nonatomic,assign) RSLoginType    loginType;
@property (nonatomic,strong) RSShareSDKUser  *user;

//share
@property (nonatomic,copy) RSShareSuccess shareSuccessCallBack;
@property (nonatomic,copy) RSShareFailed  shareFailedCallBack;
@property (nonatomic,assign) RSShareSNSType snsType;


+(instancetype)service;

-(instancetype)initWithShareSuccess:(RSShareSuccess)shareSuccess
                        shareFailed:(RSShareFailed)shareFailed
                       loginSuccess:(RSLoginSuccess)loginSuccess
                        loginFailed:(RSLoginFailed)loginFailed;

-(void)handleShareSuccess;
-(void)handleShareFailed:(RSErrorCode)errorCode;
-(void)handleLoginSuccess;
-(void)handleLoginFailed:(RSErrorCode)errorCode;


- (BOOL)handleOpenURL:(NSURL *)url;
- (void)registerApp;

- (void)shareText:(NSString *)text;

- (void)shareImage:(UIImage *)image;

- (void)shareMedia:(NSString *)title
       description:(NSString *)description
      previewImage:(UIImage *)previewImage
           openURL:(NSURL *)openURL;
-(void)snsLogin;

@end
