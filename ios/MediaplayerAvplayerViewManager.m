#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <AVFoundation/AVFoundation.h>
// #import "MediaplayerAvplayerView.h"

@interface MediaplayerAvplayerViewManager : RCTViewManager

@property (nonatomic) NSString *url;
@property (nonatomic) bool repeat;
@property (nonatomic) bool autostart;
@property (nonatomic) bool mute;
@property (nonatomic) AVPlayer *avPlayer;
@property (nonatomic) AVPlayerItem *avPlayerItem;
@property (nonatomic) AVPlayerLayer *avPlayerLayer;
@property (nonatomic) AVQueuePlayer *avQueuePlayer;
@property (nonatomic) AVPlayerLooper *avPlayerLooper;
// @property (nonatomic, strong) MediaplayerAvplayerView *mediaplayerAvplayerView;

@end

@implementation MediaplayerAvplayerViewManager

RCT_EXPORT_MODULE(MediaplayerAvplayerView)

- (UIView *)view
{
    return [[UIView alloc] init];
}

RCT_CUSTOM_VIEW_PROPERTY(playerConfig, NSDictionary, UIView)
{
    NSDictionary *dictionary = [RCTConvert NSDictionary:json];
    self.url = [dictionary objectForKey:@"url"];
    self.repeat = [[dictionary objectForKey:@"repeat"] boolValue];
    self.autostart = [[dictionary objectForKey:@"autostart"] boolValue];
    self.mute = [[dictionary objectForKey:@"mute"] boolValue];

    // [view setConfig:self.url repeat:true mute:true];
    [self setupPlayer:view];
}

- (void)setupPlayer:(UIView *)view {
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
       self.avPlayerLayer.frame = view.frame;
       [view.layer addSublayer:self.avPlayerLayer];
       if (self.repeat) {
           [self.avQueuePlayer play];
       } else {
           [self.avPlayer play];
       }
   });
}

RCT_EXPORT_METHOD(play:(nonnull NSNumber*) reactTag) {
    if (self.repeat) {
        [self.avQueuePlayer play];
    } else {
        [self.avPlayer play];
    }
}

RCT_EXPORT_METHOD(pause:(nonnull NSNumber*) reactTag) {
    if (self.repeat) {
        [self.avQueuePlayer pause];
    } else {
        [self.avPlayer pause];
    }
}

RCT_EXPORT_METHOD(stop:(nonnull NSNumber*) reactTag) {
    if (self.repeat) {
        [self.avQueuePlayer pause];
    } else {
        [self.avPlayer pause];
    }
}

RCT_EXPORT_METHOD(seekTo:(nonnull NSNumber*) reactTag:(nonnull NSNumber*) position) {
    if (self.repeat) {
        [self.avQueuePlayer seekToTime:CMTimeMakeWithSeconds(position.doubleValue, 60000)];
    } else {
        [self.avPlayer seekToTime:CMTimeMakeWithSeconds(position.doubleValue, 60000)];
    }
}

RCT_EXPORT_METHOD(setUrl:(nonnull NSNumber*) reactTag:(nonnull NSString*) url) {
    if (self.repeat) {
        self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:[[NSURL alloc] initWithString:url]];
        [self.avQueuePlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
        self.avPlayerLooper = [AVPlayerLooper playerLooperWithPlayer:self.avQueuePlayer templateItem:self.avPlayerItem];
    } else {
        self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:[[NSURL alloc] initWithString:url]];
        [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
    }
}

@end
