//
//  TemplateClassData.m
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/16/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import "TemplateClassData.h"

@implementation TemplateClassData

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"id = %@\nname = %@\nlength = %@\nvalue = %@",
            @(self.Id),
            self.name,
            @(self.len),
            self.stringValue];
}

@end

@implementation AdditionalDataObject
@end

@implementation MerchantInformation
@end

@implementation MerchantAccountInformation
@end
