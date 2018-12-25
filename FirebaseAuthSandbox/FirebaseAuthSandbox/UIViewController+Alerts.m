//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UIViewController+Alerts.h"

#import <objc/runtime.h>

/*! @var kPleaseWaitAssociatedObjectKey
 @brief Key used to identify the "please wait" spinner associated object.
 */
static NSString *const kPleaseWaitAssociatedObjectKey =
    @"_UIViewControllerAlertCategory_PleaseWaitScreenAssociatedObject";

/*! @var kOK
 @brief Text for an 'OK' button.
 */
static NSString *const kOK = @"OK";

@implementation UIViewController (Alerts)

- (void)showMessagePrompt:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:kOK style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSpinner:(NSString *)message :(nullable void (^)(void))completion {
  UIAlertController *pleaseWaitAlert =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));
  if (pleaseWaitAlert) {
    if (completion) {
      completion();
    }
    return;
  }
  pleaseWaitAlert = [UIAlertController alertControllerWithTitle:nil
                                                        message:[message stringByAppendingString:@"\n\n\n\n"] 
                                                 preferredStyle:UIAlertControllerStyleAlert];

  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  spinner.color = [UIColor blackColor];
  spinner.center = CGPointMake(pleaseWaitAlert.view.bounds.size.width / 2,
                               pleaseWaitAlert.view.bounds.size.height / 2);
  spinner.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  [spinner startAnimating];
  [pleaseWaitAlert.view addSubview:spinner];

  objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey),
                           pleaseWaitAlert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self presentViewController:pleaseWaitAlert animated:YES completion:completion];
}

- (void)hideSpinner:(nullable void (^)(void))completion {
  UIAlertController *pleaseWaitAlert =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));

  [pleaseWaitAlert dismissViewControllerAnimated:YES completion:completion];

  objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey), nil,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
