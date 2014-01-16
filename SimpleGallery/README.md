SimpleGallery
=================

Example
--------------

```objective-c
GSTGalleryView *gallery = [[GSTGalleryView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
[gallery.images addObject:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/5/57/Galunggung.jpg"]]; // you can load image directly from web
[gallery.images addObject:[UIImage imageNamed:@"images-1.jpeg"]]; // or use existing UIImage
[gallery.images addObject:@"images-2.jpeg"]; // or from resource by name

[gallery redrawView];
[self.view addSubview: gallery];
```

Dependencies
--------------
1. https://github.com/rs/SDWebImage
