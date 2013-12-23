//
//  CameraImageHelper.h
//  HelloWorld
//
//  Created by carlosk@163.com
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^CameraImageTakeFinishedBlcok)(UIImage *image);
typedef void(^CameraImageFocusFinishedBlcok)(BOOL isFocus);

@interface CameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic,copy)CameraImageTakeFinishedBlcok imageTakeFinishedBlock;//是否拍到照片
@property(nonatomic,copy)CameraImageFocusFinishedBlcok focusBlock;//是否对焦成功

//开始运行
- (void) startRunning;
//结束运行
- (void) stopRunning;

-(void)takeImage;
//添加View到相机上
- (void)embedPreviewInView: (UIView *) aView;
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
//闪光灯
- (void)onTorch:(AVCaptureTorchMode )mode;
@end
