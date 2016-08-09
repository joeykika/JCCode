//
//  JCCodeScanView.m
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import "JCCodeScanView.h"

@interface JCCodeScanView()
@property (nonatomic, strong) UIImageView * scanningLine;
@property (nonatomic, strong) NSTimer * lineMoveTimer;
@property (nonatomic, assign) CGFloat lineMoveInterval;

@property (nonatomic, strong) UIButton * returnButton;
@property (nonatomic, strong) UIButton * photoButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * tipLabel;

@property (nonatomic, strong) NSMutableArray * tipLabelConstraints;

- (void)resetScanningLinePosition:(id)sender;

@end

@implementation JCCodeScanView

- (instancetype)init {
    if(self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineMoveInterval = 0.02;
        self.scanSize = CGSizeMake(200, 200);
        self.scanRegionCornerLength = 30;
        self.scanRegionCornerWidth = 4;
        self.scanBackgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:0.5];
        self.scanRegionBordeColor = [UIColor whiteColor];
        self.scanRegionCornerColor = [UIColor colorWithRed:0.214 green:0.545 blue:1.000 alpha:1.000];
        
        [self addSubview:self.tipLabel];
        [self addSubview:self.returnButton];
        [self addSubview:self.photoButton];
        [self addSubview:self.titleLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:20]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleLabe(==44)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"titleLabe" : self.titleLabel}]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.returnButton
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.returnButton
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.titleLabel
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.returnButton
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.titleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.photoButton
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.photoButton
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.titleLabel
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.photoButton
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.titleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0]];
    }
    
    return self;
}

- (void)startRunning {
    if(!self.lineMoveTimer.valid) {
        self.lineMoveTimer = nil;
        [self.lineMoveTimer fire];
    }
}

- (void)stopRunning {
    if(self.lineMoveTimer.valid) {
        [self.lineMoveTimer invalidate];
        self.lineMoveTimer = nil;
    }
    
    [self.scanningLine removeFromSuperview];
}

- (void)setAuthorized:(BOOL)bAuthorized {
    if(bAuthorized) {
        self.tipLabel.text = @"将取景框对准二维码\n即可自动扫描";
    } else {
        self.tipLabel.text = @"你的设备不支持拍照\n不能使用扫描功能";
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self removeConstraints:self.tipLabelConstraints];
    [self.tipLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tipLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0]];
    [self.tipLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tipLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0.0]];
    [self.tipLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tipLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:self.scanRect.origin.y + self.scanRect.size.height + 10]];
    
    [self addConstraints:self.tipLabelConstraints];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect scanRect = self.scanRect;

    //绘制背景色
    CGContextSetFillColorWithColor(ctx, self.scanBackgroundColor.CGColor);
    CGContextFillRect(ctx, rect);

    //清除扫描范围颜色
    CGContextClearRect(ctx, scanRect);
    
    //绘制边框
    CGContextStrokeRect(ctx, scanRect);
    CGContextSetStrokeColorWithColor(ctx, self.scanRegionBordeColor.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextAddRect(ctx, scanRect);
    CGContextStrokePath(ctx);
    
    //绘制四个角
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, self.scanRegionCornerColor.CGColor);
    CGPoint poins[2] = {};
    CGPoint referencePoint = CGPointZero;
    
    //左上角
    referencePoint = scanRect.origin;
    poins[0] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth / 2
                           , referencePoint.y - self.scanRegionCornerWidth);
    poins[1] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth / 2
                           , referencePoint.y - self.scanRegionCornerWidth + self.scanRegionCornerLength);
    CGContextAddLines(ctx, poins, 2);
    
    poins[0] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth
                           , referencePoint.y - self.scanRegionCornerWidth / 2);
    poins[1] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth  + self.scanRegionCornerLength
                           , referencePoint.y - self.scanRegionCornerWidth / 2);
    CGContextAddLines(ctx, poins, 2);
    
    //左下角
    referencePoint = CGPointMake(scanRect.origin.x, scanRect.origin.y + scanRect.size.height);
    poins[0] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth / 2
                           , referencePoint.y + self.scanRegionCornerWidth);
    poins[1] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth / 2
                           , referencePoint.y + self.scanRegionCornerWidth - self.scanRegionCornerLength);
    CGContextAddLines(ctx, poins, 2);
    
    poins[0] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth
                           , referencePoint.y + self.scanRegionCornerWidth / 2);
    poins[1] = CGPointMake(referencePoint.x - self.scanRegionCornerWidth  + self.scanRegionCornerLength
                           , referencePoint.y + self.scanRegionCornerWidth / 2);
    CGContextAddLines(ctx, poins, 2);
    
    //右边下角
    referencePoint = CGPointMake(scanRect.origin.x + scanRect.size.width, scanRect.origin.y + scanRect.size.height);
    poins[0] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth / 2
                           , referencePoint.y + self.scanRegionCornerWidth);
    poins[1] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth / 2
                           , referencePoint.y + self.scanRegionCornerWidth - self.scanRegionCornerLength);
    CGContextAddLines(ctx, poins, 2);
    
    poins[0] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth
                           , referencePoint.y + self.scanRegionCornerWidth / 2);
    poins[1] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth  - self.scanRegionCornerLength
                           , referencePoint.y + self.scanRegionCornerWidth / 2);
    CGContextAddLines(ctx, poins, 2);
    
    //右上角
    referencePoint = CGPointMake(scanRect.origin.x + scanRect.size.width, scanRect.origin.y);
    poins[0] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth / 2
                           , referencePoint.y - self.scanRegionCornerWidth);
    poins[1] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth / 2
                           , referencePoint.y - self.scanRegionCornerWidth + self.scanRegionCornerLength);
    CGContextAddLines(ctx, poins, 2);
    
    poins[0] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth
                           , referencePoint.y - self.scanRegionCornerWidth / 2);
    poins[1] = CGPointMake(referencePoint.x + self.scanRegionCornerWidth  - self.scanRegionCornerLength
                           , referencePoint.y - self.scanRegionCornerWidth / 2);
    CGContextAddLines(ctx, poins, 2);
    
    CGContextStrokePath(ctx);
}

