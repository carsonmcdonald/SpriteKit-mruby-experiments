#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRAction : SKAction

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;
+ (SKAction *)fetchStoredAction:(mrb_state *)mrb fromObject:(mrb_value)obj;

@end
