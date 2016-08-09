//
//  JCCodeScanViewController.m
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import "JCCodeScanViewController.h"
#import "JCCodeScaner.h"
#import "JCCodeScanView.h"
#import "JCCodeDecoder.h"

@interface JCCodeScanViewController ()<JCCodeScanerDelegate, JCCodeScanViewDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) JCCodeScaner * scaner;
@property (nonatomic, strong) JCCodeScanView * scanView;

@property (nonatomic, assign) BOOL bLastNavigationBarHidden;

- (void)showNoPermissionAlert;

@end

@implementation JCCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bLastNavigationBarHidden = YES;
    
    [self.view addSubview:self.scanView];
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scanView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scanView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scanView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scanView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    
    if([self.scaner bAuthorized]) {
        AVCaptureVideoPreviewLayer * previewLayer = [self.scaner previewLayer];
        previewLayer.frame = self.view.frame;
        [self.view.layer insertSublayer:previewLayer atIndex:0];
        [self.scaner setRectOfInterest:self.scanView.rectOfInterest];
        [self.scaner setCodeTypes:@[AVMetadataObjectTypeQRCode]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.navigationController.navigationBarHidden) {
        self.bLastNavigationBarHidden = NO;
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(!self.bLastNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![self.scaner bAuthorized]) {
        [self showNoPermissionAlert];
        [self.scanView setAuthorized:NO];
    } else if(![self.scaner bRunning]) {
        [self.scaner startRunning];
        [self.scanView startRunning];
        [self.scanView setAuthorized:YES];
    }
}


#pragma mark - JCCodeScanerDelegate
- (void)codeScannerDidGetString:(NSString *)string forCode:(NSString *)codeType {
    [self.scanView stopRunning];
    
    if([self.delegate respondsToSelector:@selector(JCCodeScanViewController:didGetString:forCode:fromPhoto:)]) {
        [self.delegate JCCodeScanViewController:self didGetString:string forCode:codeType fromPhoto:NO];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JCCodeScanViewDelegate
- (void)onRetunButtonClicked {
    [self.scaner stopRunning];
    [self.scanView stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onPhotoButtonClicked {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __block NSString * string = [JCCodeDecoder stringInQRCodeImage:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(JCCodeScanViewController:didGetString:forCode:fromPhoto:)]) {
            [self.delegate JCCodeScanViewController:self didGetString:string forCode:AVMetadataObjectTypeQRCode fromPhoto:YES];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - private
- (void)showNoPermissionAlert {
    NSString * message = @"请在iPhone的\"设置-隐私-相机\"中允许访问相机。";
    UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"无法使用相机"
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    [alertViewController addAction:cancelAction];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                          if([[UIApplication sharedApplication] canOpenURL:url]) {
                                                              NSURL * url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                              [[UIApplication sharedApplication] openURL:url];
                                                          }
                                                      }];
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:^{
    }];
}

#pragma mark - getter & setter
- (JCCodeScanView *)scanView {
    if(!_scanView) {
        _scanView = [[JCCodeScanView alloc] init];
        _scanView.delegate = self;
    }
    
    return _scanView;
}

- (JCCodeScaner *)scaner {
    if(!_scaner) {
        _scaner = [[JCCodeScaner alloc] init];
        _scaner.delegate = self;
    }
    
    return _scaner;
}

@end
