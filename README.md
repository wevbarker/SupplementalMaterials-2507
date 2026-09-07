[![arXiv](https://img.shields.io/badge/arXiv-2507.05349-b31b1b.svg)](https://arxiv.org/abs/2507.05349)

# SupplementalMaterials-2507

Supplemental material for *Infrared foundations for quantum geometry. II. Catalog of all torsionlike theories including new ghost-tachyon-free cases*
(W. Barker, C. Marzo and A. Santoni), https://arxiv.org/abs/2507.05349,
Phys. Rev. D, DOI [10.1103/dwfl-y5bj](https://doi.org/10.1103/dwfl-y5bj).

Every spectrograph in the paper is regenerated from the code here, and the
catalogue table is generated from `AllModelsA23.csv`. The science is a
systematic classification of all linear, parity-conserving models propagating a
pair-antisymmetric rank-three field (spacetime torsion) on Minkowski space; each candidate is analysed with PSALTer to
extract its particle spectrum and judged ghost- and tachyon-free, or not.

### Figure map

| Figure in paper | File | Producer |
|---|---|---|
| 1 | `Propaganda.pdf` | (schematic, drawn in the manuscript source) |
| 2 | `NonRiemannianSchematic.pdf` | (schematic, drawn in the manuscript source) |
| Table I | `FieldKinematicsA23Field.pdf` | `ParticleSpectroscopy.m` |
| 3 | `ParticleSpectrographA23.pdf` | `system-tests-paper-z/ParticleSpectrographA23.m` |
| 4 | `Algorithm.pdf` | (schematic, drawn in the manuscript source) |
| 5 | `GraphRepresentationA23.pdf` | `ParticleSpectroscopy.m` (survey) |
| 6 | `ParticleSpectrographA23B1D1E1G2H1I1K2.pdf` | `system-tests-paper-z/ParticleSpectrographA23B1D1E1G2H1I1K2.m` |
| 7 | `ParticleSpectrographA23B1D1E1G2H1J1K1.pdf` | `system-tests-paper-z/ParticleSpectrographA23B1D1E1G2H1J1K1.m` |
| 8 | `ParticleSpectrographA23B1D1E1G2H1J2.pdf` | `system-tests-paper-z/ParticleSpectrographA23B1D1E1G2H1J2.m` |

The `_blue` suffix on the figures as they appear in the published article is a
recolouring applied at build time; the files here are the PSALTer originals.

### Requirements

- Wolfram Language (tested on v14.2)
- the xAct suite (v1.2.0 or later)
- PSALTer (v2.0 or later), https://github.com/wevbarker/PSALTer

Every script is a kernel script, not a notebook: run it with

```bash
wolfram -run < <script>.m
```

Each writes a `ParticleSpectrograph<Model>.pdf` alongside itself. A full survey
takes hours; a single model takes minutes.

### Model naming

Model names are paths down a symmetry-restriction tree rooted at `A23`, so
`A23B1D1E1G2H1J2` is a child of `A23B1D1E1G2H1`. ``ModelNamesA23.txt`` maps
these path names to the compact display names used in the paper.

### Contents

- ``ParticleSpectroscopy.m`` - the driver: loads PSALTer, then the field kinematics and the
  root Lagrangian, and walks the whole symmetry tree.
- `ParticleSpectroscopy/` - the pieces that driver loads: field definitions and
  coupling constants, the root Lagrangian and the survey, display helpers.
- `system-tests-paper-z/` - one stand-alone script per model (222 of them),
  each reproducing that model's spectrograph on its own.
- ``AllModelsA23.csv`` - the master result table: one row per model, giving
  the imposed equalities, the avoided inequalities and the unitarity verdict.
  A model is consistent iff the unitarity field contains an actual coupling
  condition rather than a prose verdict.
- ``ModelNamesA23.txt`` - long model name to display name.
- `ParticleSpectrograph*.pdf` - the computed spectrograph for every model.
- `DeconflictionRepair.m` and `DeconflictionRepair.py` - an audit and repair of
  the third column of the catalogue. The survey's original pruning discarded a
  condition whenever it implied any other, which is correct when one condition
  is strictly stronger, but destroys BOTH when two are equivalent -- the normal
  case when two special cases share a first branching. The column was therefore
  systematically incomplete. The two scripts are independent implementations of
  the same audit, one in the Wolfram Language and one in Python, and they agree;
  `AllModelsA23.csv` here carries the corrected column, as does the published
  article. Neither script writes anything unless `DECONFLICT_WRITE=1` is set.
- `AdeevChizhov/` - a separate analysis of the Avdeev-Chizhov antisymmetric-tensor model.
- `VerifyScienceProducts.sh` - re-runs the short-list of unitary models into a fresh
  timestamped directory.

### Note

`.mx` files (cached Wolfram expressions) and `.nb` notebooks are deliberately
not included: the former are regenerable caches, the latter are front-end
duplicates of the `.m` scripts that are authoritative here.
