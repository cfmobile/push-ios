//
//  Copyright (C) 2014 Pivotal Software, Inc. All rights reserved.
//

#import "Kiwi.h"

#import "PCFPushBackEndRegistrationRequestDataTest.h"
#import "NSObject+PCFJSONizable.h"
#import "PCFPushErrors.h"
#import "PCFPushSpecsHelper.h"

static NSArray *TEST_TAGS;

SPEC_BEGIN(PCFPushBackEndRegistrationPostRequestDataSpec)

describe(@"PCFPushBackEndRegistrationPostRequestData", ^{
    
    __block PCFPushRegistrationPostRequestData *model;
    
    beforeEach(^{
        TEST_TAGS = @[ @"TACO TAG", @"TAMALE TAG", @"TOASTY TAG" ];
    });
    
    afterEach(^{
        model = nil;
    });
    
    it(@"should be initializable", ^{
        model = [[PCFPushRegistrationPostRequestData alloc] init];
        [[model shouldNot] beNil];
    });
    
    context(@"fields", ^{
        
        beforeEach(^{
            model = [[PCFPushRegistrationPostRequestData alloc] init];
        });
        
        it(@"should start as nil", ^{
            [[model.variantUUID should] beNil];
            [[model.customUserId should] beNil];
            [[model.deviceAlias should] beNil];
            [[model.deviceManufacturer should] beNil];
            [[model.deviceModel should] beNil];
            [[model.os should] beNil];
            [[model.osVersion should] beNil];
            [[model.registrationToken should] beNil];
            [[model.tags should] beNil];
        });
        
        it(@"should have a variant_uuid", ^{
            model.variantUUID = TEST_VARIANT_UUID;
            [[model.variantUUID should] equal:TEST_VARIANT_UUID];
        });
        
        it(@"should have a custom_user_id", ^{
            model.customUserId = TEST_CUSTOM_USER_ID;
            [[model.customUserId should] equal:TEST_CUSTOM_USER_ID];
        });

        it(@"should have a device_alias", ^{
            model.deviceAlias = TEST_DEVICE_ALIAS;
            [[model.deviceAlias should] equal:TEST_DEVICE_ALIAS];
        });
        
        it(@"should have a device_manufacturer", ^{
            model.deviceManufacturer = TEST_DEVICE_MANUFACTURER;
            [[model.deviceManufacturer should] equal:TEST_DEVICE_MANUFACTURER];
        });
        
        it(@"should have a device_model", ^{
            model.deviceModel = TEST_DEVICE_MODEL;
            [[model.deviceModel should] equal:TEST_DEVICE_MODEL];
        });
        
        it(@"should have an os", ^{
            model.os = TEST_OS;
            [[model.os should] equal:TEST_OS];
        });
        
        it(@"should have an os_version", ^{
            model.os = TEST_OS_VERSION;
            [[model.os should] equal:TEST_OS_VERSION];
        });
        
        it(@"should have an registration_token", ^{
            model.registrationToken = TEST_REGISTRATION_TOKEN;
            [[model.registrationToken should] equal:TEST_REGISTRATION_TOKEN];
        });

        it(@"should have a list of tags", ^{
            model.tags = TEST_TAGS;
            [[model.tags should] equal:TEST_TAGS];
        });
    });
    
    context(@"deserialization", ^{
        
        it(@"should handle a nil input", ^{
            NSError *error;
            model = [PCFPushRegistrationPostRequestData pcfPushFromJSONData:nil error:&error];
            [[model  should] beNil];
            [[error shouldNot] beNil];
            [[error.domain should] equal:PCFPushErrorDomain];
            [[theValue(error.code) should] equal:theValue(PCFPushBackEndDataUnparseable)];
        });
        
        it(@"should handle empty input", ^{
            NSError *error;
            model = [PCFPushRegistrationPostRequestData pcfPushFromJSONData:[NSData data] error:&error];
            [[model should] beNil];
            [[error shouldNot] beNil];
            [[error.domain should] equal:PCFPushErrorDomain];
            [[theValue(error.code) should] equal:theValue(PCFPushBackEndDataUnparseable)];
        });
        
        it(@"should handle bad JSON", ^{
            NSError *error;
            NSData *JSONData = [@"I AM NOT JSON" dataUsingEncoding:NSUTF8StringEncoding];
            model = [PCFPushRegistrationPostRequestData pcfPushFromJSONData:JSONData error:&error];
            [[model  should] beNil];
            [[error shouldNot] beNil];
        });
        
        it(@"should construct a complete request object", ^{
            NSError *error;
            NSDictionary *dict = @{
                                   PCFPushRegistrationAttributes.deviceOS           : TEST_OS,
                                   PCFPushRegistrationAttributes.deviceOSVersion    : TEST_OS_VERSION,
                                   PCFPushRegistrationAttributes.customUserId       : TEST_CUSTOM_USER_ID,
                                   PCFPushRegistrationAttributes.deviceAlias        : TEST_DEVICE_ALIAS,
                                   PCFPushRegistrationAttributes.deviceManufacturer : TEST_DEVICE_MANUFACTURER,
                                   PCFPushRegistrationAttributes.deviceModel        : TEST_DEVICE_MODEL,
                                   PCFPushRegistrationAttributes.variantUUID        : TEST_VARIANT_UUID,
                                   PCFPushRegistrationAttributes.registrationToken  : TEST_REGISTRATION_TOKEN,
                                   kTags : TEST_TAGS
                                   };
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            [[error should] beNil];
            [[data shouldNot] beNil];
            
            model = [PCFPushRegistrationPostRequestData pcfPushFromJSONData:data error:&error];
            [[error should] beNil];
            [[model.os should] equal:TEST_OS];
            [[model.osVersion should] equal:TEST_OS_VERSION];
            [[model.customUserId should] equal:TEST_CUSTOM_USER_ID];
            [[model.deviceAlias should] equal:TEST_DEVICE_ALIAS];
            [[model.deviceManufacturer should] equal:TEST_DEVICE_MANUFACTURER];
            [[model.deviceModel should] equal:TEST_DEVICE_MODEL];
            [[model.variantUUID should] equal:TEST_VARIANT_UUID];
            [[model.registrationToken should] equal:TEST_REGISTRATION_TOKEN];
            [[model.tags should] equal:TEST_TAGS];
        });
    });

    context(@"serialization", ^{
        
        __block NSDictionary *dict = nil;
        
        beforeEach(^{
            model = [[PCFPushRegistrationPostRequestData alloc] init];
        });
        
        afterEach(^{
            dict = nil;
        });

        context(@"populated object", ^{
            
            beforeEach(^{
                model.variantUUID = TEST_VARIANT_UUID;
                model.customUserId = TEST_CUSTOM_USER_ID;
                model.deviceAlias = TEST_DEVICE_ALIAS;
                model.deviceManufacturer = TEST_DEVICE_MANUFACTURER;
                model.deviceModel = TEST_DEVICE_MODEL;
                model.os = TEST_OS;
                model.osVersion = TEST_OS_VERSION;
                model.registrationToken = TEST_REGISTRATION_TOKEN;
                model.tags = TEST_TAGS;
            });
            
            afterEach(^{
                [[dict shouldNot] beNil];
                [[dict[PCFPushRegistrationAttributes.variantUUID] should] equal:TEST_VARIANT_UUID];
                [[dict[PCFPushRegistrationAttributes.customUserId] should] equal:TEST_CUSTOM_USER_ID];
                [[dict[PCFPushRegistrationAttributes.deviceAlias] should] equal:TEST_DEVICE_ALIAS];
                [[dict[PCFPushRegistrationAttributes.deviceManufacturer] should] equal:TEST_DEVICE_MANUFACTURER];
                [[dict[PCFPushRegistrationAttributes.deviceModel] should] equal:TEST_DEVICE_MODEL];
                [[dict[PCFPushRegistrationAttributes.deviceOS] should] equal:TEST_OS];
                [[dict[PCFPushRegistrationAttributes.deviceOSVersion] should] equal:TEST_OS_VERSION];
                [[dict[PCFPushRegistrationAttributes.registrationToken] should] equal:TEST_REGISTRATION_TOKEN];
                [[dict[kTags] should] equal:TEST_TAGS];
            });

            it(@"should be dictionaryizable", ^{
                dict = [model pcfPushToFoundationType];
            });
            
            it(@"should be JSONizable", ^{
                NSData *JSONData = [model pcfPushToJSONData:nil];
                [[JSONData shouldNot] beNil];
                NSError *error = nil;
                dict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
                [[error  should] beNil];
            });
        });
        
        context(@"unpopulated object", ^{
            
            afterEach(^{
                [[dict shouldNot] beNil];
                [[dict[PCFPushRegistrationAttributes.variantUUID]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.customUserId]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.deviceAlias]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.deviceManufacturer]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.deviceModel]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.deviceOS]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.deviceOSVersion]  should] beNil];
                [[dict[PCFPushRegistrationAttributes.registrationToken]  should] beNil];
                [[dict[kTags]  should] beNil];
            });
            
            it(@"should be dictionaryizable", ^{
                dict = [model pcfPushToFoundationType];
            });
            
            it(@"should be JSONizable", ^{
                NSData *JSONData = [model pcfPushToJSONData:nil];
                [[JSONData shouldNot] beNil];
                NSError *error = nil;
                dict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
                [[error  should] beNil];
            });
        });
    });
});

SPEC_END
