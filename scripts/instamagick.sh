#!/bin/bash

# =================================================================== #
# Script to easily resize and watermark pictures using ImageMagick.   #
#                                                                     #
#   Call this script and point it to the PATH of the picture          #
#   with the FIRST ARGUMENT after the script call.                    #
#                                                                     #
# Brecht Van Eeckhoudt - 08/09/2019 (development started 22/08/2019)  #
# Written on Ubuntu 19.04                                             #
# =================================================================== #

# Version of this script (date)
version="08/09/2019"

# Location of the font to use for watermarking
fontLocation="/home/brecht/.fonts/BebasNeue Book.otf"



# TODO (future improvements):
#  - Simplify code (more variables and less copy-paste of code...)
#  - Bulk selection? ("-d " argument, DIRECTORY)
#  - Add metadata (with other command line utility :/ )
#  - Add small white borders to left and right of instagram pictures?
#    -bordercolor white -border 5x0



# ============================== #
# FUNCTION TO CHECK ASPECT RATIO #
#                                #
#   If the input and output      #
#   aspect ratio are NOT the     #
#   same this will ask for a     #
#   "gravity" option.            #
#                                #
#   Arguments:                   #
#     - $1 = input width         #
#     - $2 = input height        #
#     - $3 = output width        #
#     - $4 = output height       #
# ============================== #

# Default "gravity" option
selectedGravity="center"

checkAspectRatio () {
    # "bc" used for floating point arithmetic, "scale=2" = required precision
    # "* 100 / 1" for later integer comparasion

    # TODO: This doesn't seem necessary (kept here just in case)
    #inputRatio=$(echo "scale=2 ; $1 / $2" | bc)
    #inputRatio=$(echo "$inputRatio * 100 / 1" | bc)
    #outputRatio=$(echo "scale=2 ; $3 / $4" | bc)
    #outputRatio=$(echo "$outputRatio * 100 / 1" | bc)
    #
    #echo DEBUG: inputRatio = $inputRatio
    #echo DEBUG: outputRatio = $outputRatio
    # TODO: End uneccesary code

    # Calculate the ratio's of the width and height to determine what needs to be cut
    widthRatio=$(echo "scale=2 ; $1 / $3" | bc)
    widthRatio=$(echo "$widthRatio * 100 / 1" | bc)
    heightRatio=$(echo "scale=2 ; $2 / $4" | bc)
    heightRatio=$(echo "$heightRatio * 100 / 1" | bc)

    # Ask for a "gravity" used to crop the picture if the ratio's don't match
    # Double brackets to activate the aritmetic context
    if (( widthRatio != heightRatio )); then

        # echo "-e" for enabling escape sequences
        #   - "\e[1m"  = bold
        #   - "\e[93m" = light yellow
        #   - "\e[0m"  = reset all attributes

        # We can crop from the top, center or bottom
        if (( widthRatio < heightRatio )); then
            echo -e "\e[93mIn- and output aspect-ratio are not the same!"
            echo "Please select a direction to crop the picture."
            echo "  Options: 't' = Top"
            echo "           'c' = Center (default)"
            echo "           'b' = Bottom"

            # "$" to enable the use of the color escape sequence
            read -p $'Selected option: \e[0m' gravity

            case $gravity in
                # Top
                't'|'T')
                    selectedGravity="north"
                    ;;

                # Center ('' = enter without character)
                ''|'c'|'C')
                    selectedGravity="center"
                    ;;

                # Bottom
                'b'|'B')
                    selectedGravity="south"
                    ;;
                
                # Unkown option
                *)
                    echo -e "\e[91mERROR: Unknown option selected.\e[0m"
                    selectedGravity="center"
                    ;;
            esac

        # We can crop from the left, center and right
        else
            echo -e "\e[93mIn- and output aspect-ratio are not the same!"
            echo "Please select a direction to crop the picture."
            echo "  Options: 'l' = Left"
            echo "           'c' = Center (default)"
            echo "           'r' = Right"    

            # "$" to enable the use of the color escape sequence
            read -p $'Selected option: \e[0m' gravity

            case $gravity in
                # Left
                'l'|'L')
                    selectedGravity="west"
                    ;;

                # Center ('' = enter without character)
                ''|'c'|'C')
                    selectedGravity="center"
                    ;;

                # Right
                'r'|'R')
                    selectedGravity="east"
                    ;;

                # Unkown option
                *)
                    echo -e "\e[91mERROR: Unknown option selected.\e[0m"
                    selectedGravity="center"
                    ;;
            esac

        fi

        echo # Blank line
    fi
}


