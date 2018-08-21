function RDFPlot(rdfCell,str1)
%RDF plot
[numOfGraph,gar] = size(rdfCell);
for graphCount = 1:numOfGraph;
    element = rdfCell{graphCount,2};
    s=size(element);
    if ~isequal(s, [1,2])
        
    else
        element1 = element{1,1};
        element2 = element{1,2};
        element = strcat(element1,'-', element2);
    end
    rdf = rdfCell{graphCount,1};
    %rdf = rdfCell;
    Rs = rdf{1,1};
    gr = rdf{2,1};
    str = strcat(str1,',   ',element);
    figure
    plot(Rs,gr);
  %  set(gca,'FontSize',20)
    title(str);
%     xlabel('r','FontSize',18);
    xlabel('r');
 %   ylabel('g(r)','FontSize',18);
    ylabel('g(r)');

end
end