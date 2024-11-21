#!/bin/bash
# Function to find the container name
find_container_name() {
    local dir="$PWD"
    while [[ "$dir" != "$HOME" && "$dir" != "/" ]]; do
        # Check in current directory
        if [[ -f "$dir/CONTAINER_NAME" ]]; then
            cat "$dir/CONTAINER_NAME"
            return 0
        elif [[ -f "$dir/Dockerfile" ]]; then
            local first_line=$(head -n 1 "$dir/Dockerfile")
            if [[ $first_line == \#\ CONTAINER_NAME:* ]]; then
                echo "${first_line#\# CONTAINER_NAME: }"
                return 0
            fi
        fi

        # Check in .devcontainer directory if it exists
        if [[ -d "$dir/.devcontainer" ]]; then
            if [[ -f "$dir/.devcontainer/CONTAINER_NAME" ]]; then
                cat "$dir/.devcontainer/CONTAINER_NAME"
                return 0
            elif [[ -f "$dir/.devcontainer/Dockerfile" ]]; then
                local first_line=$(head -n 1 "$dir/.devcontainer/Dockerfile")
                if [[ $first_line == \#\ CONTAINER_NAME:* ]]; then
                    echo "${first_line#\# CONTAINER_NAME: }"
                    return 0
                fi
            fi
        fi

        dir="$(dirname "$dir")"
    done

    # Check the home directory as well
    if [[ -f "$HOME/CONTAINER_NAME" ]]; then
        cat "$HOME/CONTAINER_NAME"
        return 0
    elif [[ -f "$HOME/Dockerfile" ]]; then
        local first_line=$(head -n 1 "$HOME/Dockerfile")
        if [[ $first_line == \#\ CONTAINER_NAME:* ]]; then
            echo "${first_line#\# CONTAINER_NAME: }"
            return 0
        fi
    fi

    # Check home's .devcontainer directory if it exists
    if [[ -d "$HOME/.devcontainer" ]]; then
        if [[ -f "$HOME/.devcontainer/CONTAINER_NAME" ]]; then
            cat "$HOME/.devcontainer/CONTAINER_NAME"
            return 0
        elif [[ -f "$HOME/.devcontainer/Dockerfile" ]]; then
            local first_line=$(head -n 1 "$HOME/.devcontainer/Dockerfile")
            if [[ $first_line == \#\ CONTAINER_NAME:* ]]; then
                echo "${first_line#\# CONTAINER_NAME: }"
                return 0
            fi
        fi
    fi

    return 1
}

# Main dsh function
dsh() {
    local container_name=$(find_container_name)
    if [[ -z "$container_name" ]]; then
        echo "Error: CONTAINER_NAME file or Dockerfile with CONTAINER_NAME comment not found in current or parent directories up to home." >&2
        return 1
    fi
    if [[ $# -eq 0 ]]; then
        # If no arguments, open an interactive shell
        exec docker exec -it "$container_name" /bin/bash
    else
        # If arguments provided, execute the command
        exec docker exec -it "$container_name" "$@"
    fi
}

# Run the dsh function
dsh "$@"
