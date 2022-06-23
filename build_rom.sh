#!/bin/bash

BUILD_DATE="$(date +%Y%m%d)"

clean_build() {
    echo "Cleaning the build treble"
    rm -f device/*/sepolicy/common/private/genfs_contexts
    cd device/phh/treble
    git clean -fdx
    bash generate.sh lineage
    cd ../../..
    echo "Done cleaning"
}

buildVanilla() {
    echo 'Building Lineage 19.1 Vanilla...'
    lunch lineage_arm64_bvS-userdebug
    make installclean
    make -j8 systemimage
    mv $OUT/system.img ~/build-output/lineage-19.1-$BUILD_DATE-UNOFFICIAL-arm64_bvS.img
    make vndk-test-sepolicy
    echo 'Done building...'
}

buildGapps() {
    echo 'Building Lineage 19.1 with Gapps...'
    lunch lineage_arm64_bgS-userdebug
    make installclean
    make -j8 systemimage
    mv $OUT/system.img ~/build-output/lineage-19.1-$BUILD_DATE-UNOFFICIAL-arm64_bgS.img
    make vndk-test-sepolicy
    echo 'Done building...'
}

# Clean the build
clean_build

# Create a output folder 
# in the home directory
mkdir -p ~/build-output

# Build it
buildVanilla
buildGapps
