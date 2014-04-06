#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRScene : SKScene

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;

@end
