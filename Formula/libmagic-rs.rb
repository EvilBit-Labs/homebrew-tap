class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbit-labs.github.io/libmagic-rs/"
  version "0.12.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.4/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "b61f96eac96b7f675a31f27e3a387c8fb26501ca1e2c01ee92642dd8c23eb7b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.4/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "ea60e2866e343fe84734cbab7ca992c0524da746de51b1d9022224d2bea3be40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.4/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b8614916cf9e5828506d7a3c07014cf0f42f0429f94346612ce45636e47cd8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.4/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d4a64dadca156ba4dadaed575895e56a623bcf2dba796eab15d99c42313daeb"
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
