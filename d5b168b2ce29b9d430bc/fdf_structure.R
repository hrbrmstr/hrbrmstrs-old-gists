> str(fdf)
List of 32
 $ SystemName                       : chr "bcc Fe ferro GGA"
 $ SystemLabel                      : chr "Fe"
 $ WriteCoorStep                    : chr ""
 $ WriteMullikenPop                 : num 1
 $ NumberOfSpecies                  : num 1
 $ NumberOfAtoms                    : num 1
 $ PAO.EnergyShift                  : atomic [1:1] 50
  ..- attr(*, "unit")= chr "meV"
 $ PAO.BasisSize                    : chr "DZP"
 $ Fe                               : num 2
 $ LatticeConstant                  : atomic [1:1] 2.87
  ..- attr(*, "unit")= chr "Ang"
 $ KgridCutoff                      : atomic [1:1] 15
  ..- attr(*, "unit")= chr "Ang"
 $ xc.functional                    : chr "GGA"
 $ xc.authors                       : chr "PBE"
 $ SpinPolarized                    : logi TRUE
 $ MeshCutoff                       : atomic [1:1] 150
  ..- attr(*, "unit")= chr "Ry"
 $ MaxSCFIterations                 : num 40
 $ DM.MixingWeight                  : num 0.1
 $ DM.Tolerance                     : chr "1.d-3"
 $ DM.UseSaveDM                     : logi TRUE
 $ DM.NumberPulay                   : num 3
 $ SolutionMethod                   : chr "diagon"
 $ ElectronicTemperature            : atomic [1:1] 25
  ..- attr(*, "unit")= chr "meV"
 $ MD.TypeOfRun                     : chr "cg"
 $ MD.NumCGsteps                    : num 0
 $ MD.MaxCGDispl                    : atomic [1:1] 0.1
  ..- attr(*, "unit")= chr "Ang"
 $ MD.MaxForceTol                   : atomic [1:1] 0.04
  ..- attr(*, "unit")= chr "eV/Ang"
 $ AtomicCoordinatesFormat          : chr "Fractional"
 $ ChemicalSpeciesLabel             :'data.frame':	1 obs. of  3 variables:
  ..$ V1: int 1
  ..$ V2: int 26
  ..$ V3: chr "Fe"
 $ PAO.Basis                        :'data.frame':	5 obs. of  3 variables:
  ..$ V1: chr [1:5] "Fe" "0" "6." "2" ...
  ..$ V2: num [1:5] 2 2 0 2 0
  ..$ V3: chr [1:5] "" "P" "" "" ...
 $ LatticeVectors                   :'data.frame':	3 obs. of  3 variables:
  ..$ V1: num [1:3] 0.5 0.5 0.5
  ..$ V2: num [1:3] 0.5 -0.5 0.5
  ..$ V3: num [1:3] 0.5 0.5 -0.5
 $ BandLines                        :'data.frame':	5 obs. of  5 variables:
  ..$ V1: int [1:5] 1 40 28 28 34
  ..$ V2: num [1:5] 0 2 1 0 1
  ..$ V3: num [1:5] 0 0 1 0 1
  ..$ V4: num [1:5] 0 0 0 0 1
  ..$ V5: chr [1:5] "\\Gamma" "H" "N" "\\Gamma" ...
 $ AtomicCoordinatesAndAtomicSpecies:'data.frame':	1 obs. of  4 variables:
  ..$ V1: num 0
  ..$ V2: num 0
  ..$ V3: num 0
  ..$ V4: int 1