//
//  MAPIFuseTransactionalAction.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 2/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  CREATE,
  DELETE,
  UPDATE
} ActionMethod;

@interface MAPIFuseTransactionalAction : NSObject {
  
  ActionMethod method;
  NSString *entityType;
  NSString *entityId;
  NSString *content; // inner xml
  NSInteger *index;
  
}

@property (nonatomic, assign) ActionMethod method;
@property (nonatomic, retain) NSString *entityType;
@property (nonatomic, retain) NSString *entityId;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) NSInteger *index;

- (id) initWith:(ActionMethod)method entityType:(NSString *)entityType entityId:(NSString *)entityId content:(NSString *)content andIndex:(NSInteger *)index;

@end
