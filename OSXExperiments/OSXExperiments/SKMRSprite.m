#import "SKMRSprite.h"

#import "SKMRUtils.h"
#import "SKMRAction.h"
#import "SKMRNode.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRSprite

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrSpriteClass = mrb_define_class_under(mrb, skmrModule, "Sprite", mrb_class_get_under(mrb, skmrModule, "Node"));
    
    mrb_define_method(mrb, skmrSpriteClass, "initialize", skmr_sprite_init, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrSpriteClass, "color=", set_color, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrSpriteClass, "color_blend_factor=", set_color_blend_factor, MRB_ARGS_REQ(1));
}

+ (SKMRSprite *)fetchStoredSprite:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (SKMRSprite *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
}

#pragma mark - Private

static mrb_value skmr_sprite_init(mrb_state *mrb, mrb_value obj)
{
    const char *imageName;
    mrb_get_args(mrb, "z", &imageName);
    
    SKMRSprite *sprite = [[SKMRSprite alloc] initWithImageNamed:[NSString stringWithUTF8String:imageName]];
    
    [SKMRNode setStoredNode:sprite withMRB:mrb fromObject:obj];
    
    return obj;
}

static mrb_value set_color(mrb_state *mrb, mrb_value obj)
{
    const char *color;
    mrb_get_args(mrb, "z", &color);
    
    SKSpriteNode *sprite = (SKSpriteNode *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    sprite.color = [SKMRUtils convertHexStringToSKColor:[NSString stringWithUTF8String:color]];
    
    return mrb_nil_value();
}

static mrb_value set_color_blend_factor(mrb_state *mrb, mrb_value obj)
{
    mrb_float cbf;
    mrb_get_args(mrb, "f", &cbf);
    
    SKSpriteNode *sprite = (SKSpriteNode *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    sprite.colorBlendFactor = cbf;
    
    return mrb_nil_value();
}

@end
