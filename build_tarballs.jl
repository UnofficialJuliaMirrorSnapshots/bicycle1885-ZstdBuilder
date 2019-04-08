# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "ZstdBuilder"
version = v"1.3.5"

# Collection of sources required to build ZstdBuilder
sources = [
    "https://github.com/facebook/zstd/archive/v$(version).tar.gz" =>
    "d6e1559e4cdb7c4226767d4ddc990bff5f9aab77085ff0d0490c828b025e2eea",
    "https://github.com/facebook/zstd/releases/download/v$(version)/zstd-v$(version)-win64.zip" =>
    "5dabee0ab14a92d73226cf8cb90d09a17b96b77542dffd173bdeeb3c3a3bab4a",
]

# Bash recipe for building across all platforms
script = raw"""
if [ $target = "x86_64-w64-mingw32" ]; then
    mkdir -p ${WORKSPACE}/destdir/bin/
    cp dll/libzstd.dll ${WORKSPACE}/destdir/bin/
else
    cd $WORKSPACE/srcdir/zstd-*
    make prefix=${prefix} install
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libzstd", :libzstd)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
