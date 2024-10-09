function [h_figure, h_patch, functional_studies_mni_space] = plot_pmap(h_figure, functional_studies_mni_space, niftiFilename, displayName, isoValue, faceColor, edgeColor, faceAlpha, varargin)
    % plot_pmap erstellt und visualisiert eine Isosurface für eine gegebene NIFTI-Datei.
    %
    % Eingabeparameter:
    % h_figure (figure handle) - Handle des MATLAB-Figure-Objekts, auf dem die Isosurface visualisiert wird.
    % functional_studies_mni_space (Tabelle) - Tabelle mit funktionellen Studien im MNI-Raum.
    % niftiFilename (string) - Pfad zur NIFTI-Datei, aus der die Isosurface erstellt wird.
    % displayName (string) - Anzeigename für die Legende.
    % isoValue (double, optional) - Iso-Wert für die Isosurface. Standardwert: 0.5.
    % faceColor (1x3 vector, optional) - Farbe der Isosurface. Standardwert: [0, 128, 0]/255.
    % edgeColor (string, optional) - Farbe der Kanten. Standardwert: 'none'.
    % faceAlpha (double, optional) - Transparenz der Isosurface. Standardwert: 0.4.
    % varargin (key-value pairs, optional) - Zusätzliche optionale Parameter. Beinhaltet 'MPM' mit einem Integer-Wert ungleich 0.
    %
    % Rückgabe:
    % h_figure (figure handle) - Handle des aktualisierten Figure-Objekts.
    % h_patch (patch handle) - Handle des erstellten Patch-Objekts.
    % functional_studies_mni_space (Tabelle) - Aktualisierte Tabelle mit funktionellen Studien im MNI-Raum.

    % Überprüfen, ob die erforderlichen Parameter übergeben wurden
    if nargin < 3
        error('Figure Handle, functional_studies_mni_space und NIFTI-Dateiname müssen übergeben werden.');
    end

    % Setzen von Standardwerten für optionale Parameter
    if nargin < 4 || isempty(displayName), displayName = 'Fp1'; end
    if nargin < 5 || isempty(isoValue), isoValue = 0.5; end
    if nargin < 6 || isempty(faceColor), faceColor = [0, 128, 0]/255; end
    if nargin < 7 || isempty(edgeColor), edgeColor = 'none'; end
    if nargin < 8 || isempty(faceAlpha), faceAlpha = 0.4; end

    % Überprüfen und Extrahieren des 'MPM'-Wertes, falls vorhanden
    MPM = [];
    for i = 1:2:length(varargin)
        if strcmp(varargin{i}, 'MPM')
            MPM = varargin{i + 1};
            if ~isnumeric(MPM) || ~isscalar(MPM) || MPM == 0
                error('Der Wert für ''MPM'' muss eine von Null verschiedene ganze Zahl sein.');
            end
            break;
        end
    end

    % Vollständiger Pfad des Skriptes, inklusive Dateiname
    fullPath = mfilename('fullpath');
    
    % Trennen des Pfades vom Dateinamen
    [pfad, ~, ~] = fileparts(fullPath);

    % Einlesen der NIFTI-Datei
    niftiFile = fullfile(pfad,'..', 'input_data', 'orig_volume_as_nifti', niftiFilename);
    header = spm_vol(niftiFile);
    vol = spm_read_vols(header);

    if ~isempty(MPM) && (isnumeric(MPM) || isscalar(MPM) || MPM ~= 0)
        vol(vol~=MPM)=0;
        vol(vol==MPM)=MPM+1;
    end
    

    % Erstellen der Isosurface
    [X, Y, Z] = meshgrid(1:header.dim(2), 1:header.dim(1), 1:header.dim(3));
    if ~isempty(MPM) && (isnumeric(MPM) || isscalar(MPM) || MPM ~= 0)
        [fo, vo] = isosurface(X, Y, Z, vol, str2num(isoValue));
        values = zeros(size(functional_studies_mni_space, 1), 1);
        
        % Loop over each row in the table
        for i = 1:size(functional_studies_mni_space, 1)
            mni_coord = [functional_studies_mni_space.x(i), functional_studies_mni_space.y(i), functional_studies_mni_space.z(i)]; 
            % Konvertieren Sie die MNI-Koordinate in Voxel-Koordinaten
            % Die Transformation wird durch die inverse Affintransformation erreicht
            voxel_coord = inv(header.mat) * [mni_coord, 1]'; % Homogene Koordinaten
            voxel_coord = voxel_coord(1:3)';
            
            % Optional: Runden Sie die Voxel-Koordinaten auf ganzzahlige Werte
            % voxel_coord = round(voxel_coord);
            
            % Lesen Sie den Wert an dieser Voxel-Koordinate aus
            % Verwenden Sie spm_sample_vol für eine einzelne Koordinate
            % Die '1' am Ende steht für trilineare Interpolation (0 für Nearest Neighbor)
            value = spm_sample_vol(header, voxel_coord(1), voxel_coord(2), voxel_coord(3),0);
            
            % Speichern Sie den Wert im Array
            values(i) = value;
        end
        col_name=['MPM_idx_' displayName]
        % Fügen Sie nach der Schleife die neue Spalte zur Tabelle hinzu
        functional_studies_mni_space.(col_name) = values;
    else
        [fo, vo] = isosurface(X, Y, Z, vol, MPM);
                % Preallocate an array to store the values
        values = zeros(size(functional_studies_mni_space, 1), 1);
        
        % Loop over each row in the table
        for i = 1:size(functional_studies_mni_space, 1)
            mni_coord = [functional_studies_mni_space.x(i), functional_studies_mni_space.y(i), functional_studies_mni_space.z(i)]; 
            % Konvertieren Sie die MNI-Koordinate in Voxel-Koordinaten
            % Die Transformation wird durch die inverse Affintransformation erreicht
            voxel_coord = inv(header.mat) * [mni_coord, 1]'; % Homogene Koordinaten
            voxel_coord = voxel_coord(1:3)';
            
            % Optional: Runden Sie die Voxel-Koordinaten auf ganzzahlige Werte
            % voxel_coord = round(voxel_coord);
            
            % Lesen Sie den Wert an dieser Voxel-Koordinate aus
            % Verwenden Sie spm_sample_vol für eine einzelne Koordinate
            % Die '1' am Ende steht für trilineare Interpolation (0 für Nearest Neighbor)
            value = spm_sample_vol(header, voxel_coord(1), voxel_coord(2), voxel_coord(3), 1);
            
            % Speichern Sie den Wert im Array
            values(i) = value;
        end
        col_name=['pval_' displayName]
        % Fügen Sie nach der Schleife die neue Spalte zur Tabelle hinzu
        functional_studies_mni_space.(col_name) = values;
    end
    

    % Aktivieren des übergebenen Figure-Handles
    figure(h_figure);
    hold on;

    % Erstellen des Patch-Objekts
    h_patch = patch('Faces', fo, 'Vertices', vo);
    h_patch.FaceColor = faceColor;
    h_patch.EdgeColor = edgeColor;
    h_patch.FaceAlpha = faceAlpha;
    h_patch.DisplayName = displayName;
    h_patch.Tag = displayName;

    hold off;

    % Rückgabe des aktualisierten Figure-Handles und des Patch-Handles
    return;
end