//
//  RSSharePopupController.m
//  RSShareSDK
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 REEE INC. All rights reserved.
//

#import "RSSharePopupController.h"
#import "RSShareSDK.h"

@interface RSSharePopupController()
@property (nonatomic,strong) NSArray*types;
@property (nonatomic,retain) UIView *snsView;
@property (nonatomic,retain) UIView *QQView;
@property (nonatomic,retain) UIView *QQZoneView;
@property (nonatomic,retain) UIView *WeChatSessionView;
@property (nonatomic,retain) UIView *WeChatTimeLineView;
@property (nonatomic,retain) UIView *SinaWeiboView;
@property (nonatomic,retain) UIView *spacerView;
@property (nonatomic,retain) UIView *spacerView2;
@property (nonatomic,retain) NSLayoutConstraint *bottomConstraint;
@property (nonatomic,retain) UIView *maskview;
@end
@implementation RSSharePopupController

-(instancetype)initWithShareContent:(NSArray *)content{
    return nil;
}
- (void)dealloc
{
    RSShareLog(@"PopupView dealloc");
}
- (void)showPopupViewAnimated:(BOOL)animated{
    self.types = @[@0,@1,@2,@3,@4];
    [self setupSelfView];
    [self setupMaskview];
    [self setup_snsView];
    [self needsUpdateConstraints];
    [self layoutIfNeeded];
    _bottomConstraint.constant = 0;
    [UIView animateWithDuration:animated ? 0.3f : 0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self updateConstraintsIfNeeded];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {

                     }];
    
}
- (void)showPopupViewAnimated:(BOOL)animated
                     callback:(PopUpControllerCallback)callback{
    self.callback = callback;
    [self showPopupViewAnimated:animated];
}
- (void)dismissPopupViewAnimated:(BOOL)animated{
    [self needsUpdateConstraints];
    [self layoutIfNeeded];
    if([RSShareSDK isQQInstalled] &&[RSShareSDK isWeChatInstalled]){
        _bottomConstraint.constant = 160;
    }else{
        _bottomConstraint.constant = 80;
    }
    [UIView animateWithDuration:animated ? 0.3f : 0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self updateConstraintsIfNeeded];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissPopupViewAnimated:YES];
}
- (void)setupSelfView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [window addSubview:self];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|" options:0 metrics:nil views:views]];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|" options:0 metrics:nil views:views]];
}
- (void)setupMaskview{
    _maskview = [[UIView alloc] init];
    _maskview.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _maskview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_maskview];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_maskview);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_maskview]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_maskview]-0-|" options:0 metrics:nil views:views]];
}
- (void)setup_snsView{
    
    if([RSShareSDK isQQInstalled] && [RSShareSDK isWeChatInstalled] && [RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:160];
        [self addConstraint:_bottomConstraint];
        
        [_snsView addSubview:self.QQView];
        [_snsView addSubview:self.QQZoneView];
        [_snsView addSubview:self.WeChatSessionView];
        [_snsView addSubview:self.WeChatTimeLineView];
        [_snsView addSubview:self.SinaWeiboView];
        views = NSDictionaryOfVariableBindings(_snsView,_QQView,_QQZoneView,_WeChatSessionView,_WeChatTimeLineView,_SinaWeiboView);
        
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_QQView]-0-[_QQZoneView(_QQView)]-0-[_WeChatSessionView(_QQZoneView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_WeChatTimeLineView(_QQView)]-0-[_SinaWeiboView(_WeChatTimeLineView)]" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQView]-0-[_WeChatTimeLineView(_QQView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQZoneView]-0-[_SinaWeiboView(_QQZoneView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatSessionView(_QQZoneView)]" options:0 metrics:nil views:views]];
    }
    else if ([RSShareSDK isQQInstalled] &&[RSShareSDK isWeChatInstalled] && ![RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:160]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:160];
        [self addConstraint:_bottomConstraint];
        
        [_snsView addSubview:self.QQView];
        [_snsView addSubview:self.QQZoneView];
        [_snsView addSubview:self.WeChatSessionView];
        [_snsView addSubview:self.WeChatTimeLineView];
        views = NSDictionaryOfVariableBindings(_snsView,_QQView,_QQZoneView,_WeChatSessionView,_WeChatTimeLineView);
        
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_QQView]-0-[_QQZoneView(_QQView)]-0-[_WeChatSessionView(_QQZoneView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_WeChatTimeLineView(_QQView)]" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQView]-0-[_WeChatTimeLineView(_QQView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQZoneView(_QQView)]" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatSessionView(_QQZoneView)]" options:0 metrics:nil views:views]];

    }
    else if ([RSShareSDK isQQInstalled] &&![RSShareSDK isWeChatInstalled] && [RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:80];
        [self addConstraint:_bottomConstraint];
        
        
        [_snsView addSubview:self.QQView];
        [_snsView addSubview:self.QQZoneView];
        [_snsView addSubview:self.SinaWeiboView];
        
        views = NSDictionaryOfVariableBindings(_snsView,_QQView,_QQZoneView,_SinaWeiboView);
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_QQView]-0-[_QQZoneView(_QQView)]-0-[_SinaWeiboView(_QQZoneView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQZoneView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_SinaWeiboView]-0-|" options:0 metrics:nil views:views]];
        
    }
    else if (![RSShareSDK isQQInstalled] &&[RSShareSDK isWeChatInstalled] && [RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:80];
        [self addConstraint:_bottomConstraint];
        
        
        [_snsView addSubview:self.WeChatSessionView];
        [_snsView addSubview:self.WeChatTimeLineView];
        [_snsView addSubview:self.SinaWeiboView];
        
        views = NSDictionaryOfVariableBindings(_snsView,_WeChatSessionView,_WeChatTimeLineView,_SinaWeiboView);
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_WeChatSessionView]-0-[_WeChatTimeLineView(_WeChatSessionView)]-0-[_SinaWeiboView(_WeChatTimeLineView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatSessionView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatTimeLineView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_SinaWeiboView]-0-|" options:0 metrics:nil views:views]];
    }
    else if ([RSShareSDK isQQInstalled] && ![RSShareSDK isWeChatInstalled] && ![RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:80];
        [self addConstraint:_bottomConstraint];
        
        [_snsView addSubview:self.QQView];
        [_snsView addSubview:self.QQZoneView];
        [_snsView addSubview:self.spacerView];
        
        views = NSDictionaryOfVariableBindings(_QQView,_QQZoneView,_spacerView);
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_QQView]-0-[_QQZoneView(_QQView)]-0-[_spacerView(_QQZoneView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_QQZoneView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_spacerView]-0-|" options:0 metrics:nil views:views]];
        
    }
    else if (![RSShareSDK isQQInstalled] && [RSShareSDK isWeChatInstalled] && ![RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:80];
        [self addConstraint:_bottomConstraint];
        
        [_snsView addSubview:self.WeChatSessionView];
        [_snsView addSubview:self.WeChatTimeLineView];
        [_snsView addSubview:self.spacerView];
        
        views = NSDictionaryOfVariableBindings(_WeChatSessionView,_WeChatTimeLineView,_spacerView);
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_WeChatSessionView]-0-[_WeChatTimeLineView(_WeChatSessionView)]-0-[_spacerView(_WeChatTimeLineView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatSessionView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_WeChatTimeLineView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_spacerView]-0-|" options:0 metrics:nil views:views]];
    }
    else if (![RSShareSDK isQQInstalled] && ![RSShareSDK isWeChatInstalled] && [RSShareSDK isSinaWeiboInstalled]){
        [self addSubview:self.snsView];
        NSDictionary *views = NSDictionaryOfVariableBindings(_snsView);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80]];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_snsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:80];
        [self addConstraint:_bottomConstraint];
        
        [_snsView addSubview:self.SinaWeiboView];
        [_snsView addSubview:self.spacerView];
        [_snsView addSubview:self.spacerView2];
        
        views = NSDictionaryOfVariableBindings(_SinaWeiboView,_spacerView,_spacerView2);
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_SinaWeiboView]-0-[_spacerView(_SinaWeiboView)]-0-[_spacerView2(_spacerView)]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_SinaWeiboView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_spacerView]-0-|" options:0 metrics:nil views:views]];
        [_snsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_spacerView2]-0-|" options:0 metrics:nil views:views]];
    }else{
        RSShareLog(@"没有安装QQ,微信,微博客户端");
    }
}
- (void)shareClick:(UIButton *)btn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareToSNS:)]){
        [self.delegate shareToSNS:btn.tag -1000];
    }
    if(self.callback){
        self.callback(btn.tag - 1000);
    }
    [self dismissPopupViewAnimated:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)snsView{
    if(!_snsView){
        _snsView = [[UIView alloc] init];
        _snsView.backgroundColor = [UIColor whiteColor];
        _snsView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _snsView;
}
-(UIView *)QQView{
    if(!_QQView){
        _QQView = [self product_snsViewWithType:RSShareSNSTypeQQ];
    }
    return _QQView;
}
-(UIView *)QQZoneView{
    if(!_QQZoneView){
        _QQZoneView = [self product_snsViewWithType:RSShareSNSTypeQQZone];
    }
    return _QQZoneView;
}
-(UIView *)WeChatSessionView{
    if(!_WeChatSessionView){
        _WeChatSessionView = [self product_snsViewWithType:RSShareSNSTypeWeChatSession];
    }
    return _WeChatSessionView;
}
-(UIView *)WeChatTimeLineView{
    if(!_WeChatTimeLineView){
        _WeChatTimeLineView = [self product_snsViewWithType:RSShareSNSTypeWeChatTimeLine];
    }
    return _WeChatTimeLineView;
}
-(UIView *)SinaWeiboView{
    if(!_SinaWeiboView){
        _SinaWeiboView = [self product_snsViewWithType:RSShareSNSTypeSinaWeibo];
    }
    return _SinaWeiboView;
}
-(UIView *)spacerView{
    if(!_spacerView){
        _spacerView = [[UIView alloc] init];
        _spacerView.opaque = YES;
        _spacerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _spacerView;
}
-(UIView *)spacerView2{
    if(!_spacerView2){
        _spacerView2 = [[UIView alloc] init];
        _spacerView2.opaque = YES;
        _spacerView2.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _spacerView2;
}
-(UIView *)product_snsViewWithType:(RSShareSNSType)type{
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.tag = 1000+type;
    [view addSubview:btn];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:0.3 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    
    switch (type) {
        case RSShareSNSTypeQQ:
        {
            [btn setImage:[UIImage imageNamed:@"UMS_qq_icon"] forState:UIControlStateNormal];
            label.text = @"QQ";
        }
            break;
        case RSShareSNSTypeQQZone:
        {
            [btn setImage:[UIImage imageNamed:@"UMS_qzone_icon"] forState:UIControlStateNormal];
            label.text = @"QQ空间";
        }
            break;
        case RSShareSNSTypeWeChatSession:
        {
            [btn setImage:[UIImage imageNamed:@"UMS_wechat_icon"] forState:UIControlStateNormal];
            label.text = @"微信好友";
        }
            break;
        case RSShareSNSTypeWeChatTimeLine:
        {
            [btn setImage:[UIImage imageNamed:@"UMS_wechat_timeline_icon"] forState:UIControlStateNormal];
            label.text = @"微信朋友圈";
        }
            break;
        case RSShareSNSTypeSinaWeibo:
        {
            [btn setImage:[UIImage imageNamed:@"UMS_sina_icon"] forState:UIControlStateNormal];
            label.text = @"新浪微博";
        }
            break;
        default:
            break;
    }
    
    return view;
}


@end
