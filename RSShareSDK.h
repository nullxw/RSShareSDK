//
//  RSShareSDK.h
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSQQShareService.h"
#import "RSWechatShareService.h"
#import "RSSinaweiboShareService.h"
#import "RSSharePopupController.h"

@interface RSShareSDK : NSObject

+ (BOOL)isQQInstalled;
+ (BOOL)isWeChatInstalled;
+ (BOOL)isSinaWeiboInstalled;
+ (BOOL)handleOpenURL:(NSURL *)url;
+ (void)registerRSShareSDK;

+ (void)showShareActionSheet:(NSString *)title
                 description:(NSString *)description
                        text:(NSString *)text
                       image:(UIImage *)image
                     openURL:(NSString *)URL
            shareContentType:(RSShareContentType)contentType
                     success:(RSShareSuccess)success
                      failed:(RSShareFailed)failed;

+ (void)shareTo:(RSShareSNSType)snsType
          title:(NSString *)title
    description:(NSString *)description
           text:(NSString *)text
          image:(UIImage *)image
        openURL:(NSString *)URL
shareContentType:(RSShareContentType)contentType
        success:(RSShareSuccess)success
         failed:(RSShareFailed)failed;

+ (void)SNSlogin:(RSLoginType)snsType
         success:(RSLoginSuccess)success
          failed:(RSLoginFailed)failed;
@end
