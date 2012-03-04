//
//  TransactionManager.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 4/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPIFuseTransaction.h"

@interface MAPIFuseTransactionManager : NSObject {
  
  MAPIFuseTransaction *currentTransaction;
  
}

@property (nonatomic, retain) MAPIFuseTransaction *currentTransaction;

- (MAPIFuseTransaction *) beginTransaction:(NSString *)transactionName;

@end
