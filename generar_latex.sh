#!/bin/bash

OUTPUT="estructura.tex"
> "$OUTPUT"

rm -fr svg-inkscape

for grupo in */ ; do
    grupo=${grupo%/}
    #echo "\\setpartlogo{\detokenize{$grupo/logo.svg}}" >> "$OUTPUT"
    echo "\\part{$grupo}" >> "$OUTPUT"

    # echo "\\grouppart{\detokenize{$grupo/logo.svg}}" >> "$OUTPUT"

    for song in "$grupo"/*/; do
        song=${song%/}
        song_name="${song##*/}"

        echo "\\addcontentsline{toc}{chapter}{$song_name}" >> "$OUTPUT"

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