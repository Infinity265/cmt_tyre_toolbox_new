graph_options = [0,0,0,0]

% ID = 6
% make_graphs_4(ID, graph_options)


% ID = 13
% while ID <= 27
%     make_graphs_4(ID, graph_options)
%     ID = ID + 1;
% end

m = [2,6]
for i = 1:length(m)
    ID = m(i)
    run_curvefit_2(ID)
end