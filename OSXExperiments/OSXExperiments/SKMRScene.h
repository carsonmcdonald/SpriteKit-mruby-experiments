#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRScene : SKScene

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;
+ (SKMRScene *)fetchStoredScene:(mrb_state *)mrb fromObject:(mrb_value)obj;

@end
