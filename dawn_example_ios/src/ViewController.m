#import "ViewController.h"
#import "MyUIView.h"

@interface ViewController ()
{
    //CppInterface* i;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //i = [[CppInterface alloc]init];
    
    //[self.view setBackgroundColor:UIColor.redColor];
    
    MyUIView* v = [[MyUIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.view addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
