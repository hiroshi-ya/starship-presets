# A bash function that randomly select a starship `toml` config
# under the `config_dir`. Specify your `config_dir`, source it
# in your bashrc, and call the function to export a random
# `STARSHIP_CONFIG`. It will load all `.toml` files in the
# specified directory, so don't put any invalid `.toml` file
# in the destination.

# Example usage:
#   In your bashrc:
#   ```
#   source /path/to/random_starship_config.sh
#   random_starship_config /path/to/your/configs # or modify the path below and don't pass any argument
#   ```

random_starship_config() {
    local config_dir="${1:-$HOME/path/to/your/configs}"
    local config_files=()

    # Check if directory exists
    if [[ ! -d "$config_dir" ]]; then
        echo "Error: Config directory '$config_dir' does not exist" >&2
        return 1
    fi

    # Find all .toml files in the directory (excluding subdirectories)
    while IFS= read -r -d '' file; do
        config_files+=("$file")
    done < <(find "$config_dir" -maxdepth 1 -type f -name "*.toml" -print0 2>/dev/null)

    # Check if any .toml config files were found
    if [[ ${#config_files[@]} -eq 0 ]]; then
        echo "Error: No .toml config files found in '$config_dir'" >&2
        return 1
    fi

    # Select random file
    local random_index=$((RANDOM % ${#config_files[@]}))
    local selected_config="${config_files[$random_index]}"

    # Export the selected config file path
    export STARSHIP_CONFIG="$selected_config"

    # Optional: Print which config was selected (remove if you don't want this)
    # echo "Selected Starship config: $(basename "$selected_config")"
}
