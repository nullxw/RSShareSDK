//
//  RSShareSDKError.h
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {
    RSSuccess           = 0,    /**< 成功    */
    RSErrCodeCommon     = -1,   /**< 普通错误类型    */
    RSErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    RSErrCodeSentFail   = -3,   /**< 发送失败    */
    RSErrCodeAuthDeny   = -4,   /**< 授权失败    */
    RSErrCodeUnsupport  = -5,   /**< 类型不支持    */
} RSErrorCode;

static NSString *const RSSuccessDescription = @"成功";
static NSString *const RSErrCommonDescription = @"普通错误类型";
static NSString *const RSErrUserCancelDescription = @"用户点击取消并返回";
static NSString *const RSErrSentFailDescription = @"发送失败 ";
static NSString *const RSErrAuthDenyDescription = @"授权失败";
static NSString *const RSErrUnsupportDescription = @"类型不支持";
static NSString *const RSErrUnknownDescription = @"未知错误";

@interface RSShareSDKError : NSObject
@property (nonatomic , assign) RSErrorCode errorCode;
-(instancetype)initWithErrorCode:(RSErrorCode)errorCode;
@end
