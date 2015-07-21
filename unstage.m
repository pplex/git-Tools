function varargout = unstage(varargin)
%UNSTAGE Removes files from the index (staged)
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

% Terry J. Brennan  7-11-2015
% Copyright (c) 2013-2015 Prime Plexus LLC.

varargout = cell(1,nargout);
[varargout{:}] = git('reset HEAD',varargin{:});

