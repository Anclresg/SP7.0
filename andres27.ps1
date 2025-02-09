#El disco que va a pedir

$disco = Read-Host "Introduce el número del disco que quieras limpiar y particionar"

#Ahora conseguir el tamaño del disco en GB

$discoObj = Get-PhysicalDisk -Number $disco
$tamanoGB = [math]::Round($discoObj.Size / 1GB, 2)
Write-Host "El tamaño del disco $disco es aproximadamente $tamanoGB GB."

#Usar el diskpart

$diskpartScript = @"
select disk $disco
clean
"@

#Ahora que cree particiones de 1GB hasta llenar el disco

for ($i = 1; $i -le $tamanoGB; $i++) {
    $diskpartScript += @"
create partition primary size=1024
format fs=ntfs quick label=Particion$i
"@
}

#Se crea un archivo temporal de diskpart

$tempFile = [System.IO.Path]::GetTempFileName()
$diskpartScript | Out-File -FilePath $tempFile -Encoding ascii

#Ejecuta el diskpart con el archivo temporal

try {
    diskpart /s $tempFile
    Write-Host "El disco $disco ha sido limpiado y particionado en particiones de 1GB."
} catch {
    Write-Host "Hubo un error al ejecutar Diskpart: $_"
} finally {
    # Borrar el archivo temporal
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
}