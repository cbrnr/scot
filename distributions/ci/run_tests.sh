#!/bin/bash

# This script is meant to be called by the "script" step defined in
# .travis.yml. See http://docs.travis-ci.com/ for more details.
# The behavior of the script is controlled by environment variables defined
# in the .travis.yml in the top level folder of the project.

echo "============================"
echo "============================"
echo "Testing Environment:"
python --version
python -c "import numpy; print('numpy %s' % numpy.__version__)"
python -c "import scipy; print('scipy %s' % scipy.__version__)"
if [[ $SKLEARN_VERSION != "none" ]]; then
    python -c "import sklearn; print('sklearn %s' % sklearn.__version__)"
fi
if [[ $MATPLOTLIB_VERSION != "none" ]]; then
    python -c "import matplotlib; print('matplotlib %s' % matplotlib.__version__)"
fi
if [[ $MNE_VERSION != "none" ]]; then
    python -c "import mne; print('mne %s' % mne.__version__)"
fi
echo "============================"
echo "============================"


if [[ "$INSTALL_SCOT" == "true" ]]; then
    python setup.py install
fi

if [[ "$COVERAGE" == "true" ]]; then
    xvfb-run --server-args="-screen 0 1024x768x24" nosetests -v --with-coverage scot;
else
    xvfb-run --server-args="-screen 0 1024x768x24" nosetests -v;
fi

if [[ "$RUN_EXAMPLES" == "true" ]]; then
    if [[ "$INSTALL_SCOT" == "true" ]]; then
        xvfb-run --server-args="-screen 0 1024x768x24" find examples -type f -iname "*\.py" -exec python {} \;
    else
        PYTHONPATH=. xvfb-run --server-args="-screen 0 1024x768x24" find examples -type f -iname "*\.py" -exec python {} \;
    fi
fi
