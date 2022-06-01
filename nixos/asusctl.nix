{ lib, rustPlatform, fetchFromGitLab, pkg-config, udev }:
  rustPlatform.buildRustPackage rec {
		# credits to the authorof this script that i found in a random forum :)
    pname = "asusctl";
    version = "4.0.7";

    src = fetchFromGitLab {
      owner = "asus-linux";
      repo = pname;
      rev = version;
      sha256 = "pAZO+cEzy9OlheZ96HON8ECR1YZaf/k9o4tnXKx5oY8=";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ udev ];

    cargoSha256 = "bFfO6UAje+Wmcfi85IGgzK0GmE16dJxb8xDlcFHrX+M=";

    # doc tests fail
    doCheck = false;

    meta = with lib; {
      description = "ASUS Laptop Controller";
      homepage = "https://asus-linux.com/";
      license = licenses.unlicense;
      maintainers = [ maintainers.tailhook ];
    };
  }
