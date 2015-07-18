function Res = git(cmd,varargin)
%GIT Implements git from the matlab command line
%
% E.g.
%   git init
%   git st
%   git add *.m
%   git ci
%
% Can be called with an output
% E.g.
%   res = git('remote','-v')
%
% See also unstage

if nargin<1
  cmd = 'help';
end
V = varargin;
if complete(nargout) % complete and process the abreviations that may have been used
  return
end

str = [sprintf('git %s',cmd) sprintf(' %s',V{:})];
if nargout
  [~,Res]=system(str);
%  res = resformat(varargin{:});
else
  system(str);
end


%%%%%%%%%%%%%%%%%
%%% this is the svn version - need to do git
function T = complete(nargo)
% todo: future development for git
%    complete file names (add .m)
%    complete emfield\reverse to @emfield\reverse.m
%[cmd,switches,target] = disect;
T = false;
if ismember(lower(cmd),{'rev','revision','url'})
  T = true;
  info = svn('info');
  switch lower(cmd)
  case {'rev','revision'}
    getinfo('Revision:',@eval);
  case 'url'
    getinfo('URL:');
  end
end
function getinfo(str,oper)
column = length(str)+2;
f = strfind(info,str);
f = f(1);
nl = strfind(info,sprintf('\n'));
nl(nl<f) = [];
dat = info(f:nl(1)-1);
if nargo>0
  res = dat(column:end);
  if nargin>1
    res = oper(res);
  end
else
  while dat(end)==' '
    dat(end)=''
  end
  disp(dat)
end
end                      % end complete
end

end
