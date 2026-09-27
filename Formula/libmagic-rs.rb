class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbit-labs.github.io/libmagic-rs/"
  version "0.12.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.6/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "0fc56a5d1aa76f51ce82003924d8f0a54cdae870e05b2a5c0eb803a20b1a84ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.6/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "064911f21808cdd626127672d9eb2fd295950dca54787e9a6a68dd044e1db7aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.6/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ba64a298a7676ac93eb16820cbeb136c668e47d0d216dddf4974510786a87c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.6/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae70e4b567acc69b7e3210be441f9a298797e524a7098a388308f40f9813587b"
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
