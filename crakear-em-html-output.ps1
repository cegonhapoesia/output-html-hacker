# Define as pastas a serem listadas
$folders = @(
    "C:\",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Videos",
    "$env:USERPROFILE\Music",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE"
)

# Cria um arquivo HTML para exibir os links
$outputFile = "$env:USERPROFILE\Desktop\FolderLinks.html"

# Cabeçalho do HTML
$htmlHeader = @"
<!DOCTYPE html>
<html>
<head>
    <title>Links para Arquivos</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        ul { list-style-type: none; padding: 0; }
        li { margin: 5px 0; }
        a { color: #0066cc; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>Links para Arquivos nas Pastas</h1>
"@

# Conteúdo do HTML
$htmlContent = ""

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        $htmlContent += "<h2>Pasta: $folder</h2><ul>"
        $files = Get-ChildItem -Path $folder -File | Select-Object Name, FullName
        foreach ($file in $files) {
            $htmlContent += "<li><a href='file:///$($file.FullName.Replace('\', '/'))'>$($file.Name)</a></li>"
        }
        $htmlContent += "</ul>"
    } else {
        $htmlContent += "<p>A pasta $folder não foi encontrada.</p>"
    }
}

# Rodapé do HTML
$htmlFooter = @"
</body>
</html>
"@

# Combina tudo e salva no arquivo
$htmlHeader + $htmlContent + $htmlFooter | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Arquivo HTML criado em: $outputFile"
Start-Process $outputFile