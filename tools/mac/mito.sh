#!/bin/bash

# ON-Value
OV=80

#internals
F=/tmp/toggle-mic-mute


if [[ ! -f $F ]]; then
    touch $F
    osascript -e 'display notification "MUTED. Silence is bliss." with title "MIC"'
    osascript -e 'set volume input volume 0'
else
    rm -f $F
    osascript -e 'display notification "UN-MUTED. Speaking loud NOW!" with title "MIC"'
    osascript -e "set volume input volume $OV"
fi

#
#osascript -e 'set volume input volume 1'
#osascript -e 'set volume input volume 100'
#osascript -e 'get volume settings'
#osascript -e 'input volume of (get volume settings)'
