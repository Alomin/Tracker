#import "AnnotationSettingViewController.h"
#import "UIKit/UIImagePickerController.h"
#import <UIKit/UITableView.h>

@interface AnnotationSettingViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AnnotationSettingViewController

- (IBAction)CancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    
    if([sender.view isKindOfClass:[UIImageView class]]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}
- (void)viewDidLoad {
    [self.titleTextField setText:self.inputKeyPoint.title];
    [self.contentTextView setText:self.inputKeyPoint.content];
    [self.imageView setImage:self.inputKeyPoint.photo];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.outputKeyPoint = [[KeyPoint alloc] init];
    self.outputKeyPoint.title = self.titleTextField.text;
    self.outputKeyPoint.content = self.contentTextView.text;
    self.outputKeyPoint.photo = self.imageView.image;
    self.outputKeyPoint.latitude = self.inputKeyPoint.latitude;
    self.outputKeyPoint.longitude = self.inputKeyPoint.longitude;
}

@end
