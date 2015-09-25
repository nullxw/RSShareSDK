//
//  RSShareHttp.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "RSShareHttp.h"

@interface RSShareHttp()
@end

@implementation RSShareHttp

-(void)getDataFromPath:(NSString *)path
               success:(RSHttpSuccess)success
                failed:(RSHttpFailed)failed{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if(json && [json isKindOfClass:[NSDictionary class]]){
                NSDictionary *dict = (NSDictionary *)json;
                success(dict);
            }else{
                failed(nil);
            }

        }else{
            failed(nil);
        }
       
    }];
    [task resume];
}
@end
