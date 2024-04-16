graph_options = [0,0,0,0]
write_xlsx = 1

% ID = 6
% make_graphs_4(ID, graph_options)


ID = 1
while ID <=  27
    make_outputs_4(ID, graph_options, write_xlsx)
    ID = ID + 1;
end

% m = [21,23]
% for i = 1:length(m)
%     ID = m(i)
%     make_outputs_4(ID, graph_options)
%     %run_curvefit_2(ID)
% end