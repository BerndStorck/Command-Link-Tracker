#! /usr/bin/env bash
#
# getfilelinks.sh
#

if [ -z "$1" ]; then
    echo "Bitte einen Befehl angeben."
    exit 1
fi

current_link="$(command -v "$1")"
if [ -z "$current_link" ]; then
    echo "WARNUNG: Befehl '$1' nicht gefunden."
    if answer="$(grep -hE "^alias $1=" /home/bernds/.{bashrc,bash_profile,bash_aliases} \
                 2>/dev/null |uniq)"; then
       echo "\"$1\" ist ein Alias von $(cut -d'=' -f2 <<< "$answer")"
    fi
    exit 1
fi

last_link=
all_links=

add_link() {
    all_links="${all_links}|  $1"
}

echo "$1:"
while [ "$last_link" != "$current_link" ]; do
    add_link "$current_link"
    last_link="$current_link"
    current_link="$(readlink "$current_link")"
done

tr '|' '\n' <<< "${all_links:1}"

exit 0
