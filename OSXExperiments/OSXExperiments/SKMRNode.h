#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRNode : NSObject

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;
+ (SKNode *)fetchStoredNode:(mrb_state *)mrb fromObject:(mrb_value)obj;
+ (void)setStoredNode:(SKNode *)node withMRB:(mrb_state *)mrb fromObject:(mrb_value)obj;

@end