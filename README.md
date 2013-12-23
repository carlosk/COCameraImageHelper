#COCameraImageHelper

##简介
	
[**COCameraImageHelper**](https://github.com/carlosk/COCameraImageHelper)这是一个通过封装**AVFoundation**实现自定义相机功能的辅助类
	
##如何添加

* 如果您使用cocoapods管理第三方库的话,可以在podfile里增加一行:

```
pod 'COCameraImageHelper', :git => 'https://github.com/carlosk/COCameraImageHelper'
```

* 如果您直接想把代码添加到项目中,需要做以下几步

	1. 把CameraImageHelper文件夹复制到您的项目中
	2. 添加以下Frameworks:'QuartzCore','QuartzCore','CoreVideo','AVFoundation','CoreMedia','ImageIO'
	
##如何使用

通过**git**下载COCameraImageHelperTest项目,会说明如何使用添加自定义View,拍照,和调用闪光灯.

##提供的方法
```
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
```


 


	
			


