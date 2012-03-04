//
//  TransactionManager.m
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 4/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import "MAPIFuseTransactionManager.h"

@implementation MAPIFuseTransactionManager

@synthesize currentTransaction;

- (MAPIFuseTransaction *) beginTransaction:(NSString *)transactionName {
  
  if (self.currentTransaction == nil) {
    self.currentTransaction = [[MAPIFuseTransaction alloc] initWithName:transactionName];
  }
  
  return self.currentTransaction;
  
}

@end