# ===================== #
# PRINT WELCOME MESSAGE #
# ===================== #

echo # Blank line
echo -e "\e[1m\e[93mInstaMagick // Image resizing/watermarking script using ImageMagick\e[0m"
echo -e "\e[1m\e[93m(Brecht Van Eeckhoudt - $version)\e[0m"
echo # Blank line


# ============================================================= #
# ASK FOR INPUT FILEPATH IF NO ARGUMENT IS GIVEN ON SCRIPT CALL #
# ============================================================= #

if [ -z "$1" ] # "$1" = First argument given after the script call
then
    echo -e "\e[93mNo path to a picture given as the argument of this script!"
    echo "(use single or double quote marks when there are spaces in the path)"
    read -p $'Please do so now: \e[0m' inputFile
    echo # Blank line

    # Check if there are quote marks in the given file path (' or ")
    # Check if first character matches
    if [[ ${inputFile:0:1} = "'" || ${inputFile:0:1} = "\"" ]]
    then
        # Check if last character matches (space is necessary!)
        if [[ ${inputFile: -1} = "'" || ${inputFile: -1} = "\"" ]]
        then
            # Remove first and last character
            inputFile="${inputFile:1:-1}"
        fi
    fi
else
    inputFile="$1" # Quote marks so spaces can exist in the filepath
fi


# ======================== #
# ENABLE/DISABLE WATERMARK #
# ======================== #

echo -e "\e[93mDo you want to enable the watermark?"
echo "  Options: 'y' = Yes (default)"
echo "           'n' = No"
echo "           'c' = Select custom color and opacity"
read -p $'Selected option: \e[0m' watermark

# Check the given argument and set boolean value and other settings accordingly
case $watermark in
    # Yes ('' = enter without character)
    ''|'y'|'Y')
        watermarking=true
        watermarkColor="rgba(169,169,169,0.50)"
        echo -e "\e[93m  Using the default watermark options: color = \e[0mDark grey \e[93mopacity = \e[0m0.50"
        ;;
    
    # No
    'n'|'N')
        watermarking=false
        ;;

    # Custom
    'c'|'C')
        watermarking=true

        echo # Blank line
        echo -e "\e[93mWhat color do you want for the watermark?"
        echo "  Options: '0' = Dark grey (default)"
        echo "           '1' = White"
        echo "           '2' = Black"
        read -p $'Selected option: \e[0m' color

        echo # Blank line
        read -p $'\e[93mWhat should the opacity be? (0.00 - 1.00, 0.50 default) \e[0m' opacity

        # Check if an argument was given, if not: use default value of 0.65
        if [ -z $opacity ]
        then
            opacity=0.50
        fi

        case $color in
            # Dark grey ('' = enter without character)
            ''|'0')
                watermarkColor="rgba(169,169,169,$opacity)"
                echo -e "\e[93m  Using the color \e[0mDark grey \e[93mwith an opacity of \e[0m$opacity"
                ;;

            # White
            '1')
                watermarkColor="rgba(255,255,255,$opacity)"
                echo -e "\e[93m  Using the color \e[0mWhite \e[93mwith an opacity of \e[0m$opacity"
                ;;

            # Black
            '2')
                watermarkColor="rgba(0,0,0,$opacity)"
                echo -e "\e[93m  Using the color \e[0mBlack \e[93mwith an opacity of \e[0m$opacity"
                ;;
            
            # Unkown option
            *)
                echo -e "\e[91mERROR: Unknown option selected.\e[0m"
                watermarkColor="rgba(169,169,169,0.50)" # Default (dark grey)
                ;;
        esac
        ;;
    
    # Unknown option
    *)
        echo -e "\e[91mERROR: Unknown option selected.\e[0m"
        watermarking=false
        ;;
esac

echo # Blank line


# ================== #
# SELECT OUTPUT SIZE #
# ================== #

