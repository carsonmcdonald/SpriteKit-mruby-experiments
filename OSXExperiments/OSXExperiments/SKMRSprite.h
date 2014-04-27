#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRSprite : SKSpriteNode

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;

@end
