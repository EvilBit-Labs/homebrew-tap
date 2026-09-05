class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbit-labs.github.io/libmagic-rs/"
  version "0.12.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.5/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "22843c7796f4d853c87bfe6e2ee10ae1b1ac1cddb8fff7ee56d800a954570c52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.5/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "2d84ba91e4e7552f2866f898f2b680b257598d8721c24d7065dafb5ff83bf71d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.5/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42a1f52e8cddb93c6522dfba267d9c232b6c638e9132e43ee98b7c9973cc9abb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.5/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ca308a00de0b333615e2751d357180b805bd6aa2eca0f3a4f301fb1b1ba51d64"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rmagic"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rmagic"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rmagic"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rmagic"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
