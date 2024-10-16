%%
% 
%   [isDependenciesMet] = check_dependencies()
%       % check_dependencies überprüft, ob alle erforderlichen Abhängigkeiten für das ausführende Skript vorhanden sind.
%       % Dazu gehören spezifische Ordner und Dateien im Dateisystem sowie die Installation der SPM12 Toolbox.
%       %
%       % Ausgabe:
%       % isDependenciesMet - Ein logischer Wert, der angibt, ob alle Abhängigkeiten erfüllt sind (true) oder nicht (false).
%       %   Die Funktion gibt 'true' zurück, wenn:
%       %   - Alle erforderlichen Ordner im Dateisystem vorhanden sind.
%       %   - Die Datei 'mni_icbm152_t1_tal_nlin_asym_09c.nii' im Ordner 'template_volume' vorhanden ist.
%       %   - Mindestens eine .XLSX-Datei im Ordner 'coordinate_files' vorhanden ist.
%       %   - Mindestens eine .nii-Datei im Ordner 'orig_volume_as_nifti' vorhanden ist.
%       %   - Die SPM12 Toolbox im MATLAB-Pfad installiert ist.
%       %   Wenn eine dieser Bedingungen nicht erfüllt ist, gibt die Funktion 'false' zurück.
%       %
%       % Beispielaufruf:
%       % [erfüllt] = check_dependencies()
%

clear all;
close all;
clc;
[dependencies_checked] = check_dependencies();
%%
% 
%   [h_figure, template, template_vol] = visualize_template(z_level_section, x_level_section, iso_value, iso_cap, view_angle)
%       % visualize_template visualisiert Abschnitte eines 3D-Volumens mithilfe von Isosurfaces und Isocaps.
%       %
%       % Eingabeparameter:
%       % z_level_section (double) - Z-Ebene des zu visualisierenden Abschnitts. Standardwert: 45.
%       % x_level_section (double) - X-Ebene des zu visualisierenden Abschnitts. Standardwert: 70.
%       % iso_value (double) - Iso-Wert für die Isosurface-Berechnung. Standardwert: 15.
%       % iso_cap (double) - Iso-Wert für die Isocap-Berechnung. Standardwert: 10.
%       % view_angle (1x2 vector of double) - Betrachtungswinkel für die Visualisierung. Beispiel: [30, 45].
%       %
%       % Rückgabe:
%       % h_figure (figure handle) - Handle des erzeugten Figure-Objekts.
%       % template  -  nifti Header der Template Datei
%       % template_vol  -  volumen der nifti Datei
%
%% 
% 

[hfig, template, template_vol] = visualize_template();
%%
% 
%   function h_figure = plot_excel_data_on_figure(h_figure, template, excelFilename)
%       % plot_excel_data_on_figure visualisiert Daten aus einer Excel-Datei auf einem gegebenen Figure-Handle.
%       %
%       % Eingabeparameter:
%       % h_figure (figure handle) - Handle des MATLAB-Figure-Objekts, auf dem die Daten visualisiert werden sollen.
%       % template - nifti Header des Templates
%       % excelFilename (string) - Name der Excel-Datei (ohne Pfad), die die zu visualisierenden Daten enthält.
%       % view_angle (1x2 vector of double) - Betrachtungswinkel für die Visualisierung. Beispiel: [30, 45].
%       %
%       % Rückgabe:
%       % h_figure (figure handle) - Handle des aktualisierten Figure-Objekts.
%       %
%       % Die Funktion liest Daten aus der angegebenen Excel-Datei, überprüft die erforderlichen Spalten und
%       % visualisiert die Daten auf dem übergebenen Figure-Handle.
%       %
%       % Beispielaufruf:
%       % h_fig = plot_excel_data_on_figure(h_fig, template,'FEF_activations_Bedini_2021_and_iFEF.xlsx');
%

[hfig, functional_studies_mni_space] = plot_excel_data_on_figure(hfig,template,'FEF_activations_Bedini_2021_and_iFEF.xlsx');
%%
% 
%   function [h_figure, h_patch] = plot_isosurface(h_figure, niftiFilename, displayName, isoValue, faceColor, edgeColor, faceAlpha)
%       % plot_isosurface erstellt und visualisiert eine Isosurface für eine gegebene NIFTI-Datei.
%       %
%       % Eingabeparameter:
%       % h_figure (figure handle) - Handle des MATLAB-Figure-Objekts, auf dem die Isosurface visualisiert wird.
%       % niftiFilename (string) - Pfad zur NIFTI-Datei, aus der die Isosurface erstellt wird.
%       % displayName (string) - Anzeigename für die Legende. Standardwert: 'Fp1'.
%       % isoValue (double, optional) - Iso-Wert für die Isosurface.
%       Standardwert: 0.5.   [entspricht dem p Wert der Karte]
%       % faceColor (1x3 vector, optional) - Farbe der Isosurface.
%       Standardwert: [0 0.5 0]
%       % edgeColor (string, optional) - Farbe der Kanten. Standardwert: 'none'.
%       % faceAlpha (double, optional) - Transparenz der Isosurface. Standardwert: 0.4.
%       % varargin (key-value pairs, optional) - Zusätzliche optionale Parameter. Beinhaltet 'MPM' mit einem Integer-Wert ungleich 0.
%   
%       %
%       % Rückgabe:
%       % h_figure (figure handle) - Handle des aktualisierten Figure-Objekts.
%       % p_handle (patch handle) - Handle des erstellten Patch-Objekts.
%

