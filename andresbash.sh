#!/bin/bash

# Función para calcular el factorial
factorial() {
    if [ $1 -le 1 ]; then
        echo 1
    else
        prev=$(factorial $(($1-1)))
        echo $(($1 * $prev))
    fi
}

# Función para verificar si un año es bisiesto
es_bisiesto() {
    year=$1
    if (( (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 )); then
        echo "El año $year es bisiesto."
    else
        echo "El año $year no es bisiesto."
    fi
}
# Función para configurar la red
configurarred() {
    ip=$1
    mascara=$2
    puerta_enlace=$3
    dns=$4

    if [ -z "$ip" ] || [ -z "$mascara" ] || [ -z "$puerta_enlace" ] || [ -z "$dns" ]; then
        echo "Se necesitan cuatro parámetros: IP, Máscara, Puerta de enlace, y DNS"
        return
    fi

    # Configurar la red con ip route
    sudo ip addr add $ip/$mascara dev eth0
    sudo ip link set eth0 up
    sudo ip route add default via $puerta_enlace

    # Configurar DNS
    echo "nameserver $dns" | sudo tee /etc/resolv.conf > /dev/null

    # Mostrar configuración
    echo "Configuración de red actualizada:"
    ip addr show eth0
    ip route show
    cat /etc/resolv.conf
}

# Función para el juego de adivina el número
adivina() {
    numero_secreto=$((RANDOM % 100 + 1))
    intentos=0
    max_intentos=10
    echo "He pensado en un número entre 1 y 100. ¡Adivínalo!"

    while [ $intentos -lt $max_intentos ]; do
        read -p "Introduce tu suposición (intento $((intentos+1))/$max_intentos): " suposicion
        intentos=$(($intentos + 1))

        if [ $suposicion -lt $numero_secreto ]; then
            echo "El número es mayor."
        elif [ $suposicion -gt $numero_secreto ]; then
            echo "El número es menor."
        else
            echo "¡Felicidades! Has adivinado el número $numero_secreto en $intentos intentos."
            return
        fi
    done

    echo "Lo siento, has agotado tus $max_intentos intentos. El número era $numero_secreto."
}


# Función para determinar la etapa de vida basada en la edad
determinar_edad() {
    read -p "Introduce tu edad: " edad

    if [ $edad -lt 3 ]; then
        echo "Estás en la niñez."
    elif [ $edad -le 10 ]; then
        echo "Estás en la infancia."
    elif [ $edad -lt 18 ]; then
        echo "Estás en la adolescencia."
    elif [ $edad -lt 40 ]; then
        echo "Estás en la juventud."
    elif [ $edad -lt 65 ]; then
        echo "Estás en la madurez."
    else
        echo "Estás en la vejez."
    fi
}

# Función para mostrar información del fichero
fichero() {
    read -p "Introduce la ruta del fichero: " ruta
    if [ -e "$ruta" ]; then
        tamano=$(stat -c%s "$ruta")
        tipo=$(file -b "$ruta")
        inodo=$(stat -c%i "$ruta")
        punto_montaje=$(df "$ruta" | tail -1 | awk '{print $6}')
        echo "Tamaño: $tamano bytes"
        echo "Tipo: $tipo"
        echo "Inodo: $inodo"
        echo "Punto de montaje: $punto_montaje"
    else
        echo "El fichero no existe."
    fi
}

# Función para buscar un fichero
buscar() {
    read -p "Introduce el nombre del fichero a buscar: " nombre
    archivo=$(find / -name "$nombre" 2>/dev/null)
    if [ -z "$archivo" ]; then
        echo "El fichero no existe."
    else
        echo "El fichero se encuentra en: $archivo"
        vocales=$(grep -o -i "[aeiou]" "$archivo" | wc -l)
        echo "El número de vocales en el fichero es: $vocales"
    fi
}

# Función para contar ficheros en un directorio
contar() {
    read -p "Introduce el directorio: " directorio
    if [ -d "$directorio" ]; then
        num_ficheros=$(find "$directorio" -type f | wc -l)
        echo "El número de ficheros en el directorio es: $num_ficheros"
    else
        echo "El directorio no existe."
    fi
}

# Función para verificar privilegios administrativos
privilegios() {
    if sudo -n true 2>/dev/null; then
        echo "Tienes privilegios administrativos."
    else
        echo "No tienes privilegios administrativos."
    fi
}

# Función para mostrar permisos en octal
permisosoctal() {
    read -p "Introduce la ruta del objeto: " objeto
    if [ -e "$objeto" ]; then
        permisos=$(stat -c "%a" "$objeto")
        echo "Los permisos en octal de $objeto son: $permisos"
    else
        echo "El objeto no existe."
    fi
}

# Función para convertir número a romano
romano() {
    read -p "Introduce un número entre 1 y 200: " num
    if [ $num -lt 1 ] || [ $num -gt 200 ]; then
        echo "Número fuera de rango."
        return
    fi

    mil=( "" "M" "MM" )
    cent=( "" "C" "CC" "CCC" "CD" "D" "DC" "DCC" "DCCC" "CM" )
    dec=( "" "X" "XX" "XXX" "XL" "L" "LX" "LXX" "LXXX" "XC" )
    uni=( "" "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" )

    m=${mil[$((num / 1000))]}
    c=${cent[$((num % 1000 / 100))]}
    d=${dec[$((num % 100 / 10))]}
    u=${uni[$((num % 10))]}

    echo "El número $num en romano es: $m$c$d$u"
}

# Función para automatizar creación de usuarios
automatizar() {
    directorio="/mnt/usuarios"
    if [ -z "$(ls -A $directorio)" ]; then
        echo "El directorio está vacío."
    else
        for archivo in "$directorio"/*; do
            nombre_usuario=$(basename "$archivo")
            adduser "$nombre_usuario"
            while IFS= read -r carpeta; do
                mkdir -p "/home/$nombre_usuario/$carpeta"
            done < "$archivo"
            rm "$archivo"
        done
    fi
}

# Función para crear fichero
crear() {
    nombre=$1
    tamano=$2
    if [ -z "$nombre" ]; then
        nombre="fichero_vacio"
    fi
    if [ -z "$tamano" ]; then
        tamano=1024
    fi
    dd if=/dev/zero of="$nombre" bs=1K count="$tamano"
    echo "Fichero $nombre creado con tamaño $tamano KB."
}

# Función para crear fichero evitando duplicados
crear_2() {
    nombre=$1
    tamano=$2
    if [ -z "$nombre" ]; then
        nombre="fichero_vacio"
    fi
    if [ -z "$tamano" ]; then
        tamano=1024
    fi
    base_nombre=$nombre
    for i in {0..9}; do
        if [ ! -e "$nombre" ]; then
            dd if=/dev/zero of="$nombre" bs=1K count="$tamano"
            echo "Fichero $nombre creado con tamaño $tamano KB."
            return
        fi
        nombre="${base_nombre}${i}"
    done
    echo "No se pudo crear el fichero. Existen archivos con nombres hasta $base_nombre9."
}

# Función para reescribir una palabra
reescribir() {
    palabra=$1
    nueva_palabra=$(echo "$palabra" | tr 'aeiou' '12345')
    echo "La palabra reescrita es: $nueva_palabra"
}

# Función para contar usuarios reales y hacer copia de seguridad
contusu() {
    usuarios=(/home/*)
    total_usuarios=0
    usuarios_reales=()

    for usuario in "${usuarios[@]}"; do
        if [ -d "$usuario" ]; then
            total_usuarios=$((total_usuarios + 1))
            usuarios_reales+=("$(basename "$usuario")")
        fi
    done

    echo "Total de usuarios reales: $total_usuarios"
    echo "Usuarios: ${usuarios_reales[*]}"

    if [ $total_usuarios -gt 0 ]; then
        echo "Elige un usuario de la lista para hacer una copia de seguridad:"
        select user in "${usuarios_reales[@]}"; do
            if [ -n "$user" ]; then
                fecha=$(date +%Y%m%d)
                destino="/home/copiaseguridad/${user}_$fecha"
                mkdir -p "$destino"
                cp -r "/home/$user" "$destino"
                echo "Copia de seguridad de /home/$user realizada en $destino."
                break
            else
                echo "Opción no válida. Intenta de nuevo."
            fi
        done
    fi
}

# Función para gestionar notas de alumnos
alumnos() {
    read -p "Introduce el número de alumnos: " num_alumnos
    aprobados=0
    suspensos=0
    suma_notas=0

    for ((i = 1; i <= num_alumnos; i++)); do
        read -p "Introduce la nota del alumno $i: " nota
        if (( nota >= 5 )); then
            aprobados=$((aprobados + 1))
        else
            suspensos=$((suspensos + 1))
        fi
        suma_notas=$((suma_notas + nota))
    done

    media=$(echo "scale=2; $suma_notas / $num_alumnos" | bc)
    echo "Número de aprobados: $aprobados"
    echo "Número de suspensos: $suspensos"
    echo "Nota media: $media"
}

# Función para renombrar ficheros quitando espacios
quita_blancos() {
    for file in *; do
        if [[ "$file" == *" "* ]]; then
            nuevo_nombre=$(echo "$file" | tr ' ' '_')
            mv "$file" "$nuevo_nombre"
            echo "Renombrado: $file -> $nuevo_nombre"
        fi
    done
}

# Función para dibujar líneas
lineas() {
    char=$1
    num_chars=$2
    num_lines=$3

    if [ -z "$char" ] || [ -z "$num_chars" ] || [ -z "$num_lines" ]; then
        echo "Parámetros incompletos."
        return
    fi

    if (( num_chars < 1 || num_chars > 60 )) || (( num_lines < 1 || num_lines > 10 )); then
        echo "Parámetros fuera de rango."
        return
    fi

    for ((i = 1; i <= num_lines; i++)); do
        line=$(printf "%${num_chars}s" | tr ' ' "$char")
        echo "$line"
    done
}

# Función para analizar el número y tipo de documentos
analizar() {
    dir=$1
    shift
    ext="$@"
    declare -A conteo

    if [ -z "$dir" ] || [ -z "$ext" ]; then
        echo "Parámetros incompletos."
        return
    fi

    for extension in $ext; do
        conteo[$extension]=$(find "$dir" -type f -name "*.$extension" | wc -l)
    done

    echo "Informe de análisis:"
    for extension in "${!conteo[@]}"; do
        echo "$extension: ${conteo[$extension]}"
    done
}

# Función para mostrar el menú y manejar las opciones
scriptadd() {
    op=1
    while [ $op -ne 0 ]; do
        # lo que se muestra
        echo -e "\nOpción 1: factorial"
        echo "Opción 2: bisiesto"
        echo "Opción 3: configurarred"
        echo "Opción 4: adivina"
        echo "Opción 5: edad"
        echo "Opción 6: fichero"
        echo "Opción 7: buscar"
        echo "Opción 8: contar"
        echo "Opción 9: privilegios"
        echo "Opción 10: permisosoctal"
        echo "Opción 11: romano"
        echo "Opción 12: automatizar"
        echo "Opción 13: crear"
        echo "Opción 14: crear_2"
        echo "Opción 15: reescribir"
        echo "Opción 16: contusu"
        echo "Opción 17: alumnos"
        echo "Opción 18: quita_blancos"
        echo "Opción 19: lineas"
        echo "Opción 20: analizar"
        echo "Opción 0: Salir"
        read -p "Escoge la opción: " op
        echo ""

        case $op in
            0)
                echo "Saliendo..."
                ;;
            1)
                read -p "Introduce un número: " num
                resultado=$(factorial $num)
                echo "El factorial de $num es $resultado"
                ;;
            2)
                read -p "Introduce un año: " year
                es_bisiesto $year
                ;;
            3)
                read -p "Introduce IP: " ip
                read -p "Introduce Máscara: " mascara
                read -p "Introduce Puerta de enlace: " puerta_enlace
                read -p "Introduce DNS: " dns
                configurarred $ip $mascara $puerta_enlace $dns
                ;;
            4)
                adivina
                ;;
            5)
                determinar_edad
                ;;
            6)
                fichero
                ;;
            7)
                buscar
                ;;
            8)
                contar
                ;;
            9)
                privilegios
                ;;
            10)
                permisosoctal
                ;;
            11)
                romano
                ;;
            12)
                automatizar
                ;;
            13)
                read -p "Introduce el nombre del fichero: " nombre
                read -p "Introduce el tamaño en Kilobytes: " tamano
                crear $nombre $tamano
                ;;
            14)
                read -p "Introduce el nombre del fichero: " nombre
                read -p "Introduce el tamaño en Kilobytes: " tamano
                crear_2 $nombre $tamano
                ;;
            15)
                read -p "Introduce una palabra: " palabra
                reescribir $palabra
                ;;
            16)
                contusu
                ;;
            17)
                alumnos
                ;;
            18)
                quita_blancos
                ;;
            19)
                read -p "Introduce un carácter: " char
                read -p "Introduce un número entre 1 y 60: " num_chars
                read -p "Introduce un número entre 1 y 10: " num_lines
                lineas $char $num_chars $num_lines
                ;;
            20)
                read -p "Introduce el directorio: " dir
                read -p "Introduce las extensiones a analizar (separadas por espacio): " exts
                analizar $dir $exts
                ;;
            *)
                echo "Opción incorrecta. Intenta de nuevo."
                ;;
        esac
    done
}

# Ejecutar el menú
scriptadd
