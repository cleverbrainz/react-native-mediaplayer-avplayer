//
//  MediaplayerAvplayerView.h
//  MediaplayerAvplayer
//
//  Created by yrm on 9/14/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaplayerAvplayerView : UIView

@property (nonatomic) bool repeat;
@property (nonatomic) bool mute;
@property (nonatomic) NSString *url;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) AVQueuePlayer *avQueuePlayer;
@property (nonatomic, strong) AVPlayerLooper *avPlayerLooper;

- (void)setConfig:(NSString *)url repeat:(BOOL)repeat mute:(BOOL)mute;
- (void)setupPlayer;

@end
