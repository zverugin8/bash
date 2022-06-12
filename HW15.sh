#!/usr/bin/bash
read -r file
cat <<'EOF' > ./$file
An old silent pond... 
A frog jumps into the pond,
splash! Silence again.
Autumn moonlight-
a worm digs silently
into the chestnut.
In the twilight rain
these brilliant-hued hibiscus -
A lovely sunset.
EOF
#printf "%s\n" $(cat $file)
cat ./$file
echo "Task finished" 1>&2
#rm ./$file
