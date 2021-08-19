#!/usr/bin/env bash

set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

openscad=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

rm -rf ./tmp ./things
mkdir tmp things
cp ./*.dxf ./tmp/

for ((i=1; i<=7; i++)); do
    low=$((i*5+1))
    high=$((low+4))
    for j in $(seq -f "%02g" $low $high); do
        tmpFile="./tmp/tent.3x5.${j}deg.scad"
        cp tent.3x5.scad "$tmpFile"
        sed -i '' "s/tent_angle=.*/tent_angle=$j;/" "$tmpFile"
        $openscad -o "./things/tent.3x5.${j}deg.stl" "$tmpFile" &
    done
    wait
done

for ((i=1; i<=7; i++)); do
    low=$((i*5+1))
    high=$((low+4))
    for j in $(seq -f "%02g" $low $high); do
        tmpFile="./tmp/tent.3x6.${j}deg.scad"
        cp tent.3x6.scad "$tmpFile"
        sed -i '' "s/tent_angle=.*/tent_angle=$j;/" "$tmpFile"
        $openscad -o "./things/tent.3x6.${j}deg.stl" "$tmpFile" &
    done
    wait
done

rm -rf ./tmp
 
echo "done done"
