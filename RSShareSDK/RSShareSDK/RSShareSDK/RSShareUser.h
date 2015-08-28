//
//  RSShareUser.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSShareUser : NSObject
@property (nonatomic , strong) NSString *openId;
@property (nonatomic , strong) NSString *accessToken;
@property (nonatomic , strong) NSString *refreshToken;
@property (nonatomic , strong) NSDate   *expirationDate;
@property (nonatomic , strong) NSString *nickname;
@property (nonatomic , strong) NSString *avatar;
@property (nonatomic , strong) NSString *gender;
@property (nonatomic , strong) NSString *country;
@property (nonatomic , strong) NSString *province;
@property (nonatomic , strong) NSString *city;

@end
