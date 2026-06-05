function comp = resolveComponent(arch, path)
% Look up a System Composer component by slash-delimited path.
%
% Walks into sub-architectures for nested components (composites).
% Use when allocation scripts need to address both top-level and
% nested components uniformly.
%
% Examples:
%   resolveComponent(arch, 'SensorUnit')                        % top-level
%   resolveComponent(arch, 'ConveyorSystem/Motor')              % nested
%   resolveComponent(arch, 'Assembly/SubAssembly/Actuator')     % 3 levels
%
% Inputs:
%   arch - architecture to search (model.Architecture for top level)
%   path - char/string, '/'-delimited component path
%
% Output:
%   comp - the resolved systemcomposer.arch.Component

%   Copyright 2026 The MathWorks, Inc.

    parts = strsplit(char(path), '/');
    comp  = arch.getComponent(parts{1});
    for k = 2:numel(parts)
        comp = comp.Architecture.getComponent(parts{k});
    end
end
