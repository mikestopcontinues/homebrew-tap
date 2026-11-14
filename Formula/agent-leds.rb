class AgentLeds < Formula
  desc "Status lights for coding agents on a SidePulse Pro, replacing its own software"
  homepage "https://github.com/mikestopcontinues/agent-leds"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikestopcontinues/agent-leds/releases/download/v0.5.0/agent-leds-aarch64-apple-darwin.tar.xz"
      sha256 "7ac51c798d5406d20dd3dbe2451b2dac220359aff542891d4b5a49a57b0cd60b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikestopcontinues/agent-leds/releases/download/v0.5.0/agent-leds-x86_64-apple-darwin.tar.xz"
      sha256 "d907704038f8065a4177ca7b364bfcad9ffa45d77dd7e70aac4a5c9b3d7b7e8a"
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
      bin.install "agent-leds"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agent-leds"
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
