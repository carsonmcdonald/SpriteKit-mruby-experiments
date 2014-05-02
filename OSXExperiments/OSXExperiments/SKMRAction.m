#import "SKMRAction.h"

#import "SKMRTexture.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRAction

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrActionClass = mrb_define_class_under(mrb, skmrModule, "Action", mrb->object_class);
    
    mrb_define_class_method(mrb, skmrActionClass, "create_move_by", create_move_by, MRB_ARGS_REQ(2));
    mrb_define_class_method(mrb, skmrActionClass, "create_texture_animation", create_texture_animation, MRB_ARGS_REQ(2));
    mrb_define_class_method(mrb, skmrActionClass, "create_repeat", create_repeat, MRB_ARGS_REQ(2));
    mrb_define_class_method(mrb, skmrActionClass, "create_repeat_forever", create_repeat_forever, MRB_ARGS_REQ(1));
}

+ (SKAction *)fetchStoredAction:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKMRAction *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_action_type));
}

#pragma mark - Private

static void skmr_action_free(mrb_state *mrb, void *obj)
{
    SKMRAction *skmrAction = (__bridge SKMRAction *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrAction));
}

static const struct mrb_data_type skmr_action_type = {
    "skmrNodeData", skmr_action_free,
};

static mrb_value create_move_by(mrb_state *mrb, mrb_value obj)
{
    mrb_float x, y, d;
    mrb_get_args(mrb, "fff", &x, &y, &d);
    
    mrb_value mrbAction = mrb_class_new_instance(mrb, 0, NULL, mrb_obj_class(mrb, obj));
    
    SKAction *action = [SKAction moveByX:x y:y duration:d];
    
    mrb_iv_set(mrb, mrbAction, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_action_type, (void*) CFBridgingRetain(action))));
    
    return mrbAction;
}

static mrb_value create_texture_animation(mrb_state *mrb, mrb_value obj)
{
    mrb_value textures;
    mrb_float duration;
    mrb_get_args(mrb, "Af", &textures, &duration);
    
    mrb_int textureCount = mrb_ary_len(mrb, textures);
    
    NSMutableArray *textureArr = [[NSMutableArray alloc] initWithCapacity:textureCount];
    for(int i=0; i<textureCount; i++)
    {
        mrb_value texture = mrb_ary_ref(mrb, textures, i);
        [textureArr addObject:[SKMRTexture fetchStoredTexture:mrb fromObject:texture]];
    }
    
    mrb_value mrbAction = mrb_class_new_instance(mrb, 0, NULL, mrb_obj_class(mrb, obj));

    SKAction *action = [SKAction animateWithTextures:textureArr timePerFrame:duration];
    
    mrb_iv_set(mrb, mrbAction, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_action_type, (void*) CFBridgingRetain(action))));
    
    return mrbAction;
}

static mrb_value create_repeat(mrb_state *mrb, mrb_value obj)
{
    mrb_value actionToRepeat;
    mrb_int count;
    mrb_get_args(mrb, "oi", &actionToRepeat, &count);
    
    mrb_value mrbAction = mrb_class_new_instance(mrb, 0, NULL, mrb_obj_class(mrb, obj));
    
    SKAction *action = [SKAction repeatAction:[SKMRAction fetchStoredAction:mrb fromObject:actionToRepeat] count:count];
    
    mrb_iv_set(mrb, mrbAction, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_action_type, (void*) CFBridgingRetain(action))));
    
    return mrbAction;
}

static mrb_value create_repeat_forever(mrb_state *mrb, mrb_value obj)
{
    mrb_value actionToRepeat;
    mrb_get_args(mrb, "o", &actionToRepeat);
    
    mrb_value mrbAction = mrb_class_new_instance(mrb, 0, NULL, mrb_obj_class(mrb, obj));
    
    SKAction *action = [SKAction repeatActionForever:[SKMRAction fetchStoredAction:mrb fromObject:actionToRepeat]];
    
    mrb_iv_set(mrb, mrbAction, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_action_type, (void*) CFBridgingRetain(action))));
    
    return mrbAction;
}

@end
