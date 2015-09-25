//
//  RSShareSDKDefine.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/18.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

@class RSShareSDKUser;
@class RSShareSDKError;

extern NSString *const RSShareToSina;
extern NSString *const RSShareToQzone;
extern NSString *const RSShareToWechatSession;
extern NSString *const RSShareToWechatTimeline;
extern NSString *const RSShareToQQ;




#define kSinaAppKey         @"1507721037"
#define kSinaSecret         @"91ddae1d517079a0e6202585d45165ec"
#define kSinaRedirectURI    @"http://www.rootsports.cn/bld/weibocallback"

#define kWeChatAppKey        @"wx4a422bb5f498704b"
#define kWeChatAppSecret    @"8f893a0874d904a47a2b78549a5f9a7b"

#define kQQAppKey           @"1104315138"
#define kQQAppSecret        @"AcSbnyVWGmCC3Pqg"

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
typedef void(^RSShareFailed) (RSShareSNSType type,RSShareSDKError *error);

typedef void(^RSLoginSuccess)(RSLoginType type,RSShareSDKUser *user);
typedef void(^RSLoginFailed)(RSLoginType type,RSShareSDKError *error);
