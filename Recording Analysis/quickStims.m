function quickStims(stimNum)
%Simple function to load stim files

fn1 = sprintf('stim%s.txt',stimNum);
fn2 = sprintf('stim%s',stimNum);


if exist(fn1,'file')
    stimInfo = load('-ASCII',fn1);
    stimDirs = stimInfo(:,1);
    try %terrible fix
        stimSpds = stimInfo(:,2);
    catch
        stimSpds = zeros(1,length(stimDirs));
    end
    
    nDirs = numel(unique(stimDirs));
    nSpds = numel(unique(stimSpds));
    
elseif exist(fn2,'file')
    load(fn2); %bad fix, revise later
    stimDirs = stimDirs';
    nDirs = numel(unique(stimDirs));
    nSpds = 1;
    
end

end