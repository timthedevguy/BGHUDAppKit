#!/bin/sh
/usr/bin/install_name_tool -change @executable_path/../Frameworks/BGHUDAppKit.framework/Versions/A/BGHUDAppKit @loader_path/../../../../../../../BGHUDAppKit.framework/Versions/A/BGHUDAppKit ${TARGET_BUILD_DIR}/${PRODUCT_NAME}.ibplugin/Contents/MacOS/${PRODUCT_NAME}
