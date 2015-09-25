//
//  RSSinaweiboShareService.m
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSSinaweiboShareService.h"

@implementation RSSinaweiboShareService

+(instancetype)service{
    
    static RSSinaweiboShareService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[RSSinaweiboShareService alloc] init];
    });
    return service;
}
+ (BOOL)isSinaWeiboInstalled{
    return [WeiboSDK isWeiboAppInstalled];
}
- (BOOL)handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(void)registerApp{
     [WeiboSDK registerApp:kSinaAppKey];;
}
- (void)shareText:(NSString *)text{
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}

- (void)shareImage:(UIImage *)image{
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}

- (void)shareMedia:(NSString *)title
       description:(NSString *)description
      previewImage:(UIImage *)previewImage
           openURL:(NSURL *)openURL{
    //由于需要申请新浪linkcard解析,替换为文字+图片方式
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ 观看地址:%@",title,openURL.absoluteString];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(previewImage, 1.0f);
    message.imageObject = imageObject;
    //    webpage.objectID = openURL.absoluteString;
    //    webpage.title = title;
    //    webpage.description = description;
    //    webpage.thumbnailData = UIImageJPEGRepresentation(previewImage,0.5f);
    //    webpage.webpageUrl =  openURL.absoluteString;
    //    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}
-(void)snsLogin{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    int ret = [WeiboSDK sendRequest:request];
    if(!ret){
        [self handleLoginFailed:RSErrCodeSentFail];
    }
}

#pragma mark- WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){ //分享到微博
        if(response.statusCode == 0){
            [self handleShareSuccess];
        }else{
            [self handleShareFailed:(int)response.statusCode];
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]){    //微博SSO登录
        if(response.statusCode == 0){
            NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
            NSString *userID = [(WBAuthorizeResponse *)response userID];
            NSString *refreshToken = [(WBAuthorizeResponse *)response refreshToken];
            self.user.accessToken = accessToken;
            self.user.openId = userID;
            self.user.refreshToken = refreshToken;
            self.user.expirationDate = [(WBAuthorizeResponse *)response expirationDate];
            __weak typeof(self) weakself = self;
            [WBHttpRequest requestForUserProfile:userID withAccessToken:accessToken andOtherProperties:nil queue:nil
                           withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                               if(error){
                                   [weakself handleLoginFailed:RSErrCodeCommon];
                               }else{
                                   WeiboUser *user = (WeiboUser *)result;
                                   weakself.user.nickname = user.name;
                                   weakself.user.avatar = user.avatarLargeUrl;
                                   weakself.user.gender = [user.gender isEqualToString:@"m"] ? @"男" : @"女";
                                   weakself.user.province = user.province;
                                   weakself.user.city = user.city;
                                   [weakself handleLoginSuccess];
                               }
                           }];
            
        }else{
            [self handleLoginFailed:(int)response.statusCode];
        }
    }
}

@end
