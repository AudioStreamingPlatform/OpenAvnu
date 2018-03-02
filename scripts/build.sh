
#!/bin/bash
WORKSPACEROOT="$1"
TARGET="$2"

if [ ! -d $WORKSPACEROOT/build ]; then
    mkdir $WORKSPACEROOT/build
fi

if [ $TARGET = "s810" ]; then 
    source $MOZART_SDK_ENVSETUP_PATH
fi;

cd $WORKSPACEROOT/build
cmake -DSYSTEMD_WATCHDOG=OFF -DMOZART=ON ../
make gptp
