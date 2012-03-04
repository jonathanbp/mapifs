//
//  MAPIFuseTransaction.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 2/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import "MAPIFuseTransaction.h"

@implementation MAPIFuseTransaction

@synthesize actions;

- (MAPIFuseTransactionalAction *) enlist:(NSString *)entityId type:(NSString *)type withMethod:(ActionMethod)method {
  
  id action = [self.actions objectForKey:entityId];
  
  if (action == nil) {
    action = [[MAPIFuseTransactionalAction alloc] initWith:method entityType:type entityId:entityId content:@"" andIndex:0];
    [self.actions setObject:action forKey:entityId];
  }
  
  return action;
}


@end
