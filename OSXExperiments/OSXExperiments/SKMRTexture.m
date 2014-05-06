#import "SKMRTexture.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRTexture

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrTextureClass = mrb_define_class_under(mrb, skmrModule, "Texture", mrb->object_class);
    
    mrb_define_method(mrb, skmrTextureClass, "initialize", skmr_texture_init, MRB_ARGS_REQ(1));
}

+ (SKTexture *)fetchStoredTexture:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKTexture *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrTextureData")), &skmr_texture_type));
}

#pragma mark - Private

static void skmr_texture_free(mrb_state *mrb, void *obj)
{
    SKTexture *texture = (__bridge SKTexture *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(texture));
}

static const struct mrb_data_type skmr_texture_type = {
    "skmrTextureData", skmr_texture_free,
};

static mrb_value skmr_texture_init(mrb_state *mrb, mrb_value obj)
{
    const char *imageName = NULL;
    mrb_get_args(mrb, "z", &imageName);
    
    SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithUTF8String:imageName]];
    
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrTextureData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_texture_type, (void*) CFBridgingRetain(texture))));
    
    return obj;
}

@end
