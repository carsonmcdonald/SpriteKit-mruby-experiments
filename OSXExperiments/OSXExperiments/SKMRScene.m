#import "SKMRScene.h"
#import "SKMRUtils.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRScene

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrSceneClass = mrb_define_class_under(mrb, skmrModule, "Scene", mrb->object_class);
    
    mrb_define_method(mrb, skmrSceneClass, "initialize", skmr_scene_init, MRB_ARGS_REQ(2));
    mrb_define_method(mrb, skmrSceneClass, "background_color=", set_background_color, MRB_ARGS_REQ(1));
}

+ (SKMRScene *)fetchStoredScene:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKMRScene *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrSceneData")), &skmr_scene_type));
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.scaleMode = SKSceneScaleModeAspectFit;
    }
    return self;
}

#pragma mark - Private

static void skmr_scene_free(mrb_state *mrb, void *obj)
{
    SKMRScene *skmrScene = (__bridge SKMRScene *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrScene));
}

static const struct mrb_data_type skmr_scene_type = {
    "skmrSceneData", skmr_scene_free,
};

static mrb_value skmr_scene_init(mrb_state *mrb, mrb_value obj)
{
    mrb_int height = 0;
    mrb_int width = 0;
    mrb_get_args(mrb, "ii", &width, &height);
    
    SKMRScene *scene = [[SKMRScene alloc] initWithSize:CGSizeMake(width, height)];
    
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrSceneData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_scene_type, (void*) CFBridgingRetain(scene))));
    
    return obj;
}

static mrb_value set_background_color(mrb_state *mrb, mrb_value obj)
{
    const char *bgColor;
    mrb_get_args(mrb, "z", &bgColor);
    
    SKMRScene *scene = (__bridge SKMRScene *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrSceneData")), &skmr_scene_type));
    scene.backgroundColor = [SKMRUtils convertHexStringToSKColor:[NSString stringWithUTF8String:bgColor]];
    
    return obj;
}

@end
