function bout = branch(fn)
%BRANCH git branch name where fn resides
% if no input provided it returns the branch for the current folder
% this version assumes that fn is in a folder that also contains .git

if nargin
  wfn = which(fn);
  if isempty(wfn)
    fprintf('%s is not on the path\n',fn)
    if nargout
      bout = '';
    end
    return
  end
  bn = 'built-in';
  if strfind(wfn,bn)
    if nargout
      bout = '';
    else
      disp(bn)
    end
    return
  end
  [wpth,~,~] = fileparts(wfn);
  %w = fullfile(wpth,'.git');
  [w,wpth] = findgit(wpth);
  b = '';
  if exist(w,'dir')
    f = linebyline(fullfile(w,'head'));
    for k = 1:length(f)
      line = f{k};
      found = length(line)>3 && strcmpi(line(1:4),'ref:');
      if found
        b = regexp(line,'/','split');
        b = b{end};
        break
      end
    end
%  else
%    disp('No .git folder')
  end
else
  a = git('st');
  ii = find(abs(a)==10);
  a = a(1:ii-1);
  if nargout
    ii = find(a==' ');
    bout = a(ii(end)+1:end);
    if strcmp(bout,'.git')
      bout = '';
    end
  else
    disp(a)
  end
  return
end
  
if nargout
  bout = b;
else
  if isempty(b)
    fprintf('%s in %s is apparently not tracked by git\n',fn,wpth);
  else
    fprintf('%s is available from the %s branch of %s\n',fn,b,wpth);
  end
end

function [w,wpth] = findgit(wpth)
w = fullfile(wpth,'.git');
while ~exist(w,'dir') % search back up the directory tree for .git
  [wpth,~] = fileparts(wpth);
  if isempty(wpth) || regexpi(wpth,'[A-Z]:\')
    w = '';
    return
  end
  w = fullfile(wpth,'.git');
end
