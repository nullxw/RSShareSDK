//
//  RSShareSDK.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/18.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "RSShareSDK.h"
#import "WeiboUser.h"

@interface RSShareSDK()

@end

@implementation RSShareSDK


+(instancetype)shareInstance{
    static RSShareSDK *sdk = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sdk = [[self alloc] init];
    });
    return sdk;
}
+ (BOOL)isQQInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}
+ (BOOL)isWeChatInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}
+ (BOOL)isSinaWeiboInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
}
- (RSShareUser *)user{
    if(!_user){
        _user = [[RSShareUser alloc] init];
    }
    return _user;
}
-(void)registerSNSApp{
    [WXApi registerApp:kWeChatAppKey];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
    [WeiboSDK registerApp:kSinaAppKey];

}
- (BOOL)handleOpenURL:(NSURL *)url{
    RSShareLog(@"URL = %@",url.absoluteString);
    BOOL open = NO;
    if([url.absoluteString hasPrefix:@"QQ"]){
        open =  [QQApiInterface handleOpenURL:url delegate:self];
    }else if ([url.absoluteString hasPrefix:@"tencent"]){
        open = [TencentOAuth HandleOpenURL:url];
    }else if ([url.absoluteString hasPrefix:@"wx"]){
        open = [WXApi handleOpenURL:url delegate:self];
    }else if ([url.absoluteString hasPrefix:@"wb"]){
        open = [WeiboSDK handleOpenURL:url delegate:self];
    }
    return open;
}
-(void)showShareActionSheet:(NSString *)title
                description:(NSString *)description
                       text:(NSString *)text
                      image:(UIImage *)image
                    openURL:(NSString *)URL
           shareContentType:(RSShareContentType)contentType
                    success:(RSShareSuccess)success
                     failed:(RSShareFailed)failed{
    RSSharePopupController *pop = [[RSSharePopupController alloc] init];
    __weak typeof(self) weakself = self;
    [pop showPopupViewAnimated:YES callback:^(RSShareSNSType type) {
        [weakself shareToSNS:type title:title description:description text:text image:image openURL:URL shareContentType:contentType success:success failed:failed];
    }];
}
- (void)shareToSNS:(RSShareSNSType)SNS
             title:(NSString *)title
       description:(NSString *)description
              text:(NSString *)text
             image:(UIImage *)image
           openURL:(NSString *)URL
  shareContentType:(RSShareContentType)contentType
           success:(RSShareSuccess)success
            failed:(RSShareFailed)failed{
    self.successCallBack = success;
    self.failedCallBack = failed;
    NSURL *openURL = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    switch (SNS) {
        case RSShareSNSTypeQQ:
        {
            switch (contentType) {
                case RSShareContentTypeText:
                    [self shareTextToQQ:text];
                    break;
                case RSShareContentTypeImage:
                    [self shareImageToQQ:image];
                    break;
                case RSShareContentTypeMedia:
                    [self shareMediaToQQ:title description:description previewImage:image openURL:openURL];
                    break;
                default:
                    break;
            }
        }
            break;
        case RSShareSNSTypeQQZone:
        {
            switch (contentType) {
                case RSShareContentTypeText:
                    [self shareTextToQQZone:text];
                    break;
                case RSShareContentTypeImage:
                    [self shareMediaToQQZone:title description:description previewImage:image openURL:openURL];
                    break;
                case RSShareContentTypeMedia:
                    [self shareMediaToQQZone:title description:description previewImage:image openURL:openURL];
                    break;
                default:
                    break;
            }

        }
            break;
        case RSShareSNSTypeWeChatSession:
        {
            switch (contentType) {
                case RSShareContentTypeText:
                    [self shareTextToWeChatSession:text];
                    break;
                case RSShareContentTypeImage:
                    [self shareImageToWeChatSession:image];
                    break;
                case RSShareContentTypeMedia:
                    [self shareMediaToWeChatSession:title description:description previewImage:image openURL:openURL];
                    break;
                default:
                    break;
            }

        }
            break;
        case RSShareSNSTypeWeChatTimeLine:
        {
            switch (contentType) {
                case RSShareContentTypeText:
                    [self shareTextToWeChatTimeLine:text];
                    break;
                case RSShareContentTypeImage:
                    [self shareImageToWeChatTimeLine:image];
                    break;
                case RSShareContentTypeMedia:
                    [self shareMediaToWeChatTimeLine:title description:description previewImage:image openURL:openURL];
                    break;
                default:
                    break;
            }

        }
            break;
        case RSShareSNSTypeSinaWeibo:
        {
            switch (contentType) {
                case RSShareContentTypeText:
                    [self shareTextToSinaWeibo:text];
                    break;
                case RSShareContentTypeImage:
                    [self shareImageToSinaWeibo:image];
                    break;
                case RSShareContentTypeMedia:
                    [self shareMediaToSinaWeibo:title description:description previewImage:image openURL:openURL];
                    break;
                default:
                    break;
            }

        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark- 分享方法调用
-(void)handleShareSuccess{
    if(self.successCallBack){
        self.successCallBack(self.snsType);
    }
    self.successCallBack = nil;
    self.failedCallBack = nil;
    self.snsType = -1;
}
-(void)handleShareFailed:(int)errorCode{
    if(self.failedCallBack){
        self.failedCallBack(self.snsType,errorCode);
    }
    self.successCallBack = nil;
    self.failedCallBack = nil;
    self.snsType = -1;
}
#pragma mark- 分享到QQ消息
- (void)shareTextToQQ:(NSString *)text{
    self.snsType = RSShareSNSTypeQQ;
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    if(sent!=0) {
        [self handleShareFailed:-2];
    }
}
- (void)shareImageToQQ:(UIImage *)image{
    self.snsType = RSShareSNSTypeQQ;
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 1.0f)
                                               previewImageData:UIImageJPEGRepresentation(image, 0.5f)
                                                          title:@""
                                                    description:@""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    if(sent!=0) {
         [self handleShareFailed:-2];
    }
}
- (void)shareMediaToQQ:(NSString *)title
           description:(NSString *)description
          previewImage:(UIImage *)previewImage
               openURL:(NSURL *)openURL{
    self.snsType = RSShareSNSTypeQQ;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:openURL
                                title:title
                                description:description
                                previewImageData:UIImageJPEGRepresentation(previewImage, 0.5f)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];

    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    if(sent!=0) {
         [self handleShareFailed:-2];
    }
}

#pragma mark- 分享到QQ空间
- (void)shareTextToQQZone:(NSString *)text{
    self.snsType = RSShareSNSTypeQQZone;
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if(sent!=0) {
         [self handleShareFailed:-2];
    }
}
- (void)shareImageToQQZone:(UIImage *)image{
    self.snsType = RSShareSNSTypeQQZone;
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 1.0f)
                                               previewImageData:UIImageJPEGRepresentation(image, 0.5f)
                                                          title:@""
                                                    description:@""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if(sent!=0) {
         [self handleShareFailed:-2];
    }

}
- (void)shareMediaToQQZone:(NSString *)title
               description:(NSString *)description
              previewImage:(UIImage *)previewImage
                   openURL:(NSURL *)openURL{
    self.snsType = RSShareSNSTypeQQZone;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:openURL
                                title:title
                                description:description
                                previewImageData:UIImageJPEGRepresentation(previewImage, 0.5f)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    if(sent!=0) {
         [self handleShareFailed:-2];
    }

}
#pragma mark- 分享到微信消息
- (void)shareTextToWeChatSession:(NSString *)text{
    self.snsType = RSShareSNSTypeWeChatSession;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = WXSceneSession;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
        [self handleShareFailed:-2];
    }
}
- (void)shareImageToWeChatSession:(UIImage *)image{
    self.snsType = RSShareSNSTypeWeChatSession;
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.mediaObject = ext;

    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
         [self handleShareFailed:-2];
    }

}
- (void)shareMediaToWeChatSession:(NSString *)title
                      description:(NSString *)description
                     previewImage:(UIImage *)previewImage
                          openURL:(NSURL *)openURL{
    self.snsType = RSShareSNSTypeWeChatSession;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:previewImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = openURL.absoluteString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
         [self handleShareFailed:-2];
    }
}
#pragma mark- 分享到微信朋友圈
- (void)shareTextToWeChatTimeLine:(NSString *)text{
    self.snsType = RSShareSNSTypeWeChatTimeLine;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
         [self handleShareFailed:-2];
    }
}
- (void)shareImageToWeChatTimeLine:(UIImage *)image{
    self.snsType = RSShareSNSTypeWeChatTimeLine;
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
         [self handleShareFailed:-2];
    }

}
- (void)shareMediaToWeChatTimeLine:(NSString *)title
                       description:(NSString *)description
                   previewImage:(UIImage *)previewImage
                           openURL:(NSURL *)openURL{
    self.snsType = RSShareSNSTypeWeChatTimeLine;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:previewImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = openURL.absoluteString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
        [self handleShareFailed:-2];
    }

}
#pragma mark- 分享到新浪微博
- (void)shareTextToSinaWeibo:(NSString *)text{
    self.snsType = RSShareSNSTypeSinaWeibo;
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
         [self handleShareFailed:-2];
    }

}
- (void)shareImageToSinaWeibo:(UIImage *)image{
    self.snsType = RSShareSNSTypeSinaWeibo;
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.imageObject = imageObject;

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
         [self handleShareFailed:-2];
    }
}
- (void)shareMediaToSinaWeibo:(NSString *)title
                  description:(NSString *)description
              previewImage:(UIImage *)previewImage
                      openURL:(NSURL *)openURL{
    self.snsType = RSShareSNSTypeSinaWeibo;
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = openURL.absoluteString;
    webpage.title = title;
    webpage.description = description;
    webpage.thumbnailData = UIImageJPEGRepresentation(previewImage, 0.5f);
    webpage.webpageUrl =  openURL.absoluteString;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    BOOL ret = [WeiboSDK sendRequest:request];
    if(!ret){
         [self handleShareFailed:-2];
    }
}
#pragma mark- 第三方登录
- (void)loginWithSNS:(RSLoginType)snsType
             success:(RSLoginSuccess)success
              failed:(RSLoginFailed)failed{
    
    self.loginSuccessCB = success;
    self.loginFailedCB = failed;
    switch (snsType) {
        case RSLoginTypeQQ:
            [self loginWithQQ];
            break;
        case RSLoginTypeWeChat:
            [self loginWithWechat];
            break;
        case RSLoginTypeSinaWeibo:
            [self loginWithSinaWeibo];
            break;
        default:
            break;
    }
    
    
}
-(void)handleLoginSuccess{
    if(self.loginSuccessCB){
        self.loginSuccessCB(self.loginType,self.user);
    }
    self.loginSuccessCB = nil;
    self.loginFailedCB = nil;
    self.user = nil;
    self.loginType = -1;
}
-(void)handleLoginFailed{
    if(self.loginFailedCB){
        self.loginFailedCB(self.loginType);
    }
    self.loginSuccessCB = nil;
    self.loginFailedCB = nil;
    self.user = nil;
    self.loginType = -1;
}
#pragma mark- 使用QQ登录
- (void)loginWithQQ{
    self.loginType = RSLoginTypeQQ;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            nil];

    [self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark- 使用微信登录
- (void)loginWithWechat{
    self.loginType = RSLoginTypeWeChat;
    SendAuthReq* req = [[SendAuthReq alloc] init] ;
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = kWeChatAppKey;
    req.openID = @"0c806938e2413ce73eef92cc3";
    int ret = [WXApi sendReq:req];
    if(!ret){
        [self handleLoginFailed];
    }
}
- (void)getWeChatUserInfoWith:(NSString *)code{
    __weak typeof(self) weakself = self;
    NSString *path = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeChatAppKey,kWeChatAppSecret,code];
    RSShareHttp *http = [[RSShareHttp alloc] init];
    [http getDataFromPath:path success:^(NSDictionary *data) {
        NSString *access_token = [data objectForKey:@"access_token"];
        NSString *openid = [data objectForKey:@"openid"];
        weakself.user.accessToken = access_token;
        weakself.user.openId = openid;
        weakself.user.refreshToken = data[@"refresh_token"];
        weakself.user.expirationDate = [NSDate dateWithTimeInterval:[[data objectForKey:@"expires_in"] intValue] sinceDate:[NSDate date]];
        NSString *userinfopath = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
        RSShareHttp *httpuserinfo = [[RSShareHttp alloc] init];
        [httpuserinfo getDataFromPath:userinfopath success:^(NSDictionary *data) {
            weakself.user.nickname = data[@"nickname"];
            weakself.user.openId = data[@"openid"];
            weakself.user.avatar = data[@"headimgurl"];
            weakself.user.gender = [[data objectForKey:@"sex"] intValue] == 1 ? @"男" : @"女";
            weakself.user.province = data[@"province"];
            weakself.user.city = data[@"city"];
            [weakself handleLoginSuccess];
        } failed:^(NSError *error) {
            [weakself handleLoginFailed];
        }];
    } failed:^(NSError *error) {
        [weakself handleLoginFailed];
    }];

}
#pragma mark- 使用新浪微博登陆
-(void)loginWithSinaWeibo{
    self.loginType = RSLoginTypeSinaWeibo;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    int ret = [WeiboSDK sendRequest:request];
    if(!ret){
        [self handleLoginFailed];
    }
}

