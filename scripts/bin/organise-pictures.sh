#!/bin/zsh

if [[ "$EUID" = 0 ]]; then
    echo "No. Bad. Don't use root for this script."
    exit -69
fi

local input=""
local output=""

local outputExpr="Photos from %s"
local imagePattern="/(IMG|VID)_([0-9]{4})[0-9]{2}[0-9]{2}"

echo "Note that using this script comes with a certain amount of risk. If you're in doubt, don't use it. It can and will happily make mistakes"
echo "particularly if the images are stupidly named or from different sources and happen to have the same name."
echo "There are many unchecked edge-cases. Use at your own risk."
sleep 2

while [[ $# -gt 0 ]]; do
    case $1 in
    --input)
        input=$(realpath $2)
    ;;
    --output)
        output=$(realpath $2)
    ;;
    --outputExpr)
        outputExpr=$2
    ;;
    --imagePattern)
        imagePattern=$2
    ;;
    --ip1)
        imagePattern="/([0-9]{4})[0-9]{4}"
    ;;
    -h|--help)
        echo "Picture organiser"
        echo 
        echo "Flags:"
        echo "\t--input\t\t\tThe path to the unsorted images (required)"
        echo "\t--output\t\tThe path to where the output folders are (default: input_path/..)"
        echo "\t--outputExpr\t\tThe expression to use for file names. Default: \"${imagePattern}\". %s is always expanded to the year."
        echo "\t--imagePattern\t\tA pattern describing how to parse the dates from the path. Default: ${imagePattern}"
        echo "\t\t\t\tNote that this pattern must contain a single capturing group representing the year. If this isn't present in the name, the file will be skipped."
        echo "\t\t\t\tThe entire point of this script is auto-organising. If your images are pre-organised, just copy them manually."
        echo "\t--ip1\t\tShorthand for --imagePattern=/([0-9]{4})[0-9]{4}, i.e. starting with an ISO date"
        exit 0
    ;;
    esac
    shift
    shift
done

if [[ "$input" == "" ]];
then
    echo "You need to supply an input directory"
    exit -1
fi
if [[ "$output" == "" ]];
then
    echo "Attempting to infer output..."
    output=$(realpath "$input/..")
    if [[ $? != 0 ]];
    then
        echo "Realpath failed; aborting"
        exit -1
    fi
    echo "Output folder inferred to ${output}"
fi

echo "Using:"
echo "\tinput=${input}"
echo "\toutput=${output}"
echo "\toutputExpr=${outputExpr}"

echo "Sleeping for 8 seconds. Abort now if something is wrong"
sleep 8

echo "Copy started..."
for file in ${input}/*; do
    if [[ "$file" =~ ${imagePattern} ]];
    then
        local year=${match[1]}
        local target=$(printf $outputExpr $year)
        if [ ! -d $target ]; then
            mkdir $target
        fi
        local fullTargetPath=$(realpath $output/$target)

        cp -uv $file $fullTargetPath
        
    fi
done

echo "All done. Note that the source images were not removed. Make sure to review the copy to make sure nothing was deleted."
