#import <SpriteKit/SpriteKit.h>

#import <MRuby/MRuby.h>

@interface SKMRTexture : SKTexture

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule;
+ (SKTexture *)fetchStoredTexture:(mrb_state *)mrb fromObject:(mrb_value)obj;

@end
