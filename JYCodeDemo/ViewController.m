//
//  ViewController.m
//  JCCodeDemo
//
//  Created by joeykika on 16/8/5.
//  Copyright © 2016年 joeykika. All rights reserved.
//

#import "ViewController.h"
#import "JCCodeScanViewController.h"

@interface ViewController ()<JCCodeScanViewControllerDelegate>
@property (nonatomic, strong) UIButton * scanButton;

- (void)showScanView:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.scanButton];
    
    [self.scanButton setFrame:CGRectMake(100, 100, 100, 100)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showScanView:(id)sender {
    JCCodeScanViewController * viewController = [[JCCodeScanViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - JCCodeScanViewControllerDelegate
- (void)JCCodeScanViewController:(JCCodeScanViewController *)viewController didGetString:(NSString *)string forCode:(NSString *)codeType fromPhoto:(BOOL)bFromPhoto {
    if(YES == [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]]) {
        return;
    }
    
    UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                                  message:string
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }];
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:^{
    }];
}


- (UIButton *)scanButton {
    if(!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.backgroundColor = [UIColor blueColor];
        [_scanButton setTitle:@"扫描" forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(showScanView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _scanButton;
}

@end
