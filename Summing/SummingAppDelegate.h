//
//  SummingAppDelegate.h
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SummingAppDelegate : NSObject <UIApplicationDelegate> {

@private
    BOOL _shouldPlayMusic;
    BOOL _shouldPlaySound;
    NSMutableArray *_scoreList;
    BOOL _resume;
    NSString *_saveScore;
    NSMutableDictionary *_saveValueList;
    NSMutableDictionary *_saveAssignList;
    NSMutableDictionary *_saveNextList;
    AVAudioPlayer *_musicPlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, assign) BOOL shouldPlayMusic;
@property (nonatomic, assign) BOOL shouldPlaySound;
@property (nonatomic, retain) NSMutableArray *scoreList;
@property (nonatomic, retain) NSString *saveScore;
@property (nonatomic, assign, getter = isResume) BOOL resume;
@property (nonatomic, retain) NSMutableDictionary *saveValueList;
@property (nonatomic, retain) NSMutableDictionary *saveAssignList;
@property (nonatomic, retain) NSMutableDictionary *saveNextList;

- (void)addHighScore:(NSInteger)score;

@end
