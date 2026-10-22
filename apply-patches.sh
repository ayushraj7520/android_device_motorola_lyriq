#!/usr/bin/env bash
# Apply source tree patches required for Motorola Edge 40 (lyriq) LineageOS 22.1 build
set -e

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
PATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/patches" && pwd)"

declare -A REPO_MAP=(
    ["vendor_lineage"]="vendor/lineage"
    ["build_make"]="build/make"
    ["build_release"]="build/release"
    ["bootable_recovery"]="bootable/recovery"
    ["frameworks_av"]="frameworks/av"
    ["device_lineage_sepolicy"]="device/lineage/sepolicy"
    ["lineage-sdk"]="lineage-sdk"
    ["hardware_interfaces"]="hardware/interfaces"
    ["packages_modules_common"]="packages/modules/common"
    ["packages_apps_ThemePicker"]="packages/apps/ThemePicker"
    ["packages_apps_Seedvault"]="packages/apps/Seedvault"
    ["system_security"]="system/security"
    ["system_core"]="system/core"
)

for key in "${!REPO_MAP[@]}"; do
    rel_path="${REPO_MAP[$key]}"
    patch_file="${PATCH_DIR}/${key}.patch"
    if [ -f "$patch_file" ] && [ -s "$patch_file" ]; then
        echo "Applying ${key}.patch to ${rel_path}..."
        if git -C "${TOP_DIR}/${rel_path}" apply --check "$patch_file" 2>/dev/null; then
            git -C "${TOP_DIR}/${rel_path}" apply "$patch_file"
            echo "  -> Applied successfully."
        else
            echo "  -> Already applied or skipped."
        fi
    fi
done

echo "All lyriq source patches processed!"
