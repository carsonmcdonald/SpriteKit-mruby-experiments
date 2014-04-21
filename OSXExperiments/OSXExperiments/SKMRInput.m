#import "SKMRInput.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRInput

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SKMRInput *instance;
    dispatch_once(&once, ^ { instance = [[self alloc] init]; });
    return instance;
}

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrInputModule = mrb_define_module_under(mrb, skmrModule, "Input");
    
    SKMRInput *input = [self instance];
    
    mrb_mod_cv_set(mrb, skmrInputModule, mrb_intern_lit(mrb, "skmrInputData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_input_type, (void*) CFBridgingRetain(input))));
    
    mrb_define_class_method(mrb, skmrInputModule, "left_arrow_pressed", get_left_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "right_arrow_pressed", get_right_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "up_arrow_pressed", get_up_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "down_arrow_pressed", get_down_arrow_pressed, MRB_ARGS_NONE());
}

#pragma mark - Private

static void skmr_input_free(mrb_state *mrb, void *obj)
{
    SKMRInput *skmrInput = (__bridge SKMRInput *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrInput));
}

static const struct mrb_data_type skmr_input_type = {
    "skmrInputData", skmr_input_free,
};

static mrb_value get_left_arrow_pressed(mrb_state *mrb, mrb_value obj)
{
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    
    return mrb_bool_value(input.leftArrowPressed);
}

static mrb_value get_right_arrow_pressed(mrb_state *mrb, mrb_value obj)
{
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    
    return mrb_bool_value(input.rightArrowPressed);
}
static mrb_value get_up_arrow_pressed(mrb_state *mrb, mrb_value obj)
{
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    
    return mrb_bool_value(input.upArrowPressed);
}
static mrb_value get_down_arrow_pressed(mrb_state *mrb, mrb_value obj)
{
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    
    return mrb_bool_value(input.downArrowPressed);
}

@end