#pragma mark - private
- (void)resetScanningLinePosition:(id)sender {
    if(!self.scanningLine.superview) {
        self.scanningLine.frame = CGRectMake(self.scanRect.origin.x + 4
                                             , self.scanRect.origin.y
                                             , self.scanRect.size.width - 8
                                             , 33);
        [self addSubview:self.scanningLine];
    } else {
        [UIView animateWithDuration:self.lineMoveInterval animations:^{
            CGRect frame = self.scanningLine.frame;
            frame.origin.y += 1;
            if(frame.origin.y + frame.size.height == self.scanRect.origin.y + self.scanRect.size.height - 4) {
                frame.origin.y = self.scanRect.origin.y + 4;
            }
            self.scanningLine.frame = frame;
            
        } completion:^(BOOL finished) {}];
    }
}

#pragma mark - getter & setter
- (void)setDelegate:(id<JCCodeScanViewDelegate>)delegate {
    if(_delegate == delegate) {
        return;
    }
    
    if(_delegate) {
        [self.returnButton removeTarget:_delegate action:@selector(onRetunButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.photoButton removeTarget:_delegate action:@selector(onPhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _delegate = delegate;
    
    if([_delegate respondsToSelector:@selector(onRetunButtonClicked)]) {
        [self.returnButton addTarget:_delegate action:@selector(onRetunButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([_delegate respondsToSelector:@selector(onPhotoButtonClicked)]) {
        [self.photoButton addTarget:_delegate action:@selector(onPhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGRect)scanRect {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat x = (frame.size.width - self.scanSize.width) / 2;
    CGFloat y = (frame.size.height - self.scanSize.height) / 2;
    return CGRectMake(x, y, self.scanSize.width, self.scanSize.height);
}

- (CGRect)rectOfInterest {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.scanRect.size.width) / 2
                                 , (screenHeight - self.scanRect.size.height) / 2
                                 , self.scanRect.size.width
                                 , self.scanRect.size.height);
    return CGRectMake(cropRect.origin.y / screenHeight,
                      cropRect.origin.x / screenWidth,
                      cropRect.size.height / screenHeight,
                      cropRect.size.width / screenWidth);
}

- (UIImageView *)scanningLine {
    if(!_scanningLine) {
        _scanningLine = [[UIImageView alloc] init];
        _scanningLine.image = [UIImage imageNamed:({
            NSString * bundlePath = [NSString stringWithFormat:@"%@/%@.bundle"
                                     , [NSBundle mainBundle].resourcePath
                                     , @"JCCode"];
            NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
            NSString * scaneLinePath = [NSString stringWithFormat:@"%@/%@", bundle.bundlePath, @"scanningLine"];
            scaneLinePath;
        })];
//        _scanningLine.backgroundColor = [UIColor whiteColor];
    }
    
    return _scanningLine;
}

- (NSTimer *)lineMoveTimer {
    if(!_lineMoveTimer) {
        _lineMoveTimer = [NSTimer scheduledTimerWithTimeInterval:self.lineMoveInterval
                                                          target:self
                                                        selector:@selector(resetScanningLinePosition:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
    return _lineMoveTimer;
}

- (UIButton *)returnButton {
    if(!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        _returnButton.backgroundColor = [UIColor blueColor];
        [_returnButton setTitle:@"取消" forState:UIControlStateNormal];
        [_returnButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        [_returnButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _returnButton;
}

- (UIButton *)photoButton {
    if(!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        _photoButton.backgroundColor = [UIColor blueColor];
        [_photoButton setTitle:@"相册" forState:UIControlStateNormal];
        [_photoButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        [_photoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _photoButton;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor darkGrayColor];
        _titleLabel.text = @"扫一扫";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor whiteColor];
        [_tipLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _tipLabel;
}

- (NSMutableArray *)tipLabelConstraints {
    if(!_tipLabelConstraints) {
        _tipLabelConstraints = [NSMutableArray array];
    }
    
    return _tipLabelConstraints;
}


@end