echo -e "\e[93mWhat output size do you need?"
echo "  Options: '0' = 4k    (16:9)  [3840x2160] (40pt watermark)"
echo "           '1' = 1440p (16:9)  [2560x1440] (27pt watermark)"
echo "           '2' = 1080p (16:9)  [1920x1080] (20pt watermark)"
echo # Blank line
echo "           '3' = Insta (1:1)   [1080x1080]"
echo "           '4' = Insta (1:1)   [1080x1080] (fit and add white borders)"
echo "           '5' = Insta (1:1)   [1080x1080] (fit and add white borders)"
echo "                         (other watermark for analog scanned pictures)"
echo "           '6' = Insta 2x(1:1) [2160x1080] (divide in two halves)"
echo # Blank line
echo "           '7' = Insta (4:5)   [1080x1350]"
echo "           '8' = Insta (4:5)   [1080x1350] (fit and add white borders)"
echo "           '9' = Insta (4:5)   [1080x1350] (fit and add white borders)"
echo "                         (other watermark for analog scanned pictures)"
echo "          '10' = Insta 2x(4:5) [2160x1350] (divide in two halves)"
echo # Blank line
echo "          '11' = Insta (5:4)   [1080x566]"
echo # Blank line
echo "          '12' = 35mm  (3:2)   [N/A] (no watermark)"
echo "          '13' = 35mm  (2:3)   [N/A] (no watermark)"
read -p $'Selected option: \e[0m' option
echo # Blank line

# Check input dimensions ("-ping" to not load the entire image)
width=$(identify -ping -format '%w' "$inputFile") # Quote marks so spaces can exist in the filepath
height=$(identify -ping -format '%h' "$inputFile") # Quote marks so spaces can exist in the filepath


# ================== #
# PICTURE CONVERSION #
# ================== #

