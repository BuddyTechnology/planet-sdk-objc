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

typedef void (^TKTokenReady)(NSString * token);
typedef void (^TKSessionReady)(NSString * session);
typedef void (^TKVideoRoomMessage)(NSString * payload);
typedef void (^TKVideoPushMessage)(NSString * payload);
typedef void (^TKConnectStateListen)(TKVideoConnectState state,NSError * error);

@interface TKVideoPlanet : NSObject


/**
 sdk返回的token，token是客户服务器调用sdk的服务器的令牌
 */
@property (nonatomic,copy) TKTokenReady tokenReady;


/**
 本地和远程的摄像头的控制类
 */
@property (nonatomic,readonly) TKCameraPreviewController * cameraPreviewController;

+ (instancetype)videoPlanet:(NSString*)appId;


/**
 上传apns的token到服务器

 @param token apns获取的token
 @param block 上传完毕后的回调信息
 */
+ (void)setApnsToken:(NSString*)token
        completBlock:(void (^)(NSDictionary * info,NSError * error))block;


/**
 告诉服务器当前应用还有多少badge红点没有处理

 @param badge 剩下没有处理的bagde
 @param block 设置完毕后的回调信息
 */
+ (void)setApnsBadge:(NSString*)badge
        completBlock:(void (^)(NSDictionary * info,NSError * error))block;


/**
 监听视频连接时候的状态

 @param complete 视频的连接状态以及错误信息
 */
- (void)listenVideoState:(TKConnectStateListen)complete;


/**
 建立视频连接的请求，需要两个设备连接到同一个房间

 @param roomId 房间ID
 @param payload 发送给加入此房间用户的附加信息
 @param sessionReady 返回一个session，可以使用这个session查询该房间的通话时长等信息
 @param complete 连接完成后的状态
 */
- (void)connectRoomId:(NSString*)roomId
              payload:(NSString*)payload
              session:(TKSessionReady)sessionReady
                state:(TKConnectStateListen)complete;


/**
 离开房间的请求

 @param roomId 要离开的房间id
 @param payload 离开的同时，可以给对方发送附加的消息
 */
- (void)leaveRoomId:(NSString*)roomId
            payload:(NSString*)payload;


/**
 加入房间后互相发送的消息

 @param roomId 房间的ID
 @param payload 发送的消息，文本字符串
 @return 发送是否成功
 */
- (BOOL)sendRoomMessage:(NSString*)roomId
                payload:(NSString*)payload;


/**
 监听来自某个房间的消息

 @param roomId 房间的ID
 @param msgBlock 接收的消息，文本字符串
 */
- (void)listenRoomMessage:(NSString*)roomId
                  receive:(TKVideoRoomMessage)msgBlock;


/**
 监听系统全局的消息

 @param msgBlock 接收到的消息，文本字符串
 */
- (void)listenPushMessage:(TKVideoPushMessage)msgBlock;


/**
 监听连接房间时，其他人加入的消息。
 当连接另一个roomid时，此消息回调会被被置空。如果需要再次调用这个消息监听

 @param payload 监听另一个用户加入时，传递的附加信息
 */
- (void)listenJoinMessage:(void (^)(NSString * msg))payload;


/**
 监听用户离开房间后的消息。
 重新创建房间后，此消息回调会被置空，如果需要监听需再次调用这个消息监听
 
 @param payload 监听另一个用户加入时，传递的附加信息
 */
- (void)listenLeaveMessage:(void (^)(NSString * msg))payload;


/**
 初始化失败的时候，重新启动服务
 */
- (void)restartServer;


/**
 关闭视频通信功能
 */
- (void)shutdownServer;

@end
