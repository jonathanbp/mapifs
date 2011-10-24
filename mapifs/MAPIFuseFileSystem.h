//
//  MAPIFuseFileSystem.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAPIFuseFileSystem : NSObject {
  
  NSArray *types;
  
}

@property (nonatomic, retain) NSArray *types;

- (id)initWithTypes:(NSArray *)mapitypes;

@end