% kann für beliebig viele pmaps wiederholt werden

%plotte eine Karte und definiere den Namen der Karte in der Legende mit
%default Werten für isovalue und weitere Parameter
[hfig, h_patch_Fp1, functional_studies_mni_space] = plot_pmap(hfig,  functional_studies_mni_space,'Area-Fp1_pmap_l_N10_nlin2ICBM152asym2009c.nii', 'Fp1');

%plotte eine weitere Karte und definiere den Namen der Karte in der
%Legende. Isowert, RGB Wert und weitere Parameter können angepasst werden.
%Siehe Funktions definnition weiter oben. Reihenfolge beachten!
[hfig, h_patch_6v2, functional_studies_mni_space] = plot_pmap(hfig, functional_studies_mni_space, '6v2_l.nii', '6v2\_l','0.001',[1 0 0],'none',0.2);
% wiederhole diese Zeile mit jeder Karte die geplottet werden soll

%plotte eine Karte aus einer MPM und definiere den Namen der Karte in der
%Legende. Isowert wird ignoriert, dafür muss 'MPM' definiert sein und ein
%Integer ungleich null, welcher den Grauwert der Karte in der MPM angiebt.
%Weitere Karten aus der MPM können durch dublizierung der Zeile erfolgen.
[hfig, h_patch_MFG4, functional_studies_mni_space] = plot_pmap(hfig,  functional_studies_mni_space,'JulichBrainAtlas_3.1_206areas_MPM_lh_Colin27_filling.nii', 'MFG4\_l','103',[0 0 1],'none',0.1,'MPM',103);

%%
%es werde Licht
camlight(40, 40);
camlight(-20, -10);
lighting gouraud;
%%
edit_legend()
%maximize the figure
hfig.WindowState = 'maximized';

%% 
% *Ab hier keine Änderung vornehmen!!!*

function [isDependenciesMet] = check_dependencies()
    % check_dependencies überprüft, ob alle erforderlichen Abhängigkeiten für das ausführende Skript vorhanden sind.
    % Dazu gehören spezifische Ordner und Dateien im Dateisystem sowie die Installation der SPM12 Toolbox.
    %
    % Ausgabe:
    % isDependenciesMet - Ein logischer Wert, der angibt, ob alle Abhängigkeiten erfüllt sind (true) oder nicht (false).
    %   Die Funktion gibt 'true' zurück, wenn:
    %   - Alle erforderlichen Ordner im Dateisystem vorhanden sind.
    %   - Die Datei 'mni_icbm152_t1_tal_nlin_asym_09c.nii' im Ordner 'template_volume' vorhanden ist.
    %   - Mindestens eine .XLSX-Datei im Ordner 'coordinate_files' vorhanden ist.
    %   - Mindestens eine .nii-Datei im Ordner 'orig_volume_as_nifti' vorhanden ist.
    %   - Die SPM12 Toolbox im MATLAB-Pfad installiert ist.
    %   Wenn eine dieser Bedingungen nicht erfüllt ist, gibt die Funktion 'false' zurück.
    %
    % Beispielaufruf:
    % [erfüllt] = check_dependencies()

    % Vollständiger Pfad des Skriptes, inklusive Dateiname
    fullPath = mfilename('fullpath');
    
    % Trennen des Pfades vom Dateinamen
    [pfad, ~, ~] = fileparts(fullPath);

    % Definieren Sie die erforderlichen Pfade
    softwareFolder = fullfile(pfad,'.', 'software');
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
        fprintf('\nFehler: Ordner %s nicht gefunden.\n', softwareFolder);
        isDependenciesMet = false;
        return;
    elseif ~contains(path, softwareFolder)
        addpath(softwareFolder);
        fprintf('\n\nHinweis: Ordner %s wurde für diese Session zum Pfad hinzugefügt.\n', softwareFolder);
    end

    % Überprüfen Sie, ob alle anderen Ordner vorhanden sind
    for i = 2:length(requiredFolders)
        if ~exist(requiredFolders{i}, 'dir')
            fprintf('\nFehler: Ordner %s nicht gefunden.\n', requiredFolders{i});
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
        fprintf('\n\nGefundene .XLSX Datei(en): %s\n', strjoin({xlsxFiles.name}, ', '));
    end

    % Überprüfen Sie auf mindestens eine .nii-Datei im Ordner orig_volume_as_nifti
    if isempty(dir(fullfile(requiredFolders{4}, '*.nii')))
        fprintf('\n\nFehler: Keine .nii Datei im Ordner %s gefunden. Evtl. .gz Datei? Dann zuerst entpacken\n', requiredFolders{4});
        isDependenciesMet = false;
        return;
    end

    % Überprüfen, ob die SPM12 Toolbox installiert ist
    if ~exist('spm', 'file')
        fprintf('Fehler: SPM12 Toolbox ist nicht installiert oder nicht im MATLAB-Pfad.\n');
        isDependenciesMet = false;
        return;
    else
        fprintf('\n\nSPM ist installiert und erreichbar\n\n');
    end

    % Wenn alle Überprüfungen bestanden sind
    isDependenciesMet = true;
    if isDependenciesMet == true
        fprintf('\n\nAlle nötigen Abhängigkeiten erfüllt!\n\n');
    end
end