//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "NSError+LocalizedDescriptionWithoutOperationPrefix.h"
#import <objc/runtime.h> // Needed for method swizzling

@implementation NSError (LocalizedDescriptionWithoutOperationPrefix)

+ (void)load {
    Method original, swizzled;
    
    original = class_getInstanceMethod(self, @selector(localizedDescription));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_localizedDescription));
    method_exchangeImplementations(original, swizzled);
}

- (NSString *)swizzled_localizedDescription {
    static NSString *operationPrefix = @"The operation couldn’t be completed. ";
    NSString *failureReason = [self swizzled_localizedDescription];
    if ([failureReason hasPrefix:operationPrefix]) {
        failureReason = [failureReason substringFromIndex:[operationPrefix length]];
    }
    return failureReason;
}

@end
