#!/bin/bash

# Definición de repositorios y extensiones válidas
repos=("Fotografía" "Dibujo" "Imágenes")
exts=("jpg" "gif" "png")
logf="/var/log/descartados.log"

# Función para verificar y corregir el formato de un archivo
verfich() {
    local f="$1"
    local d="$2"
    local prop=$(ls -l "$f" | awk '{print $3}')

    # Obtener el formato del archivo
    form=$(file -bi "$f" | cut -d';' -f1)
    ext=${f##*.}

    case "$form" in
        "image/jpeg")
            newform="jpg"
            ;;
        "image/gif")
            newform="gif"
            ;;
        "image/png")
            newform="png"
            ;;
        *)
            # Si el formato no es válido, eliminar el archivo y registrar el borrado
            rm "$f"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $f - $prop - Eliminado por formato incorrecto" >> "$logf"
            return
            ;;
    esac

    # Si la extensión no coincide con el formato, renombrar
    if [ "$ext" != "$newform" ]; then
        newname="${f%.*}.$newform"
        mv "$f" "$newname"
        echo "Renombrado: $f a $newname"
    fi
}

# Función para procesar un repositorio
prorep() {
    local r="$1"
    for f in "$r"/*.{jpg,gif,png}; do
        if [ -f "$f" ]; then
            verfich "$f" "$r"
        fi
    done
}

# Procesar todos los repositorios si no se pasa parámetro
if [ $# -eq 0 ]; then
    for r in "${repos[@]}"; do
        prorep "$r"
    done
else
    # Procesar para un alumno específico si se pasa un parámetro
    alum="$1"
    totborr=0
    for r in "${repos[@]}"; do
        while IFS= read -r -d '' f; do
            prop=$(ls -l "$f" | awk '{print $3}')
            if [ "$prop" = "$alum" ]; then
                form=$(file -bi "$f" | cut -d';' -f1)
                if [[ ! "$form" =~ ^(image/jpeg|image/gif|image/png)$ ]]; then
                    rm "$f"
                    echo "$(date '+%Y-%m-%d %H:%M:%S') - $f - $prop - Eliminado por formato incorrecto" >> "$logf"
                    ((totborr++))
                else
                    # Aquí podrías incluir la lógica para renombrar si es necesario, aunque solo estamos contando eliminaciones.
                    verfich "$f" "$r"
                fi
            fi
        done < <(find "$r" -type f \( -name "*.jpg" -o -name "*.gif" -o -name "*.png" \) -print0)
    done
    echo "Total de ficheros borrados para $alum: $totborr"
fi

echo "Proceso de verificación y limpieza completado."
