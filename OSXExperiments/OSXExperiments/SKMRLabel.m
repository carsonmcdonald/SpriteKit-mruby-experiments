#import "SKMRLabel.h"

#import "SKMRUtils.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRLabel

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrLabelClass = mrb_define_class_under(mrb, skmrModule, "Label", mrb->object_class);
    
    mrb_define_method(mrb, skmrLabelClass, "initialize", skmr_label_init, MRB_ARGS_NONE());
    mrb_define_method(mrb, skmrLabelClass, "font_color=", set_font_color, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrLabelClass, "font_size=", set_font_size, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrLabelClass, "text=", set_text, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrLabelClass, "position=", set_position, MRB_ARGS_REQ(1));
}

+ (SKMRLabel *)fetchStoredLabel:(mrb_state *)mrb fromObject:(mrb_value)obj
{
    return (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
}

#pragma mark - Private

static void skmr_label_free(mrb_state *mrb, void *obj)
{
    SKMRLabel *skmrLabel = (__bridge SKMRLabel *)obj;
    CFBridgingRelease((__bridge CFTypeRef)(skmrLabel));
}

static const struct mrb_data_type skmr_label_type = {
    "skmrNodeData", skmr_label_free,
};

static mrb_value skmr_label_init(mrb_state *mrb, mrb_value obj)
{
    SKMRLabel *label = [[SKMRLabel alloc] init];
    
    mrb_iv_set(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData"), mrb_obj_value(Data_Wrap_Struct(mrb, mrb->object_class, &skmr_label_type, (void*) CFBridgingRetain(label))));
    
    return obj;
}

static mrb_value set_text(mrb_state *mrb, mrb_value obj)
{
    const char *bgColor;
    mrb_get_args(mrb, "z", &bgColor);
    
    SKMRLabel *label = (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
    label.text = [NSString stringWithUTF8String:bgColor];
    
    return mrb_nil_value();
}

static mrb_value set_font_color(mrb_state *mrb, mrb_value obj)
{
    const char *color;
    mrb_get_args(mrb, "z", &color);
    
    SKMRLabel *label = (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
    label.fontColor = [SKMRUtils convertHexStringToSKColor:[NSString stringWithUTF8String:color]];
    
    return mrb_nil_value();
}

static mrb_value set_font_size(mrb_state *mrb, mrb_value obj)
{
    mrb_int fontSize;
    mrb_get_args(mrb, "i", &fontSize);
    
    SKMRLabel *label = (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
    label.fontSize = fontSize;
    
    return mrb_nil_value();
}

static mrb_value set_position(mrb_state *mrb, mrb_value obj)
{
    mrb_value positionXY;
    mrb_get_args(mrb, "A", &positionXY);
    
    mrb_float x = mrb_float(mrb_ary_ref(mrb, positionXY, 0));
    mrb_float y = mrb_float(mrb_ary_ref(mrb, positionXY, 1));
    
    SKMRLabel *label = (__bridge SKMRLabel *)(mrb_data_get_ptr(mrb, mrb_iv_get(mrb, obj, mrb_intern_lit(mrb, "skmrNodeData")), &skmr_label_type));
    label.position = CGPointMake(x, y);
    
    return mrb_nil_value();
}

@end
