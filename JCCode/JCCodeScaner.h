//
//  JCCodeScaner.h
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol JCCodeScanerDelegate <NSObject>
@optional
- (void)codeScannerDidGetString:(NSString *)string forCode:(NSString *)codeType;

@end

@interface JCCodeScaner : NSObject
@property (nonatomic, assign) id<JCCodeScanerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, assign, readonly) BOOL bRunning;
@property (nonatomic, assign, readonly) BOOL bAuthorized;

- (void)setCodeTypes:(NSArray *)types;
- (void)startRunning;
- (void)stopRunning;
- (void)setRectOfInterest:(CGRect)rect;

@end
