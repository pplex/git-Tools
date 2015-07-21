function [sha,msg,date,dateRelative,nCommits,lib,pkg] = gitSha(file,previous,shaLength)
%GITSHA git repository information for a particular file
% 
%  sha = gitSha(file,[previous],[shaLength])
%    assuming file is in a repository somewhere on the path the sha of
%    the latest commit or the commit 'previous' back. previous defaults
%    to -1 if not provided of if empty.
%  
%  shaLength defaults to is the length of the returned sha. It
%    defaults to 7
%               
%  E.g.
%    s = gitSha('myFunction',-3) to get the sha from three commits back
%
%  sha = gitSha(file,'HEAD')
%    if the second argument is a string containing 'HEAD' the current
%    HEAD of the repository containing file will be returned

% Terry J. Brennan  7-18-2015
% Copyright (c) 2013-2015 Prime Plexus LLC.

[pth,fname,ext] = fileparts(which(file));
if nargin<3
  shaLength = 7;
end
if nargin<2 || isempty(previous)
  previous = -1;
else
  if ischar(previous) && strcmpi(previous,'head')
    pwd0 = cd;
    try
      cd(pth)
      sha = git('rev-parse','HEAD');
      shaLength = min(length(sha),shaLength);
      sha = sha(1:shaLength);
    catch
      sha = '';
    end
    cd(pwd0)
    return
  end
end

[pp,lib] = fileparts(pth);
if lib(1)=='+'
  pkg = lib;
  [~,lib] = fileparts(pp);
else
  pkg = '';
end
  
if isempty(pth)
  if nargout
    sha = '';
  else
    disp('No sha')
  end
end
file = [fname ext];
cwd = cd;
codes = '"%H %ad %s"'; %H is full sha, %h is short
codes2 = '"%ad"';
fmt = 'log %g --date=short --pretty=format:XXXXX %s';
try
  cd(pth)
  nl = sprintf('\n');
  fmt = sprintf(fmt,previous,file);
  dat = strrep(fmt,'XXXXX',codes);
  out = git(dat);
  % out will have abs(previous)-1 nl characters
  % we pick the last line
  ii = findstr(out,nl);
  nCommits = length(ii)+1;
  if ~isempty(ii)
    out = out((ii(end)+1):end);
  end
  [sha,remaining] = strtok(out,' ');
  sha = sha(1:min(length(sha),shaLength));
  [date,msg] = strtok(remaining,' ');
  msg(1) = [];
  if nargout>3
    dat = strrep(fmt,'XXXXX',codes2);
    dat = strrep(dat,'short','relative');
    out = git(dat);
    ii = findstr(out,nl);
    if ~isempty(ii)
      out = out((ii(end)+1):end);
    end
    dateRelative = out;
  end
catch
end
cd(cwd)