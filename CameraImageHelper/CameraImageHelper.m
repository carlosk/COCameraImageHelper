//
//  CameraImageHelper.m
//  HelloWorld
//
//  Created by carlosk@163.com
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "CameraImageHelper.h"
#import <ImageIO/ImageIO.h>


@interface CameraImageHelper ()
@property (retain) AVCaptureSession *session;
@property (retain) AVCaptureStillImageOutput *captureOutput;
@property (retain) UIImage *image;
@property (assign) UIImageOrientation g_orientation;
@property (assign) AVCaptureVideoPreviewLayer *preview;
@property(nonatomic,strong)AVCaptureDevice *device;
@end

#define kLogOn NO
#define kFocusKey @"adjustingFocus"
@implementation CameraImageHelper

//static CameraImageHelper *sharedInstance = nil;

- (void) initialize
{
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    

    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
#if 1
    int flags = NSKeyValueObservingOptionNew; //监听自动对焦
    [device addObserver:self forKeyPath:kFocusKey options:flags context:nil];
    self.device = device;
#endif

	NSError *error;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
        if (kLogOn) {
            NSLog(@"Error: %@", error);
        }
		return;
	}
    
    [self.session addInput:captureInput];
    
    
    //3.创建、配置输出       
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
	[self.session addOutput:self.captureOutput];
}

- (id) init
{
	if (self = [super init])
        [self initialize];
	return self;
}


//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:kFocusKey] ){
        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (kLogOn) {
            NSLog(@"Is adjusting focus? %@", adjustingFocus ? @"YES" : @"NO" );
            NSLog(@"Change dictionary: %@", change);
        }
        //
        if (self.focusBlock) {
            self.focusBlock(!adjustingFocus);
        }
    }
}


- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.preview) {
        return;
    }
     [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.g_orientation = UIImageOrientationUp;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.g_orientation = UIImageOrientationDown;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortrait){
        self.g_orientation = UIImageOrientationRight;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        self.g_orientation = UIImageOrientationLeft;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}

- (void) dealloc
{
    [self stopRunning];
    
    [self.device removeObserver:self forKeyPath:kFocusKey];

	self.session = nil;
	self.image = nil;
}

#pragma mark Class Interface


- (void) startRunning
{
	[[self session] startRunning];	
}

- (void) stopRunning
{
	[[self session] stopRunning];
}

- (void)onTorch:(AVCaptureTorchMode )mode{
    if (!self.device.hasTorch) {
        return;
    }
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: mode];
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
}
-(void)takeImage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         self.image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:self.g_orientation];
         
         if (self.imageTakeFinishedBlock) {
             self.imageTakeFinishedBlock(self.image);
         }
     }];
}

-(void) embedPreviewInView: (UIView *) aView {
    if (!self.session) return;
    //设置取景
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: self.preview];
}

//闪光灯是否开启
- (BOOL)isOnTorch{
    return self.device.torchMode == AVCaptureFlashModeOn;
}
- (void)distory{
    [self stopRunning];
    
    [self.device removeObserver:self forKeyPath:kFocusKey];
    
	self.session = nil;
	self.image = nil;

}
@end
