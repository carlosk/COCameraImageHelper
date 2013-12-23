//
//  Test3VC.m
//  COTest1
//
//  Created by carlos on 13-12-23.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "Test3VC.h"
#import "CameraImageHelper.h"
@interface Test3VC ()
@property(retain,nonatomic) CameraImageHelper *CameraHelper;
@property(nonatomic,weak)IBOutlet UIView *cameraV;
@property(nonatomic,weak)IBOutlet UIImageView *imageV;


@end

@implementation Test3VC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (IBAction)onClickBtn:(UIView *)sender{

    if (sender.tag == 2) {
        [_CameraHelper onTorch:AVCaptureTorchModeOn];
    }else{
        [_CameraHelper takeImage];
//    COUIImagePickerController *imagePicker = [[ COUIImagePickerController alloc ] init ];
//    imagePicker. sourceType = UIImagePickerControllerSourceTypeCamera ;
//    imagePicker.allowsEditing = YES;
//    imagePicker.showsCameraControls = NO;
////    imagePicker. delegate = self ;
//    [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _CameraHelper = [[CameraImageHelper alloc]init];
    
    // 开始实时取景
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.cameraV];
    __block typeof(self)bSelf = self;

    _CameraHelper.imageTakeFinishedBlock = ^(UIImage *image){
        bSelf.imageV.image = image;
    };
    
    _CameraHelper.focusBlock = ^(BOOL isFcous){
        NSLog(@"对焦%@",index?@"成功":@"没成功");
    };
    [_CameraHelper changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
