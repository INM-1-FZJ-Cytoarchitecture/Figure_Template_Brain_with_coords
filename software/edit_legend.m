function edit_legend()
legend(legendUnq())
h_legend=findobj('Tag','legend');
h_legend.Box='on';
h_legend.Orientation='horizontal';
h_legend.NumColumns=1;
h_legend.Location='northwest';
h_legend.TextColor=[0 0 0];
%h_legend.Color= [0.5, 0.5, 0.5, 0.2];
set(h_legend.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[.5;.5;.5;.8]));