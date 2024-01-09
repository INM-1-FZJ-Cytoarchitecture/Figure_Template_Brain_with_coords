function [h_figure, template, template_vol] = visualize_template(z_level_section, x_level_section, iso_value, iso_cap, view_angle)
    % visualize_template visualisiert Abschnitte eines 3D-Volumens mithilfe von Isosurfaces und Isocaps.
    %
    % Eingabeparameter:
    % z_level_section (double) - Z-Ebene des zu visualisierenden Abschnitts. Standardwert: 45.
    % x_level_section (double) - X-Ebene des zu visualisierenden Abschnitts. Standardwert: 70.
    % iso_value (double) - Iso-Wert für die Isosurface-Berechnung. Standardwert: 15.
    % iso_cap (double) - Iso-Wert für die Isocap-Berechnung. Standardwert: 10.
    % view_angle (1x2 vector of double) - Betrachtungswinkel für die Visualisierung. Beispiel: [30, 45].
    %
    % Rückgabe:
    % h_figure (figure handle) - Handle des erzeugten Figure-Objekts.
    % template  -  nifti Header der Template Datei
    % template_vol  -  volumen der nifti Datei
    
    % Setzen von Standardwerten, falls keine Parameter übergeben werden
    if nargin < 1, z_level_section = 45; end
    if nargin < 2, x_level_section = 70; end
    if nargin < 3, iso_value = 15; end
    if nargin < 4, iso_cap = 10; end
    if nargin < 5, view_angle = [129.0, 29.4]; end

    % Laden des Templates
    templateFile = fullfile('.', 'input_data', 'template_volume', 'mni_icbm152_t1_tal_nlin_asym_09c.nii');
    template = spm_vol(templateFile);
    template_vol = spm_read_vols(template);

    % Visualisierung vorbereiten
    h_figure = figure;
    set(gca, 'YDir', 'reverse');
    h_figure.Color = [1 1 1];

    % Erstellen der Isosurfaces und Isocaps für die Z-Ebene
    [fo, vo, fe, ve, ce] = createIsoSurface(template_vol, z_level_section, x_level_section, iso_value, iso_cap, 'z');
    createPatch(fo, vo, fe, ve, ce);

    % Erstellen der Isosurfaces und Isocaps für die X-Ebene
    [fo, vo, fe, ve, ce] = createIsoSurface(template_vol, z_level_section, x_level_section, iso_value, iso_cap, 'x');
    createPatch(fo, vo, fe, ve, ce);

    % Weitere Visualisierungseinstellungen
    daspect([1 1 1]);
    colormap(gray(100));
    box on;
    axis off;
    view(view_angle);
    % camlight(40, 40);
    % camlight(-20, -10);
    % lighting gouraud;
end

function [fo, vo, fe, ve, ce] = createIsoSurface(template_vol, z_level_section, x_level_section, iso_value, iso_cap, axisType)
    % Hilfsfunktion zur Erstellung von Isosurfaces und Isocaps
    if strcmp(axisType, 'z')
        limits = [NaN NaN NaN NaN NaN z_level_section];
    else
        limits = [0 x_level_section NaN NaN z_level_section NaN];
    end
    [x, y, z, D] = subvolume(template_vol, limits);
    [fo, vo] = isosurface(x, y, z, D, iso_value);
    [fe, ve, ce] = isocaps(x, y, z, D, iso_cap);
end

function createPatch(fo, vo, fe, ve, ce)
    % Hilfsfunktion zur Erstellung und Visualisierung von Patches
    p1 = patch('Faces', fo, 'Vertices', vo);
    p1.FaceColor = '#d6d3d2';
    p1.EdgeColor = 'none';
    p1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    p2 = patch('Faces', fe, 'Vertices', ve, 'FaceVertexCData', ce);
    p2.FaceColor = 'interp';
    p2.EdgeColor = 'none';
    p2.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
