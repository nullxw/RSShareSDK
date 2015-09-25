//
//  RSShareSDKUser.h
//  Demo
//
//  Created by 贾磊 on 15/9/23.
//  Copyright © 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSShareSDKUser : NSObject

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
