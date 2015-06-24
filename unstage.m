function varargout = unstage(varargin)
%UNSTAGE This removes files from the index (staged)
%
% unstage(filespec)
%
% e.g. If a file or files have been staged with 'git add' they can be
% removed with unstage before committing
%   >> git add x*.m
%   >> unstage x*.m
%
% This is the same as the unstage alias defined in git bash
%
% See also git

varargout = cell(1,nargout);
[varargout{:}] = git('reset HEAD',varargin{:});

