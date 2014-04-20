#import "SKMRSprite.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRSprite

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrSpriteClass = mrb_define_class_under(mrb, skmrModule, "Sprite", mrb->object_class);
    
    mrb_define_method(mrb, skmrSpriteClass, "initialize", skmr_sprite_init, MRB_ARGS_REQ(1));
    // todo mrb_define_method(mrb, skmrLabelClass, "position=", set_position, MRB_ARGS_REQ(1));
}

+ (SKMRSprite *)fetchStoredSprite:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKMRSprite *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_sprite_type));
}

#pragma mark - Private

static void skmr_sprite_free(mrb_state *mrb, void *obj)
{
    SKMRSprite *skmrSprite = (__bridge SKMRSprite *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrSprite));
}

static const struct mrb_data_type skmr_sprite_type = {
    "skmrNodeData", skmr_sprite_free,
};

static mrb_value skmr_sprite_init(mrb_state *mrb, mrb_value obj)
{
    const char *imageName;
    mrb_get_args(mrb, "z", &imageName);
    
    SKMRSprite *sprite = [[SKMRSprite alloc] initWithImageNamed:[NSString stringWithUTF8String:imageName]];
    
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_sprite_type, (void*) CFBridgingRetain(sprite))));
    
    return obj;
}


@end
