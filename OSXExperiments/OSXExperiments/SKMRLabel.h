#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRLabel : SKLabelNode

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;
+ (SKMRLabel *)fetchStoredLabel:(mrb_state *)mrb fromObject:(mrb_value)obj;

@end
