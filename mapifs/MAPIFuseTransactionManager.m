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

- (MAPIFuseTransaction *) beginTransaction {
  
  MAPIFuseTransaction *t = [[MAPIFuseTransaction alloc] init];
  
  return t;
  
}

@end
