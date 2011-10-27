//
//  MAPIFuseFileSystem.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPI.h"

@interface MAPIFuseFileSystem : NSObject {
  
  NSArray *types;
  MAPI *mapi;
  
}

@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) MAPI *mapi;

- (id)initWithTypes:(NSArray *)mapitypes andMAPI:(MAPI *)theMAPI;

@end
