function S = gitLib(file)
%GITLIB Library information
%
%S = gitLib(file)
%  returns a structure with information about the working folder
%  containing file. If that folder is called lib the result is
%  S.library   = lib
%  S.Branch    = name of current branch
%  S.HEAD      = current SHA
%  S.modified  = cell arry of modified files in lib
%todo: S.untracked

% Terry J. Brennan  5-25-2015
% Copyright (c) 2013-2015 Prime Plexus LLC.

[lib,pkg,pth] = libName(file);
if isempty(lib)
  S = '';
  return
end
pwdSave = cd;
try
  cd(pth)
  S.library = lib;
  S.Branch = branch;
  S.HEAD = gitSha(file,'HEAD');
  X = git('status');
  str = 'modified:';
  ii = strfind(X,str);
  if length(ii)
    modified = cell(1,length(ii));
    for k = 1:length(ii)
      x = X(ii(k):end);
      x(1:length(str))='';
      x = strtok(x,' ');
      nl = find(x==10);
      x(nl(1):end)='';
      modified{k} = x;
    end
    S.modified = modified;
  end
catch
end
cd(pwdSave)    
