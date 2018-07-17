//
//  EVMCoHelper.h
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/16/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateClassData.h"

typedef enum {
    PayloadFormatIndicator = 0,
    PointOfInitiationMethod,
    MerchantAccountInfo,
    MerchantCategoryCode,
    TransactionCurrency,
    TransactionAmount,
    TipOrConvenienceIndicator,
    ValueOfConvenienceFeeFixed,
    ValueOfConvenienceFeePercentage,
    CountryCode,
    MerchantName,
    MerchantCity,
    PostalCode,
    AdditionalDataFieldTemplate,
    MerchantInformationLanguageTemplate,
    RFUForEMVCo,
    UnreservedTemplates,
    CRC
}DataObjectTypes;

@interface DataObject: TemplateClassData

@property (nonatomic) NSArray *value;
- (NSArray *)additionalDataObjectFromString;
- (NSArray *)merchantAccountInformation;
- (NSArray *)merchantInformation;
- (NSArray *)templateData;

@end

@interface EVMCoHelper : NSObject

+ (instancetype)shared;
- (void)setQRCode:(NSString *)code;
- (DataObject *)get:(DataObjectTypes)type;
@property (nonatomic, readonly) NSArray *objects;
@property (nonatomic, readonly) NSString *code;

@end

