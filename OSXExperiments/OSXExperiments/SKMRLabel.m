#import "SKMRLabel.h"

#import "SKMRUtils.h"
#import "SKMRNode.h"

#import <MRuby/mruby/variable.h>
#import <MRuby/mruby/data.h>
#import <MRuby/mruby/proc.h>
#import <MRuby/mruby/array.h>

@implementation SKMRLabel

+ (void)registerModule:(mrb_state *)mrb withRootModule:(struct RClass *)skmrModule
{
    struct RClass* skmrLabelClass = mrb_define_class_under(mrb, skmrModule, "Label", mrb_class_get_under(mrb, skmrModule, "Node"));
    
    mrb_define_method(mrb, skmrLabelClass, "initialize", skmr_label_init, MRB_ARGS_NONE());
    mrb_define_method(mrb, skmrLabelClass, "font_color=", set_font_color, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrLabelClass, "font_size=", set_font_size, MRB_ARGS_REQ(1));
    mrb_define_method(mrb, skmrLabelClass, "text=", set_text, MRB_ARGS_REQ(1));
}

#pragma mark - Private

static mrb_value skmr_label_init(mrb_state *mrb, mrb_value obj)
{
    SKMRLabel *label = [[SKMRLabel alloc] init];
    
    [SKMRNode setStoredNode:label withMRB:mrb fromObject:obj];
    
    return obj;
}

static mrb_value set_text(mrb_state *mrb, mrb_value obj)
{
    const char *bgColor;
    mrb_get_args(mrb, "z", &bgColor);
    
    SKLabelNode *label = (SKLabelNode *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    label.text = [NSString stringWithUTF8String:bgColor];
    
    return mrb_nil_value();
}

static mrb_value set_font_color(mrb_state *mrb, mrb_value obj)
{
    const char *color;
    mrb_get_args(mrb, "z", &color);
    
    SKLabelNode *label = (SKLabelNode *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    label.fontColor = [SKMRUtils convertHexStringToSKColor:[NSString stringWithUTF8String:color]];
    
    return mrb_nil_value();
}

static mrb_value set_font_size(mrb_state *mrb, mrb_value obj)
{
    mrb_int fontSize;
    mrb_get_args(mrb, "i", &fontSize);
    
    SKLabelNode *label = (SKLabelNode *)[SKMRNode fetchStoredNode:mrb fromObject:obj];
    label.fontSize = fontSize;
    
    return mrb_nil_value();
}

@end
