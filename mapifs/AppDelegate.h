//
//  AppDelegate.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GMUserFileSystem;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  GMUserFileSystem* fs_;
}



@property (assign) IBOutlet NSWindow *window;

@end
