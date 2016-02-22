classdef gitInfo
%GITINFO Essential Information on git tracked files
%
% gi = gitInfo(file,[Nprevious])
%
%See also gitSha

% Terry J. Brennan  7-18-2015
% Copyright (c) 2013-2015 Prime Plexus LLC.

  properties
    %fixme: if file is in a package, library should not be package name
    file
  end
  properties ( SetAccess = protected )
    library
    package
    commitSha
    currentBranch
    currentState
  end
  properties
    previous
  end
  properties ( SetAccess = protected )
    nCommits
    message
    date
    inThePast
  end
  properties ( Hidden )
    codes = '"%h %ad %s"';
  end

  properties(Access = protected)
    file_
    previous_ = -1;
  end

  methods
    function g = gitInfo(file,previous)
    if nargin<2
      previous = -1;
    end
    if previous >= 0
      error('previous must be a negative integer')
    end
    [lib,pack] = libName(file);
    if isempty(lib)
      error('%f is not on the matlab path',file)
    end
    g.file_ = file;
    g.currentState = gitState(file);
    if strcmpi(g.currentState,'untracked')
      if ~isempty(pack)
        g.package = pack;
      end
      g.library = lib;
    else
      [g.commitSha,g.message,g.date,g.inThePast,g.nCommits,g.library,g.package] = ...
                            gitSha(file,previous);
      g.currentBranch = branch(file);
      g.previous_ = previous;
    end
    end

    function g = set.previous(g,val)
    g = gitInfo(g.file,val);
    end
    function val = get.previous(g)
    val = g.previous_;
    end

    function g = set.file(g,val)
    g = gitInfo(val,g.previous);
    end
    function val = get.file(g)
    val = g.file_;
    end

    function out = git(g,codes)
    if nargin<2
      codes = g.codes;
    end
    fmt = 'log %g --date=short --pretty=format:XXXXX %s';
    fmt = sprintf(fmt,g.previous,g.file);
    fmt = strrep(fmt,'XXXXX',codes);
    if nargout
      out = git(fmt);
    else
      git(fmt)
    end
    end

  end

end
    
  