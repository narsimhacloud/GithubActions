#!/bin/bash

# List of repositories to update
repos=("https://github.com/narsimhacloud/GithubActions.git")

# Path to the updated file
updated_file_path="C:\Users\19293\IdeaProjects\updated-file\main.yaml"

# Destination path in each repository (where the file should be placed)
destination_path=".github/workflows/main.yml"

# The directory where repositories will be temporarily cloned
tmp_dir="/tmp/repo-updates"

# Clean up any existing temporary directory
rm -rf "$tmp_dir"
mkdir -p "$tmp_dir"

# Function to update a repository
update_repo() {
    repo_url=$1
    repo_name=$(basename "$repo_url" .git)
    echo "Processing repository: $repo_name"

    # Clone the repository
    git clone "$repo_url" "$tmp_dir/$repo_name"

    # Navigate to the repository directory
    cd "$tmp_dir/$repo_name" || exit

    # Copy the updated file to the destination path
    cp "$updated_file_path" "$destination_path"

    # Add, commit, and push the changes
    git checkout -b update-file
    git add "$destination_path"
    git commit -m "Update workflow file"
    git push origin update-file

    # Optionally, create a pull request (GitHub CLI must be installed)
    #gh pr create --title "Updated workflow file" --body "Automated update of the workflow file."

    # Go back to the original directory
    cd - || exit
}

# Iterate through all repositories and update the file
for repo in "${repos[@]}"; do
    update_repo "$repo"
done

# Clean up temporary directory
rm -rf "$tmp_dir"

echo "Update process completed for all repositories."
