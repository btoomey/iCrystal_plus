function RDFPlotSingle(rdfCell,numOfGraph)
%RDF plot
    element = rdfCell{1,2};
    s=size(element);
    if ~isequal(s, [2,2])
        
    else
        element1 = element{1,1};
        element2 = element{1,2};
        element = strcat(element1,'-', element2);
    end
    rdf = rdfCell{1,1};
    Rs = rdf{1,1};
    gr = rdf{2,1};
    figure(numOfGraph);
    plot(Rs,gr);
    title(element);
    xlabel('r');
    ylabel('g(r)');

end