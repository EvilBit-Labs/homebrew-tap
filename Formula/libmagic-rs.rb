class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbit-labs.github.io/libmagic-rs/"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.3/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "ff02ab40dd5afcc2dd53711ea66326a9fc928ad22407910e3048dcc8cce029ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.3/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "041ce0f764dcddb6e8d7b31677222b3956dab9bcc5bd0ebed45f2084b6a0325c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.3/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f068ca3bf41051a5eb67b714408d5c6b2f87f166c80c20aa66cde9f08158097"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.3/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c4f1075b65a3f42a244637a21a2f22d6f34bd53ea5e0c4badbf0b2b6daaba6d"
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
