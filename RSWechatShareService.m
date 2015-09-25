//
//  RSWechatShareService.m
//  Demo
//
//  Created by 贾磊 on 15/9/22.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSWechatShareService.h"

@implementation RSWechatShareService

+(instancetype)service{
    
    static RSWechatShareService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[RSWechatShareService alloc] init];
    });
    return service;
}
+ (BOOL)isWeChatInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}
- (BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(void)registerApp{ 
     [WXApi registerApp:kWeChatAppKey];
}

- (void)shareText:(NSString *)text{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = self.snsType == RSShareSNSTypeWeChatSession ? WXSceneSession : WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}

- (void)shareImage:(UIImage *)image{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = self.snsType == RSShareSNSTypeWeChatSession ? WXSceneSession : WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}

- (void)shareMedia:(NSString *)title
       description:(NSString *)description
      previewImage:(UIImage *)previewImage
           openURL:(NSURL *)openURL{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.thumbData = [self thumbImageDataLessThan32k:previewImage];
    //[message setThumbImage:previewImage];
    //[message setThumbImage:[self thumbImageLessThan32k:previewImage]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = openURL.absoluteString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = self.snsType == RSShareSNSTypeWeChatSession ? WXSceneSession : WXSceneTimeline;
    BOOL ret = [WXApi sendReq:req];
    if(!ret){
        [self handleShareFailed:RSErrCodeSentFail];
    }
}
-(void)snsLogin{
    SendAuthReq* req = [[SendAuthReq alloc] init] ;
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = kWeChatAppKey;
    req.openID = kWeChatAppKey;
    int ret = [WXApi sendReq:req];
    if(!ret){
        [self handleLoginFailed:RSErrCodeSentFail];
    }
}
#pragma mark- WXApiDelegate
-(void) onReq:(BaseReq*)req{
    
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
            [self handleLoginFailed:temp.errCode];
        }
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
            [weakself handleLoginFailed:RSErrCodeCommon];
        }];
    } failed:^(NSError *error) {
        [weakself handleLoginFailed:RSErrCodeCommon];
    }];
    
}

//处理图片小于32K
-(NSData *)thumbImageDataLessThan32k:(UIImage *)sourceImage{
    
    float quality = 1.0f;
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, quality);
    while (imageData.length >= 32*1024 && quality > 0.1f) {
        quality -= 0.1f;
        imageData= UIImageJPEGRepresentation(sourceImage, quality);
    }
    return imageData;
}
@end
