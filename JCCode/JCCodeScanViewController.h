//
//  JCCodeScanViewController.h
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JCCodeScanViewController;

@protocol JCCodeScanViewControllerDelegate <NSObject>
@optional
- (void)JCCodeScanViewController:(JCCodeScanViewController *)viewController didGetString:(NSString *)string forCode:(NSString *)codeType fromPhoto:(BOOL)bFromPhoto;

@end

@interface JCCodeScanViewController : UIViewController
@property (nonatomic, assign) id<JCCodeScanViewControllerDelegate> delegate;

@end
