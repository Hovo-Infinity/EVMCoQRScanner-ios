//
//  ScannerViewController.m
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/11/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import "ScannerViewController.h"
#import "EVMCoHelper.h"
#import "TableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScannerViewController () < AVCaptureMetadataOutputObjectsDelegate >

@property (nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) UIView *qrCodeFrameView;
@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Scan";
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    AVCaptureDevice *device = session.devices.firstObject;
    NSError *error = nil;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error == nil) {
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:input];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        if ([self.captureSession canAddOutput:output]) {
            [self.captureSession addOutput:output];
        }
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    } else {
        NSAssert(false, @"%@", error.localizedDescription);
    }
    AVCaptureVideoPreviewLayer *videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoLayer.frame = self.view.layer.bounds;
    self.videoPreviewLayer = videoLayer;
    [self.view.layer  addSublayer:self.videoPreviewLayer];
    [self.view bringSubviewToFront:self.messageLabel];
    UIView *qrCodeFrameView = [UIView new];
    qrCodeFrameView.layer.borderColor = [UIColor greenColor].CGColor;
    qrCodeFrameView.layer.borderWidth = 2.f;
    self.qrCodeFrameView = qrCodeFrameView;
    [self.view addSubview:self.qrCodeFrameView];
    [self.view bringSubviewToFront:self.qrCodeFrameView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.qrCodeFrameView.frame = CGRectZero;
    self.messageLabel.text = @"No QR detected";
    [self.captureSession startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0) {
        self.qrCodeFrameView.frame = CGRectZero;
        self.messageLabel.text = @"No QR detected";
    } else {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        if (metadataObject.type == AVMetadataObjectTypeQRCode) {
            AVMetadataObject *transformedObject = [self.videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            self.qrCodeFrameView.frame = transformedObject.bounds;
            if (metadataObject.stringValue != nil) {
                self.messageLabel.text = metadataObject.stringValue;
                [[EVMCoHelper shared] setQRCode:metadataObject.stringValue];
                [self.captureSession stopRunning];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TableViewController"];
                    [self showViewController:vc sender:nil];
                });
            }
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
