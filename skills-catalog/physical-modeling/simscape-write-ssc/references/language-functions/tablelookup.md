## tablelookup


The `tablelookup` function interpolates 1D–4D empirical data inside `equations`.

**Call signature** — `x1d,...` (grid vectors), `fd` (output data), `x1,...` (query values), then named options:

```ssc
% 1-D
tablelookup(x1d, fd, x1, interpolation=linear, extrapolation=nearest)

% 2-D: fd is m-by-n for x1d(1-by-m), x2d(1-by-n)
tablelookup(x1d, x2d, fd, x1, x2, interpolation=linear, extrapolation=nearest)
```

**Grid vectors must be strictly monotonic (increasing or decreasing).**

**`interpolation`:** `linear` (default, 2+ points, no overshoot) or `smooth` (modified Akima, requires 3+ points per dimension).

**`extrapolation`:** `linear` (default — smooth derivatives at boundaries, good for thermodynamic state), `nearest` (clamps to edge value — use for bounded quantities like efficiency, viscosity), or `error` (hard validation).

**Units propagate naturally.** Declare grid vectors and output data as parameters with units; the query input units must be commensurate with grid vector units.

```ssc
parameters
    T_TLU = {[300 400 500], 'K'};
    p_TLU = {[1e5 2e5 3e5], 'Pa'};
end
equations
    p == tablelookup(T_TLU, p_TLU, T, interpolation=linear, extrapolation=nearest);
end
```

**Log-space tables for exponentially-varying quantities.** Store log values as grid vectors/output data; linear interpolation in log-space equals power-law interpolation in physical space.

**Prefer analytical expressions when physics provides a closed form.** Reserve `tablelookup` for empirical data (compressor maps, aerodynamic coefficients).

**Place `tablelookup` results in `intermediates` when reused in multiple equations or across conditional branches.**

----

Copyright 2026 The MathWorks, Inc.

----
