SimpleGallery
=================

Example
--------------

```objective-c
GSTGalleryView *gallery = [[GSTGalleryView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
[gallery.images addObject:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/5/57/Galunggung.jpg"]];
[gallery.images addObject:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-1.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-2.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-3.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-4.jpeg"]];
[gallery.images addObject:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/1/1a/Bachalpseeflowers.jpg"]];
[gallery.images addObject:@"images-5.jpeg"];
[gallery.images addObject:[UIImage imageNamed:@"images-6.jpeg"]];
[gallery.images addObject:[UIImage imageNamed:@"images-7.jpeg"]];

[gallery redrawView];
[self.view addSubview: gallery];
```

Dependencies
--------------
1. https://github.com/rs/SDWebImage
