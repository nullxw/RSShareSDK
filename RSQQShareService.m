//
//  RSQQShareService.m
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSQQShareService.h"

@implementation RSQQShareService

+(instancetype)service{
    
    static RSQQShareService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[RSQQShareService alloc] init];
    });
    return service;
}

+ (BOOL)isQQInstalled{
    return [TencentOAuth iphoneQQInstalled];
}
- (BOOL)handleOpenURL:(NSURL *)url{
    if([url.absoluteString hasPrefix:@"QQ"]){
         return [QQApiInterface handleOpenURL:url delegate:self];
    }else{
        return [TencentOAuth HandleOpenURL:url];
    }
}
-(void)registerApp{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
}
- (void)shareText:(NSString *)text{
    
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode sent = self.snsType == RSShareSNSTypeQQ ? [QQApiInterface sendReq:req] : [QQApiInterface SendReqToQZone:req];
    if(sent != 0){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}
- (void)shareImage:(UIImage *)image{
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 1.0f)
                                               previewImageData:UIImageJPEGRepresentation(image, 0.5f)
                                                          title:@""
                                                    description:@""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = self.snsType == RSShareSNSTypeQQ ? [QQApiInterface sendReq:req] : [QQApiInterface SendReqToQZone:req];
    if(sent != 0){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}
- (void)shareMedia:(NSString *)title
       description:(NSString *)description
      previewImage:(UIImage *)previewImage
           openURL:(NSURL *)openURL{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:openURL
                                title:title
                                description:description
                                previewImageData:UIImageJPEGRepresentation(previewImage, 0.5f)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = self.snsType == RSShareSNSTypeQQ ? [QQApiInterface sendReq:req] : [QQApiInterface SendReqToQZone:req];
    if(sent != 0){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}
-(void)snsLogin{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            nil];
    
    [self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark- QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req{
    
}

- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]){   //分享到QQ回调
        SendMessageToQQResp *qqres = (SendMessageToQQResp *)resp;
        if(qqres.result.intValue == 0){
            [self handleShareSuccess];
        }else{
            [self handleShareFailed:RSErrCodeSentFail];
        }
    }

}
- (void)isOnlineResponse:(NSDictionary *)response{
    
}

#pragma mark- TencentSessionDelegate
- (void)tencentDidLogin{
    [_tencentOAuth getUserInfo];
    self.user.accessToken = _tencentOAuth.accessToken;
    self.user.openId = _tencentOAuth.openId;
    self.user.expirationDate = _tencentOAuth.expirationDate;
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [self handleLoginFailed:RSErrCodeUserCancel];
}
- (void)tencentDidNotNetWork{
    [self handleLoginFailed:RSErrCodeAuthDeny];
}
- (void)getUserInfoResponse:(APIResponse*) response{
    if(response.retCode == 0){
        self.user.gender = response.jsonResponse[@"gender"];
        self.user.nickname = response.jsonResponse[@"nickname"];
        self.user.avatar = response.jsonResponse[@"figureurl"];
        self.user.province = response.jsonResponse[@"province"];
        self.user.city   = response.jsonResponse[@"city"];
        [self handleLoginSuccess];
    }else{
        [self handleLoginFailed:RSErrCodeAuthDeny];
    }
}

@end
