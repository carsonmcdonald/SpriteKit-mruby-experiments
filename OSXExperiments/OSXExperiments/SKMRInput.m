#import "SKMRInput.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>

@implementation SKMRInput
{
    mrb_state *currentMRB;
    
    mrb_value onLeftArrowPressBlock;
    mrb_value onRightArrowPressBlock;
    mrb_value onUpArrowPressBlock;
    mrb_value onDownArrowPressBlock;
}

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
    input->currentMRB = mrb;
    
    mrb_mod_cv_set(mrb, skmrInputModule, mrb_intern_lit(mrb, "skmrInputData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_input_type, (void*) CFBridgingRetain(input))));
    
    mrb_define_class_method(mrb, skmrInputModule, "left_arrow_pressed", get_left_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "right_arrow_pressed", get_right_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "up_arrow_pressed", get_up_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "down_arrow_pressed", get_down_arrow_pressed, MRB_ARGS_NONE());
    mrb_define_class_method(mrb, skmrInputModule, "on_left_arrow_press", on_left_arrow_press, MRB_ARGS_BLOCK());
    mrb_define_class_method(mrb, skmrInputModule, "on_right_arrow_press", on_right_arrow_press, MRB_ARGS_BLOCK());
    mrb_define_class_method(mrb, skmrInputModule, "on_up_arrow_press", on_up_arrow_press, MRB_ARGS_BLOCK());
    mrb_define_class_method(mrb, skmrInputModule, "on_down_arrow_press", on_down_arrow_press, MRB_ARGS_BLOCK());
}

- (instancetype)init
{
    if (self = [super init])
    {
        onLeftArrowPressBlock = mrb_nil_value();
        onRightArrowPressBlock = mrb_nil_value();
        onUpArrowPressBlock = mrb_nil_value();
        onDownArrowPressBlock = mrb_nil_value();
    }
    return self;
}

- (void)triggerLeftArrowPress
{
    if(!mrb_nil_p(onLeftArrowPressBlock))
    {
        mrb_yield(currentMRB, onLeftArrowPressBlock, mrb_nil_value());
    }
}

- (void)triggerRightArrowPress
{
    if(!mrb_nil_p(onRightArrowPressBlock))
    {
        mrb_yield(currentMRB, onRightArrowPressBlock, mrb_nil_value());
    }
}

- (void)triggerUpArrowPress
{
    if(!mrb_nil_p(onUpArrowPressBlock))
    {
        mrb_yield(currentMRB, onUpArrowPressBlock, mrb_nil_value());
    }
}

- (void)triggerDownArrowPress
{
    if(!mrb_nil_p(onDownArrowPressBlock))
    {
        mrb_yield(currentMRB, onDownArrowPressBlock, mrb_nil_value());
    }
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

static mrb_value on_left_arrow_press(mrb_state *mrb, mrb_value obj)
{
    mrb_value onLeftArrowPressBlock;
    mrb_get_args(mrb, "&", &onLeftArrowPressBlock);
    
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    input->onLeftArrowPressBlock = onLeftArrowPressBlock;
    
    return obj;
}

static mrb_value on_right_arrow_press(mrb_state *mrb, mrb_value obj)
{
    mrb_value onRightArrowPressBlock;
    mrb_get_args(mrb, "&", &onRightArrowPressBlock);
    
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    input->onRightArrowPressBlock = onRightArrowPressBlock;
    
    return obj;
}

static mrb_value on_up_arrow_press(mrb_state *mrb, mrb_value obj)
{
    mrb_value onUpArrowPressBlock;
    mrb_get_args(mrb, "&", &onUpArrowPressBlock);
    
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    input->onUpArrowPressBlock = onUpArrowPressBlock;
    
    return obj;
}

static mrb_value on_down_arrow_press(mrb_state *mrb, mrb_value obj)
{
    mrb_value onDownArrowPressBlock;
    mrb_get_args(mrb, "&", &onDownArrowPressBlock);
    
    SKMRInput *input = (__bridge SKMRInput *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrInputData")), &skmr_input_type));
    input->onDownArrowPressBlock = onDownArrowPressBlock;
    
    return obj;
}

@end
