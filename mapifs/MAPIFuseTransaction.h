//
//  MAPIFuseTransaction.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 2/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPIFuseTransactionalAction.h"

@interface MAPIFuseTransaction : NSObject {
  
  NSMutableDictionary *actions;
  
}

@property (nonatomic, retain) NSMutableDictionary *actions;

- (MAPIFuseTransactionalAction *) enlist:(NSString *)entityId;
- (BOOL) isEnlisted:(NSString *)entityId;
- (BOOL) updatedEnlisted:(NSString *)entityId withAction:(MAPIFuseTransactionalAction *)action;

@end
