//
//  RSShareSDK.m
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import "RSShareSDK.h"

@implementation RSShareSDK

+ (BOOL)isQQInstalled{
    return [RSQQShareService isQQInstalled];
}
+ (BOOL)isWeChatInstalled{
    return [RSWechatShareService isWeChatInstalled];
}
+ (BOOL)isSinaWeiboInstalled{
    return [RSSinaweiboShareService isSinaWeiboInstalled];
}
+(BOOL)handleOpenURL:(NSURL *)url{
    BOOL open = NO;
    if([url.absoluteString hasPrefix:@"QQ"] || [url.absoluteString hasPrefix:@"tencent"]){
        open =  [[RSQQShareService service] handleOpenURL:url];
    }else if ([url.absoluteString hasPrefix:@"wx"]){
        open = [[RSWechatShareService service] handleOpenURL:url];
    }else if ([url.absoluteString hasPrefix:@"wb"]){
        open = [[RSSinaweiboShareService service] handleOpenURL:url];
    }
    return open;
}
+ (void)registerRSShareSDK{
    [[RSQQShareService service] registerApp];
    [[RSWechatShareService service] registerApp];
    [[RSSinaweiboShareService service] registerApp];
}

+ (void)showShareActionSheet:(NSString *)title
                 description:(NSString *)description
                        text:(NSString *)text
                       image:(UIImage *)image
                     openURL:(NSString *)URL
            shareContentType:(RSShareContentType)contentType
                     success:(RSShareSuccess)success
                      failed:(RSShareFailed)failed{
    RSSharePopupController *pop = [[RSSharePopupController alloc] init];
    [pop showPopupViewAnimated:YES callback:^(RSShareSNSType type) {
        [RSShareSDK shareTo:type title:title description:description text:text image:image openURL:URL shareContentType:contentType success:success failed:failed];
    }];
}
+ (void)shareTo:(RSShareSNSType)snsType
          title:(NSString *)title
    description:(NSString *)description
           text:(NSString *)text
          image:(UIImage *)image
        openURL:(NSString *)URL
shareContentType:(RSShareContentType)contentType
        success:(RSShareSuccess)success
         failed:(RSShareFailed)failed{
    NSURL *openURL = [NSURL URLWithString:[URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    switch (snsType) {
        case RSShareSNSTypeQQ:
        case RSShareSNSTypeQQZone:
        {
            RSQQShareService *service = [RSQQShareService service];
            service.snsType = snsType;
            service.shareSuccessCallBack = success;
            service.shareFailedCallBack = failed;
            switch (contentType) {
                case RSShareContentTypeText:
                    [service shareText:text];
                    case RSShareContentTypeImage:
                    [service shareImage:image];
                    case RSShareContentTypeMedia:
                    [service shareMedia:title description:description previewImage:image openURL:openURL];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case RSShareSNSTypeWeChatSession:
        case RSShareSNSTypeWeChatTimeLine:
        {
            RSWechatShareService *service = [RSWechatShareService service];
            service.snsType = snsType;
            service.shareSuccessCallBack = success;
            service.shareFailedCallBack = failed;
            switch (contentType) {
                case RSShareContentTypeText:
                    [service shareText:text];
                case RSShareContentTypeImage:
                    [service shareImage:image];
                case RSShareContentTypeMedia:
                    [service shareMedia:title description:description previewImage:image openURL:openURL];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case RSShareSNSTypeSinaWeibo:
        {
            RSSinaweiboShareService *service = [RSSinaweiboShareService service];
            service.snsType = snsType;
            service.shareSuccessCallBack = success;
            service.shareFailedCallBack = failed;
            switch (contentType) {
                case RSShareContentTypeText:
                    [service shareText:text];
                case RSShareContentTypeImage:
                    [service shareImage:image];
                case RSShareContentTypeMedia:
                    [service shareMedia:title description:description previewImage:image openURL:openURL];
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
+ (void)SNSlogin:(RSLoginType)snsType
         success:(RSLoginSuccess)success
          failed:(RSLoginFailed)failed{
    switch (snsType) {
        case RSLoginTypeQQ:
        {
            RSQQShareService *service = [RSQQShareService service];
            service.loginType = snsType;
            service.loginSuccessCallBack = success;
            service.loginFailedCallBack = failed;
            [service snsLogin];
        }
            break;
        case RSLoginTypeWeChat:
        {
            RSWechatShareService *service = [RSWechatShareService service];
            service.loginType = snsType;
            service.loginSuccessCallBack = success;
            service.loginFailedCallBack = failed;
            [service snsLogin];
        }
            break;
        case RSLoginTypeSinaWeibo:
        {
            RSSinaweiboShareService *service = [RSSinaweiboShareService service];
            service.loginType = snsType;
            service.loginSuccessCallBack = success;
            service.loginFailedCallBack = failed;
            [service snsLogin];
        }
            break;
            
        default:
            break;
    }
}
@end
