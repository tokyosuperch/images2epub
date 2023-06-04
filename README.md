# images2epub

Converts image files to epub document.  

## Usage

1. Store image files with sequential file names, to "input" directory.  

2. Execute script with this command.  
```
$ ./images2epub.sh TITLE AUTHOR
```

3. Epub file will be stored to "output/TITLE.epub".  

## Requirements

[ImageMagick](https://github.com/ImageMagick/ImageMagick) installed & set to PATH  
  
### For Windows (Git Bash) Users

1. Install Windows version of ImageMagick (Don't forget to set to PATH)
2. Uncomment Line 6 of images2epub.sh
