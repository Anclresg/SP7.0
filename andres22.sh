#!/bin/bash

# Verificación de parámetros
if [ $# -ne 1 ]; then
    echo "Error: Debe proporcionar exactamente un parámetro (fichero con los usuarios a dar de baja)."
    exit 1
fi

fichero=$1

# Comprobación de existencia y tipo de fichero
if [ ! -f "$fichero" ]; then
    echo "Error: El fichero $fichero no existe o no es un fichero regular."
    exit 1
fi

# Directorio de logs del sistema
logdir="/var/log"

# Ficheros de log
errorlog="${logdir}/bajaserror.log"
bajaslog="${logdir}/bajas.log"

# Función para procesar cada usuario
procesarusuario() {
    local linea="$1"
    IFS=':' read -r nombre apellido1 apellido2 login <<< "$linea"

    # Verificación de existencia del usuario
    if ! id "$login" &>/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S')-$login-$nombre-$apellido1 $apellido2-Usuario no existe" >> "$errorlog"
        return
    fi

    # Crear directorio para mover ficheros
    directoriomover="/home/proyecto/$login"
    mkdir -p "$directoriomover"

    # Mover ficheros del directorio trabajo al nuevo directorio
    usuariohome="/home/$login"
    trabajodir="$usuariohome/trabajo"
    if [ -d "$trabajodir" ]; then
        mv "$trabajodir"/* "$directoriomover" 2>/dev/null
        # Cambiar propietario a root
        chown -R root:root "$directoriomover"

        # Registro de bajas
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $login - $directoriomover" >> "$bajaslog"
        echo "Ficheros movidos:" >> "$bajaslog"
        ficherosmovidos=$(find "$directoriomover" -type f | wc -l)
        n=1
        for fichero in "$directoriomover"/*; do
            if [ -f "$fichero" ]; then
                echo "$n. $(basename "$fichero")" >> "$bajaslog"
                ((n++))
            fi
        done
        echo "Total de ficheros movidos: $ficherosmovidos" >> "$bajaslog"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S')-$login-$nombre-$apellido1 $apellido2-Directorio 'trabajo' no encontrado" >> "$errorlog"
    fi

    # Borrar el usuario y sus directorios
    userdel -r "$login"
}

# Procesamiento de cada línea del fichero
while IFS= read -r linea; do
    procesarusuario "$linea"
done < "$fichero"

echo "Proceso de baja de usuarios completado."
