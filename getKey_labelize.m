function getKey_labelize( fig_obj, eventData, filename, NEWDIR)
%This function is called from labelize.m
%To extend this file, simply add another case listing the key, and use
%str - [str 'class'] to add the keyword 'class' to the string.
%%Be sure to add your key by otherwise as well.
global str;
key = get(fig_obj,'CurrentCharacter');
switch key
    case 's'
        str = [str 'safe '];
    case 'd'
        str = [str 'dangerous '];
    case 'w'
        str = [str 'water '];
    case 'r'
        str = [str 'road '];
    case 'g'
        str = [str 'grass '];
    case 'b'
        str = [str 'bushes '];
    case 13 %enter key
        if(isempty(str))
           str = filename; 
        end
            idx = 0;
            while(exist([NEWDIR,str,'(',int2str(idx),')','.jpeg']) == 2)
                idx = idx + 1;
            end
            movefile(filename,[NEWDIR,str,'(',int2str(idx),')','.jpeg']);
            disp('Labeled file');
        close;
    otherwise
        disp('This key is not supported.');
        disp('Supported keys are:');
        disp('s - safe');
        disp('d - dangerous');
        disp('w - water');
        disp('r - road');
        disp('g - grass');
        disp('b - bushes');
        
end
end

