//
//  MPMusicPlayerController+Overrides.h
//  MusicToolbox
//
//  Created by Zachary lineman on 1/7/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMusicPlayerController (Private)

- (NSInteger)numberOfItems;
- (MPMediaItem*)nowPlayingItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
