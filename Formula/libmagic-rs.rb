class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbitlabs.io/libmagic-rs"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.1.1/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "895aac30cd19a14b09547daaaa35f616b90a7d265f6494a8585eec860967a47b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.1.1/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "3343d6ee29a25929bb94bc68b20a05a7a8f067c1dbbe70c72ba93df24ecbb9f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.1.1/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d7788295e40566dde67f29254bc95df1e9990af029958888ffa1447a94c3126"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.1.1/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85c7b3aef254261654ff9a201be1fb80d0d038d8b69a331865fd18249553596d"
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
    bin.install "rmagic" if OS.mac? && Hardware::CPU.arm?
    bin.install "rmagic" if OS.mac? && Hardware::CPU.intel?
    bin.install "rmagic" if OS.linux? && Hardware::CPU.arm?
    bin.install "rmagic" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
