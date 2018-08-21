function [adj] = gen6(A, a, b, c)
adj = [];

pt = A +a;
adj = [adj;pt];
pt = A -a;
adj = [adj;pt];
pt = A +b;
adj = [adj;pt];
pt = A -b;
adj = [adj;pt];
pt = A +c;
adj = [adj;pt];
pt = A -c;
adj = [adj;pt];

end