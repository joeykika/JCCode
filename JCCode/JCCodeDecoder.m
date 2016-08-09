//
//  JCCodeDecoder.m
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import "JCCodeDecoder.h"

@implementation JCCodeDecoder

+ (NSString *)stringInQRCodeImage:(UIImage *)image {
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                               context:nil
                                               options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    NSArray * features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature * feature = [features objectAtIndex:0];
        return feature.messageString;
    }
    
    return nil;
}

@end
