class Ferret < Formula
  desc "Instant whole-disk file search for macOS: CLI, picker, live-updating daemon and MCP server"
  homepage "https://github.com/nimiology/ferret"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nimiology/ferret/releases/download/v0.2.0/ferret-aarch64-apple-darwin.tar.xz"
      sha256 "c7e0cd872269c1f1ba4346e12fcdee6d8393f97162fd60aab6ffbe42d1007d8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nimiology/ferret/releases/download/v0.2.0/ferret-x86_64-apple-darwin.tar.xz"
      sha256 "5a0acc9c1df287e3583411d6a5d22623004f57d10f56cb5bb57762291cfa4f80"
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
