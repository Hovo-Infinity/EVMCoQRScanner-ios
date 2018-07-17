//
//  ViewController.h
//  QRScanner
//
//  Created by Hovhannes Stepanyan on 7/11/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) void(^textViewChangeBlock)(UITextView *textView);

@end

