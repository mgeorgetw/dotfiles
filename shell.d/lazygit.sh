lazygit() {
    # Check if exactly one argument is provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: lazygit <argument>"
        return 1
    fi

    git add .
    git commit -m "$1"
    git push
}
