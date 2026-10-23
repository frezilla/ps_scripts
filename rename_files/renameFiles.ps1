[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Directory,

    [Parameter(Mandatory = $true)]
    [string]$MappingFile,

    [switch]$Simulation
)

if (-not (Test-Path -Path $Directory -PathType Container)) {
    throw "Le répertoire '$Directory' n'existe pas."
}

if (-not (Test-Path -Path $MappingFile -PathType Leaf)) {
    throw "Le fichier CSV '$MappingFile' n'existe pas."
}

# Colonnes attendues : Source;Destination
$mappings = Import-Csv -Path $MappingFile -Delimiter ';'

foreach ($mapping in $mappings) {
	

    $sourceFile = Join-Path $Directory $mapping.Source
    $destinationFile = Join-Path $Directory $mapping.Destination
	
    if (-not (Test-Path $sourceFile)) {
        Write-Warning "Fichier introuvable : $($mapping.Source)"
        continue
    }

    if (Test-Path $destinationFile) {
        Write-Warning "Le fichier destination existe déjà : $($mapping.Destination)"
        continue
    }

    if ($Simulation) {
        Write-Host "[SIMULATION] '$($mapping.Source)' -> '$($mapping.Destination)'" -ForegroundColor Yellow
        continue
    }

    if ($PSCmdlet.ShouldProcess(
        $mapping.Source,
        "Renommer en $($mapping.Destination)"
    )) {
        try {
            Rename-Item `
                -Path $sourceFile `
                -NewName $mapping.Destination `
                -ErrorAction Stop

            Write-Host "Renommé : '$($mapping.Source)' -> '$($mapping.Destination)'" -ForegroundColor Green
        }
        catch {
            Write-Error "Erreur lors du renommage de '$($mapping.Source)' : $_"
        }
    }
}
