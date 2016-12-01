//
//  TKCameraPreviewController.h
//  TKVideoPlanet
//
//  Created by wang animeng on 2016/11/3.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@protocol TKVideoCaptureDelegate <NSObject>
@optional

/**
 摄像头采集的源数据回调

 @param sampleBuffer 本地摄像头采集的图像源数据。
 @return 返回处理好的图像源数据，比如要增加滤镜效果。
 */
- (nullable CVPixelBufferRef)videoCaptureDidOutputSampleBuffer:(nonnull CMSampleBufferRef)sampleBuffer;
@end

@interface TKCameraPreviewController : NSObject

/**
 摄像头采集的源数据回调的代理
 */
@property (nullable,assign) id<TKVideoCaptureDelegate> captureDelegate;

/**
 摄像头是否是前置。
 */
@property (nonatomic,readonly) BOOL isFront;

/**
 切换摄像头前后置

 @param isFront 前后置参数
 */
- (void)switchCameraIsFront:(BOOL)isFront;

/**
 本地摄像头预览的view

 @return 预览的view
 */
- (nullable UIView *)getLocalCameraPreview;

/**
 远程摄像头预览的view
 
 @return 预览的view
 */
- (nullable UIView *)getRemoteCameraPreview;

/**
 打开关闭本地的摄像头
 */
- (void)turnOnCamera;
- (void)turnOffCamera;

/**
 关闭远程的视频的view
 */
- (void)closeRemoteCameraPreview;

@end
