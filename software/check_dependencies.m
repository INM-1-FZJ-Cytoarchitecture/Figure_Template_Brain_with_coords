function [isDependenciesMet] = check_dependencies()
    % check_dependencies überprüft, ob alle erforderlichen Abhängigkeiten für das ausführende Skript vorhanden sind.
    %
    % Ausgabe:
    % isDependenciesMet - Ein logischer Wert, der angibt, ob alle Abhängigkeiten erfüllt sind (true) oder nicht (false).
    %
    % Beispielaufruf:
    % [erfüllt] = check_dependencies()

    % Definieren Sie die erforderlichen Pfade
    softwareFolder = fullfile('.', 'software');
    requiredFolders = {
        softwareFolder, 
        fullfile('.', 'input_data'), 
        fullfile('.', 'input_data', 'template_volume'), 
        fullfile('.', 'input_data', 'orig_volume_as_nifti'), 
        fullfile('.', 'input_data', 'processed_volume_as_nifti'), 
        fullfile('.', 'input_data', 'coordinate_files')
    };
    templateFile = fullfile('.', 'input_data', 'template_volume', 'mni_icbm152_t1_tal_nlin_asym_09c.nii');

    % Überprüfen, ob der software-Ordner im Pfad ist
    if ~exist(softwareFolder, 'dir')
        fprintf('Fehler: Ordner %s nicht gefunden.\n', softwareFolder);
        isDependenciesMet = false;
        return;
    elseif ~contains(path, softwareFolder)
        addpath(softwareFolder);
        fprintf('Hinweis: Ordner %s wurde für diese Session zum Pfad hinzugefügt.\n', softwareFolder);
    end

    % Überprüfen Sie, ob alle anderen Ordner vorhanden sind
    for i = 2:length(requiredFolders)
        if ~exist(requiredFolders{i}, 'dir')
            fprintf('Fehler: Ordner %s nicht gefunden.\n', requiredFolders{i});
            isDependenciesMet = false;
            return;
        end
    end

    % Überprüfen Sie die spezifischen Dateien in den Ordnern
    if ~exist(templateFile, 'file')
        fprintf('Fehler: Datei %s nicht gefunden.\n', templateFile);
        isDependenciesMet = false;
        return;
    end

    % Überprüfen Sie auf mindestens eine .XLSX-Datei im Ordner coordinate_files
    if isempty(dir(fullfile(requiredFolders{6}, '*.xlsx')))
        fprintf('Fehler: Keine .XLSX Datei im Ordner %s gefunden.\n', requiredFolders{6});
        isDependenciesMet = false;
        return;
    else
        xlsxFiles = dir(fullfile(requiredFolders{6}, '*.xlsx'));
        fprintf('Gefundene .XLSX Datei(en): %s\n', strjoin({xlsxFiles.name}, ', '));
    end

    % Überprüfen Sie auf mindestens eine .nii-Datei im Ordner orig_volume_as_nifti
    if isempty(dir(fullfile(requiredFolders{4}, '*.nii')))
        fprintf('Fehler: Keine .nii Datei im Ordner %s gefunden.\n', requiredFolders{4});
        isDependenciesMet = false;
        return;
    end

    % Wenn alle Überprüfungen bestanden sind
    isDependenciesMet = true;
end
