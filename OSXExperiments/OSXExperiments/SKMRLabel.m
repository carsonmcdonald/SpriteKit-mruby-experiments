#import "SKMRLabel.h"

#import "SKMRUtils.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>

@implementation SKMRLabel

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrLabelClass = mrb_define_class_under(mrb, skmrModule, "Label", mrb->object_class);
    
    mrb_define_method(mrb, skmrLabelClass, "initialize", skmr_label_init, MRB_ARGS_NONE());
}

+ (SKMRLabel *)fetchStoredLabel:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_cv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
}

#pragma mark - Private

static void skmr_label_free(mrb_state *mrb, void *obj)
{
    SKMRLabel *skmrLabel = (__bridge SKMRLabel *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrLabel));
}

static const struct mrb_data_type skmr_label_type = {
    "skmrLabelData", skmr_label_free,
};

static mrb_value skmr_label_init(mrb_state *mrb, mrb_value obj)
{
    SKMRLabel *label = [[SKMRLabel alloc] init];
    
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_label_type, (void*) CFBridgingRetain(label))));
    
    return obj;
}

@end
