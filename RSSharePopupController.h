//
//  RSSharePopupController.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSShareSDKDefine.h"

typedef void(^PopUpControllerCallback)(RSShareSNSType type);
@protocol RSSharePopupControllerDelegate <NSObject>

-(void)shareToSNS:(RSShareSNSType)SNSType;

@end
@interface RSSharePopupController : UIView

@property (nonatomic,assign) id<RSSharePopupControllerDelegate> delegate;
@property (nonatomic,copy) PopUpControllerCallback callback;

- (void)showPopupViewAnimated:(BOOL)animated;

- (void)showPopupViewAnimated:(BOOL)animated
                     callback:(PopUpControllerCallback)callback;
@end
