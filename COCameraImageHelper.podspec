Pod::Spec.new do |s|
  s.name         = "COCameraImageHelper"
  s.version      = "0.0.1"
  s.summary      = "自定义拍照,增加了闪光灯功能"
  s.homepage     = "http://www.carloschen.cn"
  s.license      = 'MIT'
  s.author       = {"carlos" => "carlosk@163.com" }
  s.source       = { :git => "https://github.com/carlosk/CameraImageHelper"}
  s.source_files = 'CameraImageHelper/*.{h,m,mm}'
  s.framework    = 'QuartzCore','QuartzCore','CoreVideo','AVFoundation','CoreMedia','ImageIO'
  s.requires_arc = true
  s.platform     = :ios
end