#pragma mark- WXApiDelegate
-(void)onReq:(BaseReq *)req{
}
-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){ //分享到微信回调
        if(resp.errCode == 0){
            [self handleShareSuccess];
        }else{
            [self handleShareFailed:resp.errCode];
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])    //使用微信登陆
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if(temp.errCode ==0){//登陆成功
            [self getWeChatUserInfoWith:temp.code];
        }else{//微信登陆失败
            [self handleLoginFailed];
        }
        
        
    }
    else if ([resp isKindOfClass:[SendMessageToQQResp class]]){   //分享到QQ回调
        SendMessageToQQResp *qqres = (SendMessageToQQResp *)resp;
        if(qqres.result.intValue == 0){
            [self handleShareSuccess];
        }else{
            [self handleShareFailed:qqres.result.intValue];
        }
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
            [self handleShareFailed:response.statusCode];
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
                                   [self handleLoginFailed];
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
            [self handleLoginFailed];
        }
    }
}
#pragma mark- TencentSessionDelegate
- (void)tencentDidLogin{
    [_tencentOAuth getUserInfo];
    self.user.accessToken = _tencentOAuth.accessToken;
    self.user.openId = _tencentOAuth.openId;
    self.user.expirationDate = _tencentOAuth.expirationDate;
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [self handleLoginFailed];
}
- (void)tencentDidNotNetWork{
    [self handleLoginFailed];
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
        [self handleLoginFailed];
    }
}

@end
