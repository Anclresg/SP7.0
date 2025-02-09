#Creo el memu

function Menu {
    Clear-Host
    Write-Host "Menu"
    Write-Host "1. Listar los usuarios"
    Write-Host "2. Crear un usuario"
    Write-Host "3. Eliminar un usuario"
    Write-Host "4. Modificar un usuario"
    Write-Host "5. Salir"
}

#Ahroa el bucle
do {
    Menu
    $opcion = Read-Host "Elige una opción"
    
    switch ($opcion) {
        1 {
            Write-Host "Listando usuarios..."
            Get-LocalUser | Select-Object Name | Out-Host
            pause
        }
        2 {
            $usuario = Read-Host "Ingresa el nombre del usuario"
            $password = Read-Host "Ingrese contraseña" -AsSecureString
            New-LocalUser -Name $usuario -Password $password
            Write-Host "Se creó con éxito"
            pause
        }
        3 {
            $usuario = Read-Host "Ingresa el usuario que quieres eliminar"
            Remove-LocalUser -Name $usuario
            Write-Host "Elimnado..."
            pause
        }
        4 {
            $usuario = Read-Host "Ingresa el usuario que quieres modificar"
            $nuevoNombre = Read-Host "Ingresa el nuevo nombre"
            Rename-LocalUser -Name $usuario -NewName $nuevoNombre
            Write-Host "Se modificó con éxito"
            pause
        }
        5 {
            Write-Host "Saliendo..."
            break
        }
        default {
            Write-Host "Error, opción incorrecta, prueba de nuevo"
            pause
        }
    }
} while ($opcion -ne 5)
