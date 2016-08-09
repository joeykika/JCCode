//
//  JCCodeDecoder.h
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCCodeDecoder : NSObject

+ (NSString *)stringInQRCodeImage:(UIImage *)image;

@end
