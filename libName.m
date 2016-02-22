function [lib,pkg,libpath] = libName(file)
%libName the library name containing a file
%
%  [lib,package,libpath] = libName(file)
%  returns the folder containing file. This handles package names so
%  libName(pack1.pack2.pack3.fcn) returns the folder containing +pack1
%  If file is in a package the package name will be returned. In the
%  example the package name will be given as +pack1.+pack2.+pack3
%  libPath is the fully qualified path name to the library

% Terry J. Brennan  2-22-2016
% Copyright (c) 2013-2016 Prime Plexus LLC.

lib = which(file);
pkg = '';
libpath = '';
if ~isempty(lib)
  pp = fileparts(lib);
  [pp,lib] = fileparts(pp);
  while lib(1) == '+'
    if isempty(pkg)
      pkg = lib;
    else
      pkg = [lib '.' pkg];
    end
    [pp,lib] = fileparts(pp);
  end
  libpath = fullfile(pp,lib);
end

    