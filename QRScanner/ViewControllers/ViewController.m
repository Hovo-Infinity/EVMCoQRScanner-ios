//
//  ViewController.m
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/11/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import "ViewController.h"
@import MasterpassQRScanSDK;
@import AVFoundation;

@interface ViewController () <QRCodeReaderDelegate>
    
@property (nonatomic, strong) QRCodeReaderViewController *qrVC;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)presentMasterpassQRScanner:(id)sender {
//    if (![QRCodeReader isAvailable] || ![QRCodeReader supportsQRCode]) {
//        return;
//    }
    QRCodeReaderViewControllerBuilder *builder = [[QRCodeReaderViewControllerBuilder alloc] init];
    QRCodeReaderView *readerView = (QRCodeReaderView *) builder.readerView;
    
    // Setup overlay view
    QRCodeReaderViewOverlay *overlayView = (QRCodeReaderViewOverlay *)[readerView getOverlay];
    overlayView.cornerColor = UIColor.purpleColor;
    overlayView.cornerWidth = 6;
    overlayView.cornerLength = 75;
    overlayView.indicatorSize = CGSizeMake(250, 250);
    
    // Setup scanning region
    builder.scanRegionSize = CGSizeMake(250, 250);
    
    // Hide torch button provided by default view
    builder.showTorchButton = false;
    
    // Hide cancel button provided by default view
    builder.showCancelButton = false;
    
    // Don't start scanning when this view is loaded i.e initialized
    builder.startScanningAtLoad = false;
    
    builder.showSwitchCameraButton = false;
    
    self.qrVC = [[QRCodeReaderViewController alloc] initWithBuilder:builder];
    self.qrVC.delegate = self;
    
    // Add the reader as child view controller
    [self addChildViewController:self.qrVC];
    
    // Add reader view to the bottom
    [self.view insertSubview:self.qrVC.view atIndex: 0];
    
    NSDictionary *dictionary = @{@"qrVC": self.qrVC.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[qrVC]|" options:0 metrics:nil views:dictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[qrVC]|" options:0 metrics:nil views:dictionary]];
    
    [self.qrVC didMoveToParentViewController:self];
    [self.qrVC startScanning];
}

#pragma mark - QRCodeReaderViewControllerDelegate methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    NSLog(@"%@", result);
    [reader stopScanning];
}
    
- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [reader stopScanning];
}
@end
