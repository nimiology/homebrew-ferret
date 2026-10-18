class Ferret < Formula
  desc "Instant whole-disk file search for macOS: CLI, picker, live-updating daemon and MCP server"
  homepage "https://github.com/nimiology/ferret"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nimiology/ferret/releases/download/v0.1.0/ferret-aarch64-apple-darwin.tar.xz"
      sha256 "e6007609fc80ba79779196b40e37ae958edc2d2a64866da584ca690cbc47faca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nimiology/ferret/releases/download/v0.1.0/ferret-x86_64-apple-darwin.tar.xz"
      sha256 "4ebf69a5d19109fa101c8fe1e619c02b50b171f1f76a14d4fac0b1bb8370e13e"
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
