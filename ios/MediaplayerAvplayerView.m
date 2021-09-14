//
//  MediaplayerAvplayerView.m
//  MediaplayerAvplayer
//
//  Created by yrm on 9/14/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "MediaplayerAvplayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <React/RCTLog.h>

@interface MediaplayerAvplayerView ()

@end

@implementation MediaplayerAvplayerView

- (void)didMoveToSuperview {
    [self setupPlayer];
}

- (void)setConfig:(NSString *)url repeat:(BOOL)repeat mute:(BOOL)mute {
    self.url = url;
    self.repeat = repeat;
}

- (void)setupPlayer {
    self.avPlayerLayer = [[AVPlayerLayer alloc] init];
    self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:[[NSURL alloc] initWithString:self.url]];
    if (self.repeat) {
        self.avQueuePlayer = [AVQueuePlayer playerWithPlayerItem:self.avPlayerItem];
        self.avPlayerLooper = [AVPlayerLooper playerLooperWithPlayer:self.avQueuePlayer templateItem:self.avPlayerItem];
        [self.avPlayerLayer setPlayer:self.avQueuePlayer];
    } else {
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
        [self.avPlayerLayer setPlayer:self.avPlayer];
    }

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.avPlayerLayer.frame = self.frame;
        [self.layer addSublayer:self.avPlayerLayer];
        
        if (self.repeat) {
            [self.avQueuePlayer play];
        } else {
            [self.avPlayer play];
        }
    });
}

@end
