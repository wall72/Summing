//
//  SummingAppDelegate.m
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "SummingAppDelegate.h"
#import "MenuViewController.h"
#import <GameKit/GameKit.h>

@interface SummingAppDelegate ()
- (void)loadUserDefaults;
- (void)saveSettings;
- (void)loadScores;
- (void)loadSaveData;
- (void)saveData;
- (NSString *)filePath:(NSString *)fileName;
- (void)readyBGM;
- (void)checkResume;
- (BOOL)isGameCenterAvailable;
- (BOOL)checkJailbreak;
@end

@implementation SummingAppDelegate

@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize shouldPlayMusic = _shouldPlayMusic;
@synthesize shouldPlaySound = _shouldPlaySound;
@synthesize scoreList = _scoreList;
@synthesize saveScore = _saveScore;
@synthesize resume = _resume;
@synthesize saveValueList = _saveValueList;
@synthesize saveAssignList = _saveAssignList;
@synthesize saveNextList = _saveNextList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    [self readyBGM];
    [self loadUserDefaults];
    [self loadScores];
    [self loadSaveData];
    [self checkResume];
    
    if ([self isGameCenterAvailable] && ![self checkJailbreak]) {
        if([GKLocalPlayer localPlayer].authenticated == NO) {
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"Authentication failed !");
                } else {
                    NSLog(@"Authentication succeeded !");
                }
            }];
        }
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveSettings];

    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [NSUserDefaults resetStandardUserDefaults];
    
    [self loadUserDefaults];

    UIViewController *_topViewController = [self.navigationController topViewController];
    if ([_topViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *_settingsViewController = (MenuViewController *)_topViewController;
        [_settingsViewController setToggle];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveSettings];
    
    [self saveData];
}

- (void)dealloc {
    [_window release];
    [_navigationController release];
    [_scoreList release];
    [_saveScore release];
    [_saveValueList release];
    [_saveAssignList release];
    [_saveNextList release];
    [_musicPlayer release];
    [super dealloc];
}

#pragma mark - User defined function

- (void)loadUserDefaults {
    NSLog(@"call");
    
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *_defaultsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"shouldPlayMusic", [NSNumber numberWithBool:YES], @"shouldPlaySound", nil];
    [_defaults registerDefaults:_defaultsDic];
    
    [self setShouldPlayMusic:[_defaults boolForKey:@"shouldPlayMusic"]];
    [self setShouldPlaySound:[_defaults boolForKey:@"shouldPlaySound"]];
}

- (void)saveSettings {
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    
    [_defaults setBool:self.shouldPlayMusic forKey:@"shouldPlayMusic"];
    [_defaults setBool:self.shouldPlaySound forKey:@"shouldPlaySound"];
}

- (void)loadScores {
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    
    NSString *_filePath = [self filePath:@"Scores.plist"];
    
	BOOL dbexists = [_fileManager fileExistsAtPath:_filePath];
	if (dbexists) {
        self.scoreList = [NSMutableArray arrayWithContentsOfFile:_filePath];
    } else {
        self.scoreList = [NSMutableArray array];
	}
}

- (void)addHighScore:(NSInteger)score {
    [self.scoreList addObject:[NSNumber numberWithInt:score]];
    
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
	[self.scoreList sortUsingDescriptors:[NSArray arrayWithObject: sortOrder]];
    
    NSString *_filePath = [self filePath:@"Scores.plist"];
    [self.scoreList writeToFile:_filePath atomically:YES];
}

- (void)loadSaveData {
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    
    NSString *_filePath1 = [self filePath:@"SaveScore.plist"];
    NSString *_filePath2 = [self filePath:@"SaveValue.plist"];
    NSString *_filePath3 = [self filePath:@"SaveAssign.plist"];
    NSString *_filePath4 = [self filePath:@"SaveNext.plist"];
    
	BOOL dbexists = [_fileManager fileExistsAtPath:_filePath2];
	if (dbexists) {
        self.saveScore = [NSString stringWithContentsOfFile:_filePath1 encoding:NSUTF8StringEncoding error:nil];
        self.saveValueList = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath2];
        self.saveAssignList = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath3];
        self.saveNextList = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath4];
    } else {
        self.saveScore = @"0";
        self.saveValueList = [NSMutableDictionary dictionaryWithCapacity:81];
        self.saveAssignList = [NSMutableDictionary dictionaryWithCapacity:81];
        self.saveNextList = [NSMutableDictionary dictionaryWithCapacity:4];
	}
}

- (void)saveData {
    NSString *_filePath1 = [self filePath:@"SaveScore.plist"];
    [self.saveScore writeToFile:_filePath1 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *_filePath2 = [self filePath:@"SaveValue.plist"];
    [self.saveValueList writeToFile:_filePath2 atomically:YES];
    NSString *_filePath3 = [self filePath:@"SaveAssign.plist"];
    [self.saveAssignList writeToFile:_filePath3 atomically:YES];
    NSString *_filePath4 = [self filePath:@"SaveNext.plist"];
    [self.saveNextList writeToFile:_filePath4 atomically:YES];
}

- (NSString *)filePath:(NSString *)fileName {
	NSString *_documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [_documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)readyBGM {
    NSURL *_musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bg_music" ofType:@"mp3"]];
    
    NSError *_error;
    
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_musicURL error:&_error];
    [_musicPlayer setNumberOfLoops:-1];
    [_musicPlayer retain];
}

- (void)setShouldPlayMusic:(BOOL)shouldPlayMusic {
    _shouldPlayMusic = shouldPlayMusic;
    
    if (_shouldPlayMusic) {
        if (![_musicPlayer isPlaying]) {
            [_musicPlayer play];
        }
    } else {
        if ([_musicPlayer isPlaying]) {
            [_musicPlayer stop];
        }
    }
}

- (void)checkResume {
    self.resume = NO;
    
    if (![self.saveScore isEqualToString:@"0"] && [self.saveValueList count] > 0) {
        NSEnumerator *_enumerator = [self.saveAssignList objectEnumerator];
        NSString *_value;
        
        while ((_value = [_enumerator nextObject])) {
            if ([_value isEqualToString:@"1"]) {
                self.resume = YES;
                break;
            }
        }
    }
}

- (BOOL)isGameCenterAvailable {
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] !=NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (BOOL)checkJailbreak {
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"succeeded to read file !");
        return YES;
    } else {
        NSLog(@"fail to read file !");
        return NO;
    }
}

@end
