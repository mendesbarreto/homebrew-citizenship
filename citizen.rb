class Citizen < Formula
  desc "Track your citizenship application progress from command line"
  homepage "https://github.com/mendesbarreto/citizenship-tracker-cli"
  url "https://github.com/mendesbarreto/citizenship-tracker-cli/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "db61417a9d7b90e7ba1aa03e18e50af5d421b617f17671102168f1ab4cbb2ad4"
  license "MIT"
  head "https://github.com/mendesbarreto/citizenship-tracker-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bin.install_symlink "#{bin}/citizenship-tracker-cli" => "citizen"
  end

  service do
    run [opt_bin/"citizenship-tracker-cli"]
    interval 10800 # Run every 3 hours
    log_path var/"log/citizen.log"
    error_log_path var/"log/citizen.error.log"
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    output = shell_output("#{bin}/citizen --version")
    assert_match "citizenship-tracker-cli version", output
  end
end
