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
  NSString *name;
  
}

@property (nonatomic, retain) NSMutableDictionary *actions;
@property (nonatomic, retain) NSString *name;

- (id) initWithName:(NSString *)name;

- (MAPIFuseTransactionalAction *) enlist:(NSString *)entityId type:(NSString *)type withMethod:(ActionMethod)method ;
- (MAPIFuseTransactionalAction *) actionWithEntity:(NSString *)entityId;
- (NSArray *) actionsOnType:(NSString *)type;

- (BOOL) isEnlisted:(NSString *)entityId;
- (void) updateEnlisted:(NSString *)entityId withAction:(MAPIFuseTransactionalAction *)action;

@end
