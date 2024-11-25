#!/vendor/bin/sh
#
# Copyright (C) 2021-2022 Gt Aswin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BASEDIR="$(dirname $(readlink -f "$0"))"
. $BASEDIR/pathinfo.sh
. $BASEDIR/libcommon.sh
. $BASEDIR/libuperf.sh

# Create busybox symlinks
$BIN_PATH/busybox/busybox --install -s $BIN_PATH/busybox

# Support vtools
cp -af $SCRIPT_PATH/vtools_powercfg.sh /data/powercfg.sh
cp -af $SCRIPT_PATH/vtools_powercfg.sh /data/powercfg-base.sh
cp -af $SCRIPT_PATH/powercfg.json /data/powercfg.json
chmod 755 /data/powercfg.sh
chmod 755 /data/powercfg-base.sh
echo "sh $SCRIPT_PATH/powercfg_main.sh \"\$1\"" >>/data/powercfg.sh

# Wait for login
wait_until_login

# Kernel Tweaks
if ! sh $SCRIPT_PATH/kernel_tweaks.sh > $USER_PATH/kernel_tweaks.log; then
    echo "Kernel tweaks failed" >> $USER_PATH/kernel_tweaks.log
fi

# Ensure powercfg_once.sh always runs
if ! sh $SCRIPT_PATH/powercfg_once.sh > $USER_PATH/powercfg_once.log; then
    echo "powercfg_once failed" >> $USER_PATH/powercfg_once.log
fi

# Start Uperf
uperf_start
