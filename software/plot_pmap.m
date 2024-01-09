function [h_figure, h_patch] = plot_pmap(h_figure, niftiFilename, displayName, isoValue, faceColor, edgeColor, faceAlpha, varargin)
    % plot_pmap erstellt und visualisiert eine Isosurface für eine gegebene NIFTI-Datei.
    %
    % Eingabeparameter:
    % h_figure (figure handle) - Handle des MATLAB-Figure-Objekts, auf dem die Isosurface visualisiert wird.
    % niftiFilename (string) - Pfad zur NIFTI-Datei, aus der die Isosurface erstellt wird.
    % displayName (string) - Anzeigename für die Legende. Standardwert: 'Fp1'.
    % isoValue (double, optional) - Iso-Wert für die Isosurface. Standardwert: 0.5.
    % faceColor (1x3 vector, optional) - Farbe der Isosurface. Standardwert: [0, 128, 0]/255.
    % edgeColor (string, optional) - Farbe der Kanten. Standardwert: 'none'.
    % faceAlpha (double, optional) - Transparenz der Isosurface. Standardwert: 0.4.
    % varargin (key-value pairs, optional) - Zusätzliche optionale Parameter. Beinhaltet 'MPM' mit einem Integer-Wert ungleich 0.
    %
    % Rückgabe:
    % h_figure (figure handle) - Handle des aktualisierten Figure-Objekts.
    % p_handle (patch handle) - Handle des erstellten Patch-Objekts.

    % Überprüfen, ob niftiFilename und displayName übergeben wurden
    if nargin < 3
        error('Figure Handle, NIFTI-Dateiname und DisplayName müssen übergeben werden.');
    end

    % Setzen von Standardwerten für optionale Parameter
    if nargin < 4 || isempty(isoValue), isoValue = 0.5; end
    if nargin < 5 || isempty(faceColor), faceColor = [0, 128, 0]/255; end
    if nargin < 6 || isempty(edgeColor), edgeColor = 'none'; end
    if nargin < 7 || isempty(faceAlpha), faceAlpha = 0.4; end

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
    else
        [fo, vo] = isosurface(X, Y, Z, vol, MPM);
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
