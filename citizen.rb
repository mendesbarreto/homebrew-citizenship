class Citizen < Formula
  desc "Track your citizenship application progress from command line"
  homepage "https://github.com/mendesbarreto/citizenship-tracker-cli"
  url "https://github.com/mendesbarreto/citizenship-tracker-cli/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "923eef9c3af6b1dce24d90ab16190c1dd35d7b54e047d528ea6d5e9d27b7ef1f"
  license "MIT"
  head "https://github.com/mendesbarreto/citizenship-tracker-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    # Build the binary directly to the bin directory
    system "go", "build", "-o", bin/"citizenship-tracker-cli", "./main.go"
    
    # Create a symlink
    bin.install_symlink bin/"citizenship-tracker-cli" => "citizen"
  end

  service do
    run [opt_bin/"citizenship-tracker-cli", "run", "--headless"]
    run_type :interval
    interval 10800 # Run every 3 hours
    log_path var/"log/citizen.log"
    error_log_path var/"log/citizen.error.log"
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    output = shell_output("#{bin}/citizenship-tracker-cli --version")
    assert_match "citizenship-tracker-cli version", output
  end
end
