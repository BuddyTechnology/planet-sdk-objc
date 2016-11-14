//
//  ViewController.m
//  TKVideoPlanetDemo
//
//  Created by wang animeng on 2016/10/31.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import "ViewController.h"
#import <TKVideoPlanet/TKVideoPlanet.h>
#import <Masonry/Masonry.h>

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic,strong) TKVideoPlanet * planet;
@property (nonatomic,strong) NSString * roomId;
@property (nonatomic,strong) NSString * token;

@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIView *remoteView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *connectTipLabel;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *leaveBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.planet = [TKVideoPlanet videoPlanet:@"581a91f9f8c3e102a9a1273c"];
    
    self.activityView.hidden = YES;
    [self.activityView startAnimating];
    self.leaveBtn.hidden = YES;
    self.connectTipLabel.hidden = YES;
    
    [self startCapture];
    
    [self.planet listenVideoState:^(TKVideoConnectState state, NSError *error) {
        NSLog(@"state:%d error:%@",(int)state,error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRoomInput:(id)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"房间号" message:@"请输入房间号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.roomId = alert.textFields[0].text;
        [self connectRoom];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入房间号";
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)leave:(id)sender
{
    [self.planet leaveRoomId:self.roomId];
    self.leaveBtn.hidden = YES;
    self.connectBtn.hidden = NO;
}

- (void)connectRoom
{
    self.activityView.hidden = NO;
    self.connectTipLabel.hidden = NO;
    self.connectTipLabel.text = @"";
    __block ViewController * weakSelf = self;
    [self.planet connectRoomId:self.roomId
                         state:^(TKVideoConnectState state, NSError *error) {
                             BOOL needHiddenBtn;
                             BOOL needHiddenLoadingView;
                             if (state == TKVideoPlanetConnected) {
                                 needHiddenBtn = YES;
                                 needHiddenLoadingView = YES;
                                 weakSelf.connectTipLabel.text = @"connected";
                                 
                                 [weakSelf listenRoomMessage:self.roomId];
                             }
                             else if(state == TKVideoPlanetDisconnected){
                                 needHiddenBtn = NO;
                                 needHiddenLoadingView = YES;
                             }
                             else if(state == TKVideoPlanetConnecting){
                                 needHiddenBtn = YES;
                                 needHiddenLoadingView = NO;
                                 self.connectTipLabel.text = [NSString stringWithFormat:@"connect room:%@",self.roomId];
                             }
                             weakSelf.activityView.hidden = needHiddenLoadingView;
                             weakSelf.connectTipLabel.hidden = needHiddenLoadingView;
                             weakSelf.leaveBtn.hidden = !needHiddenBtn;
                             weakSelf.connectBtn.hidden = needHiddenBtn;
                             [weakSelf handleErrorMessge:error];
                         }];
    
    UIView * remotePreview = self.planet.cameraPreviewController.getRemoteCameraPreview;
    if (!remotePreview.superview) {
        [self.remoteView addSubview:remotePreview];
        [remotePreview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.remoteView);
        }];
    }
}

- (void)handleErrorMessge:(NSError*)error
{
    if (error) {
        self.connectTipLabel.text = error.localizedDescription;
        self.connectTipLabel.hidden = NO;
    }
}

- (void)startCapture
{
    UIView * preview = [self.planet.cameraPreviewController getLocalCameraPreview];
    [self.planet.cameraPreviewController turnOnCamera];
    [self.localView addSubview:preview];
    [preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - send message

- (IBAction)sendMessage:(id)sender {
    [self showTextInput];
}

- (void)listenRoomMessage:(NSString*)roomId
{
    __block ViewController * weakSelf = self;
    [self.planet listenRoomMessage:roomId receive:^(NSString *payload) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"新消息" message:payload preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirmAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showTextInput
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * willSendText = alert.textFields[0].text;
        [self.planet sendRoomMessage:self.roomId payload:willSendText];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - switch camera

- (IBAction)switchCamera:(id)sender
{
    [self.planet.cameraPreviewController switchCameraIsFront:!self.planet.cameraPreviewController.isFront];
}

@end
