#!/bin/bash

rm -rf build/* &&
pushd build >/dev/null &&
cmake .. &&
echo 'ccache before:' &&
ccache -s &&
cmake --build . &&
echo 'ccache after:' &&
ccache -s
popd >/dev/null

echo '>> Now run the project by executing "./build/Hello"'
