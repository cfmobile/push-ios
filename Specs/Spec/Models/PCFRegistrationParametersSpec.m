//
//  PCFRegistrationParametersSpec.mm
//  PCFSDK
//
//  Created by Rob Szumlakowski on 2014-02-14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//
#import <objc/runtime.h>

#import "Kiwi.h"
#import "PCFParameters.h"
#import "PCFClassPropertyUtility.h"

static NSString *const TEST_DEVICE_API_URL = @"http://testURL.com";
static NSString *const TEST_ANALYTICS_URL  = @"http://analyticsURL.com";
static NSString *const TEST_VARIANT_UUID   = @"SOS-WE-LIKE-IT-SPICY";
static NSString *const TEST_RELEASE_SECRET = @"Put sweet chili sauce on everything";
static NSString *const TEST_DEVICE_ALIAS   = @"Extreme spiciness classification";

static NSString *const TEST_ANALYTICS_KEY   = @"TEST_ANALYTICS_KEY";

SPEC_BEGIN(PCFRegistrationParametersSpec)

void (^checkPramatersAreValid)(NSString *, PCFParameters *) = ^(NSString *pramType, PCFParameters *model) {
    NSDictionary *properties = [PCFClassPropertyUtility propertiesForClass:[PCFParameters class]];
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *propertyType, BOOL *stop) {
        //Primatives use single character property types.
        //https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
        if ([propertyName rangeOfString:pramType options:NSCaseInsensitiveSearch].length > 0 && propertyType.length > 1) {
            id value = [model valueForKey:propertyName];
            [model setValue:nil forKey:propertyName];
            
            BOOL (^valid)(PCFParameters *) = ^BOOL(PCFParameters *model) {
                return [pramType isEqualToString:@"push"] ? [model pushParametersValid] : [model analyticsParametersValid];
            };
            [[theValue(valid(model)) should] beFalse];
            
            [model setValue:@"" forKey:propertyName];
            [[theValue(valid(model)) should] beFalse];
            
            [model setValue:value forKey:propertyName];
            [[theValue(valid(model)) should] beTrue];
        }
    }];
};

describe(@"PCFRegistrationParameters", ^{
    
    __block PCFParameters *model;

    afterEach(^{
        model = nil;
    });
    
    context(@"initializing with bad arguments programatically", ^{
        
        beforeEach(^{
            model = [PCFParameters parameters];
            [model setPushDeviceAlias:TEST_DEVICE_ALIAS];
            [model setPushAPIURL:TEST_DEVICE_API_URL];
            [model setAnalyticsAPIURL:TEST_ANALYTICS_URL];
            
            [model setDevelopmentPushReleaseSecret:TEST_RELEASE_SECRET];
            [model setProductionPushReleaseSecret:TEST_RELEASE_SECRET];
            
            [model setDevelopmentPushVariantUUID:TEST_VARIANT_UUID];
            [model setProductionPushVariantUUID:TEST_VARIANT_UUID];
            
            [model setAnalyticsAPIURL:TEST_DEVICE_API_URL];
            [model setDevelopmentAnalyticsKey:TEST_ANALYTICS_KEY];
            [model setProductionAnalyticsKey:TEST_ANALYTICS_KEY];
        });
        
        it(@"should require all push properties to be non-nil and non-empty", ^{
            [[theValue([model pushParametersValid]) should] beTrue];
            checkPramatersAreValid(@"push", model);
        });
        
        it(@"should require all analytics properties to be non-nil and non-empty", ^{
            [[theValue([model pushParametersValid]) should] beTrue];
            checkPramatersAreValid(@"analytics", model);
        });
    });
    
    context(@"initializing with valid arguments from plist", ^{
        
        beforeEach(^{
            model = [PCFParameters parametersWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"PCFParameters-Valid" ofType:@"plist"]];
        });
        
        it(@"push Parameters should be initialized successfully and valid", ^{
            [[model shouldNot] beNil];
            [[theValue([model pushParametersValid]) should] beTrue];
        });
        
        it(@"analytics Parameters should be initialized successfully and valid", ^{
            [[model shouldNot] beNil];
            [[theValue([model analyticsParametersValid]) should] beTrue];
        });
    });

    context(@"initializing with invalid arguments from plist", ^{
       
        beforeEach(^{
            model = [PCFParameters parametersWithContentsOfFile:@"PCFParameters-Invalid.plist"];
        });
        
        it(@"push Parameters should be initialized successfully and invalid", ^{
            [[model shouldNot] beNil];
            [[theValue([model pushParametersValid]) should] beFalse];
        });
        
        it(@"analytics Parameters should be initialized successfully and invalid", ^{
            [[model shouldNot] beNil];
            [[theValue([model analyticsParametersValid]) should] beFalse];
        });
    });
});

SPEC_END