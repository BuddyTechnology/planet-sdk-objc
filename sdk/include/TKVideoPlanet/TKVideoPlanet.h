//
//  TKVideoPlanet.h
//  TKVideoPlanet
//
//  Created by wang animeng on 2016/10/31.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKCameraPreviewController.h"

typedef NS_ENUM(NSInteger, TKVideoConnectState) {
    TKVideoPlanetInit,
    TKVideoPlanetConnecting,
    TKVideoPlanetConnected,
    TKVideoPlanetDisconnected,
};

typedef NS_ENUM(NSInteger, TKVideoConnectErrorCode) {
    TKVideoInitFailError = 400,
    TKVideoSocketCloseError = 401,
    TKVideoRoomFullError = 402,
    TKVideoAppIdInvalidError = 403,
    TKVideoNetworkTimeOutError = 404,
    TKVideoAppInternalError = 405,
    TKVideoRoomIdInValidError = 406,
    TKVideoNetworkDisconnect = 500,
    TKVideoNetworkJitter = 501,
    TKVideoNetworkChange = 502,
};

typedef void (^TKTokenReady)(NSString *token);
typedef void (^TKVideoRoomMessage)(NSString * payload);
typedef void (^TKVideoPushMessage)(NSString * payload);
typedef void (^TKConnectStateListen)(TKVideoConnectState state,NSError * error);

@interface TKVideoPlanet : NSObject

@property (nonatomic,readonly) TKCameraPreviewController * cameraPreviewController;
@property (nonatomic,copy) TKTokenReady tokenReady;

+ (instancetype)videoPlanet:(NSString*)appId;

// 监听视频连接时候的状态
- (void)listenVideoState:(TKConnectStateListen)complete;

- (void)connectRoomId:(NSString*)roomId
                state:(TKConnectStateListen)complete;
- (void)leaveRoomId:(NSString*)roomId;

// 加入房间后互相发送的消息
- (BOOL)sendRoomMessage:(NSString*)roomId
                payload:(NSString*)payload;
- (void)listenRoomMessage:(NSString*)roomId
                  receive:(TKVideoRoomMessage)msgBlock;
// 监听push的消息
- (void)listenPushMessage:(TKVideoPushMessage)msgBlock;

// 初始化失败的时候，重新启动服务
- (void)restartServer;
// 关闭视频通信功能
- (void)shutdownServer;


@end
