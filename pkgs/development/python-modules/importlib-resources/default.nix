{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  importlib-metadata,

  # Reverse dependency
  sage,

  # tests
  jaraco-collections,
  jaraco-test,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "6.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-GF+Hre9bzCiESdmPtPugfOp4vANkVd1ExfxKL+eP7Sw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    jaraco-collections
    jaraco-test
  ];

  pythonImportsCheck = [ "importlib_resources" ];

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
