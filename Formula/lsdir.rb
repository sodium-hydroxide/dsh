class Dsh < Formula
  desc "Docker shell utility for container interaction"
  homepage "https://github.com/sodium-hydroxide/dsh"
  url "https://github.com/sodium-hydroxide/dsh/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "HASH_HERE"
  license "MIT"

  depends_on "docker"

  def install
    bin.install "bin/dsh"
    prefix.install "src"
    inreplace bin/"dsh", "../src", prefix/"src"
  end

  test do
    system "#{bin}/dsh", "--help"
  end
end
