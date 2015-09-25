//
//  RSShareHttp.h
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RSHttpSuccess)(NSDictionary *data);
typedef void(^RSHttpFailed)(NSError *error);
@interface RSShareHttp : NSObject


-(void)getDataFromPath:(NSString *)path
               success:(RSHttpSuccess)success
                failed:(RSHttpFailed)failed;
@end
