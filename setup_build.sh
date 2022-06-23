#!/bin/bash

apply_patches() {
    echo "Applying patch group ${1}"
    bash ./lineage_build_unified/apply_patches.sh ./lineage_patches_unified/${1}
}

setupBuilds() {
    echo "Setting up build environment"
    source build/envsetup.sh &> /dev/null
    echo "Setting up environment done"
    
    echo "Applying changes"
    repopick -Q "(status:open+AND+NOT+is:wip)+(label:Code-Review>=0+AND+label:Verified>=0)+project:LineageOS/android_packages_apps_Trebuchet+branch:lineage-19.1+NOT+332083"
    repopick -t twelve-burnin
    repopick -t qs-lightmode
    repopick -t powermenu-lightmode
    repopick 321337 # Deprioritize important developer notifications
    repopick 321338 # Allow disabling important developer notifications
    repopick 321339 # Allow disabling USB notifications
    repopick 329229 -f # Alter model name to avoid SafetyNet HW attestation enforcement
    repopick 329230 -f # keystore: Block key attestation for SafetyNet
    repopick 329409 # SystemUI: screenshot: open the screenshot instead of edit
    repopick 331534 -f # SystemUI: Add support to add/remove QS tiles with one tap
    repopick 331791 # Skip checking SystemUI's permission for observing sensor privacy
    echo "Applying changes done"
    
    echo "Applying patches"
    apply_patches patches_treble_prerequisite
    apply_patches patches_treble_phh
    apply_patches patches_platform
    apply_patches patches_treble
    echo "Done applying patches"
}

setupBuilds
