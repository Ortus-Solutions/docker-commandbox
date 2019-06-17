#!/bin/bash

LOC=$(curl -fsSL -I https://www.ortussolutions.com/parent/download/commandbox/type/bin |grep -i location: |tail -n1 |sed -n 's,^location: ,,ip'|sed -e 's,\r,,g;')
VER=$(echo $LOC |sed -n 's,^.*/ortussolutions/commandbox/\([^/]*\)/commandbox-bin.*,\1,p')

perl -pi -e "s|(-\s*COMMANDBOX_VERSION)=\S+|\$1=${VER}|" .travis.yml

