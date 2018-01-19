# ImageLibrarySwift

Simple library written in swift to zoom images. Image array can contain UIImage object and URL string both.
Pan down to close.

To integrate, add ImageLibraryViewController.swift to your project.

Note: This library uses SDWebImage for downloading network images.

Installation:

- install SDWebImage (pod 'SDWebImage', '~>3.8')
- drag ImageLibraryViewController.swift to your project


        let library = ImageLibraryViewController()
        library.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        library.arrayImages = [UIImage.init(named: "random.jpg")!,"https://i.ytimg.com/vi/PCwL3-hkKrg/maxresdefault.jpg",UIImage.init(named: "random.jpg")!]
        library.showBottomBar = true // optional bottom bar
        library.selectedIndex = 0 // to start the library from any particular index. Defaults to first image.
        self.present(library, animated: true) {
            
        }

<a href="https://imgflip.com/gif/22yrtn"><img src="https://i.imgflip.com/22yrtn.gif" title="made at imgflip.com"/></a>
