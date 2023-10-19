//
//  SCPCreateConfiguration.h
//  StripeTerminal
//
//  Created by Brian Cooke on 3/11/22.
//  Copyright © 2022 Stripe. All rights reserved.
//
//  Use of this SDK is subject to the Stripe Terminal Terms:
//  https://stripe.com/terminal/legal
//

#import <Foundation/Foundation.h>

#import <StripeTerminal/SCPBuilder.h>

NS_ASSUME_NONNULL_BEGIN

/**
  The available operating modes that define how payment intents respond to changes in network connectivity.
 */
typedef NS_ENUM(NSInteger, SCPOfflineBehavior) {
    /**
      When network connectivity is available, this PaymentIntent will be transacted online. When network connectivity is unavailable, the PaymentIntent will be transacted offline.
     */
    SCPOfflineBehaviorPreferOnline,
    /**
      The PaymentIntent will only be transacted when network connectivity is available.
     */
    SCPOfflineBehaviorRequireOnline,
    /**
      The PaymentIntent will only be transacted offline, regardless of network connectivity.
     */
    SCPOfflineBehaviorForceOffline
} NS_SWIFT_NAME(OfflineBehavior);

/**
 The `CreateConfiguration` contains configuration relevant to creating a payment intent.
 */
NS_SWIFT_NAME(CreateConfiguration)
@interface SCPCreateConfiguration : NSObject

/**
 Determine the behavior of the SDK depending if the iOS device is currently offline and unable
 to communicate with stripe.com. Defaults to `SCPOfflineBehaviorPreferOnline`.

 You must be part of the offline beta for this to take effect.

 @see https://stripe.com/docs/terminal/features/operate-offline/collect-payments?terminal-sdk-platform=ios#create-payment-intent
 */
@property (nonatomic, readonly) SCPOfflineBehavior offlineBehavior;

/**
 Use `SCPCreateConfigurationBuilder`
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Use `SCPCreateConfigurationBuilder`
 */
+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 Builder class for `SCPCreateConfiguration`.
 */
NS_SWIFT_NAME(CreateConfigurationBuilder)
@interface SCPCreateConfigurationBuilder : SCPBuilder <SCPCreateConfiguration *>

/// @see `SCPCreateConfiguration.offlineBehavior`
- (SCPCreateConfigurationBuilder *)setOfflineBehavior:(SCPOfflineBehavior)offlineBehavior;

@end

NS_ASSUME_NONNULL_END
