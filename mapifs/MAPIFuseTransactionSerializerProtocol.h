//
//  TransactionFormatter.h
//  mapifs
//
//  Created by Jonathan Bunde-Pedersen on 4/3/12.
//  Copyright (c) 2012 Cetrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPIFuseTransaction.h"
#import "MAPIFuseTransactionalAction.h"

@protocol MAPIFuseTransactionSerializerProtocol <NSObject>

@required 
- (NSString *)serializeTransaction:(MAPIFuseTransaction *)transaction;
- (NSString *)serializeTransactionalAction:(MAPIFuseTransactionalAction *)action;
  
@end
