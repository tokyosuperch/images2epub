#!/bin/sh
title=$1
author=$2
mkdir temporary/$title
cp -r template/ebook temporary/$title
rm temporary/$title/ebook/item/xhtml/page.xhtml
rm temporary/$title/ebook/item/images/.gitkeep
sed -i -e "s/<!--title-->/$title/g" -e "s/<!--creator-->/$author/g" temporary/$title/ebook/item/standard.opf
for pathfile in `ls ./input`; do
    cp ./input/$pathfile temporary/$title/ebook/item/images/
    cat template/ebook/item/xhtml/page.xhtml | sed -e "s/<!--imagepath-->/..\/images\/$pathfile/g" -e "s/<!--title-->/$title/g" > temporary/$title/ebook/item/xhtml/$pathfile.xhtml
    sed -i -e "s/<!--title-->/$title/g" temporary/$title/ebook/item/xhtml/$pathfile.xhtml
    sed -i \
    -e "s/<!--xhtml+xml-->/<item media-type=\"application\/xhtml+xml\" id=\"$pathfile\" href=\"xhtml\/$pathfile.xhtml\"\/>\r\n<!--xhtml+xml-->/g" \
    -e "s/<!--itemref-->/<itemref idref=\"$pathfile\" \/>\r\n<!--itemref-->/g" \
    temporary/$title/ebook/item/standard.opf
done
cd ./temporary/$title/
zip -r ../../output/$title.epub ebook
zip -0 ../../output/$title.epub ebook/mimetype 
cd ../..
rm -rf ./temporary/$title