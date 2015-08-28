//
//  ViewController.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/17.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "ViewController.h"
#include "RSShareSDK.h"
#import "RSSharePopupController.h"

@interface ViewController ()
@property (nonatomic,retain) UIView *maskview;
@property (nonatomic,retain) UIView *greenview;
@property (nonatomic,retain) NSArray *constraints;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _maskview = [[UIView alloc] init];
//    _maskview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
//    _maskview.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:_maskview];
    
    
    _greenview = [[UIView alloc] init];
    _greenview.backgroundColor = [UIColor greenColor];
    _greenview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_greenview];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_greenview);
    self.constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_greenview(0)]-0-|" options:0 metrics:nil views:dict];
    [self.view addConstraints:self.constraints];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_greenview]-0-|" options:0 metrics:nil views:dict]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [[RSShareSDK shareInstance] loginWithSNS:RSLoginTypeQQ success:^(RSLoginType type, RSShareUser *user) {
//        NSLog(@"%@",user);
//    } failed:^(RSLoginType type) {
//        
//    }];
    [self shareToQQ];

}

-(void)shareToQQ{
    
    [[RSShareSDK shareInstance] showShareActionSheet:@"分享标题" description:@"这个是分享的详情,bla bla bla ..." text:@"这个是分享的文字,bla bla bla ..." image:[UIImage imageNamed:@"hehe.jpg"] openURL:@"http://www.baidu.com" shareContentType:RSShareContentTypeMedia success:^(RSShareSNSType type) {
        NSLog(@"分享成功:%ld",type);
    } failed:^(RSShareSNSType type, int errorCode) {
        NSLog(@"分享失败:%ld 错误码:%d",type,errorCode);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
