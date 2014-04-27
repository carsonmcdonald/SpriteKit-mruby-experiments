#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRLabel : SKLabelNode

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;

@end
