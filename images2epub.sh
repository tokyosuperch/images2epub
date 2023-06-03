#!/bin/sh
title=$1
author=$2
mkdir temporary/$title
cp -r template/ebook temporary/$title
rm temporary/$title/ebook/item/xhtml/page.xhtml
rm temporary/$title/ebook/item/images/.gitkeep
standard=$(cat temporary/$title/ebook/item/standard.opf)
page=$(cat template/ebook/item/xhtml/page.xhtml)
standard=$(echo "$standard" | sed -e "s/<!--title-->/$title/g" -e "s/<!--creator-->/$author/g")
for pathfile in `ls ./input`; do
    cp ./input/$pathfile temporary/$title/ebook/item/images/
    echo "$page" | sed -e "s/<!--imagepath-->/..\/images\/$pathfile/g" -e "s/<!--title-->/$title/g" > temporary/$title/ebook/item/xhtml/$pathfile.xhtml
    standard=$(echo "$standard" | sed \
    -e "s/<!--xhtml+xml-->/<item media-type=\"application\/xhtml+xml\" id=\"$pathfile\" href=\"xhtml\/$pathfile.xhtml\"\/>\n<!--xhtml+xml-->/g" \
    -e "s/<!--itemref-->/<itemref idref=\"$pathfile\" \/>\n<!--itemref-->/g")
done
echo "$standard" > temporary/$title/ebook/item/standard.opf
cd ./temporary/$title/
zip -r ../../output/$title.epub ebook
zip -0 ../../output/$title.epub ebook/mimetype 
cd ../..
rm -rf ./temporary/$title