class Citizen < Formula
  desc "Track your citizenship application progress from command line"
  homepage "https://github.com/mendesbarreto/citizenship-tracker-cli"
  url "https://github.com/mendesbarreto/citizenship-tracker-cli/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "ec404c447187c54266623a86294859e47ba04b938477ee0e72fce365acb6b3b6"
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
