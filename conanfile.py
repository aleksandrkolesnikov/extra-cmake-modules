from conan import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain
import os


required_conan_version = ">=1.43.0"


class ExtraCMakeModulesConan(ConanFile):
    name = "extra-cmake-modules"
    version = "5.96.0"
    license = ("MIT", "BSD-2-Clause", "BSD-3-Clause")
    url = "https://github.com/aleksandrkolesnikov/extra-cmake-modules"
    topics = ("conan", "cmake", "toolchain", "build-settings")
    description = "KDE's CMake modules"
    settings = "os", "compiler", "build_type", "arch"
    scm = {
        "type": "git",
        "url": "auto",
        "revision": "auto"
    }

    _cmake_helper = None

    @property
    def _share_dir_name(self):
        return "share"

    @property
    def _cmake(self):
        if self._cmake_helper:
            return self._cmake_helper

        self._cmake_helper = CMake(self)
        self._cmake_helper.configure()
        return self._cmake_helper

    def build_requirements(self):
        self.tool_requires("cmake/[>=3.16.0]")

    def generate(self):
        toolchain = CMakeToolchain(self)
        toolchain.generate()

    def build(self):
        cmake = self._cmake
        cmake.build()

    def package(self):
        cmake = self._cmake
        cmake.install()

    def package_info(self):
        self.cpp_info.resdirs = [self._share_dir_name]
        dirs = ["cmake", "kde-module", "modules", "test-modules", "toolchain"]
        self.cpp_info.builddirs = [os.path.join(self._share_dir_name, "ECM", dir) for dir in dirs]

    def package_id(self):
        self.info.header_only()
