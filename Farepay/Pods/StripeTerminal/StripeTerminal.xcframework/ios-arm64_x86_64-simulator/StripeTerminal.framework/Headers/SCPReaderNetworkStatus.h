//
//  SCPReaderNetworkStatus.h
//  StripeTerminal
//
//  Created by Catriona Scott on 7/1/19.
//  Copyright © 2019 Stripe. All rights reserved.
//
//  Use of this SDK is subject to the Stripe Terminal Terms:
//  https://stripe.com/terminal/legal
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The possible networking statuses for a reader.

 @see https://stripe.com/docs/api/terminal/readers/object
 */
typedef NS_ENUM(NSUInteger, SCPReaderNetworkStatus) {

    /**
     The reader is offline. Note that Chipper 2x and WisePad 3 will always report
     `offline`.
     */
    SCPReaderNetworkStatusOffline,

    /**
     The reader is online.
     */
    SCPReaderNetworkStatusOnline,
} NS_SWIFT_NAME(ReaderNetworkStatus);

NS_ASSUME_NONNULL_END
