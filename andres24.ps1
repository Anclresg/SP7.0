#Declaro dos variables para los dias pares e impares
$LosPares = 0
$LosImpares = 0

#Ahora se hace el calculo por los días del año
0..365 | ForEach-Object {
    $dia = ([datetime]"01/01/2025 00:00").AddDays($_).Day
    
    if ($dia % 2) {
        $LosImpares++
    } else {
        $LosPares++
    }
}
#El resultado 
Write-Host "$LosPares pares"
Write-Host "$LosImpares impares"