//
//  AppDelegate.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import "AppDelegate.h"
#import "MAPIFuseFileSystem.h"
#import "MAPIFuseTransactionManager.h"
#import "XMLReader.h"
#import <Fuse4X/Fuse4X.h>

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
  [center addObserver:self selector:@selector(didMount:)
                 name:kGMUserFileSystemDidMount object:nil];
  [center addObserver:self selector:@selector(didUnmount:)
                 name:kGMUserFileSystemDidUnmount object:nil];
  
  NSString* mountPath = @"/Volumes/MAPI";
  
  // create a transactional manager
  MAPIFuseTransactionManager *tm = [[MAPIFuseTransactionManager alloc] init];
  
  // create single mapi endpoint
  MAPI *mapi = [[MAPI alloc] initWithURL:[NSURL URLWithString:@"172.16.125.214:8080"] userName:@"spider" andPassword:@"spider"];
  
  MAPIFuseFileSystem* mapifs = [[MAPIFuseFileSystem alloc] initWithTypes:[NSArray arrayWithObjects: @"Organization", @"Location", @"Personnel", @"Bed", nil] MAPI:mapi andTransactionManager:tm];
  
  fs_ = [[GMUserFileSystem alloc] initWithDelegate:mapifs isThreadSafe:YES];
  NSMutableArray* options = [NSMutableArray array];
  //[options addObject:@"rdonly"];
  [options addObject:@"volname=MAPIFS"];
  [options addObject:[NSString stringWithFormat:@"volicon=%@", [[NSBundle mainBundle] pathForResource:@"Fuse" ofType:@"icns"]]];
  [fs_ mountAtPath:mountPath withOptions:options];
}

- (void)didMount:(NSNotification *)notification {
  NSDictionary* userInfo = [notification userInfo];
  NSString* mountPath = [userInfo objectForKey:kGMUserFileSystemMountPathKey];
  NSString* parentPath = [mountPath stringByDeletingLastPathComponent];
  [[NSWorkspace sharedWorkspace] selectFile:mountPath
                   inFileViewerRootedAtPath:parentPath];
}

- (void)didUnmount:(NSNotification*)notification {
  [[fs_ delegate] release]; 
  [fs_ release];
  [[NSApplication sharedApplication] terminate:nil];
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [fs_ unmount];  // Just in case we need to unmount;
  [[fs_ delegate] release];  // Clean up HelloFS
  [fs_ release];
  return NSTerminateNow;
}

@end
