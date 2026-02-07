{...}: {
  flake.modules.homeManager.fetch-all-code = {
    home.file.".local/bin/fetch_all_code" = {
      text = ''
        #!/usr/bin/env zsh
        set -e

        trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

        scm_name="$1"
        account_type="$2"
        account_name="$3"
        token_name="ghorg - $account_name - $scm_name"

        echo "Cloning $account_name repositories..."

        if ! token=$(op item get --vault 'Private' "$token_name" --fields=credential --reveal); then
          echo "Error: Failed to retrieve token for $account_name from 1Password"
          exit 1
        fi

        if ! ghorg clone "$account_name" \
          --scm="$scm_name" \
          --token="$token" \
          --clone-type="$account_type" \
          --protocol=ssh \
          --path=$HOME/Code \
          --include-submodules \
          --fetch-all \
          --preserve-dir \
          --skip-archived; then
          echo "Error: Failed to clone $account_name repositories"
          exit 1
        fi

        echo "Successfully cloned $account_name repositories"
      '';
      executable = true;
    };
  };
}
