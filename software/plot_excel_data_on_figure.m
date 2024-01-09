function h_figure = plot_excel_data_on_figure(h_figure, template, excelFilename)
    % plot_excel_data_on_figure visualisiert Daten aus einer Excel-Datei auf einem gegebenen Figure-Handle.
    %
    % Eingabeparameter:
    % h_figure (figure handle) - Handle des MATLAB-Figure-Objekts, auf dem die Daten visualisiert werden sollen.
    % template - nifti Header des Templates
    % excelFilename (string) - Name der Excel-Datei (ohne Pfad), die die zu visualisierenden Daten enthält.
    % view_angle (1x2 vector of double) - Betrachtungswinkel für die Visualisierung. Beispiel: [30, 45].
    %
    % Rückgabe:
    % h_figure (figure handle) - Handle des aktualisierten Figure-Objekts.
    %
    % Die Funktion liest Daten aus der angegebenen Excel-Datei, überprüft die erforderlichen Spalten und
    % visualisiert die Daten auf dem übergebenen Figure-Handle.
    %
    % Beispielaufruf:
    % h_fig = plot_excel_data_on_figure(h_fig, template,'FEF_activations_Bedini_2021_and_iFEF.xlsx');
    
    if nargin < 4, view_angle = [129.0, 29.4]; end

    % Vollständiger Pfad des Skriptes, inklusive Dateiname
    fullPath = mfilename('fullpath');
    
    % Trennen des Pfades vom Dateinamen
    [pfad, ~, ~] = fileparts(fullPath);

    % Pfad zur Excel-Datei konstruieren
    baseDir = fullfile(pfad,'..', 'input_data', 'coordinate_files');
    fullPathToFile = fullfile(baseDir, excelFilename);

    % Überprüfen, ob die Excel-Datei existiert
    if ~exist(fullPathToFile, 'file')
        error('Die angegebene Excel-Datei existiert nicht: %s', fullPathToFile);
    end

    % Einlesen der Daten aus der Excel-Datei
    data = readtable(fullPathToFile);

    % Überprüfen, ob die erforderlichen Spalten vorhanden sind
    requiredColumns = {'Study', 'x', 'y', 'z'};
    if ~all(ismember(requiredColumns, data.Properties.VariableNames))
        error('Die Excel-Datei ist nicht korrekt aufgebaut. Sie sollte mindestens die Spalten "Study", "x", "y" und "z" enthalten.');
    end

    % Daten in die gewünschte Variable speichern
    functional_studies_mni_space = data;

    % Erstellen einer Colormap basierend auf der Anzahl der einzigartigen Studien
    uniqueStudies = unique(functional_studies_mni_space.Study);
    numStudies = numel(uniqueStudies);
    colormapValues = lines(numStudies); % Verwendung der 'lines' Colormap

    % Aktivieren des übergebenen Figure-Handles
    figure(h_figure);
    hold on;

    % 3D-Sphären an den Koordinaten der Studien plotten
    for i = 1:size(functional_studies_mni_space, 1)
        studyIndex = find(strcmp(uniqueStudies, functional_studies_mni_space.Study(i)));
        studyColor = colormapValues(studyIndex, :);

        % 3D-Bubbleplot mit den gegebenen Koordinaten und Farben
        % Hinweis: 'template.mat' muss entsprechend Ihrer Umgebung angepasst werden
        bubbleplot3(functional_studies_mni_space.y(i)-template.mat(2,4), ...
                    functional_studies_mni_space.x(i)-template.mat(1,4), ...
                    functional_studies_mni_space.z(i)-template.mat(3,4), ...
                    2, studyColor, [], [], [], ...
                    'DisplayName', char(functional_studies_mni_space.Study(i)));
    end
    view(view_angle);
    hold off;
end
