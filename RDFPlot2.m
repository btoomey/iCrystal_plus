function RDFPlot2(rdfCell)
%RDF plot
[numOfGraph,gar] = size(rdfCell);
for graphCount = 1:numOfGraph;
    element = rdfCell{graphCount,2};
    s=size(element);
    if ~isequal(s, [2,2])
        
    else
        element1 = element{1,1};
        element2 = element{1,2};
        element = strcat(element1,'-', element2);
    end
    rdf = rdfCell{graphCount,1};
    Rs = rdf{1,1};
    gr = rdf{2,1};
    figure(graphCount+100);
    plot(Rs,gr);
    title(element);
    xlabel('r');
    ylabel('g(r)');
end
end