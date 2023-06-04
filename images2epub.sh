#!/bin/sh

# For Unix Systems
identify=identify
# For Windows Git Bash
# identify="magick identify"

title=$1
author=$2
mkdir "temporary/$title"
cp -r template/ebook "temporary/$title"
rm "temporary/$title/ebook/item/xhtml/page.xhtml"
rm "temporary/$title/ebook/item/images/.gitkeep"
standard=$(cat "temporary/$title/ebook/item/standard.opf")
pagetemp=$(cat template/ebook/item/xhtml/page.xhtml)
standard=$(echo "$standard" | sed -e "s/<!--title-->/$title/g" -e "s/<!--creator-->/$author/g")
for pathfile in `ls ./input`; do
    cp "./input/$pathfile" "temporary/$title/ebook/item/images/"
    page=$(echo "$pagetemp" | sed \
    -e "s/<!--imagepath-->/..\/images\/$pathfile/g" \
    -e "s/<!--title-->/$title/g")
    resolution=$($identify -format '%w,%h' "temporary/$title/ebook/item/images/$pathfile")
    width=$(echo $resolution | awk -F'[,]' '{print $1}')
    height=$(echo $resolution | awk -F'[,]' '{print $2}')
    if [ "$width" != '' ] && [ "$height" != '' ]; then
        page=$(echo "$page" | sed -e "s/<!--viewport-->/<meta name=\"viewport\" content=\"width=$width, height=$height\" \/>/g")
    fi
    echo "$page" > "temporary/$title/ebook/item/xhtml/$pathfile.xhtml"
    standard=$(echo "$standard" | sed \
    -e "s/<!--xhtml+xml-->/<item media-type=\"application\/xhtml+xml\" id=\"$pathfile\" href=\"xhtml\/$pathfile.xhtml\"\/>\n<!--xhtml+xml-->/g" \
    -e "s/<!--itemref-->/<itemref idref=\"$pathfile\" \/>\n<!--itemref-->/g")
    echo "$pathfile added."
done
echo "$standard" > "temporary/$title/ebook/item/standard.opf"
cd "./temporary/$title/"
zip -r "../../output/$title.epub" ebook
zip -0 "../../output/$title.epub" ebook/mimetype 
cd ../..
rm -rf "./temporary/$title"