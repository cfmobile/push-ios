//
//  SpecHelper.h
//  OmniaPushSDK
//
//  Created by Rob Szumlakowski on 2013-12-31.
//  Copyright (c) 2013 Omnia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OmniaPushAppDelegateProxy;
@protocol OmniaPushRegistrationListener;

@class OmniaPushAppDelegateProxy;
@class OmniaPushAPNSRegistrationRequestOperation;
@class OmniaFakeOperationQueue;
@class OmniaPushFakeApplicationDelegateSwitcher;
@class OmniaPushPersistentStorage;
@class OmniaPushRegistrationParameters;
@class OmniaPushRegistrationEngine;
@class OmniaPushFakeNSURLConnectionFactory;

#define TEST_NOTIFICATION_TYPES               UIRemoteNotificationTypeAlert
#define TEST_RELEASE_UUID                     @"444-555-666-777"
#define TEST_RELEASE_SECRET                   @"No secret is as strong as its blabbiest keeper"
#define TEST_DEVICE_ALIAS                     @"Let's watch cat videos"
#define TEST_RELEASE_UUID_2                   @"222-444-999-ZZZ"
#define TEST_RELEASE_SECRET_2                 @"My cat's breath smells like cat food"
#define TEST_DEVICE_ALIAS_2                   @"I can haz cheezburger?"

@interface OmniaSpecHelper : NSObject

@property (nonatomic) id application;
@property (nonatomic) id<UIApplicationDelegate> applicationDelegate;
@property (nonatomic) OmniaFakeOperationQueue *workerQueue;
@property (nonatomic) OmniaPushAPNSRegistrationRequestOperation *registrationRequestOperation;
@property (nonatomic) OmniaPushAppDelegateProxy *applicationDelegateProxy;
@property (nonatomic) OmniaPushFakeApplicationDelegateSwitcher *applicationDelegateSwitcher;
@property (nonatomic) NSData *apnsDeviceToken;
@property (nonatomic) NSData *apnsDeviceToken2;
@property (nonatomic) NSString *backEndDeviceId;
@property (nonatomic) NSString *backEndDeviceId2;
@property (nonatomic) OmniaPushPersistentStorage *storage;
@property (nonatomic) OmniaPushRegistrationParameters *params;
@property (nonatomic) OmniaPushRegistrationEngine *registrationEngine;
@property (nonatomic) OmniaPushFakeNSURLConnectionFactory *connectionFactory;

// Spec Helper lifecycle
- (instancetype) init;
- (void) reset;

// Front-end singleton helpers
- (void) resetSingleton;
- (void) setApplicationInSingleton;

// Application helpers
- (id) setupApplication;
- (void) setupApplicationForSuccessfulRegistrationWithNotificationTypes:(UIRemoteNotificationType)notificationTypes;
- (void) setupApplicationForSuccessfulRegistrationWithNotificationTypes:(UIRemoteNotificationType)notificationTypes withNewApnsDeviceToken:(NSData*)newApnsDeviceToken;
- (void) setupApplicationForFailedRegistrationWithNotificationTypes:(UIRemoteNotificationType)notificationTypes error:(NSError*)error;

// Application Delegate helpers
- (id<UIApplicationDelegate>) currentApplicationDelegate;
- (id<UIApplicationDelegate>) setupApplicationDelegate;
- (void) setupApplicationDelegateForSuccessfulRegistration;
- (void) setupApplicationDelegateForSuccessfulRegistrationWithApnsDeviceToken:(NSData*)apnsDeviceToken;
- (void) setupApplicationDelegateForFailedRegistrationWithError:(NSError*)error;

// Application Delegate Proxy helpers
- (OmniaPushAppDelegateProxy*) setupAppDelegateProxy;

// Registration Request Operation helpers
- (OmniaPushAPNSRegistrationRequestOperation*) setupRegistrationRequestOperationWithNotificationTypes:(UIRemoteNotificationType)notificationTypes;

// Operation Queue helpers
- (OmniaFakeOperationQueue*) setupQueues;

// Parameters helpers
- (OmniaPushRegistrationParameters*) setupParametersWithNotificationTypes:(UIRemoteNotificationType)notificationTypes;
- (void) changeReleaseUuidInParameters:(NSString*)newReleaseUuid;
- (void) changeReleaseSecretInParameters:(NSString*)newReleaseSecret;
- (void) changeDeviceAliasInParameters:(NSString*)newDeviceAlias;

// Registration Engine helpers
- (OmniaPushRegistrationEngine*) setupRegistrationEngine;

// NSURLConnection heleprs
- (OmniaPushFakeNSURLConnectionFactory*) setupConnectionFactory;

@end