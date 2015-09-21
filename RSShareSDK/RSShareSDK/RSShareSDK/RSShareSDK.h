//
//  RSShareSDK.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/18.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSShareSDKDefine.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "RSShareHttp.h"
#import "RSShareUser.h"
#import "RSSharePopupController.h"
@interface RSShareSDK : NSObject<WXApiDelegate,WeiboSDKDelegate,TencentSessionDelegate,QQApiInterfaceDelegate>
//login
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,strong) RSShareUser  *user;
@property (nonatomic,copy)   RSLoginSuccess loginSuccessCB;
@property (nonatomic,copy)   RSLoginFailed  loginFailedCB;
@property (nonatomic,assign) RSLoginType    loginType;

//share
@property (nonatomic,copy) RSShareSuccess successCallBack;
@property (nonatomic,copy) RSShareFailed  failedCallBack;

@property (nonatomic,assign) RSShareSNSType snsType;



+ (instancetype)shareInstance;

+ (BOOL)isQQInstalled;
+ (BOOL)isWeChatInstalled;
+ (BOOL)isSinaWeiboInstalled;

- (void)registerSNSApp;

- (BOOL)handleOpenURL:(NSURL *)url;


-(void)showShareActionSheet:(NSString *)title
                description:(NSString *)description
                       text:(NSString *)text
                      image:(UIImage *)image
                    openURL:(NSString *)URL
           shareContentType:(RSShareContentType)contentType
                    success:(RSShareSuccess)success
                     failed:(RSShareFailed)failed;

- (void)shareToSNS:(RSShareSNSType)SNS
             title:(NSString *)title
       description:(NSString *)description
              text:(NSString *)text
             image:(UIImage *)image
           openURL:(NSString *)URL
  shareContentType:(RSShareContentType)contentType
           success:(RSShareSuccess)success
            failed:(RSShareFailed)failed;


- (void)loginWithSNS:(RSLoginType)snsType
             success:(RSLoginSuccess)success
              failed:(RSLoginFailed)failed;


#if 0
- (void)shareTextToQQ:(NSString *)text;
- (void)shareImageToQQ:(UIImage *)image;
- (void)shareMediaToQQ:(NSString *)title
           description:(NSString *)description
          previewImage:(UIImage *)previewImage
               openURL:(NSURL *)openURL;

- (void)shareTextToQQZone:(NSString *)text;
- (void)shareImageToQQZone:(UIImage *)image;
- (void)shareMediaToQQZone:(NSString *)title
               description:(NSString *)description
              previewImage:(UIImage *)previewImage
                   openURL:(NSURL *)openURL;

- (void)shareTextToWeChatSession:(NSString *)text;
- (void)shareImageToWeChatSession:(UIImage *)image;
- (void)shareMediaToWeChatSession:(NSString *)title
                      description:(NSString *)description
                  previewImage:(UIImage *)previewImage
                          openURL:(NSURL *)openURL;

- (void)shareTextToWeChatTimeLine:(NSString *)text;
- (void)shareImageToWeChatTimeLine:(UIImage *)image;
- (void)shareMediaToWeChatTimeLine:(NSString *)title
                       description:(NSString *)description
                   previewImage:(UIImage *)previewImage
                           openURL:(NSURL *)openURL;

- (void)shareTextToSinaWeibo:(NSString *)text;
- (void)shareImageToSinaWeibo:(UIImage *)image;
- (void)shareMediaToSinaWeibo:(NSString *)title
                  description:(NSString *)description
              previewImage:(UIImage *)previewImage
                      openURL:(NSURL *)openURL;

- (void)loginWithQQ;
- (void)loginWithWechat;
- (void)loginWithSinaWeibo;
#endif


@end
