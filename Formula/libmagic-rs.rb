class LibmagicRs < Formula
  desc "A pure-Rust implementation of libmagic for file type identification"
  homepage "https://evilbit-labs.github.io/libmagic-rs/"
  version "0.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.1/libmagic-rs-aarch64-apple-darwin.tar.xz"
      sha256 "f49fbc19e9b17914950005dd3ec67eafcb2eb9e613ef350f68c43214558f3daf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.1/libmagic-rs-x86_64-apple-darwin.tar.xz"
      sha256 "7ad5a45fcb8d10b1f147da7e7ce174f5528d683517605378d9db28fa4a8b64ff"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.1/libmagic-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9042f16c1d33db810960a978ed448671036ad5c1fc58fe82039e866368ddbca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EvilBit-Labs/libmagic-rs/releases/download/v0.12.1/libmagic-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0b81cd9a42738f25ead349747771cb534a4ae7329e086d7ed3f232c74385055"
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
