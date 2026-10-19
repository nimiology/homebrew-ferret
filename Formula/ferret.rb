class Ferret < Formula
  desc "Instant whole-disk file search for macOS: CLI, picker, live-updating daemon and MCP server"
  homepage "https://github.com/nimiology/ferret"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nimiology/ferret/releases/download/v0.3.0/ferret-aarch64-apple-darwin.tar.xz"
      sha256 "ebe86e7ed9ceca629e0c3eeb16b7ffb4a70179da3a9fa67b58a01a189b1f84f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nimiology/ferret/releases/download/v0.3.0/ferret-x86_64-apple-darwin.tar.xz"
      sha256 "0392a30ee029f79dcaff56369c83f7d4ab211a407750bb2b210d94f65ab719f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "ferretd", "ff"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ferretd", "ff"
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
