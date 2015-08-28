//
//  RSShareSDKDefine.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/18.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

@class RSShareUser;

extern NSString *const RSShareToSina;
extern NSString *const RSShareToQzone;
extern NSString *const RSShareToWechatSession;
extern NSString *const RSShareToWechatTimeline;
extern NSString *const RSShareToQQ;




#define kSinaAppKey         @"2650608488"
#define kSinaSecret         @"2e98eaff7e233122af7e7abfe57ab045"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define kWeChatAppKey        @"wx6ab158b6dbda7d7a"
#define kWeChatAppSecret    @"c686143a78cff83717ab5c893a60e130"

#define kQQAppKey           @"1104802638"
#define kQQAppSecret        @"mjRK03ewUacnXnZo"

#ifndef __OPTIMIZE__
#define RSShareLog(...) NSLog(__VA_ARGS__)
#else
#define RSShareLog(...) {}
#endif

typedef enum : NSUInteger {
    RSShareSNSTypeQQ = 0,
    RSShareSNSTypeQQZone,
    RSShareSNSTypeWeChatSession,
    RSShareSNSTypeWeChatTimeLine,
    RSShareSNSTypeSinaWeibo
} RSShareSNSType;

typedef enum : NSUInteger {
    RSShareContentTypeText = 0,
    RSShareContentTypeImage,
    RSShareContentTypeMedia,
} RSShareContentType;
typedef enum : NSUInteger {
    RSLoginTypeQQ = 0,
    RSLoginTypeWeChat,
    RSLoginTypeSinaWeibo,
} RSLoginType;
typedef void(^RSShareSuccess)(RSShareSNSType type);
typedef void(^RSShareFailed) (RSShareSNSType type,int errorCode);

typedef void(^RSLoginSuccess)(RSLoginType type,RSShareUser *user);
typedef void(^RSLoginFailed)(RSLoginType type);
