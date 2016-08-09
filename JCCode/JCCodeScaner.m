//
//  JCCodeScaner.m
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import "JCCodeScaner.h"
#import <UIKit/UIKit.h>

@interface JCCodeScaner()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureDevice            * device;
@property (strong, nonatomic) AVCaptureDeviceInput       * input;
@property (strong, nonatomic) AVCaptureMetadataOutput    * output;
@property (strong, nonatomic) AVCaptureSession           * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;

- (AVCaptureVideoOrientation)videoOrientationFromCurrentDeviceOrientation;
- (BOOL)checkAVAuthorizationStatus;
- (void)startOnBackground;
@end

@implementation JCCodeScaner

- (void)setCodeTypes:(NSArray *)types {
    if([self.session isRunning]) {
        [self.session beginConfiguration];
    }
    
    self.output.metadataObjectTypes = types;
    
    if([self.session isRunning]) {
        [self.session commitConfiguration];
    }
}

- (void)startRunning {
    [self performSelectorInBackground:@selector(startOnBackground) withObject:nil];
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (void)setRectOfInterest:(CGRect)rect {
    [self.output setRectOfInterest:rect];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if(metadataObjects.count) {
        [self.session stopRunning];
        if([self.delegate respondsToSelector:@selector(codeScannerDidGetString:forCode:)]) {
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            NSString * stringValue = metadataObject.stringValue;
            NSString * type = nil;
            NSLog(@"%@:%@", stringValue, metadataObject.type);
            
            if([metadataObject.type isEqualToString:@"org.iso.QRCode"]) {
                type = AVMetadataObjectTypeQRCode;
            }
            
            [self.delegate codeScannerDidGetString:stringValue forCode:type];
        }
    }
}

#pragma mark - private
- (AVCaptureVideoOrientation)videoOrientationFromCurrentDeviceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        return AVCaptureVideoOrientationPortrait;
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeLeft;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        return AVCaptureVideoOrientationLandscapeRight;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

- (BOOL)checkAVAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return (status != AVAuthorizationStatusRestricted
            && status != AVAuthorizationStatusDenied);
}

- (void)startOnBackground {
    if(![self.session isRunning]) {
        [self.session startRunning];
    }
}

#pragma mark - getter & setter
- (BOOL)bRunning {
    return [self.session isRunning];
}

- (BOOL)bAuthorized {
    return [self checkAVAuthorizationStatus];
}

- (AVCaptureDevice *)device {
    if(!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if(!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    
    return _input;
}

- (AVCaptureMetadataOutput *)output {
    if(!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self
                                      queue:dispatch_get_main_queue()];
    }
    
    return _output;
}

- (AVCaptureSession *)session {
    if(!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if(!_previewLayer) {
        _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResize;
        _previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    }
    
    return _previewLayer;
}
@end