case $option in
    # 4k (16:9) [3840x2160] (40pt watermark / kerning 2.11 -annotate +20+8)
    0)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 3840 2160

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            convert -quality 100 "$inputFile" \
                -resize '3840x2160^' -gravity $selectedGravity -crop '3840x2160+0+0' +repage \
                -pointsize 40 -font "$fontLocation" -kerning 2.11 -fill $watermarkColor \
                -gravity SouthWest -annotate +20+8 '@brecht.ve' \
                "${inputFile::-4}"-4k-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-4k-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '3840x2160^' -gravity $selectedGravity -crop '3840x2160+0+0' \
                "${inputFile::-4}"-4k.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-4k.jpg"
        fi
        ;;

    # 1440p (16:9) [2560x1440] (27pt watermark / kerning 1.51 -annotate +13+5)
    1)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 2560 1440

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            convert -quality 100 "$inputFile" \
                -resize '2560x1440^' -gravity $selectedGravity -crop '2560x1440+0+0' +repage \
                -pointsize 27 -font "$fontLocation" -kerning 1.51 -fill $watermarkColor \
                -gravity SouthWest -annotate +13+5 '@brecht.ve' \
                "${inputFile::-4}"-1440p-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-1440p-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '2560x1440^' -gravity $selectedGravity -crop '2560x1440+0+0' \
                "${inputFile::-4}"-1440p.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-1440p.jpg"
        fi
        ;;

    # 1080p (16:9) [1920x1080] (20pt watermark / kerning 1.01 -annotate +10+4)
    2)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 1920 1080

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            convert -quality 100 "$inputFile" \
                -resize '1920x1080^' -gravity $selectedGravity -crop '1920x1080+0+0' +repage \
                -pointsize 20 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +10+4 '@brecht.ve' \
                "${inputFile::-4}"-1080p-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-1080p-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '1920x1080^' -gravity $selectedGravity -crop '1920x1080+0+0' \
                "${inputFile::-4}"-1080p.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-1080p.jpg"
        fi
        ;;

    # Insta (1:1) [1080x1080]
    3)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 1080 1080

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            # "$inputFile" Quote marks so spaces can exist in the filepath
            # Resize flags:
            #   - ">" = Only shrink larger images
            #   - "^"  = Resize the image based on the smallest fitting dimension so it'll completely fill (and even overflow) the pixel area given
            # "+repage" = Reset dimensions of image virtual canvas to the actual image itself after cropping for the annotation to work correctly
            # "-kerning 1.01" = Slightly more space between characters
            # ""${inputFile::-4}"-insta-1x1-wm.jpg" =  Remove file extension and replace with new string
            convert -quality 100 "$inputFile" \
                -resize '1080x1080^' -gravity $selectedGravity -crop '1080x1080+0+0' +repage \
                -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +9+4 '@brecht.ve' \
                "${inputFile::-4}"-insta-1x1-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '1080x1080^' -gravity $selectedGravity -crop '1080x1080+0+0' \
                "${inputFile::-4}"-insta-1x1.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1.jpg"
        fi
        ;;

    # Insta (1:1) [1080x1080] (fit and add white borders)
    4)
        # Calculate the ratio's of the width and height to determine where we need to add white borders
        widthRatio=$(echo "scale=2 ; $width / 1080" | bc)
        widthRatio=$(echo "$widthRatio * 100 / 1" | bc)
        heightRatio=$(echo "scale=2 ; $height / 1080" | bc)
        heightRatio=$(echo "$heightRatio * 100 / 1" | bc)

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        # Add white borders to the left and right (double brackets to activate the aritmetic context)
        if (( widthRatio < heightRatio )); then
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with HEIGHT of 1080 (x1080), then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize x1080 \
                    -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +9+4 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize x1080 -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full.jpg"
            fi

        # Add white border to the top and bottom
        else
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with WIDTH of 1080, then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize 1080 \
                    -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +9+4 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize 1080 -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full.jpg"
            fi
        fi
        ;;

    # Insta (1:1) [1080x1080] (fit and add white borders) (other watermark for analog scanned pictures)
    5)
        # Calculate the ratio's of the width and height to determine where we need to add white borders
        widthRatio=$(echo "scale=2 ; $width / 1080" | bc)
        widthRatio=$(echo "$widthRatio * 100 / 1" | bc)
        heightRatio=$(echo "scale=2 ; $height / 1080" | bc)
        heightRatio=$(echo "$heightRatio * 100 / 1" | bc)

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        # Add white borders to the left and right (double brackets to activate the aritmetic context)
        if (( widthRatio < heightRatio )); then
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with HEIGHT of 1080 (x1080), then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize x1080 \
                    -pointsize 25 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +25+32 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize x1080 -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full.jpg"
            fi

        # Add white border to the top and bottom
        else
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with WIDTH of 1080, then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize 1080 \
                    -pointsize 25 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +38+20 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize 1080 -gravity center -background white -extent '1080x1080' \
                    "${inputFile::-4}"-insta-1x1-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-full.jpg"
            fi
        fi
        ;;

    # Insta 2x(1:1) [2160x1080] (divide in two halves)
    6)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 2160 1080

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            # First resize to big picture, then divide in two, then watermark 
            # "@" = Equally divide the image into the number of tiles generated
            # "+gravity" = reset gravity option
            convert -quality 100 "$inputFile" \
                -resize '2160x1080^' -gravity $selectedGravity -crop '2160x1080+0+0' +repage \
                +gravity -crop 2x1@ +repage \
                -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +9+4 '@brecht.ve' \
                "${inputFile::-4}"-insta-1x1-wm-wide.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-wm-wide-0/1.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '2160x1080^' -gravity $selectedGravity -crop '2160x1080+0+0' +repage \
                +gravity -crop 2x1@ +repage \
                "${inputFile::-4}"-insta-1x1-wide.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-1x1-wide-0/1.jpg"
        fi
        ;;

    # Insta (4:5) [1080x1350]
    7)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 1080 1350

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            convert -quality 100 "$inputFile" \
                -resize '1080x1350^' -gravity $selectedGravity -crop '1080x1350+0+0' +repage \
                -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +9+4 '@brecht.ve' \
                "${inputFile::-4}"-insta-4x5-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '1080x1350^' -gravity $selectedGravity -crop '1080x1350+0+0' \
                "${inputFile::-4}"-insta-4x5.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5.jpg"
        fi
        ;;

    # Insta (4:5) [1080x1350] (fit and add white borders)
    8)
        # Calculate the ratio's of the width and height to determine where we need to add white borders
        widthRatio=$(echo "scale=2 ; $width / 1080" | bc)
        widthRatio=$(echo "$widthRatio * 100 / 1" | bc)
        heightRatio=$(echo "scale=2 ; $height / 1350" | bc)
        heightRatio=$(echo "$heightRatio * 100 / 1" | bc)

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        # Add white borders to the left and right (double brackets to activate the aritmetic context)
        if (( widthRatio < heightRatio )); then
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with HEIGHT of 1350 (x1350), then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize x1350 \
                    -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +9+4 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize x1080 -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full.jpg"
            fi

        # Add white border to the top and bottom
        else
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with WIDTH of 1080, then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize 1080 \
                    -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +9+4 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize 1080 -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full.jpg"
            fi
        fi
        ;;

    # Insta (4:5) [1080x1350] (fit and add white borders) (other watermark for analog scanned pictures)
    9)
        # Calculate the ratio's of the width and height to determine where we need to add white borders
        widthRatio=$(echo "scale=2 ; $width / 1080" | bc)
        widthRatio=$(echo "$widthRatio * 100 / 1" | bc)
        heightRatio=$(echo "scale=2 ; $height / 1350" | bc)
        heightRatio=$(echo "$heightRatio * 100 / 1" | bc)

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        # Add white borders to the left and right (double brackets to activate the aritmetic context)
        if (( widthRatio < heightRatio )); then
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with HEIGHT of 1350 (x1350), then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize x1350 \
                    -pointsize 25 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +30+40 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize x1350 -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full.jpg"
            fi

        # Add white border to the top and bottom
        else
            if [ "$watermarking" = true ] # Boolean check
            then
                # First resize to picture with WIDTH of 1080, then watermark, then add borders
                convert -quality 100 "$inputFile" \
                    -resize 1080 \
                    -pointsize 25 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                    -gravity SouthWest -annotate +38+20 '@brecht.ve' +repage \
                    -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full-wm.jpg

                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full-wm.jpg"
            else
                convert -quality 100 "$inputFile" \
                    -resize 1080 -gravity center -background white -extent '1080x1350' \
                    "${inputFile::-4}"-insta-4x5-full.jpg
                
                echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-full.jpg"
            fi
        fi
        ;;

    # Insta 2x(4:5) [2160x1350] (divide in two halves)
    10)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 2160 1350

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            # First resize to big picture, then divide in two, then watermark 
            # "@" = Equally divide the image into the number of tiles generated
            # "+gravity" = reset gravity option
            convert -quality 100 "$inputFile" \
                -resize '2160x1350^' -gravity $selectedGravity -crop '2160x1350+0+0' +repage \
                +gravity -crop 2x1@ +repage \
                -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +9+4 '@brecht.ve' \
                "${inputFile::-4}"-insta-4x5-wm-wide.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-wm-wide-0/1.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '2160x1350^' -gravity $selectedGravity -crop '2160x1350+0+0' +repage \
                +gravity -crop 2x1@ +repage \
                "${inputFile::-4}"-insta-4x5-wide.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-4x5-wide-0/1.jpg"
        fi
        ;;

    # Insta (5:4) [1080x566]
    11)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 1080 566

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting... \e[0m"

        if [ "$watermarking" = true ] # Boolean check
        then
            convert -quality 100 "$inputFile" \
                -resize '1080x566^' -gravity $selectedGravity -crop '1080x566+0+0' +repage \
                -pointsize 30 -font "$fontLocation" -kerning 1.01 -fill $watermarkColor \
                -gravity SouthWest -annotate +9+4 '@brecht.ve' \
                "${inputFile::-4}"-insta-5x4-wm.jpg

            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-5x4-wm.jpg"
        else
            convert -quality 100 "$inputFile" \
                -resize '1080x566^' -gravity $selectedGravity -crop '1080x566+0+0' \
                "${inputFile::-4}"-insta-5x4.jpg
            
            echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-insta-5x4.jpg"
        fi
        ;;

    # 35mm (3:2) [NA] (no watermark)
    12)
        # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 3 2

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting ... \e[0m"

        convert -quality 100 "$inputFile" \
            -gravity $selectedGravity -crop 3:2 \
            "${inputFile::-4}"-3x2.jpg
        
        echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-3x2.jpg"
        ;;

    # 35mm (2:3) [NA] (no watermark)
    13)
         # Check if the aspect ratio's match and ask for a "gravity" option if not the case
        checkAspectRatio $width $height 2 3

        # "-n" for not advancing to the next line
        echo -n -e "\e[93mConverting ... \e[0m"

        convert -quality 100 "$inputFile" \
            -gravity $selectedGravity -crop 2:3 \
            "${inputFile::-4}"-2x3.jpg
        
        echo -e "\e[93mDone! converted file: \e[0m${inputFile::-4}-2x3.jpg"
        ;;

    # Unknown option
    *)
        echo -e "\e[91mERROR: Unknown option selected.\e[0m"
        ;;
esac