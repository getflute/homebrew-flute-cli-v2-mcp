class Flute2Mcp < Formula
  desc "MCP server that drives the flute2 payments CLI"
  homepage "https://github.com/getflute/flute-cli-v2-mcp"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-v2-mcp/releases/download/v1.0.0/flute2-mcp-aarch64-apple-darwin.tar.xz"
    sha256 "7fd64381b69de1cf46e789c9f9e88dcad54178b78e1e5dc7c143197f6373b3ad"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getflute/flute-cli-v2-mcp/releases/download/v1.0.0/flute2-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "832585278d3fc38484b94c5c575b190af366d775a1403af1a060517617ac8a53"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "flute2-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flute2-mcp"
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
