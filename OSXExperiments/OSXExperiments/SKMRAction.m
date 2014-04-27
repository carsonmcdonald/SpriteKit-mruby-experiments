#import "SKMRAction.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRAction

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrActionClass = mrb_define_class_under(mrb, skmrModule, "Action", mrb->object_class);
    
    mrb_define_class_method(mrb, skmrActionClass, "create_move_by", create_move_by, MRB_ARGS_REQ(2));
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

@end
