#!/bin/sh
title=$1
author=$2
mkdir temporary/$title
cp -r template/ebook temporary/$title
rm temporary/$title/ebook/item/xhtml/page.xhtml
rm temporary/$title/ebook/item/images/.gitkeep
standard=$(cat temporary/$title/ebook/item/standard.opf)
pagetemp=$(cat template/ebook/item/xhtml/page.xhtml)
standard=$(echo "$standard" | sed -e "s/<!--title-->/$title/g" -e "s/<!--creator-->/$author/g")
for pathfile in `ls ./input`; do
    cp ./input/$pathfile temporary/$title/ebook/item/images/
    page=$(echo "$pagetemp" | sed \
    -e "s/<!--imagepath-->/..\/images\/$pathfile/g" \
    -e "s/<!--title-->/$title/g")
    fileinfo=$(file temporary/$title/ebook/item/images/$pathfile)
    filetype=$(echo $fileinfo | awk -F'[:,]' '{print $2}')
    if [ "$filetype" = " JPEG image data" ]; then
        resolution=$(echo $fileinfo | awk -F'[:,]' '{print $9}')
        width=$(echo $resolution | awk -F'[ x]' '{print $1}')
        height=$(echo $resolution | awk -F'[ x]' '{print $2}')
        page=$(echo "$page" | sed -e "s/<!--viewport-->/<meta name=\"viewport\" content=\"width=$width, height=$height\" \/>/g")
    elif [ "$filetype" = " PNG image data" ]; then
        resolution=$(echo $fileinfo | awk -F'[:,]' '{print $3}')
        width=$(echo $resolution | awk -F'[ x]' '{print $1}')
        height=$(echo $resolution | awk -F'[ x]' '{print $4}')
        page=$(echo "$page" | sed -e "s/<!--viewport-->/<meta name=\"viewport\" content=\"width=$width, height=$height\" \/>/g")
    fi
    echo "$page" > temporary/$title/ebook/item/xhtml/$pathfile.xhtml
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