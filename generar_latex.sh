#!/bin/bash

OUTPUT="estructura.tex"
> "$OUTPUT"

find . -name svg-inkscape -type d -prune -exec rm -fr "{}" \;

for grupo in */ ; do
    grupo=${grupo%/}
    echo "\\part{$grupo}" >> "$OUTPUT"

    for song in "$grupo"/*/; do
        song=${song%/}
        song_name="${song##*/}"

        echo "\\chapter{$song_name}" >> "$OUTPUT"

        echo "\\begin{center}" >> "$OUTPUT"
        # SVGs ordenados de forma natural, manteniendo ruta completa
        find "$song" -maxdepth 1 -name "*.svg" -print0 \
        | sort -z -V \
        | while IFS= read -r -d '' score; do

            # Ignorar logo.svg si apareciera aquí
            [ "${score##*/}" = "logo.svg" ] && continue

            echo "\\includesvg[width=\paperwidth]{\\detokenize{$score}}" >> "$OUTPUT"
        done
        echo "\\end{center}" >> "$OUTPUT"
    done

    echo "" >> "$OUTPUT"
done