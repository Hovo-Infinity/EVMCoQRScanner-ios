//
//  EVMCoHelper.m
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/16/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import "EVMCoHelper.h"

@interface EVMCoHelper()

@property (nonatomic) NSString *code;
@property (nonatomic, readwrite) NSArray *objects;

@end

@implementation EVMCoHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static EVMCoHelper *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[EVMCoHelper alloc] init];
    });
    return shared;
}

- (void)setQRCode:(NSString *)code {
    self.code = code;
}

- (void)setCode:(NSString *)code {
    _code = code;
    NSArray *strings = [EVMCoHelper splitedStringsFromCode:code];
    NSMutableArray *arr = [@[] mutableCopy];
    for (NSString *string in strings) {
        DataObject *obj = [EVMCoHelper dataObjectFromString:string];
        [arr addObject:obj];
    }
    self.objects = arr;
}

- (DataObject *)get:(DataObjectTypes)type {
    switch (type) {
        case PayloadFormatIndicator:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 0"]].firstObject;
        case PointOfInitiationMethod:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 1"]].firstObject;
        case MerchantAccountInfo:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id >= 2 AND Id <= 51"]].firstObject;
        case MerchantCategoryCode:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 52"]].firstObject;
        case TransactionCurrency:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 53"]].firstObject;
        case TransactionAmount:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 54"]].firstObject;
        case TipOrConvenienceIndicator:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 55"]].firstObject;
        case ValueOfConvenienceFeeFixed:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 56"]].firstObject;
        case ValueOfConvenienceFeePercentage:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 57"]].firstObject;
        case CountryCode:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 58"]].firstObject;
        case MerchantName:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 59"]].firstObject;
        case MerchantCity:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 60"]].firstObject;
        case PostalCode:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 61"]].firstObject;
        case AdditionalDataFieldTemplate:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 62"]].firstObject;
        case MerchantInformationLanguageTemplate:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 64"]].firstObject;
        case RFUForEMVCo:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id >= 65 AND Id <= 79"]].firstObject;
        case UnreservedTemplates:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id >= 80 AND Id <= 99"]].firstObject;
        case CRC:
            return [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = 63"]].firstObject;
    }
}

+ (NSArray<NSString *> *)splitedStringsFromCode:(NSString *)code {
    NSMutableArray<NSString *> *splitedStrings = [@[] mutableCopy];
    NSInteger index = 0;
    const NSInteger len = 2;
    while (index < code.length) {
        NSInteger count = [[code substringWithRange:NSMakeRange(index + 2, len)] integerValue];
        NSString *part = [code substringWithRange:NSMakeRange(index, count + 4)];
        index += count + 4;
        [splitedStrings addObject:part];
    }
    return splitedStrings;
}

+ (DataObject *)dataObjectFromString:(NSString *)string {
    NSInteger Id = [[string substringToIndex:2] integerValue];
    DataObject *obj = [[DataObject alloc] init];
    obj.Id = Id;
    obj.len = [[string substringWithRange:NSMakeRange(2, 2)] integerValue];
    obj.stringValue = [string substringFromIndex:4];
    switch (Id) {
        case 0:
            obj.name = @"Payload Format Indicator";
            obj.value = @[obj.stringValue];
            break;
            
        case 1:
            obj.name = @"Point of Initiation Method";
            obj.value = @[[NSString stringWithFormat:@"%@ Note: The value of \"11\" should be used when the same QR Code is shown for more than one transaction and the value of \"12\" should be used when a new QR Code is shown for each transaction.", obj.stringValue]];
            break;
        case 2:case 3:
            obj.name = @"Reserved for Visa";
            obj.value = @[obj.stringValue];
            break;
        case 4:case 5:
            obj.name = @"Reserved for Mastercard";
            obj.value = @[obj.stringValue];
            break;
        case 6:case 7:case 8:
            obj.name = @"Reserved by EMVCo";
            obj.value = @[obj.stringValue];
            break;
        case 9:case 10:
            obj.name = @"Reserved for Discover";
            obj.value = @[obj.stringValue];
            break;
        case 11:case 12:
            obj.name = @"Reserved for Amex";
            obj.value = @[obj.stringValue];
            break;
        case 13:case 14:
            obj.name = @"Reserved for JCB";
            obj.value = @[obj.stringValue];
            break;
        case 15:case 16:
            obj.name = @"Reserved for UnionPay";
            obj.value = @[obj.stringValue];
            break;
        case 17 ... 25:
            obj.name = @"Reserved by EMVCo";
            obj.value = @[obj.stringValue];
            break;
        case 26 ... 51:
            obj.name = @"Templates reserved for additional payment networks";
            obj.value = [obj merchantAccountInformation];
            break;

        case 52:
            obj.name = @"Merchant Category Code";
            obj.value = @[obj.stringValue];
            break;
            
        case 53: {
            obj.name = @"Transaction Currency";
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.currencyCode = obj.stringValue;
        }
            break;
            
        case 54:
            obj.name = @"Transaction Amount";
            obj.value = @[obj.stringValue];
            break;
            
        case 55:
            obj.name = @"Tip or Convenience Indicator";
            obj.value = @[obj.stringValue];
            break;
            
        case 56:
            obj.name = @"Value of Convenience Fee Fixed";
            obj.value = @[obj.stringValue];
            break;
            
        case 57:
            obj.name = @"Value of Convenience Fee Percentage";
            obj.value = @[obj.stringValue];
            break;
            
        case 58:
            obj.name = @"Country Code";
            obj.value = @[obj.stringValue];
            break;
            
        case 59:
            obj.name = @"Merchant Name";
            obj.value = @[obj.stringValue];
            break;
            
        case 60:
            obj.name = @"Merchant City";
            obj.value = @[obj.stringValue];
            break;
            
        case 61:
            obj.name = @"Postal Code";
            obj.value = @[obj.stringValue];
            break;
            
        case 62:
            obj.name = @"Additional Data Field Template";
            obj.value = [obj additionalDataObjectFromString];
            break;
            
        case 63:
            obj.name = @"CRC";
            obj.value = @[obj.stringValue];
            break;
            
        case 64:
            obj.name = @"Merchant Information— Language Template";
            obj.value = [obj merchantInformation];
            break;
            
        case 65 ... 79:
            obj.name = @"RFU for EMVCo";
            obj.value = @[obj.stringValue];
            break;
            
        default: // case 80 ... 99:
            obj.name = @"Unreserved Templates";
            obj.value = [obj templateData];
            break;
    }
    return obj;
}

@end

@implementation DataObject

- (NSArray *)additionalDataObjectFromString {
    NSString *code = self.stringValue;
    NSMutableArray *array = [@[] mutableCopy];
    NSMutableArray<NSString *> *splitedStrings = [@[] mutableCopy];
    NSInteger index = 0;
    const NSInteger len = 2;
    while (index < code.length) {
        NSInteger count = [[code substringWithRange:NSMakeRange(index + 2, len)] integerValue];
        NSString *part = [code substringWithRange:NSMakeRange(index, count + 4)];
        index += count + 4;
        [splitedStrings addObject:part];
    }
    for (NSString *string in splitedStrings) {
        AdditionalDataObject *obj = [[AdditionalDataObject alloc] init];
        NSInteger Id = [[string substringToIndex:2] integerValue];
        obj.Id = Id;
        obj.len = [[string substringWithRange:NSMakeRange(2, 2)] integerValue];
        obj.stringValue = [string substringFromIndex:4];
        switch (Id) {
            case 1:
                obj.name = @"Bill Number";
                break;
            case 2:
                obj.name = @"Mobile Number";
                break;
            case 3:
                obj.name = @"Store Label";
                break;
            case 4:
                obj.name = @"Loyalty Number";
                break;
            case 5:
                obj.name = @"Reference Label";
                break;
            case 6:
                obj.name = @"Customer Label";
                break;
            case 7:
                obj.name = @"Terminal Label";
                break;
            case 8:
                obj.name = @"Purpose of Transaction";
                break;
            case 9:
                obj.name = @"Additional Consumer Data Request";
                break;
            case 10 ... 49:
                obj.name = @"RFU for EMVCo";
                break;
            case 50 ... 99:
                obj.name = @"Payment System specific templates";
                break;
                
            default:
                break;
        }
        [array addObject:obj];
    }
    return array;
}

- (NSArray *)merchantInformation {
    NSArray *strings = [EVMCoHelper splitedStringsFromCode:self.stringValue];
    NSMutableArray *array = [@[] mutableCopy];
    for (NSString *string in strings) {
        MerchantInformation *obj = [[MerchantInformation alloc] init];
        NSInteger Id = [[string substringToIndex:2] integerValue];
        obj.Id = Id;
        obj.len = [[string substringWithRange:NSMakeRange(2, 2)] integerValue];
        obj.stringValue = [string substringFromIndex:4];
        switch (Id) {
            case 0:
                obj.name = @"Language Preference";
                break;
            case 1:
                obj.name = @"Merchant Name—Alternate Language";
                break;
            case 2:
                obj.name = @"Merchant City—Alternate Language";
                break;
            case 3 ... 99:
                obj.name = @"RFU for EMVCo";
                break;
                
            default:
                break;
        }
        [array addObject:obj];
    }
    return array;
}

- (NSArray *)merchantAccountInformation {
    NSArray *strings = [EVMCoHelper splitedStringsFromCode:self.stringValue];
    NSMutableArray *array = [@[] mutableCopy];
    for (NSString *string in strings) {
        MerchantInformation *obj = [[MerchantInformation alloc] init];
        NSInteger Id = [[string substringToIndex:2] integerValue];
        obj.Id = Id;
        obj.len = [[string substringWithRange:NSMakeRange(2, 2)] integerValue];
        obj.stringValue = [string substringFromIndex:4];
        switch (Id) {
            case 0:
                obj.name = @"Globally Unique Identifier";
                break;
            case 1 ... 99:
                obj.name = @"Payment network specific";
                break;
            default:
                break;
        }
        [array addObject:obj];
    }
    return array;
}

- (NSArray *)templateData {
    NSArray *strings = [EVMCoHelper splitedStringsFromCode:self.stringValue];
    NSMutableArray *array = [@[] mutableCopy];
    for (NSString *string in strings) {
        MerchantInformation *obj = [[MerchantInformation alloc] init];
        NSInteger Id = [[string substringToIndex:2] integerValue];
        obj.Id = Id;
        obj.len = [[string substringWithRange:NSMakeRange(2, 2)] integerValue];
        obj.stringValue = [string substringFromIndex:4];
        switch (Id) {
            case 0:
                obj.name = @"Globally Unique Identifier";
                break;
            case 1 ... 99:
                obj.name = @"Context Specific Data";
                break;
            default:
                break;
        }
        [array addObject:obj];
    }
    return array;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"id = %@\nname = %@\nlength = %@\nvalue = %@", @(self.Id), self.name, @(self.len),
            [self.value debugDescription]];
}

@end
