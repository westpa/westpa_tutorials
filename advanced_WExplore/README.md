# WESTPA-WExplore Plugin
A plugin to run the [WExplore](https://pubs.acs.org/doi/abs/10.1021/jp411479c) algorithm in the [WESTPA](http://chong.chem.pitt.edu/WESTPA) toolkit.

# Installation
To install the WExplore module for WESTPA on your machine, clone the git repository:

```
git clone https://github.com/ADicksonLab/WESTPA-WExplore.git
```

change to the newly created WESTPA-WExplore directory:

```
cd WESTPA-WExplore/
```

and run `setup.py`:

```
python setup.py install
```

If you want to run the RingPotential example, this requires an additional step:
```
cd examples/RingPotential
python setup.py build_ext --inplace
```

To run the examples, edit the `env.sh` files in the corresponding directories (e.g. `examples/RingPotential` or `examples/kcrownether`) to include the necessary paths to python, WESTPA, and the WESTPA-WExplore plugin.

# Dependencies

WESTPA should already be installed on your system, see [this page](https://westpa.github.io/westpa/sphinx_index.html#installation) for installation instructions.

# Contributors
This work was done almost entirely by Josh Adelman (@synapticarbors) and Audrey Pratt (@ajoshpratt).
