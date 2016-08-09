//
//  JCCodeScanView.h
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCCodeScanViewDelegate <NSObject>
@optional
- (void)onRetunButtonClicked;
- (void)onPhotoButtonClicked;
- (void)onChangeScanCodeType:(NSString *)type;

@end

@interface JCCodeScanView : UIView
@property (nonatomic, assign) id<JCCodeScanViewDelegate> delegate;
@property (nonatomic, assign) CGSize scanSize;
@property (nonatomic, assign, readonly) CGRect scanRect;
@property (nonatomic, assign, readonly) CGRect rectOfInterest;

@property (nonatomic, assign) CGFloat  scanRegionCornerLength;
@property (nonatomic, assign) CGFloat  scanRegionCornerWidth;

@property (nonatomic, strong) UIColor * scanBackgroundColor;
@property (nonatomic, strong) UIColor * scanRegionBordeColor;
@property (nonatomic, strong) UIColor * scanRegionCornerColor;

- (void)startRunning;
- (void)stopRunning;
- (void)setAuthorized:(BOOL)bAuthorized;

@end
