//
//  MAPIFuseTransactionalAction.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 2/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import "MAPIFuseTransactionalAction.h"

@implementation MAPIFuseTransactionalAction

@synthesize method, entityType, entityId, content, index;

- (id) initWith:(ActionMethod)method entityType:(NSString *)entityType entityId:(NSString *)entityId content:(NSString *)content andIndex:(NSInteger *)index {
  
  self.method = method;
  self.entityType = entityType;
  self.entityId = entityId;
  self.content = content;
  self.index = index;
  
  
  return [self init];
  
}

@end
