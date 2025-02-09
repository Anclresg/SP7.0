#Pizza vegetariana si o no
$tipo = Read-Host "¿Quieres una pizza vegetariana? (si/no)"

#Definir ingredientes
$ingredv = @("Pimiento", "Tofu")
$ingrednv = @("Peperoni", "Jamón", "Salmón")
if ($tipo -eq "si" -or $tipo -eq "sí") {
    
    #Mostrar opciones vegetarianas
    Write-Host "Ingredientes disponibles:"
    for ($i = 0; $i -lt $ingredv.Length; $i++) {
        Write-Host "$($i+1). $($ingredv[$i])"
    }
    $opcion = Read-Host "Elige un ingrediente (1 o 2)"
    $elegido = $ingredv[$opcion - 1]
    $esveg = $true
} else {

    #Mostrar opciones no vegetarianas
    Write-Host "Ingredientes disponibles:"
    for ($i = 0; $i -lt $ingrednv.Length; $i++) {
        Write-Host "$($i+1). $($ingrednv[$i])"
    }
    $opcion = Read-Host "Elige un ingrediente (1, 2 o 3)"
    $elegido = $ingrednv[$opcion - 1]
    $esveg = $false
}

#Mostrar la pizza elegida
if ($esveg) {
    Write-Host "Has elegido una pizza vegetariana con los siguientes ingredientes:"
} else {
    Write-Host "Has elegido una pizza no vegetariana con los siguientes ingredientes:"
}
Write-Host "Mozzarella"
Write-Host "Tomate"
Write-Host $elegido