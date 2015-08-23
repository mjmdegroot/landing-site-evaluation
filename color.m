function H = color(I, cellsize, blocksize, bins)
%Color: Calculates histogram of saturation and hue for an image
%   I - The image
%   cellsize - The width and height of a cell, a single cell is cellsize X
%      cellsize big.
%   blocksize - The number of cells in a block, a block is blocksize X
%       blocksize cells big.
%   bins - The number of bins

%initialize variables.
eps = 0.001;
[Ih, Iw, Id] = size(I);
cells_x = floor(Iw / cellsize);
cells_y = floor(Ih / cellsize);
H = zeros(1,floor(((cells_x-blocksize)/blocksize) + 1) * floor(((cells_y-blocksize)/blocksize) + 1) * blocksize*blocksize* bins);


%browse blocks
for nblocky = 1: (cells_y/blocksize)
    for nblockx = 1: (cells_x/blocksize)
        block = I( ((nblocky - 1) * blocksize * cellsize + 1):(nblocky * blocksize * cellsize), ...
            ((nblockx - 1) * blocksize * cellsize + 1) :  (nblockx * blocksize * cellsize),:);
        histo = zeros(1,blocksize*blocksize*bins);
        
        %browse cells
        for ncelly = 1: blocksize
            for ncellx = 1:blocksize
                cell = block(((ncelly - 1) * cellsize + 1):(ncelly * cellsize), ...
                    ((ncellx - 1) * cellsize + 1): (ncellx * cellsize),:);
                [Ch,Cw,Cd] = size(cell);
                
                %browse pixels, calculate hue/saturation, put it in a bin.
                for y = 1:Ch
                    for x = 1:Cw
                        hue = cell(y,x,1);
                        sat = cell(y,x,2);
                        
                        bin = abs(fix(hue * bins)) + 1;
                        histno = ((ncelly-1) * blocksize + (ncellx - 1)) * bins;
                        histo(histno + bin) = histo(histno + bin) + sat;
                    end
                end
                
                %normalize using L2-norm:
                histo = histo / sqrt(norm(histo)^2 + eps^2);
                
                H((((nblocky-1)   * (cells_x/blocksize) + (nblockx - 1)) * length (histo) + 1): ...
                    (((nblocky-1) * (cells_x/blocksize) +  nblockx)      * length (histo))) ...
                    = histo;
            end
        end
        
    end
end
end