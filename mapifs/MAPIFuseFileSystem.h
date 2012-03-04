//
//  MAPIFuseFileSystem.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 21/10/11.
//  Copyright (c) 2011 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPI.h"
#import "MAPIFuseTransactionManager.h"
#import "MAPIFuseTransactionSerializerProtocol.h"

@interface MAPIFuseFileSystem : NSObject {
  
  NSArray *types;
  MAPI *mapi;
  MAPIFuseTransactionManager *transactionManager;
  
  id<MAPIFuseTransactionSerializerProtocol> serializer;
  NSArray *topLevelFolders;
  
}

@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) MAPI *mapi;
@property (nonatomic, retain) MAPIFuseTransactionManager *transactionManager;

- (id)initWithTypes:(NSArray *)mapitypes MAPI:(MAPI *)theMAPI andTransactionManager:(MAPIFuseTransactionManager *)tm;

@end
