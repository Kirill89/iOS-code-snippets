SimpleGallery
=================

Example
--------------

```objective-c
GSTGalleryView *gallery = [[GSTGalleryView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
[gallery.images addObject:[UIImage imageNamed:@"images-1.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-2.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-3.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-4.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-5.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-6.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-7.jpeg"]];
[gallery redrawView];

[self.view addSubview: gallery];
```
