#Creo el menú

function Show-Menu {
    Clear-Host
    Write-Host "Menu"
    Write-Host "1. Listar grupos"
    Write-Host "2. Ver miembros de un grupo"
    Write-Host "3. Crear grupo"
    Write-Host "4. Eliminar grupo"
    Write-Host "5. Agregar miembro a un grupo"
    Write-Host "6. Eliminar miembro de un grupo"
    Write-Host "0. Salir"
}

#Ahora su bucle
do {
    Show-Menu
    $opcion = Read-Host "Elige una opción"

    switch ($opcion) {
        1 {
            Write-Host "Listando grupos..."
            Get-LocalGroup | Select-Object Name | Out-Host
            pause
        }
        2 {
            Get-LocalGroup | Select-Object Name | Out-Host
            $grupo = Read-Host "Ingresa el nombre del grupo"
            Write-Host "Miembros del grupo '$grupo':"
            Get-LocalGroupMember -Group $grupo | Select-Object Name | Out-Host
            pause
        }
        3 {
            $grupo = Read-Host "Ingresa el nombre del nuevo grupo"
            New-LocalGroup -Name $grupo
            Write-Host "Grupo '$grupo' se ha creado correctamente"
            pause
        }
        4 {
            $grupo = Read-Host "Ingresa el nombre del grupo que quieres eliminar"
            Remove-LocalGroup -Name $grupo
            Write-Host "El grupo '$grupo' se ha eliminado con éxito"
            pause
        }
        5 {
            $grupo = Read-Host "Ingresa el nombre del grupo"
            $usuario = Read-Host "Ingresa el nombre del usuario que quieres agregar"
            Add-LocalGroupMember -Group $grupo -Member $usuario
            Write-Host "El usuario '$usuario' se agregó al grupo '$grupo' con éxito"
            pause
        }
        6 {
            $grupo = Read-Host "Ingresa el nombre del grupo"
            $usuario = Read-Host "Ingresa el nombre del usuario que quieres eliminar"
            Remove-LocalGroupMember -Group $grupo -Member $usuario
            Write-Host "El usuario '$usuario' se ha eliminado del grupo '$grupo' con éxito"
            pause
        }
        0 {
            Write-Host "Saliendo..."
            break
        }
        default {
            Write-Host "Opción no válida"
            pause
        }
    }
} while ($opcion -ne 0)
