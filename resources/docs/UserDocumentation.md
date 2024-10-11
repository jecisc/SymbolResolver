# User Documentation of the Symbol Resolver
<!-- TOC -->

- [User Documentation of the Symbol Resolver](#user-documentation-of-the-symbol-resolver)
  - [Solvers](#solvers)
    - [Existing solvers](#existing-solvers)
    - [Add you own solver](#add-you-own-solver)

<!-- /TOC -->

TODO

This documentation is still a WIP. I'll add parts when I get the time little by little

## Solvers 

TODO

### Existing solvers 

TODO

### Add you own solver

It is highly possible that for some cases it is required to implement a solver that is not yet present in SymbolResolver. For example, depending on the language, the import system might differ and you need one with specificities.

TODO - Add description on how to implement the Solver

The actual resolution should be implemented in the method `MyResolvable>>#resolveInScope:currentEntity:`. This method takes the current scope and the current entity as a parameter. 
The method will be called first in the top scope. In case the entity is not found, you should throw a `NotFound` error. In that case, the solver will catch this error and try in the next scope until there is no scope left to look into. If that's happening, then the replacement strategy will be triggered. 
In some cases it is also possible that we know that an entity will not be found in any scope left to search. In that case, it is possible to raise a `SRNoResolutionPossible` error instead of a `NotFound`. This will stop the resolution right away and delegate the resolution to the replacement strategy. This is an optimization.

