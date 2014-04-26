#import <Foundation/Foundation.h>

#import <MRuby/MRuby.h>

@interface SKMRInput : NSObject

@property (nonatomic, assign) BOOL leftArrowPressed;
@property (nonatomic, assign) BOOL rightArrowPressed;
@property (nonatomic, assign) BOOL upArrowPressed;
@property (nonatomic, assign) BOOL downArrowPressed;

+ (instancetype)instance;
+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;

- (void)triggerLeftArrowPress;
- (void)triggerRightArrowPress;
- (void)triggerUpArrowPress;
- (void)triggerDownArrowPress;

@end
