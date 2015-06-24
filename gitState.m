function state = gitState(file)
% state = gitState(file)
% Cases:
%   state = ''           file is safely stashed in git repository
%   state = 'modified'   file has been modified since last commit
%   state = 'untracked'  file is not being tracked by git
%
% See also gitSha, gitInfo

% Terry J. Brennan  5-25-2015
% Copyright (c) 2013-2015 Prime Plexus LLC.

if ~nargin
  error('gitState requires a file name')
end
pwdsave = cd;
try
  [fldr,fname,ext] = fileparts(which(file));
  if isempty(ext)
    ext = '.m';
  end
  fname = [fname ext];
  cd(fldr)
  x = git('status',fname);
  if ~isempty(strfind(x,'modified:'))
    state = 'modified';
  elseif  ~isempty(strfind(x,'Untracked'))
    state = 'untracked';
  else
    state = 'committed';
  end
catch
end
cd(pwdsave)