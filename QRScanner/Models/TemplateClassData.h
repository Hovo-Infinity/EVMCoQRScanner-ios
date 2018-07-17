//
//  TemplateClassData.h
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/16/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateClassData : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger Id;
@property (nonatomic) NSInteger len;
@property (nonatomic) NSString *stringValue;

@end

@interface AdditionalDataObject: TemplateClassData

@end

@interface MerchantInformation: TemplateClassData

@end

@interface MerchantAccountInformation: TemplateClassData

@end
