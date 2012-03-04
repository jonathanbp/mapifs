//
//  MAPIFuseTransaction.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 2/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import "MAPIFuseTransaction.h"

@implementation MAPIFuseTransaction

@synthesize actions, name;

- (id)initWithName:(NSString *)name {
  self.name = name;
  self.actions = [[NSMutableDictionary alloc] init];
  return [self init];
}

- (MAPIFuseTransactionalAction *) enlist:(NSString *)entityId type:(NSString *)type withMethod:(ActionMethod)method {
  
  id action = [self.actions objectForKey:entityId];
  
  if (action == nil) {
    action = [[MAPIFuseTransactionalAction alloc] initWith:method entityType:type entityId:entityId content:@"" andIndex:0];
    [self.actions setObject:action forKey:entityId];
  }
  
  return action;
}


- (MAPIFuseTransactionalAction *) actionWithEntity:(NSString *)entityId {
  return [self.actions objectForKey:entityId];
}

- (BOOL) isEnlisted:(NSString *)entityId {
  
  return ([self.actions objectForKey:entityId] != nil);
  
}

- (void) updateEnlisted:(NSString *)entityId withAction:(MAPIFuseTransactionalAction *)action {
  
  [self.actions setObject:action forKey:entityId];
  
}


- (NSArray *) actionsOnType:(NSString *)type {
  
  NSMutableArray *actionsOnType = [[NSMutableArray alloc] init];
  
  NSSet *keys = [self.actions keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
    if ([((NSString *)key) hasPrefix:type])
      return YES;
    else
      return NO;
  }];
  
  for (NSString *key in keys) {
    [actionsOnType addObject:[self.actions objectForKey:key]];
  }

  
  return actionsOnType;
}

@end
