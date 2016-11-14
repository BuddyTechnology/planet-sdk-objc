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
// 摄像头采集的源数据回调
- (nullable CVPixelBufferRef)videoCaptureDidOutputSampleBuffer:(nonnull CMSampleBufferRef)sampleBuffer;
@end

@interface TKCameraPreviewController : NSObject

@property (nullable,assign) id<TKVideoCaptureDelegate> captureDelegate;

@property (nonatomic,assign) BOOL isFront;
// 切换摄像头前后置
- (void)switchCameraIsFront:(BOOL)isFront;

- (nullable UIView *)getLocalCameraPreview;
- (nullable UIView *)getRemoteCameraPreview;

// 打开关闭摄像头
- (void)turnOnCamera;
- (void)turnOffCamera;

// 关闭远程的视频的view
- (void)closeRemoteCameraPreview;

@end
