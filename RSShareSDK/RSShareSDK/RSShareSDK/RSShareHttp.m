//
//  RSShareHttp.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "RSShareHttp.h"

@interface RSShareHttp()<NSURLConnectionDataDelegate>
@property (nonatomic,copy)RSHttpSuccess scb;
@property (nonatomic,copy)RSHttpFailed fcb;
@property (nonatomic,strong)NSMutableData *data;
@end

@implementation RSShareHttp

-(void)getDataFromPath:(NSString *)path
               success:(RSHttpSuccess)success
                failed:(RSHttpFailed)failed{
    
    self.scb = success;
    self.fcb = failed;
    self.data = [[NSMutableData alloc] initWithCapacity:0];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if(self.fcb){
        self.fcb(error);
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    id json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
    if(json && [json isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary *)json;
        if(self.scb){
            self.scb(dict);
        }
    }else{
        if(self.fcb){
            self.fcb(nil);
        }
    }
}
@end
